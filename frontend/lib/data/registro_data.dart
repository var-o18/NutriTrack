import 'package:flutter/cupertino.dart';
import 'models/registro_model.dart';

class RegistroData with ChangeNotifier {
  final RegistroModel _registro = RegistroModel();

  RegistroModel get datos => _registro;

  void actualizarRegistro({
    String? nombre,
    String? apellidos,
    String? correo,
    String? contrasena,
    String? genero,
    int? edad,
    int? peso,
    int? altura,
    String? objetivos,
    String? actividadFisica,
    List<String>? alergenos,
  }) {
    if (nombre != null) _registro.nombre = nombre;
    if (apellidos != null) _registro.apellidos = apellidos;
    if (correo != null) _registro.correo = correo;
    if (contrasena != null) _registro.contrasena = contrasena;
    if (genero != null) _registro.genero = genero;
    if (edad != null) _registro.edad = edad;
    if (peso != null) _registro.peso = peso;
    if (altura != null) _registro.altura = altura;
    if (objetivos != null) _registro.objetivos = objetivos;
    if (actividadFisica != null) _registro.actividadFisica = actividadFisica;
    if (alergenos != null) _registro.alergenos = alergenos;

    notifyListeners();
  }
}