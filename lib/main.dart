import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/client/homeScreen.dart'; // Client's HomeScreen
import 'screens/delivery/homeScreen.dart'; // Delivery's HomeScreen
import 'screens/loginScreen.dart';
import 'auth/auth.dart' as auth_service; // For SharedPreferences keys

void main() async {
  // Asegura que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userRole = prefs.getString(auth_service.userRoleKey);
  String? authToken = prefs.getString(auth_service.authTokenKey);

  Widget initialScreen = const LoginScreen(); // Por defecto, ir al Login

  if (userRole != null && authToken != null) {
    if (userRole == 'customer') {
      // HomeScreen (cliente) no toma parámetros en su constructor actual en main.dart,
      // asume que los carga internamente desde SharedPreferences.
      initialScreen = const HomeScreen();
    } else if (userRole == 'driver' || userRole == 'repartidor') {
      // Aceptamos ambos por si acaso
      int? repartidorId = prefs.getInt(
        auth_service.userIdKey,
      ); // userIdKey guarda el id del repartidor
      String? repartidorNombre = prefs.getString(
        auth_service.userNameKey,
      ); // userNameKey guarda el nombre del repartidor

      if (repartidorId != null && repartidorNombre != null) {
        initialScreen = DeliveryHomeScreen(
          repartidorId: repartidorId,
          repartidorNombre: repartidorNombre,
        );
      } else {
        // Si falta información del repartidor, mejor ir a Login para re-autenticar
        initialScreen = const LoginScreen();
      }
    } else {
      // Rol desconocido o estado inválido, ir a Login
      initialScreen = const LoginScreen();
    }
  }

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickBite App', // Título actualizado
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFf05000),
        ), // Usando tu color naranja
        primaryColor: const Color(0xFFf05000), // Color primario
        scaffoldBackgroundColor: Colors.white, // Fondo de scaffold por defecto
        fontFamily: 'Roboto', // Puedes definir una fuente global si quieres
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFf05000), // Color naranja para AppBars por defecto
          foregroundColor: Colors.white, // Texto e iconos blancos en AppBar por defecto
          elevation: 1.0,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: const Color(0xFFf05000), // Naranja para ítem seleccionado
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFf05000), // Naranja para botones elevados
            foregroundColor: Colors.white, // Texto blanco
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFf05000), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFFf05000)),
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: initialScreen, // La pantalla inicial se determina dinámicamente
      routes: {
        // Define tus rutas nombradas aquí si las necesitas para navegación interna
        LoginScreen.routeName: (context) => const LoginScreen(),
        HomeScreen.routeName:
            (context) => const HomeScreen(), // Asumiendo que HomeScreen tiene routeName
        DeliveryHomeScreen.routeName: (context) {
          // Para DeliveryHomeScreen, necesitarías una forma de pasar los argumentos
          // si se navega a ella directamente por nombre de ruta después del login.
          // Por ahora, la navegación inicial desde main() ya los pasa.
          // Si se navega desde otro lugar, se deben proveer los argumentos.
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args != null &&
              args.containsKey('repartidorId') &&
              args.containsKey('repartidorNombre')) {
            return DeliveryHomeScreen(
              repartidorId: args['repartidorId'] as int,
              repartidorNombre: args['repartidorNombre'] as String,
            );
          }
          // Fallback o error si los argumentos no están
          return const LoginScreen(); // O una pantalla de error
        },
        // ... otras rutas
      },
    );
  }
}
