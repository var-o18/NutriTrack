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
      usuarioId: map['usuario_id'],
      alimentoId: map['alimento_id'],
      cantidad: map['cantidad'],
      fechaConsumo: map['fecha_consumo'],
      horaConsumo: map['hora_consumo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuarioId,
      'alimento_id': alimentoId,
      'cantidad': cantidad,
      'fecha_consumo': fechaConsumo,
      'hora_consumo': horaConsumo,
    };
  }
}
