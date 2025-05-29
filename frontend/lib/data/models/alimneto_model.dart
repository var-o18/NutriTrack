class Alimento {
  final int id;
  final String nombre;
  final double calorias;
  final double proteinas;
  final double carbohidratos;
  final double grasas;
  final String? codigoBarras;
  final String? ingredientes;

  Alimento({
    required this.id,
    required this.nombre,
    required this.calorias,
    required this.proteinas,
    required this.carbohidratos,
    required this.grasas,
    this.codigoBarras,
    this.ingredientes,
  });

  factory Alimento.fromJson(Map<String, dynamic> json) {
    double toDoubleSafe(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return 0.0;
    }

    return Alimento(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      calorias: toDoubleSafe(json['calorias']),
      proteinas: toDoubleSafe(json['proteinas']),
      carbohidratos: toDoubleSafe(json['carbohidratos']),
      grasas: toDoubleSafe(json['grasas']),
      codigoBarras: json['codigo_barras'],
      ingredientes: json['ingredientes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'calorias': calorias,
    'proteinas': proteinas,
    'carbohidratos': carbohidratos,
    'grasas': grasas,
    'codigo_barras': codigoBarras,
    'ingredientes': ingredientes,
  };
}
