import 'package:flutter/material.dart';
import '../../customBottomNavigationBar.dart';
import '../../homeScreen.dart';
import 'membership.dart'; // Para el botón "View Membership"
import '../../orders/orders.dart'; // Para la navbar
import '../profile.dart'; // Para la navbar
import '../../cart/shoppingCart.dart'; // Para la navbar

const Color primaryColor = Color(0xFFf05000);
const Color lightButtonColor = Color(0xFFFFF6F2); // Color para el botón "Skip" o "Go to Home"

class MembershipSuccessfulScreen extends StatefulWidget {
  const MembershipSuccessfulScreen({super.key});

  @override
  State<MembershipSuccessfulScreen> createState() => _MembershipSuccessfulScreenState();
}

class _MembershipSuccessfulScreenState extends State<MembershipSuccessfulScreen> {
  // Cuando esta pantalla carga, el ítem "Cuenta" (índice 3) debería estar activo.
  final int _initialSelectedIndex = 3;

  void _onTabTapped(int index) {
    // Si ya está en la pestaña "Cuenta" y la presiona de nuevo,
    // podría ir a la pantalla principal de perfil o a la de membresía.
    if (index == _initialSelectedIndex) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ProfileClient()), // O MembershipScreen()
        (Route<dynamic> route) => false,
      );
      return;
    }

    switch (index) {
      case 0: // Cart
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 1: // Home
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 2: // Orders
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OrdersScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 3: // Account (ya manejado arriba)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
          (Route<dynamic> route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // FONDO
            Positioned.fill(
              child: Image.asset(
                'assets/images/fondoSemiTransparente.png', // Tu imagen de fondo
                fit: BoxFit.cover,
              ),
            ),

            // BOTÓN DE RETROCESO (similar al de la imagen)
            Positioned(
              top: 16, // Ajusta según sea necesario
              left: 16, // Ajusta según sea necesario
              child: Material(
                color: Colors.white.withOpacity(0.7), // Fondo semitransparente para el botón
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    // Volver a la pantalla de membresía principal o perfil
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MembershipScreen(),
                      ), // O ProfileClient()
                      (Route<dynamic> route) => false,
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
                  ),
                ),
              ),
            ),

            // CONTENIDO PRINCIPAL (centrado)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Spacer(flex: 2), // Empuja el contenido hacia abajo
                  // ÍCONO DE CHECK (similar al de la imagen)
                  Container(
                    padding: const EdgeInsets.all(16), // Espacio alrededor del check
                    decoration: BoxDecoration(
                      color: primaryColor, // Círculo naranja
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white, // Check blanco
                      size: 60.0, // Tamaño del check
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // TEXTO DE CONFIRMACIÓN (adaptado para membresía)
                  Text(
                    'Welcome to the Team!', // O 'Subscription Successful!'
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0, // Ajusta el tamaño según la imagen
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Your QuickBite membership is now active.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0, // Ajusta el tamaño según la imagen
                      color: Colors.grey[700],
                    ),
                  ),
                  const Spacer(flex: 3), // Espacio antes de los botones
                  // BOTONES INFERIORES
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
                      ),
                      textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      // Navegar a la pantalla de Membresía o Cuenta
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MembershipScreen(),
                        ), // O ProfileClient()
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('View Membership', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightButtonColor, // Color claro para el botón "Skip"
                      foregroundColor: primaryColor, // Color del texto
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
                      ),
                      elevation: 0, // Sin sombra para un look más plano como en la imagen
                      textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      // Navegar a la pantalla de Home
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('Go to Home'), // Adaptado de "Skip"
                  ),
                  const Spacer(flex: 1), // Espacio después de los botones
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _initialSelectedIndex,
        onTabChanged: _onTabTapped,
        backgroundColor: Colors.white.withOpacity(0.95), // Fondo de la navbar
      ),
    );
  }
}
