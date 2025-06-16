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

    final now = DateTime.now();
    final adjustedDate = now.add(const Duration(hours: 2)); // Ajustar para UTC+2 (España)
    final fechaConsumo = "${adjustedDate.year}-${adjustedDate.month.toString().padLeft(2, '0')}-${adjustedDate.day.toString().padLeft(2, '0')}";
    final horaConsumo = "${adjustedDate.hour.toString().padLeft(2, '0')}:${adjustedDate.minute.toString().padLeft(2, '0')}:${adjustedDate.second.toString().padLeft(2, '0')}";

    print('[INFO] registrarIngesta: Fecha local: ${now.toIso8601String()}');
    print('[INFO] registrarIngesta: Fecha ajustada: ${adjustedDate.toIso8601String()}');
    print('[INFO] registrarIngesta: Fecha y hora a enviar: $fechaConsumo $horaConsumo');

    final ingestaLocal = Ingesta(
      id: ingesta.id,
      usuarioId: ingesta.usuarioId,
      alimentoId: ingesta.alimentoId,
      cantidad: ingesta.cantidad,
      fechaConsumo: fechaConsumo,
      horaConsumo: horaConsumo,
      tipoIngesta: ingesta.tipoIngesta,
    );

    final url = Uri.parse(baseUrl);
    print('[INFO] registrarIngesta: Posting to $url');
    print('[INFO] registrarIngesta: Body: ${jsonEncode(ingestaLocal.toMap())}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(ingestaLocal.toMap()),
      );

      if (response.statusCode == 201) {
        print('[INFO] registrarIngesta: Success (201 Created).');
        print('[INFO] registrarIngesta: Response body: ${response.body}');
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
      print('[ERROR] obtenerIngestasDelUsuario: No hay token o usuarioId disponible');
      return [];
    }

    final url = Uri.parse('$baseUrl?usuarioId=$usuarioId');
    print('[INFO] obtenerIngestasDelUsuario: GET $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('[INFO] obtenerIngestasDelUsuario: Recibidas ${data.length} ingestas');
        
        final List<Ingesta> ingestas = data.map((json) {
          final ingesta = Ingesta.fromJson(json);
          
          try {
            final fechaHora = DateTime.parse('${ingesta.fechaConsumo} ${ingesta.horaConsumo}');
            final adjustedDate = fechaHora.add(const Duration(hours: 2)); // Ajustar para UTC+2 (España)
            final fechaConsumo = "${adjustedDate.year}-${adjustedDate.month.toString().padLeft(2, '0')}-${adjustedDate.day.toString().padLeft(2, '0')}";
            final horaConsumo = "${adjustedDate.hour.toString().padLeft(2, '0')}:${adjustedDate.minute.toString().padLeft(2, '0')}:${adjustedDate.second.toString().padLeft(2, '0')}";
            
            print('[INFO] obtenerIngestasDelUsuario: Procesando ingesta:');
            print('[INFO] obtenerIngestasDelUsuario: - ID: ${ingesta.id}');
            print('[INFO] obtenerIngestasDelUsuario: - Fecha original: ${ingesta.fechaConsumo} ${ingesta.horaConsumo}');
            print('[INFO] obtenerIngestasDelUsuario: - Fecha ajustada: $fechaConsumo $horaConsumo');
            print('[INFO] obtenerIngestasDelUsuario: - Alimento ID: ${ingesta.alimentoId}');
            print('[INFO] obtenerIngestasDelUsuario: - Cantidad: ${ingesta.cantidad}');
            
            return Ingesta(
              id: ingesta.id,
              usuarioId: ingesta.usuarioId,
              alimentoId: ingesta.alimentoId,
              cantidad: ingesta.cantidad,
              fechaConsumo: fechaConsumo,
              horaConsumo: horaConsumo,
              tipoIngesta: ingesta.tipoIngesta,
            );
          } catch (e) {
            print('[ERROR] obtenerIngestasDelUsuario: Error al ajustar fecha: $e');
            return ingesta;
          }
        }).toList();
        
        return ingestas;
      } else {
        print('[ERROR] obtenerIngestasDelUsuario: Error ${response.statusCode}');
        print('[ERROR] obtenerIngestasDelUsuario: ${response.body}');
        return [];
      }
    } catch (e) {
      print('[ERROR] obtenerIngestasDelUsuario: Exception: $e');
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
      print('[ERROR] eliminarIngesta: Exception: $e');
      return false;
    }
  }

  Future<bool> actualizarIngesta(Ingesta ingesta) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      print('[ERROR] actualizarIngesta: No token available.');
      return false;
    }

    final now = DateTime.now();
    final adjustedDate = now.add(const Duration(hours: 2)); // Ajustar para UTC+2 (España)
    final fechaConsumo = "${adjustedDate.year}-${adjustedDate.month.toString().padLeft(2, '0')}-${adjustedDate.day.toString().padLeft(2, '0')}";
    final horaConsumo = "${adjustedDate.hour.toString().padLeft(2, '0')}:${adjustedDate.minute.toString().padLeft(2, '0')}:${adjustedDate.second.toString().padLeft(2, '0')}";

    print('[INFO] actualizarIngesta: Fecha local: ${now.toIso8601String()}');
    print('[INFO] actualizarIngesta: Fecha ajustada: ${adjustedDate.toIso8601String()}');
    print('[INFO] actualizarIngesta: Fecha y hora a enviar: $fechaConsumo $horaConsumo');

    final ingestaLocal = Ingesta(
      id: ingesta.id,
      usuarioId: ingesta.usuarioId,
      alimentoId: ingesta.alimentoId,
      cantidad: ingesta.cantidad,
      fechaConsumo: fechaConsumo,
      horaConsumo: horaConsumo,
      tipoIngesta: ingesta.tipoIngesta,
    );

    final url = Uri.parse('$baseUrl/${ingesta.id}');
    print('[INFO] actualizarIngesta: Updating at $baseUrl/${ingesta.id}');
    print('[INFO] actualizarIngesta: Body: ${jsonEncode(ingestaLocal.toMap())}');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(ingestaLocal.toMap()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('[INFO] actualizarIngesta: Success (Status: ${response.statusCode}).');
        print('[INFO] actualizarIngesta: Response body: ${response.body}');
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
      final today = DateTime(now.year, now.month, now.day);

      final todosLosAlimentos = await _alimentoService.getAllAlimentos();
      final mapaAlimentos = {
        for (var alimento in todosLosAlimentos) alimento.id!: alimento
      };

      final ingestasHoy = ingestas.where((ingesta) {
        try {
          final fechaHora = DateTime.parse('${ingesta.fechaConsumo} ${ingesta.horaConsumo}');
          final adjustedDate = fechaHora.add(const Duration(hours: 2)); // Ajustar para UTC+2 (España)
          final fechaIngestaNormalizada = DateTime(adjustedDate.year, adjustedDate.month, adjustedDate.day);
          
          print('[INFO] getResumenDiario: Procesando ingesta:');
          print('[INFO] getResumenDiario: - Fecha ingesta: ${fechaHora.toIso8601String()}');
          print('[INFO] getResumenDiario: - Fecha ajustada: ${adjustedDate.toIso8601String()}');
          print('[INFO] getResumenDiario: - Fecha normalizada: ${fechaIngestaNormalizada.toIso8601String()}');
          print('[INFO] getResumenDiario: - Fecha hoy: ${today.toIso8601String()}');
          print('[INFO] getResumenDiario: - Es hoy: ${fechaIngestaNormalizada.isAtSameMomentAs(today)}');
          
          return fechaIngestaNormalizada.isAtSameMomentAs(today);
        } catch (e) {
          print('[ERROR] getResumenDiario: Error al parsear fecha: ${ingesta.fechaConsumo} ${ingesta.horaConsumo}');
          return false;
        }
      }).toList();

      print('[INFO] getResumenDiario: Ingestas de hoy: ${ingestasHoy.length}');

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
          
          print('[INFO] getResumenDiario: Procesando alimento:');
          print('[INFO] getResumenDiario: - Nombre: ${alimento.nombre}');
          print('[INFO] getResumenDiario: - Cantidad: ${ingesta.cantidad}g');
          print('[INFO] getResumenDiario: - Factor: $factor');
          print('[INFO] getResumenDiario: - Calorías: ${alimento.calorias * factor}');
          print('[INFO] getResumenDiario: - Carbohidratos: ${alimento.carbohidratos * factor}');
          print('[INFO] getResumenDiario: - Proteínas: ${alimento.proteinas * factor}');
          print('[INFO] getResumenDiario: - Grasas: ${alimento.grasas * factor}');
        }
      }

      print('[INFO] getResumenDiario: Resumen calculado:');
      print('[INFO] getResumenDiario: - Calorías: $caloriasConsumidas');
      print('[INFO] getResumenDiario: - Carbohidratos: $carbohidratosConsumidos');
      print('[INFO] getResumenDiario: - Proteínas: $proteinasConsumidas');
      print('[INFO] getResumenDiario: - Grasas: $grasasConsumidas');

      return {
        'caloriasConsumidas': caloriasConsumidas,
        'carbohidratosConsumidos': carbohidratosConsumidos,
        'proteinasConsumidas': proteinasConsumidas,
        'grasasConsumidas': grasasConsumidas,
      };
    } catch (e) {
      print('[ERROR] getResumenDiario: Error al calcular resumen diario: $e');
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
      final today = DateTime(now.year, now.month, now.day);
      
      print('[INFO] calcularYGuardarCaloriasConsumidas: Fecha actual: ${now.toIso8601String()}');
      print('[INFO] calcularYGuardarCaloriasConsumidas: Total ingestas recibidas: ${ingestas.length}');
      
      final todosLosAlimentos = await _alimentoService.getAllAlimentos();
      final mapaAlimentos = {
        for (var alimento in todosLosAlimentos) alimento.id!: alimento
      };

      int caloriasTotales = 0;

      for (var ingesta in ingestas) {
        try {
          final fechaHora = DateTime.parse('${ingesta.fechaConsumo} ${ingesta.horaConsumo}');
          final adjustedDate = fechaHora.add(const Duration(hours: 2)); // Ajustar para UTC+2 (España)
          final fechaIngestaNormalizada = DateTime(adjustedDate.year, adjustedDate.month, adjustedDate.day);
          
          print('[INFO] calcularYGuardarCaloriasConsumidas: Procesando ingesta:');
          print('[INFO] calcularYGuardarCaloriasConsumidas: - Fecha ingesta: ${fechaHora.toIso8601String()}');
          print('[INFO] calcularYGuardarCaloriasConsumidas: - Fecha ajustada: ${adjustedDate.toIso8601String()}');
          print('[INFO] calcularYGuardarCaloriasConsumidas: - Fecha normalizada: ${fechaIngestaNormalizada.toIso8601String()}');
          print('[INFO] calcularYGuardarCaloriasConsumidas: - Fecha hoy: ${today.toIso8601String()}');
          print('[INFO] calcularYGuardarCaloriasConsumidas: - Es hoy: ${fechaIngestaNormalizada.isAtSameMomentAs(today)}');

          if (fechaIngestaNormalizada.isAtSameMomentAs(today)) {
            final alimento = mapaAlimentos[ingesta.alimentoId];
            if (alimento != null) {
              double factor = ingesta.cantidad / 100.0;
              int caloriasIngesta = (alimento.calorias * factor).round();
              caloriasTotales += caloriasIngesta;
              print('[INFO] calcularYGuardarCaloriasConsumidas: Añadiendo ${caloriasIngesta} calorías de ${alimento.nombre}');
            } else {
              print('[WARNING] calcularYGuardarCaloriasConsumidas: No se encontró el alimento con ID ${ingesta.alimentoId}');
            }
          } else {
            print('[INFO] calcularYGuardarCaloriasConsumidas: Ingesta no es del día actual');
          }
        } catch (e) {
          print('[ERROR] calcularYGuardarCaloriasConsumidas: Error al procesar ingesta: $e');
          continue;
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('today_calories_consumed', caloriasTotales);
      print('[INFO] calcularYGuardarCaloriasConsumidas: Total de calorías guardadas: $caloriasTotales');

      return caloriasTotales;
    } catch (e) {
      print('[ERROR] calcularYGuardarCaloriasConsumidas: Error al calcular calorías: $e');
      return 0;
    }
  }

  Future<int> obtenerCaloriasConsumidas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('today_calories_consumed') ?? 0;
    } catch (e) {
      print('[ERROR] obtenerCaloriasConsumidas: Error al obtener calorías: $e');
      return 0;
    }
  }
}
