import 'package:flutter/material.dart';
import '../../loginScreen.dart'; // Para el logout
import '../../../auth/auth.dart'; // Para getUserName, getUserEmail, deleteAuthToken, getUserId
import '../homeScreen.dart'; // Para DeliveryHomeScreen
import 'accountInformation.dart'; // Importa la nueva pantalla de información de cuenta del repartidor
import './changePassword.dart'; // Importa la pantalla de cambio de contraseña
import './help/helpCenter.dart'; // Importa la pantalla principal del Centro de Ayuda
import './help/terms&conditions.dart'; // Importa la pantalla de Términos y Condiciones del Repartidor
import './help/privacy&policy.dart'; // Importa la pantalla de Política de Privacidad del Repartidor

class ProfileDelivery extends StatefulWidget {
  // static const String routeName = '/delivery-profile'; // No es necesario si es parte del IndexedStack

  const ProfileDelivery({super.key});

  @override
  State<ProfileDelivery> createState() => _ProfileDeliveryState();
}

class _ProfileDeliveryState extends State<ProfileDelivery> {
  String? _userName;
  String? _userEmail;
  int? _userId; // Para pasar al HomeScreen si es necesario

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userName = await getUserName();
    final userEmail = await getUserEmail();
    final userId = await getUserId(); // Cargar el ID del usuario
    if (mounted) {
      setState(() {
        _userName = userName;
        _userEmail = userEmail;
        _userId = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFf05000);
    final Color iconColor = primaryColor;
    final Color textColor = Colors.black87;
    final Color subtitleColor = Colors.grey.shade700;
    final Color cardBackgroundColor = Colors.white.withOpacity(0.95);
    final String backgroundImagePath = 'assets/images/fondoSemiTransparente.png';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.grey.shade200);
            },
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            final String repartidorNombre = _userName ?? "Repartidor";
                            // Usa el _userId cargado, o un valor por defecto si aún no está disponible
                            final int repartidorId = _userId ?? 0;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DeliveryHomeScreen(
                                      repartidorNombre: repartidorNombre,
                                      repartidorId: repartidorId,
                                    ),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 22),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: cardBackgroundColor,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryColor.withOpacity(0.15),
                          child: Icon(Icons.delivery_dining, size: 30, color: primaryColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userName ?? 'Loading name...',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                _userEmail ?? 'Loading email...',
                                style: TextStyle(fontSize: 15, color: subtitleColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionContainer(
                    context,
                    title: 'Account',
                    cardBackgroundColor: cardBackgroundColor,
                    children: [
                      _buildListTile(
                        context,
                        'Account Information',
                        'View or change your account information',
                        icon: Icons.person_outline,
                        iconColor: iconColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeliveryAccountInformationScreen(),
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        context,
                        'Password',
                        'Change your password',
                        icon: Icons.lock_outline,
                        iconColor: iconColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeliveryChangePasswordScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionContainer(
                    context,
                    title: 'Support',
                    cardBackgroundColor: cardBackgroundColor,
                    children: [
                      _buildListTile(
                        context,
                        'Help Center',
                        'Find answers and contact support',
                        icon: Icons.help_outline,
                        iconColor: iconColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeliveryHelpCenterScreen(),
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        context,
                        'Privacy & Policy',
                        'Read our privacy policy',
                        icon: Icons.shield_outlined,
                        iconColor: iconColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeliveryPrivacyPolicyScreen(),
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        context,
                        'Terms & Conditions',
                        'Read our terms and conditions',
                        icon: Icons.description_outlined,
                        iconColor: iconColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeliveryTermsAndConditionsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            label: const Text(
                              'Delete Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Delete Account (Delivery) - Coming Soon'),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.redAccent),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text(
                              'Log Out',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              await deleteAuthToken(); // Elimina todos los datos de SharedPreferences
                              if (mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    required Color cardBackgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle, {
    IconData? icon,
    Color iconColor = const Color(0xFFf05000),
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }
}
