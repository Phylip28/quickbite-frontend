import 'package:flutter/material.dart';
import 'loginScreen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/fondoSemiTransparente.png',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView( // Lo mantenemos para evitar overflow por teclado
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 40), // Reducido
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24, // Reducido
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6), // Reducido
                const Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 14, // Reducido
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20), // Reducido
                Center(
                  child: Stack(
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 40, // Reducido
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 48, color: Colors.grey), // Reducido
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            print('Add Photo');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6.0), // Reducido
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.add_a_photo, size: 16, color: Colors.grey), // Reducido
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Reducido
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    hintText: 'Enter your full name',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontSize: 14), // Reducido
                    hintStyle: TextStyle(fontSize: 12), // Reducido
                  ),
                ),
                const SizedBox(height: 15), // Reducido
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email, size: 20), // Reducido
                    labelStyle: TextStyle(fontSize: 14), // Reducido
                    hintStyle: TextStyle(fontSize: 12), // Reducido
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15), // Reducido
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, size: 20), // Reducido
                    labelStyle: TextStyle(fontSize: 14), // Reducido
                    hintStyle: TextStyle(fontSize: 12), // Reducido
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20), // Reducido
                ElevatedButton(
                  onPressed: () {
                    print('Register button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12), // Reducido
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 16), // Reducido
                  ),
                ),
                const SizedBox(height: 15), // Reducido
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '- or register with -',
                      style: TextStyle(fontSize: 12, color: Colors.grey), // Reducido
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Reducido
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
                          padding: const EdgeInsets.all(6.0), // Reducido
                          child: Image.asset(
                            'assets/images/googleLogo.png',
                            height: 24, // Reducido
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Reducido
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
                          padding: const EdgeInsets.all(6.0), // Reducido
                          child: Icon(Icons.facebook, color: Colors.blue[700], size: 24), // Reducido
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Reducido
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Have an account?',
                      style: TextStyle(fontSize: 12, color: Colors.grey), // Reducido
                    ),
                    const SizedBox(width: 4), // Reducido
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 14, color: Colors.orange, fontWeight: FontWeight.bold), // Reducido
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30), // Reducido
              ],
            ),
          ),
        ],
      ),
    );
  }
}