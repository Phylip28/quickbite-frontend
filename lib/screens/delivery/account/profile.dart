import 'package:flutter/material.dart';
import '../../loginScreen.dart'; // Para el logout
import '../../../auth/auth.dart'; // Para getUserName, getUserEmail, deleteAuthToken
import '../homeScreen.dart'; // Para DeliveryHomeScreen
import './info.dart'; // Importa la nueva pantalla de información de cuenta del repartidor
import './changePassword.dart'; // Importa la pantalla de cambio de contraseña

class ProfileDelivery extends StatefulWidget {
  // static const String routeName = '/delivery-profile'; // No es necesario si es parte del IndexedStack

  const ProfileDelivery({super.key});

  @override
  State<ProfileDelivery> createState() => _ProfileDeliveryState();
}

class _ProfileDeliveryState extends State<ProfileDelivery> {
  // _selectedIndex y _onTabTapped NO son necesarios aquí
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userName = await getUserName();
    final userEmail = await getUserEmail();
    if (mounted) {
      setState(() {
        _userName = userName;
        _userEmail = userEmail;
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
            // Ya no necesitamos la Column externa para fijar el encabezado.
            // El SingleChildScrollView será el hijo directo del SafeArea.
            child: SingleChildScrollView(
              // El padding general se aplica aquí
              padding: const EdgeInsets.all(
                16.0,
              ), // Padding general para todo el contenido desplazable
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Encabezado Personalizado (AHORA DENTRO de SingleChildScrollView, se desplazará)
                  Padding(
                    // Quitamos el padding individual del encabezado si el padding general de SingleChildScrollView es suficiente,
                    // o lo ajustamos si es necesario. Por ahora, lo dejamos para mantener la estructura.
                    padding: const EdgeInsets.only(
                      bottom: 8.0,
                    ), // Ajusta el padding según sea necesario, ej. solo inferior
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            final String repartidorNombre = _userName ?? "Repartidor";
                            final int repartidorId = 0; // Placeholder - DEBES OBTENER EL ID REAL

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
                        const SizedBox(width: 40), // Para balancear el botón de retroceso
                      ],
                    ),
                  ),
                  // const SizedBox(height: 10), // Espacio después del encabezado si es necesario

                  // Información del Usuario
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

                  // Sección de Cuenta
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
                          // Navegar a DeliveryAccountInformationScreen
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
                          // Navegar a DeliveryChangePasswordScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeliveryChangePasswordScreen(),
                            ),
                          );
                        },
                      ),
                      // "Invite your friends" OMITIDO para el repartidor
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sección de Soporte (QuickBite en la imagen del cliente)
                  _buildSectionContainer(
                    context,
                    title: 'Support', // O 'QuickBite Support'
                    cardBackgroundColor: cardBackgroundColor,
                    children: [
                      _buildListTile(
                        context,
                        'Help Center',
                        'Find answers and contact support',
                        icon: Icons.help_outline,
                        iconColor: iconColor,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Help Center (Delivery) - Coming Soon')),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Privacy & Policy (Delivery) - Coming Soon'),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Terms & Conditions (Delivery) - Coming Soon'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botones de Acción
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          // Envuelve el botón "Delete Account"
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            label: const Text(
                              'Delete Account',
                              textAlign: TextAlign.center, // Centra el texto si se envuelve
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
                        const SizedBox(width: 8.0), // Espacio pequeño entre botones
                        Flexible(
                          // Envuelve el botón "Log Out"
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text(
                              'Log Out',
                              textAlign: TextAlign.center, // Centra el texto si se envuelve
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              await deleteAuthToken();
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
                  const SizedBox(height: 20), // Espacio para la navbar ya no es necesario aquí
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper para crear los contenedores de sección
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
                fontSize: 20, // Coincide con la imagen del cliente
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
                      fontSize: 16, // Coincide con la imagen del cliente
                      fontWeight: FontWeight.w500, // Un poco más de peso
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ), // Ligeramente más pequeño
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16), // Más pequeño
          ],
        ),
      ),
    );
  }
}
