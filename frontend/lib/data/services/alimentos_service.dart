import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alimneto_model.dart';

class AlimentoService {
  final String _baseUrl = 'https://nutritrack-production-4645.up.railway.app/api/alimentos';

  // Función auxiliar para ajustar fechas a UTC+2
  DateTime _ajustarFechaUTC2(DateTime fecha) {
    return fecha.add(const Duration(hours: 2));
  }

  // Función auxiliar para formatear fecha y hora
  Map<String, String> _formatearFechaHora(DateTime fecha) {
    final fechaAjustada = _ajustarFechaUTC2(fecha);
    return {
      'fecha': "${fechaAjustada.year}-${fechaAjustada.month.toString().padLeft(2, '0')}-${fechaAjustada.day.toString().padLeft(2, '0')}",
      'hora': "${fechaAjustada.hour.toString().padLeft(2, '0')}:${fechaAjustada.minute.toString().padLeft(2, '0')}:${fechaAjustada.second.toString().padLeft(2, '0')}"
    };
  }

  Future<Map<String, dynamic>?> getAlimentoRaw(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('[ERROR] getAlimentoRaw: No token available');
      return null;
    }

    final url = Uri.parse('$_baseUrl/$id');
    print('[DEBUG] getAlimentoRaw: Fetching from $url');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(utf8.decode(response.bodyBytes));
      print('[DEBUG] getAlimentoRaw: Successfully fetched alimento with ID $id');
      return {'data': jsonBody};
    } else {
      print('[ERROR] getAlimentoRaw: Error ${response.statusCode}: ${response.body}');
      return null;
    }
  }

  Future<List<Alimento>> getAllAlimentos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('[ERROR] getAllAlimentos: No token available');
      return [];
    }

    final url = Uri.parse(_baseUrl); 
    print('[DEBUG] getAllAlimentos: Fetching from $url');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final String responseBodyUtf8 = utf8.decode(response.bodyBytes);
        List<dynamic> jsonList = jsonDecode(responseBodyUtf8);
        List<Alimento> alimentos = jsonList.map((json) {
          final alimento = Alimento.fromJson(json);
          print('[DEBUG] getAllAlimentos: Procesando alimento:');
          print('[DEBUG] getAllAlimentos: - ID: ${alimento.id}');
          print('[DEBUG] getAllAlimentos: - Nombre: ${utf8.decode(alimento.nombre.codeUnits)}');
          print('[DEBUG] getAllAlimentos: - Calorías: ${alimento.calorias}');
          return alimento;
        }).toList();
        print('[DEBUG] getAllAlimentos: Successfully fetched ${alimentos.length} alimentos');
        return alimentos;
      } else {
        print('[ERROR] getAllAlimentos: Error ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('[ERROR] getAllAlimentos: Exception: $e');
      return [];
    }
  }

  Future<Alimento?> getAlimentoByCodigoBarras(String codigoBarras) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('[ERROR] getAlimentoByCodigoBarras: No token available');
      return null;
    }

    final url = Uri.parse('$_baseUrl/codigo/$codigoBarras');
    print('[DEBUG] getAlimentoByCodigoBarras: Fetching from $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      print('[DEBUG] getAlimentoByCodigoBarras: Response status: ${response.statusCode}');
      print('[DEBUG] getAlimentoByCodigoBarras: Response body: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(utf8.decode(response.bodyBytes));
        print('[DEBUG] getAlimentoByCodigoBarras: Successfully fetched alimento with barcode $codigoBarras');
        return Alimento.fromJson(jsonBody);
      } else if (response.statusCode == 404) {
        print('[INFO] getAlimentoByCodigoBarras: Alimento with barcode $codigoBarras not found');
        return null;
      } else {
        print('[ERROR] getAlimentoByCodigoBarras: Error ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('[ERROR] getAlimentoByCodigoBarras: Exception: $e');
      return null;
    }
  }

  Future<Alimento?> saveAlimento(Alimento alimento) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('[ERROR] saveAlimento: No token available');
      return null;
    }
    
    final url = Uri.parse(_baseUrl);
    print('[DEBUG] saveAlimento: Saving to $url');
    
    final now = DateTime.now();
    final adjustedDate = now.add(const Duration(hours: 2)); // Ajustar para UTC+2 (España)
    print('[DEBUG] saveAlimento: Fecha local: ${now.toIso8601String()}');
    print('[DEBUG] saveAlimento: Fecha ajustada: ${adjustedDate.toIso8601String()}');
    
    final body = alimento.toJson();
    print('[DEBUG] saveAlimento: Request body: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('[DEBUG] saveAlimento: Response status: ${response.statusCode}');
      print('[DEBUG] saveAlimento: Response body: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200 || response.statusCode == 201) { 
        final String responseBody = utf8.decode(response.bodyBytes);
        final int? nuevoId = int.tryParse(responseBody);
        if (nuevoId != null) {
          print('[DEBUG] saveAlimento: Successfully saved alimento with ID: $nuevoId');
          return Alimento(
            id: nuevoId,
            nombre: alimento.nombre,
            calorias: alimento.calorias,
            proteinas: alimento.proteinas,
            carbohidratos: alimento.carbohidratos,
            grasas: alimento.grasas,
            codigoBarras: alimento.codigoBarras,
            ingredientes: alimento.ingredientes,
            sodio: alimento.sodio,
            grasasSaludables: alimento.grasasSaludables
          );
        } else {
          print('[ERROR] saveAlimento: Failed to parse ID from response: $responseBody');
          return null;
        }
      } else {
        print('[ERROR] saveAlimento: Error ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('[ERROR] saveAlimento: Exception: $e');
      return null;
    }
  }

  Future<Alimento?> getAlimentoById(int id) async {
    final raw = await getAlimentoRaw(id);
    if (raw != null && raw['data'] != null) {
      print('[DEBUG] getAlimentoById: Successfully fetched alimento with ID $id');
      return Alimento.fromJson(raw['data']);
    }
    print('[ERROR] getAlimentoById: Failed to fetch alimento with ID $id');
    return null;
  }

  Future<List<Alimento>> getSugerencias(int limite, double margenPorcentaje) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      print('[ERROR] getSugerencias: No token available');
      throw Exception('No hay token de autenticación');
    }

    final url = Uri.parse('$_baseUrl/sugerencias?limite=$limite&margenPorcentaje=$margenPorcentaje');
    print('[DEBUG] getSugerencias: Fetching from $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final String responseBodyUtf8 = utf8.decode(response.bodyBytes);
        final List<dynamic> alimentosJson = jsonDecode(responseBodyUtf8);
        final List<Alimento> alimentos = alimentosJson.map((json) {
          final alimento = Alimento.fromJson(json);
          print('[DEBUG] getSugerencias: Procesando sugerencia:');
          print('[DEBUG] getSugerencias: - ID: ${alimento.id}');
          print('[DEBUG] getSugerencias: - Nombre: ${utf8.decode(alimento.nombre.codeUnits)}');
          print('[DEBUG] getSugerencias: - Calorías: ${alimento.calorias}');
          return alimento;
        }).toList();
        print('[DEBUG] getSugerencias: Successfully fetched ${alimentos.length} sugerencias');
        return alimentos;
      } else {
        print('[ERROR] getSugerencias: Error ${response.statusCode} - ${response.body}');
        throw Exception('Error al obtener sugerencias: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] getSugerencias: Exception: $e');
      throw Exception('Error al obtener sugerencias: $e');
    }
  }
}