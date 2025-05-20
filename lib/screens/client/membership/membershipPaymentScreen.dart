import 'package:flutter/material.dart';
import '../../../auth/auth.dart'; // Ajusta la ruta si es necesario
import 'membership.dart'; // Para navegar de vuelta, etc.
import '../homeScreen.dart';
import '../cart/shoppingCart.dart'; // Podrías no necesitar globalCartItems aquí
import '../account/profile.dart';
import '../customBottomNavigationBar.dart';

const Color primaryColor = Color(0xFFf05000);

// MODIFICACIÓN 1: Quitar efectivo
enum MembershipPaymentMethod { visa, mastercard }

class MembershipPaymentScreen extends StatefulWidget {
  const MembershipPaymentScreen({super.key});

  @override
  State<MembershipPaymentScreen> createState() => _MembershipPaymentScreenState();
}

class _MembershipPaymentScreenState extends State<MembershipPaymentScreen> {
  // MODIFICACIÓN 1: Ajustar el método de pago seleccionado
  MembershipPaymentMethod? _selectedPaymentMethod =
      MembershipPaymentMethod.visa; // O null si prefieres que elija
  final int _selectedIndex = 2; // Asumiendo que es parte del flujo de Membership

  // MODIFICACIÓN 2: Campos para nombre y correo
  String _userEmail = "Loading email...";
  String _userName = "Loading name...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // MODIFICACIÓN 2: Cargar nombre y correo
    final email = await getUserEmail(); // Necesitas esta función en auth.dart
    final name = await getUserName();
    if (mounted) {
      setState(() {
        _userEmail = email ?? "Not available";
        _userName = name ?? "Customer";
      });
    }
  }

  void _onTabTapped(int index) {
    if (_selectedIndex == index) return;

    // Lógica de navegación similar a otras pantallas, ajustada para los 4 ítems
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        break;
      case 2: // Membership
        // Si ya está en el flujo de membresía, podría ir a la pantalla principal de membresía
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MembershipScreen()),
          (route) => false,
        );
        break;
      case 3:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
          (route) => false,
        );
        break;
    }
  }

  void _processSubscription() {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a payment method.')));
      return;
    }
    print('Subscription processing with: $_selectedPaymentMethod');
    print('User: $_userName, Email: $_userEmail');

    // TODO: Implementar lógica de suscripción (API, actualizar estado, etc.)

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Subscription Successful!'),
          content: const Text('Welcome to QuickBite Team! Your membership is now active.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Great!'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el diálogo
                // Navegar a la pantalla de membresía o perfil
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MembershipScreen(),
                  ), // O ProfileClient
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Copia y adapta _buildPaymentOption de PaymentScreen, quitando la lógica de 'isIconAsset' si solo tendrás tarjetas
  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required String iconAsset,
    required MembershipPaymentMethod value,
  }) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: RadioListTile<MembershipPaymentMethod>(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (MembershipPaymentMethod? newValue) {
          setState(() {
            _selectedPaymentMethod = newValue;
          });
        },
        secondary: Image.asset(
          iconAsset,
          width: 30,
          height: 30,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.credit_card, size: 30),
        ),
        activeColor: primaryColor,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // FONDO DEL SCAFFOLD A BLANCO SÓLIDO
      appBar: AppBar(
        title: const Text(
          'Join QuickBite Team',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // APPBAR CON FONDO BLANCO SÓLIDO
        elevation: 0.5, // Puedes mantener una sombra sutil o poner 0.0
        iconTheme: const IconThemeData(color: primaryColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Si tenías algún widget de fondo aquí (ej. Image.asset), elimínalo
          // para que se vea el backgroundColor del Scaffold.
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account Details',
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
                                      Icons.email_outlined,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _userEmail,
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
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPaymentOption(
                          title: 'Visa',
                          subtitle: 'Pay with your Visa card',
                          iconAsset: 'assets/logos/visa.png',
                          value: MembershipPaymentMethod.visa,
                        ),
                        _buildPaymentOption(
                          title: 'MasterCard',
                          subtitle: 'Pay with your MasterCard',
                          iconAsset: 'assets/logos/masterCard.png',
                          value: MembershipPaymentMethod.mastercard,
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
                      onPressed: _processSubscription,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white, // El botón ya tiene fondo blanco
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Subscribe Now'),
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
        backgroundColor: Colors.white, // BOTTOMNAVBAR CON FONDO BLANCO SÓLIDO
      ),
    );
  }
}
