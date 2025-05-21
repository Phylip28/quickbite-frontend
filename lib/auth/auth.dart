import 'package:shared_preferences/shared_preferences.dart';

// Claves para SharedPreferences (AHORA PÚBLICAS)
const String authTokenKey = 'authToken';
const String userIdKey = 'userId';
const String userNameKey = 'userName';
const String userLastNameKey = 'userLastName';
const String userAddressKey = 'userAddress';
const String userPhoneKey = 'userPhone';
const String userEmailKey = 'userEmail';
const String userRoleKey = 'userRole';

// --- Token de Autenticación ---
Future<void> saveAuthToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(authTokenKey, token); // Usar la clave pública
  print('AuthToken guardado: $token');
}

Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(authTokenKey); // Usar la clave pública
}

Future<void> deleteAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(authTokenKey); // Usar la clave pública
  await _removeAllUserInfo();
  print('AuthToken eliminado y toda la info de usuario limpiada.');
}

// --- Rol del Usuario ---
Future<void> saveUserRole(String role) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(userRoleKey, role); // Usar la clave pública
  print('UserRole guardado: $role');
}

Future<String?> getUserRole() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final role = prefs.getString(userRoleKey); // Usar la clave pública
  print('UserRole obtenido: $role');
  return role;
}

Future<void> deleteUserRole() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(userRoleKey); // Usar la clave pública
  print('UserRole eliminado.');
}

// --- ID del Usuario (Cliente o Repartidor) ---
Future<void> saveUserId(int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(userIdKey, userId); // Usar la clave pública
  print('UserID guardado: $userId');
}

Future<int?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(userIdKey); // Usar la clave pública
}

// --- Nombre del Usuario (Cliente o Repartidor) ---
Future<void> saveUserName(String userName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(userNameKey, userName); // Usar la clave pública
  print('UserName guardado: $userName');
}

Future<String?> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(userNameKey); // Usar la clave pública
}

// --- Apellido del Usuario ---
Future<void> saveUserLastName(String lastName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(userLastNameKey, lastName); // Usar la clave pública
  print('UserLastName guardado: $lastName');
}

Future<String?> getUserLastName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(userLastNameKey); // Usar la clave pública
}

// --- Dirección del Usuario ---
Future<void> saveUserAddress(String address) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(userAddressKey, address); // Usar la clave pública
  print('UserAddress guardado: $address');
}

Future<String?> getUserAddress() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(userAddressKey); // Usar la clave pública
}

// --- Teléfono del Usuario ---
Future<void> saveUserPhone(String phone) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(userPhoneKey, phone); // Usar la clave pública
  print('UserPhone guardado: $phone');
}

Future<String?> getUserPhone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(userPhoneKey); // Usar la clave pública
}

// --- Correo del Usuario ---
Future<void> saveUserEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(userEmailKey, email); // Usar la clave pública
  print('UserEmail guardado: $email');
}

Future<String?> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(userEmailKey); // Usar la clave pública
}

// --- Limpiar toda la información del usuario ---
Future<void> _removeAllUserInfo() async {
  // Esta puede seguir siendo privada si solo se llama desde aquí
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(userIdKey);
  await prefs.remove(userNameKey);
  await prefs.remove(userLastNameKey);
  await prefs.remove(userAddressKey);
  await prefs.remove(userPhoneKey);
  await prefs.remove(userEmailKey);
  await prefs.remove(userRoleKey);
  print(
    'Toda la información del usuario (ID, Nombre, Apellido, Dirección, Teléfono, Email, Rol) ha sido eliminada.',
  );
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
