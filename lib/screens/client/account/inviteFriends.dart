import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para copiar al portapapeles

// Colores (asegúrate que estén definidos o importados)
const primaryColor = Color(0xFFf05000); // RGB: 240, 80, 0
const lightAccentColor = Color(0xFFFEEAE6); // RGB: 254, 234, 230

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key});

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  final String _referralCode = "QUICKBITE123";

  void _copyReferralCode() {
    Clipboard.setData(ClipboardData(text: _referralCode));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Referral code copied to clipboard!')));
  }

  void _shareReferral() {
    print('Share referral tapped. Code: $_referralCode');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Share functionality not yet implemented.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/fondoCarga.png', fit: BoxFit.cover)),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: lightAccentColor, // Opacidad completa aquí
                            borderRadius: BorderRadius.circular(10),
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
                          'Invite Friends',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 44), // Balance for back button
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(
                          255,
                          255,
                          255,
                          0.95,
                        ), // Colors.white.withOpacity(0.95)
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(
                              158,
                              158,
                              158,
                              0.2,
                            ), // Colors.grey.withOpacity(0.2)
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.card_giftcard, // Icono de regalo
                            size: 80,
                            color: primaryColor,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Invite Friends, Earn Rewards!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Share your referral code with friends. When they sign up and place their first order, you both get \$59!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.4),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Your Referral Code:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: _copyReferralCode,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(
                                  254,
                                  234,
                                  230,
                                  0.7,
                                ), // lightAccentColor.withOpacity(0.7)
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: const Color.fromRGBO(
                                    240,
                                    80,
                                    0,
                                    0.5,
                                  ), // primaryColor.withOpacity(0.5)
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _referralCode,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.copy_all_outlined,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.share_outlined, color: Colors.white),
                            label: const Text(
                              'Share Your Code',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: _shareReferral,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
