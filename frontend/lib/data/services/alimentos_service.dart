import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/alimneto_model.dart';

class AlimentoService {
  final String _baseUrl = 'http://192.168.56.1:8080/api/alimentos';

  Future<Alimento?> crearAlimento(Alimento alimentoParaCrear) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('[ERROR AlimentoService] No hay token disponible para crear alimento');
      return null;
    }

    final url = Uri.parse(_baseUrl);
    try {
      print('[INFO AlimentoService] Creando alimento (POST): ${jsonEncode(alimentoParaCrear.toJson())}');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(alimentoParaCrear.toJson()),
      );

      if (response.statusCode == 201) { // 201 Created
        print('[INFO AlimentoService] POST exitoso (201). El cuerpo de la respuesta POST fue: "${response.body}"');
        print('[INFO AlimentoService] Intentando recuperar el alimento creado mediante GET All y búsqueda...');

        // Paso 1: Obtener todos los alimentos
        List<Alimento> todosLosAlimentos = await getAllAlimentos();

        if (todosLosAlimentos.isEmpty) {
          print('[WARN AlimentoService] getAllAlimentos devolvió una lista vacía después de crear.');
          return null;
        }

        // Paso 2: Buscar el alimento por nombre y tomar el que tenga el ID más alto (más reciente)
        List<Alimento> candidatos = todosLosAlimentos
            .where((alimento) => alimento.nombre == alimentoParaCrear.nombre)
            .toList();

        if (candidatos.isEmpty) {
          print('[WARN AlimentoService] No se encontró el alimento "${alimentoParaCrear.nombre}" en la lista después de crearlo.');
          return null;
        } else {
          // Ordenar candidatos por ID descendente para obtener el más reciente
          // Asumimos que el ID no es nulo para alimentos recuperados de getAllAlimentos
          candidatos.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0)); 
          Alimento alimentoEncontrado = candidatos.first;
          print('[INFO AlimentoService] Alimento encontrado por nombre "${alimentoEncontrado.nombre}" con ID: ${alimentoEncontrado.id}');
          return alimentoEncontrado;
        }
      } else {
        print('[ERROR AlimentoService] Error en POST al crear alimento: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('[ERROR AlimentoService] Excepción en la llamada HTTP para crear alimento: $e');
      return null;
    }
  }

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
      print('No hay token disponible para getAllAlimentos');
      return [];
    }

    final url = Uri.parse(_baseUrl);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        List<Alimento> alimentos = jsonList.map((json) => Alimento.fromJson(json)).toList();
        return alimentos;
      } else {
        print('Error al obtener todos los alimentos: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Excepción al obtener todos los alimentos: $e');
      return [];
    }
  }
}