class Alimento {
  final int? id;
  final String nombre;
  final double calorias;
  final double proteinas;
  final double carbohidratos;
  final double grasas;
  final String? codigoBarras;
  final String? ingredientes;
  final double sodio;
  final double grasasSaludables;

  Alimento({
    this.id,
    required this.nombre,
    required this.calorias,
    required this.proteinas,
    required this.carbohidratos,
    required this.grasas,
    this.codigoBarras,
    this.ingredientes,
    this.sodio = 0.0,
    this.grasasSaludables = 0.0,
  });

  factory Alimento.fromJson(Map<String, dynamic> json) {
    print('[DEBUG] Alimento.fromJson: Mapeando datos:');
    print('[DEBUG] Alimento.fromJson: - id: ${json['id']}');
    print('[DEBUG] Alimento.fromJson: - nombre: ${json['nombre']}');
    print('[DEBUG] Alimento.fromJson: - calorias: ${json['calorias']}');
    print('[DEBUG] Alimento.fromJson: - proteinas: ${json['proteinas']}');
    print('[DEBUG] Alimento.fromJson: - carbohidratos: ${json['carbohidratos']}');
    print('[DEBUG] Alimento.fromJson: - grasas: ${json['grasas']}');
    print('[DEBUG] Alimento.fromJson: - codigoBarras: ${json['codigo_barras']}');
    print('[DEBUG] Alimento.fromJson: - ingredientes: ${json['ingredientes']}');
    print('[DEBUG] Alimento.fromJson: - sodio: ${json['sodio']}');
    print('[DEBUG] Alimento.fromJson: - grasasSaludables: ${json['grasas_saludables']}');

    double toDoubleSafe(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    final alimento = Alimento(
      id: json['id'] as int?,
      nombre: json['nombre'] ?? '',
      calorias: (toDoubleSafe(json['calorias'])).round().toDouble(),
      proteinas: toDoubleSafe(json['proteinas']),
      carbohidratos: toDoubleSafe(json['carbohidratos']),
      grasas: toDoubleSafe(json['grasas']),
      codigoBarras: json['codigo_barras'],
      ingredientes: json['ingredientes'],
      sodio: toDoubleSafe(json['sodio']),
      grasasSaludables: toDoubleSafe(json['grasas_saludables']),
    );

    print('[DEBUG] Alimento.fromJson: Alimento creado:');
    print('[DEBUG] Alimento.fromJson: - id: ${alimento.id}');
    print('[DEBUG] Alimento.fromJson: - nombre: ${alimento.nombre}');
    print('[DEBUG] Alimento.fromJson: - calorias: ${alimento.calorias}');
    print('[DEBUG] Alimento.fromJson: - proteinas: ${alimento.proteinas}');
    print('[DEBUG] Alimento.fromJson: - carbohidratos: ${alimento.carbohidratos}');
    print('[DEBUG] Alimento.fromJson: - grasas: ${alimento.grasas}');
    print('[DEBUG] Alimento.fromJson: - sodio: ${alimento.sodio}');
    print('[DEBUG] Alimento.fromJson: - grasasSaludables: ${alimento.grasasSaludables}');

    return alimento;
  }

  Map<String, dynamic> toJson() {
    print('[DEBUG] Alimento.toJson: Convirtiendo a JSON:');
    print('[DEBUG] Alimento.toJson: - id: $id');
    print('[DEBUG] Alimento.toJson: - nombre: $nombre');
    print('[DEBUG] Alimento.toJson: - calorias: $calorias');
    print('[DEBUG] Alimento.toJson: - proteinas: $proteinas');
    print('[DEBUG] Alimento.toJson: - carbohidratos: $carbohidratos');
    print('[DEBUG] Alimento.toJson: - grasas: $grasas');
    print('[DEBUG] Alimento.toJson: - sodio: $sodio');
    print('[DEBUG] Alimento.toJson: - grasasSaludables: $grasasSaludables');

    final Map<String, dynamic> data = {
      'nombre': nombre,
      'calorias': calorias,
      'proteinas': proteinas,
      'carbohidratos': carbohidratos,
      'grasas': grasas,
      'sodio': sodio,
      'grasas_saludables': grasasSaludables,
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
