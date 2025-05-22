import 'package:flutter/material.dart';
import '../../../auth/auth.dart';
import 'shoppingCart.dart'; // Para globalCartItems y shoppingCartScreenKey
import '../homeScreen.dart';
import '../orders/orders.dart';
import '../account/profile.dart';
import '../customBottomNavigationBar.dart';
import './paymentSuccesfull.dart'; // <--- AÑADIR ESTE IMPORT

const Color primaryColor = Color(0xFFf05000); // Color principal de la app

enum PaymentMethod { visa, mastercard, cash }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? _selectedPaymentMethod = PaymentMethod.cash; // Valor inicial
  final int _selectedIndex = 0; // PaymentScreen es parte del flujo del Carrito (índice 0)

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
    if (mounted) {
      setState(() {
        _userAddress = address ?? "Not available";
        _userName = name ?? "Customer";
      });
    }
  }

  void _onTabTapped(int index) {
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
        (Route<dynamic> route) => false,
      );
      return;
    }
    switch (index) {
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OrdersScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 3:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
          (Route<dynamic> route) => false,
        );
        break;
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

    if (shoppingCartScreenKey.currentState != null && shoppingCartScreenKey.currentState!.mounted) {
      shoppingCartScreenKey.currentState!.setState(() {});
    }

    // --- INICIO DE CAMBIOS ---
    // Navegar directamente a PaymentSuccessfulScreen
    // Se elimina el AlertDialog y la navegación a HomeScreen desde aquí.
    // Si deseas mantener un mensaje breve, puedes usar un SnackBar antes de navegar,
    // pero PaymentSuccessfulScreen ya cumple la función de confirmación.

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const PaymentSuccessfulScreen()),
      (Route<dynamic> route) => false, // Limpia la pila hasta PaymentSuccessfulScreen
    );
    // --- FIN DE CAMBIOS ---

    // El código del AlertDialog anterior se elimina o se comenta:
    /*
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Order Placed!'),
          content: const Text('Thank you for your order. It has been placed successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
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
    */
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
      color: Colors.white,
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/fondoSemiTransparente.png', fit: BoxFit.cover),
          ),
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
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Confirm Payment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Para balancear el botón de retroceso
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
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
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
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
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
                          iconAsset: 'assets/logos/visa.png',
                          value: PaymentMethod.visa,
                        ),
                        _buildPaymentOption(
                          title: 'MasterCard',
                          subtitle: 'Enter information on the card',
                          iconAsset: 'assets/logos/masterCard.png',
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
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _finishOrder,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
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
        backgroundColor: Colors.white.withOpacity(0.95),
      ),
    );
  }
}
