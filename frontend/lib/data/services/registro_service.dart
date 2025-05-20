import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/registro_model.dart';

Future<void> enviarRegistro(RegistroModel registro) async {
  final url = Uri.parse('http://127.0.0.1:8080/api/registro');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registro.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(' Registro exitoso');
    } else {
      print('Error al registrar: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Excepción durante el envío: $e');
  }
}
