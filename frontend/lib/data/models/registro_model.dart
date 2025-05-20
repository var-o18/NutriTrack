class RegistroModel {
  String? _nombre;
  String? _apellidos;
  String? _correo;
  String? _contrasena;
  String? _genero;
  int? _edad;
  int? _peso;
  int? _altura;
  String? _objetivos;
  String? _actividadFisica;
  List<String>? _alergenos;

  String? get nombre => _nombre;
  String? get apellidos => _apellidos;
  String? get correo => _correo;
  String? get contrasena => _contrasena;
  String? get genero => _genero;
  int? get edad => _edad;
  int? get peso => _peso;
  int? get altura => _altura;
  String? get objetivos => _objetivos;
  String? get actividadFisica => _actividadFisica;
  List<String>? get alergenos => _alergenos;

  set nombre(String? value) => _nombre = value;
  set apellidos(String? value) => _apellidos = value;
  set correo(String? value) => _correo = value;
  set contrasena(String? value) => _contrasena = value;
  set genero(String? value) => _genero = value;
  set edad(int? value) => _edad = value;
  set peso(int? value) => _peso = value;
  set altura(int? value) => _altura = value;
  set objetivos(String? value) => _objetivos = value;
  set actividadFisica(String? value) => _actividadFisica = value;
  set alergenos(List<String>? value) => _alergenos = value;

  Map<String, dynamic> toJson() {
    return {
      'nombre': _nombre,
      'apellidos': _apellidos,
      'correo': _correo,
      'contrasena': _contrasena,
      'genero': _genero,
      'edad': _edad,
      'peso': _peso,
      'altura': _altura,
      'objetivos': _objetivos,
      'actividadFisica': _actividadFisica,
      'alergenos': _alergenos,
    };
  }
}