class Filme {
  final int? id;
  final String titulo;
  final bool assistido;

  Filme({
    this.id,
    required this.titulo,
    required this.assistido,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'assistido': assistido ? 1 : 0,
    };
  }

  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      titulo: map['titulo'],
      assistido: map['assistido'] == 1,
    );
  }
}