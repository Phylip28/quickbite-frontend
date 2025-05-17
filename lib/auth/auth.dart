import 'package:shared_preferences/shared_preferences.dart';

const String _authTokenKey = 'authToken';
const String _userIdKey = 'userId';
const String _userNameKey = 'userName';
const String _userLastNameKey = 'userLastName';
const String _userAddressKey = 'userAddress';
const String _userPhoneKey = 'userPhone';
const String _userEmailKey = 'userEmail';

Future<void> saveAuthToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_authTokenKey, token);
  print('Token guardado: $token');
}

Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_authTokenKey);
}

Future<void> deleteAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(_authTokenKey);
  await _removeAllUserInfo(); // Limpia también la info del usuario al cerrar sesión
  print('Token eliminado');
}

// Funciones para guardar y leer el ID del usuario
Future<void> saveUserId(int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_userIdKey, userId);
  print('UserID guardado: $userId');
}

Future<int?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_userIdKey);
}

// Funciones para guardar y leer el nombre del usuario
Future<void> saveUserName(String userName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userNameKey, userName);
  print('UserName guardado: $userName');
}

Future<String?> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userNameKey);
}

// Funciones para guardar y leer el apellido del usuario
Future<void> saveUserLastName(String lastName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userLastNameKey, lastName);
  print('UserLastName guardado: $lastName');
}

Future<String?> getUserLastName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userLastNameKey);
}

// Funciones para guardar y leer la dirección del usuario
Future<void> saveUserAddress(String address) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userAddressKey, address);
  print('UserAddress guardado: $address');
}

Future<String?> getUserAddress() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userAddressKey);
}

// Funciones para guardar y leer el teléfono del usuario
Future<void> saveUserPhone(String phone) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userPhoneKey, phone);
  print('UserPhone guardado: $phone');
}

Future<String?> getUserPhone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userPhoneKey);
}

// Funciones para guardar y leer el correo electrónico del usuario
Future<void> saveUserEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userEmailKey, email);
  print('UserEmail guardado: $email');
}

Future<String?> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userEmailKey);
}

// Función para limpiar toda la información del usuario
Future<void> _removeAllUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(_userIdKey);
  await prefs.remove(_userNameKey);
  await prefs.remove(_userLastNameKey);
  await prefs.remove(_userAddressKey);
  await prefs.remove(_userPhoneKey);
  await prefs.remove(_userEmailKey);
  print('Información del usuario eliminada');
}

// (Opcional) Puedes mantener tu clase AuthService aquí si lo deseas
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
