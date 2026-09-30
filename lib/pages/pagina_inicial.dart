import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/filme_viewmodel.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FilmeViewModel>().carregarFilmes();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _adicionarFilme() async {
    if (_controller.text.trim().isEmpty) {
      return;
    }

    await context.read<FilmeViewModel>().adicionarFilme(
          _controller.text,
        );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FilmeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Lista de Filmes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nome do filme',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _adicionarFilme(),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _adicionarFilme,
                child: const Text('Adicionar'),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: viewModel.filmes.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum filme cadastrado.',
                      ),
                    )
                  : ListView.builder(
                      itemCount: viewModel.filmes.length,
                      itemBuilder: (context, index) {
                        final filme = viewModel.filmes[index];

                        return ListTile(
                          leading: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          title: Text(
                            filme.titulo,
                            style: TextStyle(
                              fontSize: 17,
                              decoration: filme.assistido
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),

                          trailing: Checkbox(
                            value: filme.assistido,
                            onChanged: (_) {
                              viewModel.alterarStatus(filme);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}