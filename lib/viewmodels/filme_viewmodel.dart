import 'package:flutter/material.dart';

import '../models/filme.dart';
import '../services/filme_service.dart';

class FilmeViewModel extends ChangeNotifier {
  final FilmeService _service = FilmeService();

  List<Filme> filmes = [];

  Future<void> carregarFilmes() async {
    filmes = await _service.listarFilmes();

    notifyListeners();
  }

  Future<void> adicionarFilme(String titulo) async {
    if (titulo.trim().isEmpty) {
      return;
    }

    final filme = Filme(
      titulo: titulo.trim(),
      assistido: false,
    );

    await _service.inserirFilme(filme);

    await carregarFilmes();
  }

  Future<void> alterarStatus(Filme filme) async {
    if (filme.id == null) {
      return;
    }

    await _service.atualizarStatus(
      filme.id!,
      !filme.assistido,
    );

    await carregarFilmes();
  }
}