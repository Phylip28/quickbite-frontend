import 'package:flutter/material.dart';
import 'registerScreen.dart';
import 'client/homeScreen.dart'; // Para clientes
import 'delivery/homeScreen.dart'; // Para repartidores
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth.dart'; // Importa todas tus funciones de auth.dart

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login'; // <--- AÑADE ESTA LÍNEA

  const LoginScreen({super.key}); // Asegúrate de que el constructor esté bien

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Selector de rol
  final List<bool> _selectedRoleToggle = [
    true,
    false,
  ]; // [Customer, Driver] - Customer seleccionado por defecto
  String _selectedRole = 'customer'; // Valores: 'customer', 'driver'

  // URL base de tu API (ajusta la IP y puerto si es necesario)
  final String _apiBaseUrl =
      'http://192.168.246.36:8000'; // Asegúrate que esta IP sea accesible desde tu emulador/dispositivo

  Future<void> _attemptLogin(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fields cannot be empty')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    late Uri url;
    late Map<String, String> headers;
    late String body;

    if (_selectedRole == 'customer') {
      url = Uri.parse('$_apiBaseUrl/api/auth'); // <--- CAMBIO AQUÍ: Eliminado '/login'
      headers = <String, String>{'Content-Type': 'application/x-www-form-urlencoded'};
      // Para clientes, el backend espera 'username' y 'password' como form data
      final Map<String, String> requestBody = {
        'username': email, // El backend de cliente espera 'username'
        'password': password,
      };
      // http.post para x-www-form-urlencoded no usa json.encode, se pasa el map directamente a 'body'
      // pero como http.post espera un String o Uint8List para body, necesitamos codificarlo
      body = requestBody.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      print('Intentando login como Cliente a $url');
      print('Headers: $headers');
      print('Body (form-urlencoded): $body');
    } else if (_selectedRole == 'driver') {
      url = Uri.parse('$_apiBaseUrl/api/repartidores/login'); // Endpoint para repartidores
      headers = <String, String>{'Content-Type': 'application/json; charset=UTF-8'};
      // Para repartidores, el backend espera 'correo_repartidor' y 'contrasenia' en JSON
      final Map<String, String> requestBody = {'correo_repartidor': email, 'contrasenia': password};
      body = jsonEncode(requestBody);
      print('Intentando login como Repartidor a $url');
      print('Headers: $headers');
      print('Body (JSON): $body');
    }

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (!context.mounted) return; // Verificar si el widget sigue montado

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Respuesta del servidor ($_selectedRole): ${response.statusCode} -> $responseData');

      if (response.statusCode == 200) {
        if (_selectedRole == 'customer') {
          if (responseData.containsKey('access_token') &&
              responseData.containsKey('id_cliente') &&
              responseData.containsKey('nombre_cliente') &&
              responseData.containsKey('apellido_cliente') &&
              // ... (otros campos de cliente que esperas)
              responseData.containsKey('correo_cliente')) {
            await saveAuthToken(responseData['access_token']);
            await saveUserId(responseData['id_cliente']);
            await saveUserName(responseData['nombre_cliente']);
            await saveUserLastName(responseData['apellido_cliente']);
            await saveUserEmail(responseData['correo_cliente']);
            // Guarda otros datos del cliente si es necesario (dirección, teléfono)
            if (responseData.containsKey('direccion_cliente')) {
              await saveUserAddress(responseData['direccion_cliente']);
            }
            if (responseData.containsKey('telefono_cliente')) {
              await saveUserPhone(responseData['telefono_cliente']);
            }
            await saveUserRole('customer'); // <--- CAMBIO AQUÍ: de 'cliente' a 'customer'

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Customer login successful!')));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()), // Pantalla de cliente
            );
          } else {
            _showErrorSnackbar(
              context,
              'Customer login error: Missing user information in response.',
            );
            print('Respuesta incompleta del backend (Cliente): ${response.body}');
          }
        } else if (_selectedRole == 'driver') {
          if (responseData.containsKey('access_token') &&
              responseData.containsKey('id_repartidor') &&
              responseData.containsKey('nombre_repartidor') &&
              responseData.containsKey('apellido_repartidor') &&
              responseData.containsKey('correo_repartidor') &&
              responseData.containsKey('role') &&
              responseData['role'] == 'repartidor') {
            await saveAuthToken(responseData['access_token']);
            await saveUserId(responseData['id_repartidor']);
            await saveUserName(responseData['nombre_repartidor']);
            await saveUserLastName(responseData['apellido_repartidor']);
            await saveUserEmail(responseData['correo_repartidor']);
            await saveUserRole(responseData['role']);

            // --- INICIO DE CAMBIOS SUGERIDOS ---
            // Verificar y guardar el número de teléfono del repartidor si está presente
            if (responseData.containsKey('telefono_repartidor')) {
              await saveUserPhone(responseData['telefono_repartidor']);
              print('Teléfono del repartidor guardado: ${responseData['telefono_repartidor']}');
            } else {
              print('Teléfono del repartidor no encontrado en la respuesta del login.');
              // Opcionalmente, guardar un valor por defecto o null si prefieres
              // await saveUserPhone("N/A");
            }

            // Verificar y guardar detalles del vehículo si están presentes
            if (responseData.containsKey('vehiculo_repartidor')) {
              // <--- CLAVE CORREGIDA
              // Ahora que la clave es correcta, decidimos cómo guardarlo.
              // Opción 1: Si tienes una función específica en auth.dart como saveVehicleDetails
              // await saveVehicleDetails(responseData['vehiculo_repartidor']);
              // print('Vehículo del repartidor guardado (usando saveVehicleDetails): ${responseData['vehiculo_repartidor']}');

              // Opción 2: Si quieres usar una clave genérica en SharedPreferences
              // y tienes una función como saveString('userVehicleDetailsKey', responseData['vehiculo_repartidor'])
              // O si la pantalla DeliveryAccountInformationScreen espera cargar esto con una clave específica.

              // Por ahora, solo imprimamos para confirmar que se lee correctamente:
              print('Vehículo del repartidor RECIBIDO: ${responseData['vehiculo_repartidor']}');

              // PARA QUE SE MUESTRE EN DeliveryAccountInformationScreen:
              // Debes tener una función en auth.dart para guardar este dato, por ejemplo:
              // Future<void> saveDeliveryVehicleDetails(String details) async {
              //   SharedPreferences prefs = await SharedPreferences.getInstance();
              //   await prefs.setString('deliveryVehicleDetails', details); // Usa una clave consistente
              // }
              // Y luego llamarla aquí:
              await saveDeliveryVehicleDetails(
                responseData['vehiculo_repartidor'],
              ); // Asumiendo que creas esta función
            } else {
              // Este else ya no debería ejecutarse si el backend envía 'vehiculo_repartidor'
              print(
                'Vehículo del repartidor (vehiculo_repartidor) no encontrado en la respuesta del login.',
              );
            }
            // --- FIN DE CAMBIOS SUGERIDOS ---

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Driver login successful!')));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => DeliveryHomeScreen(
                      repartidorNombre:
                          responseData['nombre_repartidor'] +
                          " " +
                          responseData['apellido_repartidor'], // Nombre completo
                      repartidorId: responseData['id_repartidor'],
                    ),
              ),
            );
          } else {
            _showErrorSnackbar(
              context,
              'Driver login error: Missing or incorrect user information in response.',
            );
            print('Respuesta incompleta o incorrecta del backend (Repartidor): ${response.body}');
          }
        }
      } else if (response.statusCode == 401) {
        _showErrorSnackbar(context, 'Invalid credentials. Please check your email and password.');
      } else if (response.statusCode == 404 && _selectedRole == 'driver') {
        _showErrorSnackbar(context, 'Driver login endpoint not found. Check API URL.');
        print('Error 404 para repartidor, verificar URL del API: $url');
      } else {
        _showErrorSnackbar(
          context,
          'Login failed. Status: ${response.statusCode}. Error: ${responseData['detail'] ?? response.body}',
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      print('Error de conexión o parseo: $e');
      _showErrorSnackbar(context, 'Could not connect to the server or an error occurred.');
    } finally {
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.redAccent));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color orangeColor = const Color(0xFFf05000);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fondoSemiTransparente.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                FractionallySizedBox(
                  widthFactor: 0.4,
                  child: Image.asset('assets/logos/logo.png', height: 70),
                ),
                const SizedBox(height: 20),

                // Títulos
                const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Log in to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Selector de rol
                Center(
                  child: ToggleButtons(
                    isSelected: _selectedRoleToggle,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < _selectedRoleToggle.length; i++) {
                          _selectedRoleToggle[i] = i == index;
                        }
                        _selectedRole = index == 0 ? 'customer' : 'driver';
                        print('Rol seleccionado: $_selectedRole');
                      });
                    },
                    borderRadius: BorderRadius.circular(8.0),
                    selectedBorderColor: orangeColor,
                    selectedColor: Colors.white,
                    fillColor: orangeColor,
                    color: orangeColor,
                    constraints: const BoxConstraints(minHeight: 40.0, minWidth: 120.0),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Customer'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Driver'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Campos de texto
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    labelStyle: TextStyle(fontSize: 14),
                    filled: true, // Para que el fondo blanco se vea sobre la imagen
                    fillColor: Colors.white70, // Un blanco semi-transparente
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    labelStyle: TextStyle(fontSize: 14),
                    filled: true, // Para que el fondo blanco se vea sobre la imagen
                    fillColor: Colors.white70, // Un blanco semi-transparente
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                // Botón de Login
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _attemptLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                          : const Text('Login'),
                ),
                const SizedBox(height: 10),

                // Olvidaste tu contraseña
                TextButton(
                  onPressed: () {
                    print('Forgot your password');
                  },
                  child: Text(
                    'Forgot your password?',
                    style: TextStyle(color: orangeColor, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 15),

                // Separador "o inicia sesión con" - ESTILO ACTUALIZADO
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  // decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)), // Ya no es necesario si solo es texto
                  child: Row(
                    // Mantenemos el Row para centrar el texto
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Eliminamos las Dividers
                      // Expanded(
                      //   child: Divider(
                      //     endIndent: 10,
                      //     color: Colors.grey.shade400,
                      //     thickness: 0.8,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ), // Mantenemos el padding
                        child: Text(
                          "- or sign in with -", // <--- CAMBIO AQUÍ: Guiones añadidos al texto
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ),
                      // Eliminamos las Dividers
                      // Expanded(
                      //   child: Divider(
                      //     indent: 10,
                      //     color: Colors.grey.shade400,
                      //     thickness: 0.8,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Botones de Google y Facebook
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialLoginButton(
                      assetPath: 'assets/logos/googleLogo.png',
                      onTap: () => print('Sign in with Google'),
                    ),
                    const SizedBox(width: 20),
                    _buildSocialLoginButton(
                      icon: Icons.facebook,
                      iconColor: Colors.blue.shade700,
                      onTap: () => print('Sign in with Facebook'),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Enlace de Registro
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        // <--- CAMBIO AQUÍ
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ), // <--- CAMBIO: Color y tamaño
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Register!',
                          style: TextStyle(
                            fontSize: 14, // Mantenemos tamaño 14 para el botón de acción
                            color: orangeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para botones de login social
  Widget _buildSocialLoginButton({
    String? assetPath,
    IconData? icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco para los botones
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10.0), // Padding uniforme
        child:
            assetPath != null
                ? Image.asset(assetPath, height: 28) // Tamaño unificado
                : Icon(icon, color: iconColor, size: 28), // Tamaño unificado
      ),
    );
  }
}
