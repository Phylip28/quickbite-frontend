import 'package:flutter/material.dart';
import '../../loginScreen.dart';
import '../homeScreen.dart';
import '../cart/shoppingCart.dart';
import '../membership.dart';
import '../customBottomNavigationBar.dart';
import '../../../auth/auth.dart';
import 'accountInformation.dart';
import 'changePassword.dart';
import 'inviteFriends.dart';
import 'help/helpCenter.dart';
import 'help/privacy&policy.dart';
import 'help/terms&conditions.dart';

class ProfileClient extends StatefulWidget {
  const ProfileClient({super.key});

  @override
  State<ProfileClient> createState() => _ProfileClientState();
}

class _ProfileClientState extends State<ProfileClient> {
  int _selectedIndex = 3; // ASEGÚRATE DE QUE ESTÉ INICIALIZADO A 3
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
    if (_selectedIndex == index) return; // Si ya está en la pestaña, no hacer nada

    // Si se navega a una pantalla diferente, esa pantalla se encargará de su propio _selectedIndex.
    // Si se usa pushReplacement, esta instancia de ProfileClient se destruirá y reconstruirá
    // si se navega de vuelta, inicializando _selectedIndex a 3 de nuevo.

    // setState(() { // Esta línea es importante si NO usas pushReplacement para todas las navegaciones
    //   _selectedIndex = index; // y quieres que el estado visual se actualice inmediatamente.
    // });                 // Con pushReplacement para las pestañas principales, la reconstrucción se encarga.

    switch (index) {
      case 0: // Cart
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
        );
        break;
      case 1: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 2: // Membership
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MembershipScreen()),
        );
        break;
      case 3: // Account (Profile)
        // Ya estamos en ProfileClient, no se necesita acción de navegación si _selectedIndex ya es 3.
        // Si por alguna razón _selectedIndex no fuera 3 y se llega aquí,
        // la inicialización de la pantalla (si se reconstruye) o un setState asegurarían el estado correcto.
        if (_selectedIndex != 3 && mounted) {
          // Solo si es necesario y para asegurar consistencia
          setState(() {
            _selectedIndex = 3;
          });
        }
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                        // Reemplazar Image.asset con un Icon para consistencia y mejor escalabilidad
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
                      color: Colors.white.withOpacity(0.9), // Aumentar opacidad para legibilidad
                      borderRadius: BorderRadius.circular(12.0), // Bordes más suaves
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
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ), // Color más oscuro para el email
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 8.0,
                    ), // Ajustar padding
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
                          icon: Icons.person_outline, // Añadir icono
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
                          icon: Icons.lock_outline, // Añadir icono
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                            );
                          },
                        ),
                        _buildListTile(
                          context,
                          'Invite your friends',
                          'Get \$59 for each invitation!',
                          icon: Icons.people_outline, // Añadir icono
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const InviteFriendsScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 24), // Espacio entre secciones
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
                          'Find answers and contact support', // Subtítulo más descriptivo
                          icon: Icons.help_outline, // Añadir icono
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
                          'Read our privacy policy', // Subtítulo más descriptivo
                          icon: Icons.shield_outlined, // Añadir icono
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
                          'Read our terms and conditions', // Subtítulo más descriptivo
                          icon: Icons.description_outlined, // Añadir icono
                          onTap: () {
                            // CAMBIO AQUÍ
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TermsAndConditionsScreen(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton.icon(
                          // Usar .icon para mejor UI
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          label: const Text('Delete account', style: TextStyle(color: Colors.red)),
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
                        ElevatedButton.icon(
                          // Usar .icon para mejor UI
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text('Log Out', style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            await deleteAuthToken();
                            Navigator.pushAndRemoveUntil(
                              // Limpiar pila de navegación
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (Route<dynamic> route) =>
                                  false, // Eliminar todas las rutas anteriores
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFf05000),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80), // Espacio para la barra de navegación inferior
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex, // ASEGÚRATE DE PASAR EL _selectedIndex CORRECTO
        onTabChanged: _onTabTapped,
        backgroundColor: Colors.white, // O el color que uses
      ),
    );
  }

  // Modificar _buildListTile para aceptar un icono opcional
  static Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle, {
    IconData? icon, // NUEVO: Parámetro de icono opcional
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0), // Ajustar padding
        child: Row(
          children: [
            if (icon != null) // Mostrar icono si se proporciona
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
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 18,
            ), // Tamaño de flecha ajustado
          ],
        ),
      ),
    );
  }
}
