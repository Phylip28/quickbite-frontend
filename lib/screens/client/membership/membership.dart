import 'package:flutter/material.dart';
import '../customBottomNavigationBar.dart';
import '../homeScreen.dart';
import '../cart/shoppingCart.dart';
import '../account/profile.dart';
import 'membershipPaymentScreen.dart';
import 'membershipTerms.dart';

const primaryColor = Color(0xFFf05000);
const starColor = Colors.amber;

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final int _selectedIndex = 2;

  void _onTabTapped(int index) {
    if (_selectedIndex == index) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 2:
        // Ya estamos en MembershipScreen
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true, // PERMITE QUE EL BODY SE EXTIENDA DETRÁS DE LA APPBAR
      appBar: AppBar(
        title: const Text(
          'QuickBite Team',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // CENTRA EL TÍTULO
        backgroundColor: Colors.white.withOpacity(0.85), // FONDO BLANCO SEMITRANSPARENTE
        elevation: 0.5, // SOMBRA MUY SUTIL O 0.0 PARA NINGUNA SOMBRA
        iconTheme: const IconThemeData(color: primaryColor),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        // El padding superior del SingleChildScrollView ayuda a que el contenido no quede oculto
        // por la AppBar translúcida. Si es necesario, se puede envolver el Column
        // dentro de un SafeArea y ajustar el padding.
        padding: EdgeInsets.only(
          top:
              kToolbarHeight +
              MediaQuery.of(context).padding.top +
              20.0, // Ajuste para AppBar y status bar
          left: 16.0,
          right: 16.0,
          bottom: 80.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              // CONTENEDOR SUPERIOR
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white, // FONDO BLANCO
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300, width: 0.5),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.star_purple500_outlined,
                    size: 60,
                    color: starColor,
                  ), // ESTRELLA AMARILLA
                  const SizedBox(height: 12),
                  const Text(
                    'Unlock Exclusive Benefits!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor, // LETRAS DEL TÍTULO EN NARANJA
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join QuickBite Premium today and elevate your food ordering experience with perks designed just for you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700], // Texto descriptivo en gris oscuro
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                'What You Get:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildBenefitItem(
              icon: Icons.delivery_dining_outlined,
              title: 'Free Delivery on All Orders',
              description:
                  'Enjoy unlimited free delivery from any restaurant, any time. No minimum order value required!',
            ),
            _buildBenefitItem(
              icon: Icons.local_offer_outlined,
              title: 'Exclusive Discounts & Deals',
              description:
                  'Get access to special member-only discounts, weekly deals, and early access to promotions.',
            ),
            _buildBenefitItem(
              icon: Icons.restaurant_menu_outlined,
              title: 'Priority Customer Support',
              description:
                  'Jump the queue with our dedicated priority support line for Premium members.',
            ),
            _buildBenefitItem(
              icon: Icons.card_giftcard_outlined,
              title: 'Monthly Surprise Perks',
              description:
                  'Receive a surprise gift or a special voucher every month as a token of our appreciation.',
            ),
            _buildBenefitItem(
              icon: Icons.new_releases_outlined,
              title: 'Early Access to New Restaurants',
              description:
                  'Be the first to try out new restaurants and special menus added to QuickBite.',
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // ANTERIOR:
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Subscription process not implemented yet.')),
                // );
                // print('Subscribe Now tapped');

                // NUEVO: Navegar a MembershipPaymentScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MembershipPaymentScreen()),
                );
              },
              child: const Text(
                'Subscribe Now for €9.99/month', // Cambiado de $ a €
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // ANTERIOR:
                // print('Learn more / Terms tapped');

                // NUEVO: Navegar a MembershipTermsScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MembershipTermsScreen()),
                );
              },
              child: const Text('Learn more or view terms', style: TextStyle(color: primaryColor)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChanged: _onTabTapped,
        backgroundColor: Colors.white.withOpacity(0.95), // También puedes hacerlo semitransparente
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 30, color: primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[850],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
