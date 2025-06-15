class Ingesta {
  final int? id;
  final int usuarioId;
  final int alimentoId;
  final int cantidad;
  final String fechaConsumo;
  final String horaConsumo;
  final String tipoIngesta;

  Ingesta({
    this.id,
    required this.usuarioId,
    required this.alimentoId,
    required this.cantidad,
    required this.fechaConsumo,
    required this.horaConsumo,
    required this.tipoIngesta,
  });

  factory Ingesta.fromMap(Map<String, dynamic> map) {
    print('[DEBUG] Ingesta.fromMap: Mapeando datos:');
    print('[DEBUG] Ingesta.fromMap: - id: ${map['id']}');
    print('[DEBUG] Ingesta.fromMap: - usuarioId: ${map['usuarioId']}');
    print('[DEBUG] Ingesta.fromMap: - alimentoId: ${map['alimentoId']}');
    print('[DEBUG] Ingesta.fromMap: - cantidad: ${map['cantidad']}');
    print('[DEBUG] Ingesta.fromMap: - fechaConsumo: ${map['fechaConsumo']}');
    print('[DEBUG] Ingesta.fromMap: - horaConsumo: ${map['horaConsumo']}');
    print('[DEBUG] Ingesta.fromMap: - tipoIngesta: ${map['tipoIngesta']}');

    return Ingesta(
      id: map['id'] as int?,
      usuarioId: map['usuarioId'] as int? ?? 0,
      alimentoId: map['alimentoId'] as int? ?? 0,
      cantidad: (map['cantidad'] as num?)?.toInt() ?? 0,
      fechaConsumo: map['fechaConsumo'] as String? ?? '',
      horaConsumo: map['horaConsumo'] as String? ?? '',
      tipoIngesta: map['tipoIngesta'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    print('[DEBUG] Ingesta.toMap: Convirtiendo a mapa:');
    print('[DEBUG] Ingesta.toMap: - id: $id');
    print('[DEBUG] Ingesta.toMap: - usuarioId: $usuarioId');
    print('[DEBUG] Ingesta.toMap: - alimentoId: $alimentoId');
    print('[DEBUG] Ingesta.toMap: - cantidad: $cantidad');
    print('[DEBUG] Ingesta.toMap: - fechaConsumo: $fechaConsumo');
    print('[DEBUG] Ingesta.toMap: - horaConsumo: $horaConsumo');
    print('[DEBUG] Ingesta.toMap: - tipoIngesta: $tipoIngesta');

    return {
      'id': id,
      'usuarioId': usuarioId,
      'alimentoId': alimentoId,
      'cantidad': cantidad,
      'fecha_consumo': fechaConsumo,
      'hora_consumo': horaConsumo,
      'tipoIngesta': tipoIngesta,
    };
  }

  factory Ingesta.fromJson(Map<String, dynamic> json) {
    print('[DEBUG] Ingesta.fromJson: Mapeando JSON:');
    print('[DEBUG] Ingesta.fromJson: - id: ${json['id']}');
    print('[DEBUG] Ingesta.fromJson: - usuarioId: ${json['usuarioId']}');
    print('[DEBUG] Ingesta.fromJson: - alimentoId: ${json['alimentoId']}');
    print('[DEBUG] Ingesta.fromJson: - cantidad: ${json['cantidad']}');
    print('[DEBUG] Ingesta.fromJson: - fechaConsumo: ${json['fechaConsumo']}');
    print('[DEBUG] Ingesta.fromJson: - horaConsumo: ${json['horaConsumo']}');
    print('[DEBUG] Ingesta.fromJson: - tipoIngesta: ${json['tipoIngesta']}');

    return Ingesta(
      id: json['id'] as int?,
      usuarioId: json['usuarioId'] as int? ?? 0,
      alimentoId: json['alimentoId'] as int? ?? 0,
      cantidad: (json['cantidad'] as num?)?.toInt() ?? 0,
      fechaConsumo: json['fechaConsumo'] as String? ?? '',
      horaConsumo: json['horaConsumo'] as String? ?? '',
      tipoIngesta: json['tipoIngesta'] as String? ?? '',
    );
  }
}
