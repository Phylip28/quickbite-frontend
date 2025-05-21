import 'package:shared_preferences/shared_preferences.dart';

// Claves para SharedPreferences
const String _authTokenKey = 'authToken';
const String _userIdKey = 'userId';
const String _userNameKey = 'userName';
const String _userLastNameKey = 'userLastName'; // Asumo que lo usas para clientes y repartidores
const String _userAddressKey = 'userAddress'; // Asumo que lo usas para clientes y repartidores
const String _userPhoneKey = 'userPhone'; // Asumo que lo usas para clientes y repartidores
const String _userEmailKey = 'userEmail';
const String _userRoleKey = 'userRole'; // <--- CLAVE AÑADIDA PARA EL ROL

// --- Token de Autenticación ---
Future<void> saveAuthToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_authTokenKey, token);
  print('AuthToken guardado: $token');
}

Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_authTokenKey);
}

Future<void> deleteAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(_authTokenKey);
  await _removeAllUserInfo(); // Llama a limpiar toda la info del usuario
  print('AuthToken eliminado y toda la info de usuario limpiada.');
}

// --- Rol del Usuario ---
Future<void> saveUserRole(String role) async {
  // <--- FUNCIÓN AÑADIDA
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userRoleKey, role);
  print('UserRole guardado: $role');
}

Future<String?> getUserRole() async {
  // <--- FUNCIÓN AÑADIDA
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final role = prefs.getString(_userRoleKey);
  print('UserRole obtenido: $role');
  return role;
}

Future<void> deleteUserRole() async {
  // <--- FUNCIÓN AÑADIDA
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(_userRoleKey);
  print('UserRole eliminado.');
}

// --- ID del Usuario (Cliente o Repartidor) ---
Future<void> saveUserId(int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_userIdKey, userId);
  print('UserID guardado: $userId');
}

Future<int?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_userIdKey);
}

// --- Nombre del Usuario (Cliente o Repartidor) ---
Future<void> saveUserName(String userName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userNameKey, userName);
  print('UserName guardado: $userName');
}

Future<String?> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userNameKey);
}

// --- Apellido del Usuario ---
Future<void> saveUserLastName(String lastName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userLastNameKey, lastName);
  print('UserLastName guardado: $lastName');
}

Future<String?> getUserLastName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userLastNameKey);
}

// --- Dirección del Usuario ---
Future<void> saveUserAddress(String address) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userAddressKey, address);
  print('UserAddress guardado: $address');
}

Future<String?> getUserAddress() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userAddressKey);
}

// --- Teléfono del Usuario ---
Future<void> saveUserPhone(String phone) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userPhoneKey, phone);
  print('UserPhone guardado: $phone');
}

Future<String?> getUserPhone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userPhoneKey);
}

// --- Correo del Usuario ---
Future<void> saveUserEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userEmailKey, email);
  print('UserEmail guardado: $email');
}

Future<String?> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userEmailKey);
}

// --- Limpiar toda la información del usuario ---
Future<void> _removeAllUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(_userIdKey);
  await prefs.remove(_userNameKey);
  await prefs.remove(_userLastNameKey);
  await prefs.remove(_userAddressKey);
  await prefs.remove(_userPhoneKey);
  await prefs.remove(_userEmailKey);
  await prefs.remove(_userRoleKey); // <--- ASEGÚRATE QUE EL ROL SE LIMPIE AQUÍ
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
