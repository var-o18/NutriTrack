import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/alimneto_model.dart';

class AlimentoService {
  final String _baseUrl = 'http://192.168.56.1:8080/api/alimentos';

  Future<Map<String, dynamic>?> getAlimentoRaw(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('No hay token disponible');
      return null;
    }

    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return {'data': jsonBody};
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      return null;
    }
  }

  Future<List<Alimento>> getAllAlimentos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('No hay token disponible');
      return [];
    }

    final url = Uri.parse(_baseUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Alimento.fromJson(json)).toList();
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      return [];
    }
  }
}
