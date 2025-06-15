import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/registro_model.dart';

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

Future<Map<String, dynamic>> registrarUsuario(RegistroModel registro) async {
  final url = Uri.parse('https://nutritrack-production-4645.up.railway.app/api/usuarios/registro');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registro.toJson()),
    );

    print('Respuesta del registro: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      final token = data['token'];
      final usuarioData = data['usuario'];

      print('Token recibido: $token');
      print('Datos del usuario recibidos: $usuarioData');

      if (token == null || usuarioData == null) {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'body': 'Token o datos del usuario no recibidos en la respuesta',
        };
      }

      final id = usuarioData['id'];
      print('ID recibido: $id');

      if (id == null) {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'body': 'ID del usuario no disponible',
        };
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setInt('jwt_id', id);

      print('Credenciales guardadas en SharedPreferences');

      try {
        final usuario = await getDatosUsuario();
        print('Datos del usuario recuperados: $usuario');

        return {
          'success': true,
          'statusCode': response.statusCode,
          'usuario': usuario,
        };
      } catch (e) {
        print('Error al obtener datos del usuario: $e');
        return {
          'success': false,
          'statusCode': response.statusCode,
          'body': 'Error al obtener datos del usuario: $e',
        };
      }
    } else {
      return {
        'success': false,
        'statusCode': response.statusCode,
        'body': response.body,
      };
    }
  } catch (e) {
    print('Error en la petición de registro: $e');
    return {
      'success': false,
      'statusCode': 0,
      'body': 'Error en la petición: $e',
    };
  }
}

