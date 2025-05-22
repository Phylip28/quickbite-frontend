import 'package:flutter/material.dart';
import '../customBottomNavigationBar.dart';
import '../homeScreen.dart';
import '../cart/shoppingCart.dart';
import '../account/profile.dart';

// Define el color primario si no está ya accesible globalmente
// o importa tu archivo de constantes de color.
const Color primaryColor = Color(0xFFf05000);

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Asumiendo la siguiente estructura de la BottomNavigationBar:
  // Índice 0: Carrito
  // Índice 1: Home
  // Índice 2: Pedidos (esta pantalla)
  // Índice 3: Cuenta
  final int _selectedIndex = 2;

  void _onTabTapped(int index) {
    if (index == _selectedIndex) {
      // Ya estamos en esta pantalla, no hacer nada o refrescar si es necesario.
      return;
    }

    // Navegación usando pushReplacement para evitar acumular pantallas en la pila
    // si el usuario navega mucho entre las pestañas principales.
    switch (index) {
      case 0: // Cart
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
        );
        break;
      case 1: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      // case 2: // Orders - Ya estamos aquí, no se necesita acción.
      //   break;
      case 3: // Account (Profile)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- INICIO DE CAMBIOS ---
      backgroundColor: Colors.white, // Fondo del Scaffold blanco
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ), // Texto naranja y negrita
        ),
        centerTitle: true, // Título centrado
        backgroundColor: Colors.white, // AppBar blanca
        elevation: 1.0, // Sutil elevación para distinguir del cuerpo
        automaticallyImplyLeading: false, // No mostrar botón de retroceso
        // iconTheme: const IconThemeData(color: primaryColor), // Si tuvieras otros iconos en el AppBar
      ),
      // --- FIN DE CAMBIOS ---
      body: Center(
        // TODO: Reemplazar esto con la lógica para mostrar la lista de pedidos.
        // Por ahora, un placeholder.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[400],
            ), // Icono actualizado
            const SizedBox(height: 20),
            Text(
              'You have no orders yet.', // O 'Loading orders...'
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            Text(
              'Start shopping to see your orders here!',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChanged: _onTabTapped,
        // backgroundColor: Colors.white, // Puedes definir el color de fondo aquí también si es necesario
      ),
    );
  }
}
