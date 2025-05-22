class LoginModel {
  String? _correoelectronico;
  String? _contrasena;

  String? get correoelectronico => _correoelectronico;
  set correoelectronico(String? value) {
    _correoelectronico = value;
  }

  String? get contrasena => _contrasena;
  set contrasena(String? value) {
    _contrasena = value;
  }
}
