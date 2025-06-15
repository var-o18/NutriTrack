import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ingesta_model.dart';
import 'alimentos_service.dart';

class IngestaService {
  final String baseUrl = 'https://nutritrack-production-4645.up.railway.app/api/ingestas';
  final AlimentoService _alimentoService = AlimentoService();

  Future<bool> registrarIngesta(Ingesta ingesta) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('[ERROR] registrarIngesta: No token available.');
      return false;
    }

    final url = Uri.parse(baseUrl);
    print('[INFO] registrarIngesta: Posting to $url');
    print('[INFO] registrarIngesta: Body: ${jsonEncode(ingesta.toMap())}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(ingesta.toMap()),
      );

      if (response.statusCode == 201) {
        print('[INFO] registrarIngesta: Success (201 Created).');
        return true;
      } else {
        print('[ERROR] registrarIngesta: Failed. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('[ERROR] registrarIngesta: Exception: $e');
      return false;
    }
  }

  Future<List<Ingesta>> obtenerIngestasDelUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final usuarioId = prefs.getInt('jwt_id');

    if (token == null || usuarioId == null) {
      print('No hay token o usuarioId disponible');
      return [];
    }

    final url = Uri.parse('$baseUrl?usuarioId=$usuarioId');
    print('GET $url');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final String responseBodyUtf8 = utf8.decode(response.bodyBytes);
      final List<dynamic> listaJson = jsonDecode(responseBodyUtf8);
      return listaJson.map((json) => Ingesta.fromMap(json)).toList();
    } else {
      print('Error al obtener ingestas: ${response.statusCode}');
      return [];
    }
  }

  Future<bool> eliminarIngesta(int ingestaId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('[ERROR] eliminarIngesta: No token available.');
      return false;
    }

    final url = Uri.parse('$baseUrl/$ingestaId'); 
    print('[INFO] eliminarIngesta: Deleting from $url');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('[INFO] eliminarIngesta: Success (Status: ${response.statusCode}).');
        return true;
      } else {
        print('[ERROR] eliminarIngesta: Failed. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('[ERROR] registrarIngesta: Exception: $e');
      return false;
    }
  }

  Future<bool> actualizarIngesta(Ingesta ingesta) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      return false;
    }

    if (ingesta.id == null) {
      print('[ERROR] actualizarIngesta: No ingesta ID provided.');
      return false;
    }

    final url = Uri.parse('$baseUrl/${ingesta.id}');
    print('[INFO] actualizarIngesta: Updating at $baseUrl/${ingesta.id}');
    print('[INFO] actualizarIngesta: Body: ${jsonEncode(ingesta.toMap())}');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(ingesta.toMap()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('[INFO] actualizarIngesta: Success (Status: ${response.statusCode}).');
        return true;
      } else {
        print('[ERROR] actualizarIngesta: Failed. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('[ERROR] actualizarIngesta: Exception: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getResumenDiario() async {
    try {
      final ingestas = await obtenerIngestasDelUsuario();
      final now = DateTime.now();

      final todosLosAlimentos = await _alimentoService.getAllAlimentos();
      final mapaAlimentos = {
        for (var alimento in todosLosAlimentos) alimento.id!: alimento
      };

      final ingestasHoy = ingestas.where((ingesta) {
        try {
          final fechaIngesta = DateTime.parse(ingesta.fechaConsumo);
          return fechaIngesta.year == now.year &&
                 fechaIngesta.month == now.month &&
                 fechaIngesta.day == now.day;
        } catch (e) {
          print('Error al parsear fecha: ${ingesta.fechaConsumo}');
          return false;
        }
      }).toList();

      print('Ingestas de hoy: ${ingestasHoy.length}');

      double caloriasConsumidas = 0;
      double carbohidratosConsumidos = 0;
      double proteinasConsumidas = 0;
      double grasasConsumidas = 0;

      for (var ingesta in ingestasHoy) {
        final alimento = mapaAlimentos[ingesta.alimentoId];
        if (alimento != null) {
          double factor = ingesta.cantidad / 100.0;
          caloriasConsumidas += alimento.calorias * factor;
          carbohidratosConsumidos += alimento.carbohidratos * factor;
          proteinasConsumidas += alimento.proteinas * factor;
          grasasConsumidas += alimento.grasas * factor;
        }
      }

      print('Resumen calculado:');
      print('Calorías: $caloriasConsumidas');
      print('Carbohidratos: $carbohidratosConsumidos');
      print('Proteínas: $proteinasConsumidas');
      print('Grasas: $grasasConsumidas');

      return {
        'caloriasConsumidas': caloriasConsumidas,
        'carbohidratosConsumidos': carbohidratosConsumidos,
        'proteinasConsumidas': proteinasConsumidas,
        'grasasConsumidas': grasasConsumidas,
      };
    } catch (e) {
      print('Error al calcular resumen diario: $e');
      return {
        'caloriasConsumidas': 0,
        'carbohidratosConsumidos': 0,
        'proteinasConsumidas': 0,
        'grasasConsumidas': 0,
      };
    }
  }

  Future<int> calcularYGuardarCaloriasConsumidas() async {
    try {
      final ingestas = await obtenerIngestasDelUsuario();
      final now = DateTime.now();
      
      final todosLosAlimentos = await _alimentoService.getAllAlimentos();
      final mapaAlimentos = {
        for (var alimento in todosLosAlimentos) alimento.id!: alimento
      };

      int caloriasTotales = 0;

      for (var ingesta in ingestas) {
        try {
          final fechaIngesta = DateTime.parse(ingesta.fechaConsumo);
          if (fechaIngesta.year == now.year &&
              fechaIngesta.month == now.month &&
              fechaIngesta.day == now.day) {
            
            final alimento = mapaAlimentos[ingesta.alimentoId];
            if (alimento != null) {
              double factor = ingesta.cantidad / 100.0;
              caloriasTotales += (alimento.calorias * factor).round();
            }
          }
        } catch (e) {
          print('Error al procesar ingesta: $e');
          continue;
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('today_calories_consumed', caloriasTotales);
      print('Calorías guardadas: $caloriasTotales');

      return caloriasTotales;
    } catch (e) {
      print('Error al calcular calorías: $e');
      return 0;
    }
  }

  Future<int> obtenerCaloriasConsumidas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('today_calories_consumed') ?? 0;
    } catch (e) {
      print('Error al obtener calorías: $e');
      return 0;
    }
  }
}
