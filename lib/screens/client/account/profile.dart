import 'package:flutter/material.dart';
import '../../loginScreen.dart';
import '../homeScreen.dart';
import '../cart/shoppingCart.dart';
import '../orders/orders.dart';
import '../membership/membership.dart';
import '../customBottomNavigationBar.dart';
import '../../../auth/auth.dart';
import 'accountInformation.dart';
import 'changePassword.dart';
import 'inviteFriends.dart';
import 'help/helpCenter.dart';
import 'help/privacy&policy.dart';
import 'help/terms&conditions.dart'; // Asegúrate que el nombre del archivo sea correcto si es 'terms_and_conditions.dart'

class ProfileClient extends StatefulWidget {
  const ProfileClient({super.key});

  @override
  State<ProfileClient> createState() => _ProfileClientState();
}

class _ProfileClientState extends State<ProfileClient> {
  final int _selectedIndex = 3; // El índice de "Account" en la navbar
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

  void _onTabTapped(int index) {
    if (_selectedIndex == index && index != 1 /* Permitir recargar HomeScreen */ ) {
      // Si es HomeScreen y ya está seleccionada, permitir recargarla (o manejar de otra forma)
      if (index == 1) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      }
      return;
    }

    // Actualizar el índice seleccionado ANTES de navegar si la pantalla actual no se reemplaza completamente
    // y si la barra de navegación necesita reflejar el cambio inmediatamente.
    // Sin embargo, con pushReplacement/pushAndRemoveUntil, la pantalla se reconstruye.
    // setState(() {
    //   _selectedIndex = index;
    // });

    switch (index) {
      case 0: // Cart
        Navigator.pushAndRemoveUntil(
          // Usar pushAndRemoveUntil para limpiar la pila
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
      case 2: // Orders (NUEVO en lugar de Membership)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const OrdersScreen(),
          ), // NAVEGAR A LA PANTALLA DE ÓRDENES
          (Route<dynamic> route) => false,
        );
        break;
      case 3: // Account (Profile)
        // Ya estamos en ProfileClient, no se necesita acción si _selectedIndex ya es 3.
        // Si se llega aquí desde otra pestaña, la pantalla se reconstruirá y _selectedIndex se inicializará a 3.
        // No es necesario un setState aquí si se usa pushAndRemoveUntil para las otras pestañas.
        break;
    }
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Al presionar atrás, usualmente se vuelve a la pantalla anterior en la pila.
                          // Si la pila está vacía o se quiere un comportamiento específico como ir a HomeScreen:
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFFf05000),
                            size: 24,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Your profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Para balancear el botón de retroceso
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFFf05000).withOpacity(0.2),
                          child: const Icon(Icons.person, size: 30, color: Color(0xFFf05000)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userName ?? 'Loading name...',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                _userEmail ?? 'Loading email...',
                                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                          child: Text(
                            'Account',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        _buildListTile(
                          context,
                          'Account information',
                          'Change your account information',
                          icon: Icons.person_outline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AccountInformationScreen(),
                              ),
                            );
                          },
                        ),
                        _buildListTile(
                          context,
                          'Password',
                          'Change your Password',
                          icon: Icons.lock_outline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                            );
                          },
                        ),
                        // AÑADIR OPCIÓN DE MEMBRESÍA AQUÍ
                        _buildListTile(
                          context,
                          'Membership',
                          'Manage your QuickBite membership',
                          icon: Icons.card_membership, // Icono para membresía
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MembershipScreen()),
                            );
                          },
                        ),
                        _buildListTile(
                          context,
                          'Invite your friends',
                          'Get \$59 for each invitation!',
                          icon: Icons.people_outline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const InviteFriendsScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                          child: Text(
                            'Support',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        _buildListTile(
                          context,
                          'Help Center',
                          'Find answers and contact support',
                          icon: Icons.help_outline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                            );
                          },
                        ),
                        _buildListTile(
                          context,
                          'Privacy & Policy',
                          'Read our privacy policy',
                          icon: Icons.shield_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                            );
                          },
                        ),
                        _buildListTile(
                          context,
                          'Terms & Conditions',
                          'Read our terms and conditions',
                          icon: Icons.description_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const TermsAndConditionsScreen(), // Asegúrate que el nombre de la clase sea correcto
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround, // Keeps the spacing distribution
                      children: [
                        Flexible(
                          // Wrap the "Delete account" button
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            label: const Text(
                              'Delete account',
                              textAlign: TextAlign.center, // Center text if it wraps
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              // TODO: Implementar diálogo de confirmación para eliminar cuenta
                              print('Delete account pressed');
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        // Add a small SizedBox for a guaranteed minimum space,
                        // though spaceAround might make this less critical.
                        // You can adjust or remove this if spaceAround provides enough.
                        const SizedBox(width: 8.0),
                        Flexible(
                          // Wrap the "Log Out" button
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text(
                              'Log Out',
                              textAlign: TextAlign.center, // Center text if it wraps
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              await deleteAuthToken();
                              if (mounted) {
                                // Add mounted check
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFf05000),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChanged: _onTabTapped,
        backgroundColor: Colors.white,
      ),
    );
  }

  static Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle, {
    IconData? icon,
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
                child: Icon(icon, color: const Color(0xFFf05000), size: 24),
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
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}
