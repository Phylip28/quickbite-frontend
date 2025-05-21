import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'loginScreen.dart';
import '../auth/auth.dart';
import 'client/homeScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contraseniaController = TextEditingController();
  bool _termsAndConditionsChecked = false;
  bool _isLoading = false; // Para mostrar un indicador de carga

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_termsAndConditionsChecked) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('You must accept the terms and conditions.')));
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String nombre = _nombreController.text.trim();
    final String apellido = _apellidoController.text.trim();
    final String direccion = _direccionController.text.trim();
    final String telefono = _telefonoController.text.trim();
    final String correo = _correoController.text.trim();
    final String contrasenia = _contraseniaController.text.trim();

    final Uri url = Uri.parse('http://192.168.1.7:8000/users/register');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{
          'nombre_cliente': nombre,
          'apellido_cliente': apellido,
          'direccion_cliente': direccion,
          'telefono_cliente': telefono,
          'correo_cliente': correo,
          'contrasenia': contrasenia,
        }),
      );

      if (mounted) {
        if (response.statusCode == 201) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          print("[RegisterScreen] Response data from server: $data");

          if (data.containsKey('id_cliente') &&
              data.containsKey('nombre_cliente') &&
              data.containsKey('apellido_cliente') &&
              data.containsKey('direccion_cliente') &&
              data.containsKey('telefono_cliente') &&
              data.containsKey('correo_cliente') &&
              data.containsKey('access_token')) {
            // Es buena idea verificar el token también aquí

            // Guardar todos los datos del usuario
            // Asegúrate que el tipo de dato de id_cliente coincida con lo que espera saveUserId
            // o conviértelo. SharedPreferences usualmente guarda int como int, String como String.
            // Si saveUserId espera String:
            await saveUserId(data['id_cliente']);
            // Si saveUserId espera int (y SharedPreferences lo guarda como int):
            // await saveUserId(data['id_cliente']);
            print("[RegisterScreen] UserID saved: ${data['id_cliente']}");

            await saveUserName(data['nombre_cliente']);
            print("[RegisterScreen] UserName saved: ${data['nombre_cliente']}");

            await saveUserLastName(data['apellido_cliente']);
            print("[RegisterScreen] UserLastName saved: ${data['apellido_cliente']}");

            await saveUserAddress(data['direccion_cliente']);
            print("[RegisterScreen] Address saved: ${data['direccion_cliente']}");

            await saveUserPhone(data['telefono_cliente']); // <--- AÑADIDO
            print("[RegisterScreen] UserPhone saved: ${data['telefono_cliente']}");

            await saveUserEmail(data['correo_cliente']); // <--- AÑADIDO
            print("[RegisterScreen] UserEmail saved: ${data['correo_cliente']}");

            await saveAuthToken(data['access_token']);
            print("[RegisterScreen] Token saved: ${data['access_token']}");

            // Los prints de verificación de token pueden ir aquí si lo deseas
            // final tempToken = await getAuthToken();
            // print("[RegisterScreen] Token read back immediately after save: $tempToken");

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Registration successful!')));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            // Construye un mensaje de error más específico
            String missingKeys = "";
            if (!data.containsKey('id_cliente')) missingKeys += "id_cliente, ";
            if (!data.containsKey('nombre_cliente')) missingKeys += "nombre_cliente, ";
            if (!data.containsKey('apellido_cliente')) missingKeys += "apellido_cliente, ";
            if (!data.containsKey('direccion_cliente')) missingKeys += "direccion_cliente, ";
            if (!data.containsKey('telefono_cliente')) missingKeys += "telefono_cliente, ";
            if (!data.containsKey('correo_cliente')) missingKeys += "correo_cliente, ";
            if (!data.containsKey('access_token')) missingKeys += "access_token, ";

            if (missingKeys.isNotEmpty) {
              missingKeys = missingKeys.substring(
                0,
                missingKeys.length - 2,
              ); // Remover la última coma y espacio
            }

            print("[RegisterScreen] Error: Missing keys in response: $missingKeys");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Registration error: Missing user information in response. Missing: $missingKeys',
                ),
              ),
            );
          }
        } else {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorData['detail'] ?? 'Registration failed. Please try again.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error during registration: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/fondoSemiTransparente.png', fit: BoxFit.cover),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 40),
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Create your account',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 48, color: Colors.grey),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              print('Add Photo');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(Icons.add_a_photo, size: 16, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'First Name', // CAMBIADO
                      hintText: 'Enter your first name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                      labelStyle: TextStyle(fontSize: 14),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name'; // CAMBIADO
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _apellidoController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name', // CAMBIADO
                      hintText: 'Enter your last name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                      labelStyle: TextStyle(fontSize: 14),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name'; // CAMBIADO
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _direccionController,
                    decoration: const InputDecoration(
                      labelText: 'Address', // CAMBIADO
                      hintText: 'Enter your address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home_outlined, size: 20),
                      labelStyle: TextStyle(fontSize: 14),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address'; // CAMBIADO
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(
                      labelText: 'Phone', // CAMBIADO
                      hintText: 'Enter your phone number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_outlined, size: 20),
                      labelStyle: TextStyle(fontSize: 14),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number'; // CAMBIADO
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _correoController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email, size: 20),
                      labelStyle: TextStyle(fontSize: 14),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email'; // CAMBIADO
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email'; // CAMBIADO
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _contraseniaController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock, size: 20),
                      labelStyle: TextStyle(fontSize: 14),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password'; // CAMBIADO
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters'; // CAMBIADO
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _termsAndConditionsChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _termsAndConditionsChecked = value!;
                          });
                        },
                      ),
                      const Text(
                        'I agree to the Terms and Conditions',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isLoading ? null : (_termsAndConditionsChecked ? _register : null),
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
                            : const Text('Register', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '- or register with -',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          print('Register with Google');
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset('assets/logos/googleLogo.png', height: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          print('Register with Facebook');
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(Icons.facebook, color: Colors.blue[700], size: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Have an account?',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          'Sign in',
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
