import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/registro_model.dart';

Future<bool> loginUsuario(String correo, String contrasena) async {
  final url = Uri.parse('https://nutritrack-production-4645.up.railway.app/api/usuarios/login');

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

  final url = Uri.parse('https://nutritrack-production-4645.up.railway.app/api/usuarios/$userId');
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

Future<bool> updateCaloriasRestantesUsuario(int userId, int caloriasRestantes) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  if (token == null) {
    print('Token no disponible para actualizar calorías');
    return false;
  }

  final url = Uri.parse('http://192.168.18.110:8080/api/usuarios/$userId');
  try {
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'caloriasRestantes': caloriasRestantes}),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Calorías restantes actualizadas correctamente en el backend.');
      return true;
    } else {
      print('Error al actualizar calorías restantes: ${response.statusCode} - ${response.body}');
      return false;
    }
  } catch (e) {
    print('Excepción al actualizar calorías restantes: $e');
    return false;
  }
}

Future<bool> patchUsuario(Map<String, dynamic> patchData) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');
  final userId = prefs.getInt('jwt_id');

  if (token == null || userId == null) {
    print('Token o ID no disponible para patchUsuario');
    return false;
  }

  final url = Uri.parse('https://nutritrack-production-4645.up.railway.app/api/usuarios/$userId');
  try {
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(patchData),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Usuario actualizado correctamente.');
      return true;
    } else {
      print('Error al actualizar usuario: \\${response.statusCode} - \\${response.body}');
      return false;
    }
  } catch (e) {
    print('Excepción al actualizar usuario: $e');
    return false;
  }
}

Future<void> logoutUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');
  await prefs.remove('jwt_id');
  print('Usuario cerró sesión: tokens JWT eliminados.');
}
