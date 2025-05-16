import 'package:flutter/material.dart';
import 'screens/client/homeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MPV',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: HomeScreen(), // Pantalla de carga
      routes: {
        '/home': (context) => HomeScreen(), // Mantenemos la ruta /home
      },
    );
  }
}
