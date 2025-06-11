import 'package:flutter/cupertino.dart';
import 'package:nutritack/data/models/login_modelo.dart';

class LoginData with ChangeNotifier {
  final LoginModel _login = LoginModel();

  LoginModel get datos => _login;

  void actualizarLogin({
    String? correo,
    String? contrasena,
  }) {
    if (correo != null) _login.correo= correo;
    if (contrasena != null) _login.contrasena = contrasena;

    notifyListeners();
  }

  void limpiarDatos() {
    _login.correo = null;
    _login.contrasena = null;
    notifyListeners();
  }
}
