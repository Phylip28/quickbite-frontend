import 'package:flutter/material.dart';
import 'customBottomNavigationBar.dart';

// Placeholder screens (sin cambios)
class DeliveryOrdersScreen extends StatelessWidget {
  const DeliveryOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Orders Screen (Content)'));
  }
}

class DeliveryMapScreen extends StatelessWidget {
  const DeliveryMapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Map Screen (Content)'));
  }
}

class DeliveryHistoryScreen extends StatelessWidget {
  const DeliveryHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('History Screen (Content)'));
  }
}

class DeliveryProfileScreen extends StatelessWidget {
  final String repartidorNombre;
  final int repartidorId;

  const DeliveryProfileScreen({
    super.key,
    required this.repartidorNombre,
    required this.repartidorId,
  });

  @override
  Widget build(BuildContext context) {
    // El logout podría moverse a esta pantalla de perfil si se desea
    return Center(child: Text('Profile Screen for $repartidorNombre (ID: $repartidorId)'));
  }
}

class DeliveryHomeScreen extends StatefulWidget {
  static const String routeName = '/delivery-home';

  final String repartidorNombre;
  final int repartidorId;

  const DeliveryHomeScreen({super.key, required this.repartidorNombre, required this.repartidorId});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFf05000);

    const String appBarTitle = 'Delivery Panel';

    return Scaffold(
      backgroundColor: Colors.white, // Asegura fondo blanco para el Scaffold
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold), // Texto Naranja
        ),
        backgroundColor: Colors.white, // Fondo Blanco
        elevation: 1.0, // Una elevación sutil o 0.0 si prefieres sin sombra
        iconTheme: IconThemeData(color: primaryColor), // Iconos (si los hubiera) en Naranja
        automaticallyImplyLeading: false, // Elimina la flecha de retroceso
        // actions: [], // Eliminada la sección de actions (botón de logout)
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DeliveryDashboardContent(
            repartidorNombre: widget.repartidorNombre,
            repartidorId: widget.repartidorId,
          ),
          const DeliveryMapScreen(),
          const DeliveryHistoryScreen(),
          DeliveryProfileScreen(
            repartidorNombre: widget.repartidorNombre,
            repartidorId: widget.repartidorId,
          ),
        ],
      ),
      bottomNavigationBar: DeliveryCustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class DeliveryDashboardContent extends StatelessWidget {
  final String repartidorNombre;
  final int repartidorId;

  const DeliveryDashboardContent({
    super.key,
    required this.repartidorNombre,
    required this.repartidorId,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFf05000);
    final Color textColorOnPrimary =
        Colors.white; // Se sigue usando para las cards con fondo naranja
    final Color subtleTextColor = Colors.grey.shade700;

    return Container(
      color: Colors.white, // Asegura fondo blanco para el contenido del dashboard
      // decoration: BoxDecoration( // Eliminado el gradiente
      //   gradient: LinearGradient(
      //     colors: [primaryColor.withOpacity(0.05), Colors.grey.shade100.withOpacity(0.5)],
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //   ),
      // ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: <Widget>[
          _buildWelcomeHeader(context, primaryColor, textColorOnPrimary, repartidorNombre),
          const SizedBox(height: 24),
          _buildInfoSection(context, primaryColor, subtleTextColor, repartidorId),
          const SizedBox(height: 24),
          _buildActionsGrid(context, primaryColor, textColorOnPrimary),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // _buildWelcomeHeader, _buildInfoSection, _buildActionsGrid (sin cambios en su lógica interna,
  // solo se adaptan al fondo blanco general si es necesario, pero sus Cards internas mantienen sus colores)

  Widget _buildWelcomeHeader(
    BuildContext context,
    Color primaryColor,
    Color textColorOnPrimary,
    String repartidorNombre,
  ) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: primaryColor, // Esta card mantiene su color naranja
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.delivery_dining_outlined,
                  size: 40,
                  color: textColorOnPrimary.withOpacity(0.8),
                ),
                const SizedBox(width: 12),
                Text(
                  'QuickBite Delivery',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColorOnPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Hello, $repartidorNombre!',
              style: TextStyle(fontSize: 20, color: textColorOnPrimary.withOpacity(0.9)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    Color primaryColor,
    Color subtleTextColor,
    int repartidorId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          color: Colors.white, // Aseguramos que esta card sea blanca si el fondo general lo es
          child: ListTile(
            leading: Icon(Icons.badge_outlined, color: primaryColor),
            title: const Text('Driver ID'),
            subtitle: Text(
              '$repartidorId',
              style: TextStyle(fontSize: 16, color: subtleTextColor, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsGrid(BuildContext context, Color primaryColor, Color textColorOnPrimary) {
    Widget buildActionCardLocal({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      required Color backgroundColor,
      required Color iconColor,
      required Color textColor,
      Color? borderColor,
    }) {
      return Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: borderColor != null ? BorderSide(color: borderColor, width: 1.5) : BorderSide.none,
        ),
        color: backgroundColor, // Las cards de acción mantienen sus colores definidos
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 36, color: iconColor),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          children: <Widget>[
            buildActionCardLocal(
              icon: Icons.list_alt_rounded,
              label: 'Available\nOrders',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature: View Available Orders (Coming Soon)')),
                );
              },
              backgroundColor: primaryColor,
              iconColor: textColorOnPrimary,
              textColor: textColorOnPrimary,
            ),
            buildActionCardLocal(
              icon: Icons.two_wheeler_rounded,
              label: 'My Assigned\nOrders',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature: My Assigned Orders (Coming Soon)')),
                );
              },
              backgroundColor: primaryColor,
              iconColor: textColorOnPrimary,
              textColor: textColorOnPrimary,
            ),
            buildActionCardLocal(
              icon: Icons.history_edu_rounded,
              label: 'Delivery\nHistory',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature: Delivery History (Coming Soon)')),
                );
              },
              backgroundColor: Colors.white,
              iconColor: primaryColor,
              textColor: primaryColor,
              borderColor: primaryColor,
            ),
            buildActionCardLocal(
              icon: Icons.manage_accounts_rounded,
              label: 'Profile\nSettings',
              onTap: () {
                // Aquí podrías navegar a la pestaña de perfil si lo deseas
                // _onItemTapped(3); // Si _onItemTapped fuera accesible aquí
                // O directamente:
                // DefaultTabController.of(context)?.animateTo(3); // Si usaras TabBarView
                // O manejar la navegación de otra forma.
                // Por ahora, un SnackBar.
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Feature: Settings (Coming Soon)')));
              },
              backgroundColor: Colors.white,
              iconColor: primaryColor,
              textColor: primaryColor,
              borderColor: primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
