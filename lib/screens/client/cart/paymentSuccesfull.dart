import 'package:flutter/material.dart';
import '../customBottomNavigationBar.dart';
import '../homeScreen.dart';
import '../orders/orders.dart';
import '../account/profile.dart';
import 'shoppingCart.dart'; // For CartScreen if needed by navbar

const Color primaryColor = Color(0xFFf05000);
const Color lightBackgroundColor = Color(0xFFFFF6F2); // A light background for the "Skip" button

class PaymentSuccessfulScreen extends StatefulWidget {
  const PaymentSuccessfulScreen({super.key});

  @override
  State<PaymentSuccessfulScreen> createState() => _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen> {
  // Default to Home tab active when this screen loads.
  // When user navigates via bottom bar, _onTabTapped will handle it.
  final int _initialSelectedIndex = 1; // Home

  void _onTabTapped(int index) {
    // if (_initialSelectedIndex == index) return; // No need for this check if always replacing

    switch (index) {
      case 0: // Cart
        Navigator.pushAndRemoveUntil(
          // Clear stack and go to cart
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
      case 3: // Account
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
      // backgroundColor: Colors.white, // El Stack cubrirá esto
      body: SafeArea(
        child: Stack(
          children: [
            // FONDO
            Positioned.fill(
              // child: Opacity( // SE ELIMINA EL WIDGET OPACITY
              child: Image.asset(
                'assets/images/fondoSemiTransparente.png', // Esta es tu imagen de fondo
                fit: BoxFit.cover,
              ),
              // ), // SE ELIMINA EL WIDGET OPACITY
            ),

            // Contenido principal de la pantalla
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Spacer(flex: 2),
                    Icon(Icons.check_circle, color: primaryColor, size: 100.0),
                    const SizedBox(height: 24.0),
                    Text(
                      'Your order',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      'has been received',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const Spacer(flex: 3),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        // Navegar a la pantalla de Pedidos
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const OrdersScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text('Track your order', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: lightBackgroundColor, // ANTERIOR
                        backgroundColor: Colors.white, // CAMBIO AQUÍ
                        foregroundColor: primaryColor, // Text color
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          // Considera añadir un borde si el fondo de la pantalla también es blanco
                          // side: BorderSide(color: primaryColor.withOpacity(0.5))
                        ),
                        elevation: 0, // Mantenemos la elevación en 0 para un aspecto más plano
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
                      child: const Text('Skip'),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),

            // Custom Back Button (opcional, ya que los botones principales manejan la navegación)
            // Si decides mantenerlo, asegúrate de que su comportamiento sea el deseado.
            // Por ejemplo, podría llevar a HomeScreen.
            Positioned(
              top: 10,
              left: 10,
              child: Material(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
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
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _initialSelectedIndex, // Usar el índice inicial
        onTabChanged: _onTabTapped,
      ),
    );
  }
}
