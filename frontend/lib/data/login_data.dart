import 'package:flutter/cupertino.dart';
import 'package:nutritack/data/models/login_modelo.dart';

class LoginData with ChangeNotifier {
  final LoginModel _login = LoginModel();

  LoginModel get datos => _login;

  void actualizarLogin({
    String? correoelectronico,
    String? contrasena,
  }) {
    if (correoelectronico != null) _login.correoelectronico = correoelectronico;
    if (contrasena != null) _login.contrasena = contrasena;

    notifyListeners();
  }

  void limpiarDatos() {
    _login.correoelectronico = null;
    _login.contrasena = null;
    notifyListeners();
  }
}
