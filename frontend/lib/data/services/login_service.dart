import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> loginUsuario(String correo, String contrasena) async {
  final url = Uri.parse('http://192.168.56.1:8080/api/usuarios/login');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'correo': correo,
      'contrasena': contrasena,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final token = data['token'];
    print('Token recibido: $token');
    return true;
  } else {
    print('Error login: ${response.statusCode} - ${response.body}');
    return false;
  }
}
