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
    String? sexo,
    int? edad,
    double? peso,
    double? altura,
    String? objetivo_personal,
    String? nivel_actividad_fisica,
    int? calorias_diarias,
  }) {
    if (nombre != null) _registro.nombre = nombre;
    if (apellidos != null) _registro.apellidos = apellidos;
    if (correo != null) _registro.correo = correo;
    if (contrasena != null) _registro.contrasena = contrasena;
    if (sexo != null) _registro.genero = sexo;
    if (edad != null) _registro.edad = edad;
    if (peso != null) _registro.peso = peso;
    if (altura != null) _registro.altura = altura;
    if (objetivo_personal != null) _registro.objetivos = objetivo_personal;
    if (nivel_actividad_fisica != null) _registro.actividadFisica = nivel_actividad_fisica;
    if (calorias_diarias != null) _registro.calorias_diarias = calorias_diarias;

    notifyListeners();
  }
}