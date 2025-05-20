import 'package:flutter/material.dart';
import '../../../../auth/auth.dart'; // Para getUserName, getUserEmail
import '../../customBottomNavigationBar.dart';
import '../../homeScreen.dart';
import '../../orders/orders.dart'; // CORREGIDO
import '../profile.dart';
import '../../cart/shoppingCart.dart'; // Para ShoppingCartScreen en la navbar
import 'membershipSuccessfulScreen.dart'; // Pantalla de éxito de membresía

const Color primaryColor = Color(0xFFf05000);
const double membershipPrice = 9.99; // Precio fijo de la membresía

// ENUM DE MÉTODO DE PAGO SIN EFECTIVO PARA MEMBRESÍA
enum MembershipPaymentMethod { visa, mastercard }

class MembershipPaymentScreen extends StatefulWidget {
  const MembershipPaymentScreen({super.key});

  @override
  State<MembershipPaymentScreen> createState() => _MembershipPaymentScreenState();
}

class _MembershipPaymentScreenState extends State<MembershipPaymentScreen> {
  MembershipPaymentMethod? _selectedPaymentMethod =
      MembershipPaymentMethod.visa; // Visa por defecto
  String _userName = "Loading...";
  String _userEmail = "Loading...";

  final int _navBarIndex = 3;

  @override
  void initState() {
    super.initState();
    print("DEBUG: MembershipPaymentScreen initState() llamado.");
    print("DEBUG: Valor inicial de _selectedPaymentMethod en initState: $_selectedPaymentMethod");
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    print("DEBUG: _loadUserData() llamado.");
    final name = await getUserName();
    final email = await getUserEmail();
    if (mounted) {
      print("DEBUG: _loadUserData() - widget montado, actualizando estado.");
      setState(() {
        _userName = name ?? "User";
        _userEmail = email ?? "No email available";
      });
    } else {
      print("DEBUG: _loadUserData() - widget NO montado después de async.");
    }
  }

  void _onTabTapped(int index) {
    print("DEBUG: _onTabTapped() llamado con index: $index");
    if (index == _navBarIndex) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ProfileClient()),
        (Route<dynamic> route) => false,
      );
      return;
    }
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
          (Route<dynamic> route) => false,
        );
        break;
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
      case 3: // Account
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
          (Route<dynamic> route) => false,
        );
        break;
    }
  }

  void _processSubscription() {
    print("DEBUG: _processSubscription() llamado.");
    print(
      "DEBUG: Valor de _selectedPaymentMethod al inicio de _processSubscription: $_selectedPaymentMethod",
    );
    if (_selectedPaymentMethod == null) {
      print("DEBUG: _selectedPaymentMethod ES NULL. Mostrando SnackBar.");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a payment method.')));
      return;
    }
    print("DEBUG: _selectedPaymentMethod NO ES NULL. Procesando...");
    print('Membership subscription processing with: $_selectedPaymentMethod');
    print('User: $_userName, Email: $_userEmail');
    print('Membership Price: €${membershipPrice.toStringAsFixed(2)}');

    print("DEBUG: Navegando a MembershipSuccessfulScreen...");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MembershipSuccessfulScreen()),
      (Route<dynamic> route) => false,
    );
    print("DEBUG: Navegación a MembershipSuccessfulScreen INVOCADA.");
  }

  Widget _buildMembershipPaymentOption({
    required String title,
    required String subtitle,
    required String iconAsset,
    required MembershipPaymentMethod value,
  }) {
    // print("DEBUG: _buildMembershipPaymentOption llamado para: $title, valor actual de _selectedPaymentMethod: $_selectedPaymentMethod");
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
          print(
            "DEBUG: RadioListTile onChanged para '$title'. Nuevo valor: $newValue. Valor anterior de _selectedPaymentMethod: $_selectedPaymentMethod",
          );
          setState(() {
            print("DEBUG: setState llamado en onChanged. _selectedPaymentMethod será: $newValue");
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
    print(
      "DEBUG: MembershipPaymentScreen build() llamado. Valor actual de _selectedPaymentMethod: $_selectedPaymentMethod",
    );
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
                        onTap: () {
                          print("DEBUG: Botón de retroceso presionado.");
                          Navigator.pop(context);
                        },
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
                          'Membership Payment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
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
                          'Payment',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildMembershipPaymentOption(
                          title: 'Visa',
                          subtitle: 'Enter information on the card',
                          iconAsset: 'assets/logos/visa.png',
                          value: MembershipPaymentMethod.visa,
                        ),
                        _buildMembershipPaymentOption(
                          title: 'MasterCard',
                          subtitle: 'Enter information on the card',
                          iconAsset: 'assets/logos/masterCard.png',
                          value: MembershipPaymentMethod.mastercard,
                        ),
                        const SizedBox(height: 24),
                        Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Membership Fee:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '€${membershipPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                    child: ElevatedButton(
                      onPressed: _processSubscription,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
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
        currentIndex: _navBarIndex,
        onTabChanged: _onTabTapped,
        backgroundColor: Colors.white.withOpacity(0.95),
      ),
    );
  }
}
