import 'package:flutter/foundation.dart';
import 'models/alimneto_model.dart';

class AlimentoData extends ChangeNotifier {
  Alimento? _alimento;

  Alimento? get alimento => _alimento;

  void setAlimento(Alimento nuevo) {
    _alimento = nuevo;
    notifyListeners();
  }

  void updateAlimento({
    int? id,
    String? nombre,
    double? calorias,
    double? proteinas,
    double? carbohidratos,
    double? grasas,
    String? codigoBarras,
    String? ingredientes,
  }) {
    if (_alimento == null) return;

    _alimento = Alimento(
      id: id ?? _alimento!.id,
      nombre: nombre ?? _alimento!.nombre,
      calorias: calorias ?? _alimento!.calorias,
      proteinas: proteinas ?? _alimento!.proteinas,
      carbohidratos: carbohidratos ?? _alimento!.carbohidratos,
      grasas: grasas ?? _alimento!.grasas,
      codigoBarras: codigoBarras ?? _alimento!.codigoBarras,
      ingredientes: ingredientes ?? _alimento!.ingredientes,
    );

    notifyListeners();
  }

  void clear() {
    _alimento = null;
    notifyListeners();
  }
}
