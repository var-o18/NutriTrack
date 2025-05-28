import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/registro_model.dart';

Future<bool> loginUsuario(String correo, String contrasena) async {
  final url = Uri.parse('http://192.168.56.1:8080/api/usuarios/login');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'correo': correo,
      'contrasena': contrasena,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final token = data['token'];
    final id = data['id'];
    print('Token recibido: $token');
    print('ID: $id');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setInt('jwt_id', id);

    return true;
  } else {
    print('Error login: ${response.statusCode} - ${response.body}');
    return false;
  }
}

Future<RegistroModel?> getDatosUsuario() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');
  final userId = prefs.getInt('jwt_id');

  if (token == null || userId == null) {
    print('Token o ID no disponible');
    return null;
  }

  print('Consultando datos del usuario con ID: $userId');

  final url = Uri.parse('http://192.168.56.1:8080/api/usuarios/$userId');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final datosUsuarioJson = jsonDecode(response.body);
    final usuario = RegistroModel.fromJson(datosUsuarioJson);
    print('Datos recibidos del backend: $datosUsuarioJson');
    return usuario;
  } else {
    print('Error al obtener usuario: ${response.statusCode}');
    return null;
  }
}
