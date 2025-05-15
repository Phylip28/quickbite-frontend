import 'package:flutter/material.dart';
import 'homeScreen.dart'; // Importa la HomeScreen

class LoadScreen extends StatefulWidget { // StatefulWidget para manejar el estado
  const LoadScreen({super.key});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  @override
  void initState() {
    super.initState();
    // Navega a la HomeScreen después de 2.5 segundos
    Future.delayed(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(), // Navega a HomeScreen
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/fondoCarga.png', // Fondo de la pantalla de inicio
            fit: BoxFit.cover,
          ),
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}