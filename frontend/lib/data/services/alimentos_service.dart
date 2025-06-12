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
        List<dynamic> jsonList = jsonDecode(response.body);
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

  Future<Alimento?> getAlimentoByCodigoBarras(String codigoBarras) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('[DEBUG AlimentoService] No hay token disponible para getAlimentoByCodigoBarras');
      return null;
    }

    final url = Uri.parse('$_baseUrl/codigo/$codigoBarras');
    
    print('[DEBUG AlimentoService] Llamando a URL: $url');
    print('[DEBUG AlimentoService] Token: $token');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('[DEBUG AlimentoService] Headers: $headers');

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      print('[DEBUG AlimentoService] Respuesta del backend - Status: ${response.statusCode}');
      print('[DEBUG AlimentoService] Respuesta del backend - Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        print('[DEBUG AlimentoService] JSON decodificado: $jsonBody');
        return Alimento.fromJson(jsonBody);
      } else if (response.statusCode == 404) {
        print('Alimento con código de barras $codigoBarras no encontrado.');
        return null;
      } else {
        print('Error al obtener alimento por código de barras: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Excepción al obtener alimento por código de barras: $e');
      return null;
    }
  }

  Future<Alimento?> saveAlimento(Alimento alimento) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('[DEBUG AlimentoService] No hay token disponible para saveAlimento');
      return null;
    }
    
    final url = Uri.parse(_baseUrl);
    print('[DEBUG AlimentoService - saveAlimento] POST a URL: $url');
    
    final body = alimento.toJson();

    print('[DEBUG AlimentoService - saveAlimento] Body: ${jsonEncode(body)}');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('[DEBUG AlimentoService - saveAlimento] Headers: $headers');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print('[DEBUG AlimentoService - saveAlimento] Respuesta del backend - Status: ${response.statusCode}');
      print('[DEBUG AlimentoService - saveAlimento] Respuesta del backend - Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) { 
        final String responseBody = response.body;
        final int? nuevoId = int.tryParse(responseBody);
        if (nuevoId != null) {
          print('[DEBUG AlimentoService - saveAlimento] Alimento guardado con ID: $nuevoId');
          return Alimento(
            id: nuevoId,
            nombre: alimento.nombre,
            calorias: alimento.calorias,
            proteinas: alimento.proteinas,
            carbohidratos: alimento.carbohidratos,
            grasas: alimento.grasas,
            codigoBarras: alimento.codigoBarras,
            ingredientes: alimento.ingredientes
          );
        } else {
          print('[DEBUG AlimentoService - saveAlimento] Error al parsear ID de respuesta: $responseBody');
          return null;
        }
      } else {
        print('[DEBUG AlimentoService - saveAlimento] Error al guardar alimento: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('[DEBUG AlimentoService - saveAlimento] Excepción al guardar alimento: $e');
      return null;
    }
  }

  Future<Alimento?> getAlimentoById(int id) async {
    final raw = await getAlimentoRaw(id);
    if (raw != null && raw['data'] != null) {
      return Alimento.fromJson(raw['data']);
    }
    return null;
  }

  Future<List<Alimento>> getSugerencias(int limite, double margenPorcentaje) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    final url = Uri.parse('$_baseUrl/sugerencias?limite=$limite&margenPorcentaje=$margenPorcentaje');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> alimentosJson = jsonDecode(response.body);
        return alimentosJson.map((json) => Alimento.fromJson(json)).toList();
      } else {
        print('Error al obtener sugerencias: ${response.statusCode} - ${response.body}');
        throw Exception('Error al obtener sugerencias: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la petición de sugerencias: $e');
      throw Exception('Error al obtener sugerencias: $e');
    }
  }
}