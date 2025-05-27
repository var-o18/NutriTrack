class LoginModel {
  String? _correo;
  String? _contrasena;

  String? get correo => _correo;
  String? get contrasena => _contrasena;

  set correo(String? value) => _correo = value;
  set contrasena(String? value) => _contrasena = value;

  Map<String, dynamic> toJson() {
    return {
      'correo': _correo,
      'contrasena': _contrasena,
    };
  }
}
