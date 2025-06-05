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
