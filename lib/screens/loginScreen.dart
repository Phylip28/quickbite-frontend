import 'package:flutter/material.dart';
import 'registerScreen.dart';
import 'client/homeScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Para mostrar un indicador de carga

  Future<void> _attemptLogin(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fields cannot be empty'))); // CAMBIADO
      return;
    }

    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    final Uri url = Uri.parse('http://192.168.246.36:8000/auth');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded'},
        body: <String, String>{'username': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Cuerpo de la respuesta del login: $data');
        if (data.containsKey('access_token') &&
            data.containsKey('id_cliente') &&
            data.containsKey('nombre_cliente') &&
            data.containsKey('apellido_cliente') &&
            data.containsKey('direccion_cliente') &&
            data.containsKey('telefono_cliente') &&
            data.containsKey('correo_cliente')) {
          print('Login exitoso (token e info de usuario recibida)');
          final String accessToken = data['access_token'];
          await saveAuthToken(accessToken);
          await saveUserId(data['id_cliente']);
          await saveUserName(data['nombre_cliente']);
          await saveUserLastName(data['apellido_cliente']);
          await saveUserAddress(data['direccion_cliente']);
          await saveUserPhone(data['telefono_cliente']);
          await saveUserEmail(data['correo_cliente']);
          print('Información del usuario guardada localmente');

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful'))); // CAMBIADO
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Authentication error: Missing user information in response', // CAMBIADO
              ),
            ),
          );
          print('Respuesta incompleta del backend (falta info de usuario): ${response.body}');
        }
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid credentials'))); // CAMBIADO
      } else {
        print('Error en el login: ${response.statusCode}');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login failed'))); // CAMBIADO
      }
    } catch (e) {
      print('Error de conexión: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not connect to the server'))); // CAMBIADO
    } finally {
      setState(() {
        _isLoading = false; // Ocultar indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/fondoSemiTransparente.png', fit: BoxFit.cover),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Image.asset('assets/logos/logo.png', height: 80),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Login', // YA EN INGLÉS
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Log in to your account', // YA EN INGLÉS
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email', // YA EN INGLÉS
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password', // YA EN INGLÉS
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _attemptLogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf05000),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                            : const Text('Login', style: TextStyle(fontSize: 16)), // YA EN INGLÉS
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      print('Forgot your password');
                    },
                    child: const Text(
                      'Forgot your password?', // YA EN INGLÉS
                      style: TextStyle(color: Color(0xFFf05000), fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '- or sign up with -', // YA EN INGLÉS
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          print('Sign in with Google');
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image(
                              image: AssetImage('assets/logos/googleLogo.png'),
                              height: 25,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          print('Sign in with Facebook');
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.facebook, color: Colors.blue, size: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?", // YA EN INGLÉS
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
                          'Register!', // YA EN INGLÉS
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFf05000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
