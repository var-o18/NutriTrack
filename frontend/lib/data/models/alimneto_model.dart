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
    return Alimento(
      id: json['id'],
      nombre: json['nombre'],
      calorias: (json['calorias'] as num).toDouble(),
      proteinas: (json['proteinas'] as num).toDouble(),
      carbohidratos: (json['carbohidratos'] as num).toDouble(),
      grasas: (json['grasas'] as num).toDouble(),
      codigoBarras: json['codigo_barras'],
      ingredientes: json['ingredientes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}
