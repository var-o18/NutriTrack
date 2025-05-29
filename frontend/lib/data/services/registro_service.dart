import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/registro_model.dart';

Future<Map<String, dynamic>> registrarUsuario(RegistroModel registro) async {
  final url = Uri.parse('http://192.168.56.1:8080/api/usuarios/registro');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registro.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      final token = data['token'];
      final id = data['id'];

      final prefs = await SharedPreferences.getInstance();

      if (token != null) {
        await prefs.setString('jwt_token', token);
      }
      if (id != null) {
        await prefs.setInt('jwt_id', id);
      }

      return {
        'success': true,
        'statusCode': response.statusCode,
      };
    } else {
      return {
        'success': false,
        'statusCode': response.statusCode,
        'body': response.body,
      };
    }
  } catch (e) {
    return {
      'success': false,
      'statusCode': 0,
      'body': 'Error en la petición: $e',
    };
  }
}

