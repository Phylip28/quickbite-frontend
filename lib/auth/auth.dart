import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveAuthToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('authToken', token);
  print('Token guardado: $token');
}

Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken');
}

Future<void> deleteAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('authToken');
  print('Token eliminado');
}

// (Opcional) Puedes agregar aquí tu clase AuthService si la tienes
// para manejar las llamadas a la API de autenticación (login, register, logout)
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AuthService {
//   final String baseUrl = 'http://0.0.0.0:8000'; // Reemplaza con tu URL base

//   Future<Map<String, dynamic>> login(String correo, String contrasena) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
//     );
//     return jsonDecode(response.body);
//   }

//   Future<Map<String, dynamic>> register(Map<String, String> userData) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(userData),
//     );
//     return jsonDecode(response.body);
//   }
// }
