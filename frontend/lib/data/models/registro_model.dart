import 'dart:ffi';

class RegistroModel {
  String? _nombre;
  String? _apellidos;
  String? _correo;
  String? _contrasena;
  String? _genero;
  int? _edad;
  double? _peso;
  double? _altura;
  String? _objetivos;
  String? _actividadFisica;
  int? _calorias_diarias;

  String? get nombre => _nombre;
  String? get apellidos => _apellidos;
  String? get correo => _correo;
  String? get contrasena => _contrasena;
  String? get sexo => _genero;
  int? get edad => _edad;
  double? get peso => _peso;
  double? get altura => _altura;
  String? get objetivo_personal => _objetivos;
  String? get nivel_actividad_fisica => _actividadFisica;
  int? get calorias_diarias => _calorias_diarias;

  set nombre(String? value) => _nombre = value;
  set apellidos(String? value) => _apellidos = value;
  set correo(String? value) => _correo = value;
  set contrasena(String? value) => _contrasena = value;
  set genero(String? value) => _genero = value;
  set edad(int? value) => _edad = value;
  set peso(double? value) => _peso = value;
  set altura(double? value) => _altura = value;
  set objetivos(String? value) => _objetivos = value;
  set actividadFisica(String? value) => _actividadFisica = value;
  set calorias_diarias(int? value) => _calorias_diarias = value;

  Map<String, dynamic> toJson() {
    return {
      'nombre': _nombre,
      'apellidos': _apellidos,
      'correo': _correo,
      'contrasena': _contrasena,
      'sexo': _genero,
      'edad': _edad,
      'peso': _peso,
      'altura': _altura,
      'objetivo_personal': _objetivos,
      'nivel_actividad_fisica': _actividadFisica,
      'calorias_diarias': _calorias_diarias,
    };
  }
}