import 'package:flutter/material.dart';
import '../../../auth/auth.dart';
import 'shoppingCart.dart'; // Para globalCartItems y shoppingCartScreenKey
import '../homeScreen.dart';
import '../account/profile.dart'; // Para la navegación desde la NavBar
import '../customBottomNavigationBar.dart'; // IMPORTANTE: Añadir esta importación

const Color primaryColor = Color(0xFFf05000); // Color principal de la app

enum PaymentMethod { visa, mastercard, cash }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? _selectedPaymentMethod = PaymentMethod.cash; // Valor inicial
  final int _selectedIndex = 0; // Para el CustomBottomNavigationBar, el carrito es el índice 0

  String _userAddress = "Loading address...";
  String _userName = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final address = await getUserAddress();
    final name = await getUserName();
    setState(() {
      _userAddress = address ?? "Not available";
      _userName = name ?? "Customer";
    });
  }

  void _onTabTapped(int index) {
    if (_selectedIndex == index) return;

    // setState(() { // No es necesario si la navegación reemplaza la pantalla
    //   _selectedIndex = index;
    // });

    if (index == 0) {
      // Si ya estamos en PaymentScreen (que es parte del flujo del carrito),
      // y el usuario tapea "Carrito" de nuevo, podríamos ir a ShoppingCartScreen.
      // O si esta es la pantalla final del carrito, podría no hacer nada o ir a ShoppingCartScreen.
      // Por consistencia, si no estamos en ShoppingCartScreen, vamos allí.
      if (ModalRoute.of(context)?.settings.name != '/shoppingCart') {
        // Evita recargar si ya está en una pantalla de carrito
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
        );
      }
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false, // Limpia la pila de navegación hasta HomeScreen
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileClient()),
      );
    }
  }

  void _finishOrder() {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a payment method.')));
      return;
    }
    print('Order finished with: $_selectedPaymentMethod');
    print('Address: $_userAddress');
    globalCartItems.clear();
    // Si ShoppingCartScreen está en la pila y necesita actualizarse, puedes usar la key:
    if (shoppingCartScreenKey.currentState != null && shoppingCartScreenKey.currentState!.mounted) {
      shoppingCartScreenKey.currentState!.setState(() {});
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Placed!'),
          content: const Text('Thank you for your order. It has been placed successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required String iconAsset,
    required PaymentMethod value,
    bool isIconAsset = true,
  }) {
    return Card(
      elevation: 1,
      color: Colors.white, // Asegurar que las tarjetas sean blancas sobre el fondo
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: RadioListTile<PaymentMethod>(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (PaymentMethod? newValue) {
          setState(() {
            _selectedPaymentMethod = newValue;
          });
        },
        secondary:
            isIconAsset
                ? Image.asset(
                  iconAsset,
                  width: 30,
                  height: 30,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(Icons.credit_card, size: 30),
                )
                : Icon(Icons.local_atm, color: primaryColor.withOpacity(0.7), size: 30),
        activeColor: primaryColor,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent, // Hacemos el fondo del Scaffold transparente
      body: Stack(
        // Para el fondo semitransparente
        children: [
          // 1. Imagen de fondo semitransparente
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondoSemiTransparente.png', // Asegúrate de que esta ruta sea correcta
              fit: BoxFit.cover,
            ),
          ),
          // 2. Contenido principal de la pantalla
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8), // Fondo blanco para el botón
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delivery address',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 2,
                          color: Colors.white, // Fondo blanco para la tarjeta
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // MODIFICADO: Añadir icono de persona
                                  children: [
                                    const Icon(
                                      Icons.person_outline,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      // Para que el texto no se desborde si es largo
                                      child: Text(
                                        _userName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8), // Aumentar un poco el espacio
                                Row(
                                  // MODIFICADO: Añadir icono de ubicación
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      // Para que el texto no se desborde si es largo
                                      child: Text(
                                        _userAddress,
                                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPaymentOption(
                          title: 'Visa',
                          subtitle: 'Enter information on the card',
                          iconAsset:
                              'assets/logos/visa.png', // Asegúrate que esta ruta sea correcta
                          value: PaymentMethod.visa,
                        ),
                        _buildPaymentOption(
                          title: 'MasterCard',
                          subtitle: 'Enter information on the card',
                          iconAsset:
                              'assets/logos/masterCard.png', // Asegúrate que esta ruta sea correcta
                          value: PaymentMethod.mastercard,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Center(
                            child: Text(
                              '- or -',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ),
                        _buildPaymentOption(
                          title: 'Cash on delivery',
                          subtitle: 'Pay when your order arrives',
                          iconAsset: '',
                          value: PaymentMethod.cash,
                          isIconAsset: false,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _finishOrder,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white, // Botón con fondo blanco
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Finish order'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChanged: _onTabTapped,
        backgroundColor: Colors.white.withOpacity(
          0.95,
        ), // Fondo ligeramente transparente para la NavBar
      ),
    );
  }
}
