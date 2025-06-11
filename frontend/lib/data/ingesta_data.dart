import 'package:flutter/foundation.dart';
import 'models/ingesta_model.dart';

class IngestaData extends ChangeNotifier {
  List<Ingesta> _ingestas = [];
  List<Ingesta> get ingestas => List.unmodifiable(_ingestas);

  void setIngestas(List<Ingesta> nuevas) {
    _ingestas = List.from(nuevas);
    notifyListeners();
  }

  void addIngesta(Ingesta ingesta) {
    _ingestas.add(ingesta);
    notifyListeners();
  }

  void updateIngesta(int index, Ingesta nueva) {
    if (index < 0 || index >= _ingestas.length) return;
    _ingestas[index] = nueva;
    notifyListeners();
  }

  void removeIngesta(Ingesta ingesta) {
    _ingestas.remove(ingesta);
    notifyListeners();
  }

  void clear() {
    _ingestas.clear();
    notifyListeners();
  }

  List<Ingesta> filterByDate(String fecha) {
    return _ingestas
        .where((i) => i.fechaConsumo == fecha)
        .toList(growable: false);
  }
}