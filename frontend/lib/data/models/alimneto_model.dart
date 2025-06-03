class Alimento {
  final int? id;
  final String nombre;
  final double calorias;
  final double proteinas;
  final double carbohidratos;
  final double grasas;
  final String? codigoBarras;
  final String? ingredientes;

  Alimento({
    this.id,
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
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Alimento(
      id: json['id'] as int?,
      nombre: json['nombre'] ?? '',
      calorias: toDoubleSafe(json['calorias']),
      proteinas: toDoubleSafe(json['proteinas']),
      carbohidratos: toDoubleSafe(json['carbohidratos']),
      grasas: toDoubleSafe(json['grasas']),
      codigoBarras: json['codigo_barras'],
      ingredientes: json['ingredientes'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombre': nombre,
      'calorias': calorias,
      'proteinas': proteinas,
      'carbohidratos': carbohidratos,
      'grasas': grasas,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (codigoBarras != null) {
      data['codigo_barras'] = codigoBarras;
    }
    if (ingredientes != null) {
      data['ingredientes'] = ingredientes;
    }
    return data;
  }
}
