class Ingesta {
  final int alimento_id;
  final int usuario_id;
  final int cantidad;
  final String fechaConsumo;
  final String horaConsumo;

  Ingesta({
    required this.usuario_id,
    required this.alimento_id,
    required this.cantidad,
    required this.fechaConsumo,
    required this.horaConsumo,
  });

  factory Ingesta.fromMap(Map<String, dynamic> map) {
    return Ingesta(
      usuario_id: map['usuario_id'],
      alimento_id: map['alimento_id'],
      cantidad: map['cantidad'],
      fechaConsumo: map['fecha_consumo'],
      horaConsumo: map['hora_consumo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alimentoId': alimento_id,
      'usuarioId': usuario_id,
      'cantidad': cantidad,
      'fecha_consumo': fechaConsumo,
      'hora_consumo': horaConsumo,
    };
  }
  factory Ingesta.fromJson(Map<String, dynamic> json) {
    return Ingesta(
      usuario_id: json['usuarioId'] as int? ?? 0,
      alimento_id: json['alimentoId'] as int? ?? 0,
      cantidad: (json['cantidad'] as num?)?.toInt() ?? 0,
      fechaConsumo: json['fechaConsumo'] as String? ?? '',
      horaConsumo: json['horaConsumo'] as String? ?? '',
    );
  }
}
