import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ingesta_model.dart';

class IngestaService {
  final String _baseUrl = 'http://192.168.56.1:8080/api/ingestas';

  Future<bool> addIngesta(Ingesta ingesta) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      print('Token JWT no disponible');
      return false;
    }

    final url = Uri.parse(_baseUrl);

    final jsonBody = jsonEncode(ingesta.toMap());
    print('JSON que se enviará: $jsonBody');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(ingesta.toMap()),
    );

    if (response.statusCode == 201) {
      print('Ingesta creada correctamente');
      return true;
    } else {
      print('Error al crear ingesta: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  Future<List<Ingesta>> getIngestasByUsuarioId(int usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      print('Token JWT no disponible');
      return [];
    }

    final url = Uri.parse('$_baseUrl?usuarioId=$usuarioId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('GET $url');
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Ingesta.fromJson(json)).toList();
    } else {
      print('Error al obtener historial: ${response.statusCode} - ${response.body}');
      return [];
    }
  }
}
