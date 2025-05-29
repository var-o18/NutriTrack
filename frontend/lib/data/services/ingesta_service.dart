import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ingesta_model.dart';

class IngestaService {
  final String baseUrl = 'http://192.168.56.1:8080/api/ingestas';

  Future<bool> registrarIngesta(Ingesta ingesta) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) return false;

    final url = Uri.parse('$baseUrl/ingestas');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(ingesta.toMap()),
    );

    return response.statusCode == 201;
  }

  Future<List<Ingesta>> obtenerIngestasDelUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final usuarioId = prefs.getInt('jwt_id');

    if (token == null || usuarioId == null) {
      print('No hay token o usuarioId disponible');
      return [];
    }

    final url = Uri.parse('$baseUrl/usuarios/$usuarioId/ingestas');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((json) => Ingesta.fromMap(json)).toList();
    } else {
      print('Error al obtener ingestas: ${response.statusCode}');
      return [];
    }
  }
}
