class Ingesta {
  final int usuarioId;
  final int alimentoId;
  final int cantidad;
  final String fechaConsumo;
  final String horaConsumo;

  Ingesta({
    required this.usuarioId,
    required this.alimentoId,
    required this.cantidad,
    required this.fechaConsumo,
    required this.horaConsumo,
  });

  factory Ingesta.fromMap(Map<String, dynamic> map) {
    return Ingesta(
      usuarioId: map['usuarioId'] as int? ?? 0,
      alimentoId: map['alimentoId'] as int? ?? 0,
      cantidad: (map['cantidad'] as num?)?.toInt() ?? 0,
      fechaConsumo: map['fechaConsumo'] as String? ?? '',
      horaConsumo: map['horaConsumo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'alimentoId': alimentoId,
      'cantidad': cantidad,
      'fecha_consumo': fechaConsumo,
      'hora_consumo': horaConsumo,
    };
  }
}
