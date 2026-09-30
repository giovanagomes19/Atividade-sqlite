import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/filme.dart';

class FilmeService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _abrirBanco();

    return _database!;
  }

  Future<Database> _abrirBanco() async {
    final caminho = join(
      await getDatabasesPath(),
      'filmes.db',
    );

    return await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE filmes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            assistido INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> inserirFilme(Filme filme) async {
    final db = await database;

    await db.insert(
      'filmes',
      filme.toMap(),
    );
  }

  Future<List<Filme>> listarFilmes() async {
    final db = await database;

    final resultado = await db.query(
      'filmes',
      orderBy: 'id DESC',
    );

    return resultado.map((map) {
      return Filme.fromMap(map);
    }).toList();
  }

  Future<void> atualizarStatus(
    int id,
    bool assistido,
  ) async {
    final db = await database;

    await db.update(
      'filmes',
      {
        'assistido': assistido ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}