import 'package:flutter/cupertino.dart';
import 'models/registro_model.dart';

class RegistroData extends ChangeNotifier {
  RegistroModel datos = RegistroModel();

  void setDatos(RegistroModel nuevoRegistro) {
    datos = nuevoRegistro;
    notifyListeners();
  }

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
  }) {
    datos.nombre = nombre ?? datos.nombre;
    datos.apellidos = apellidos ?? datos.apellidos;
    datos.correo = correo ?? datos.correo;
    datos.contrasena = contrasena ?? datos.contrasena;
    datos.sexo = sexo ?? datos.sexo;
    datos.edad = edad ?? datos.edad;
    datos.peso = peso ?? datos.peso;
    datos.altura = altura ?? datos.altura;
    datos.objetivoPersonal = objetivo_personal ?? datos.objetivoPersonal;
    datos.nivelActividadFisica = nivel_actividad_fisica ?? datos.nivelActividadFisica;

    notifyListeners();
  }
}