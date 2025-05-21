import 'package:flutter/material.dart';
import 'customBottomNavigationBar.dart';
import 'account/profile.dart'; // Para ProfileDelivery
// Importa las otras pantallas principales si están en archivos separados
// import 'map/map.dart'; // Si DeliveryRouteMapScreen está en map.dart
// import 'history_screen.dart'; // Si DeliveryHistoryScreen está en history_screen.dart

// Las clases DeliveryDashboardContent, DeliveryRouteMapScreen, DeliveryHistoryScreen
// deben estar definidas (pueden estar en este archivo o importadas).
// CADA UNA DE ESTAS DEBE TENER SU PROPIA AppBar.

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

  // _appBarTitles ya no es necesario aquí, cada pantalla maneja su título.

  @override
  Widget build(BuildContext context) {
    // Define widgetOptions directamente en el método build.
    // CADA WIDGET EN ESTA LISTA DEBE SER UN SCAFFOLD CON SU PROPIA AppBar.
    final List<Widget> widgetOptions = <Widget>[
      DeliveryDashboardContent(
        // Index 0
        repartidorNombre: widget.repartidorNombre,
        repartidorId: widget.repartidorId,
      ),
      const DeliveryRouteMapScreen(), // Index 1
      const DeliveryHistoryScreen(), // Index 2
      const ProfileDelivery(), // Index 3
    ];

    return Scaffold(
      // backgroundColor: Colors.white, // El color de fondo lo manejará cada pantalla individual
      // appBar: AppBar(...), // <--- NO HAY AppBar EN DeliveryHomeScreen
      body: IndexedStack(
        index: (_selectedIndex < widgetOptions.length) ? _selectedIndex : 0,
        children: widgetOptions,
      ),
      bottomNavigationBar: DeliveryCustomBottomNavigationBar(
        currentIndex: (_selectedIndex < widgetOptions.length) ? _selectedIndex : 0,
        onTap: (int index) {
          // Simplemente actualiza el índice para cambiar la pestaña
          if (index < widgetOptions.length) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        // Asegúrate que DeliveryCustomBottomNavigationBar tenga 4 items
        // (Dashboard, Map, History, Profile)
      ),
    );
  }
}

// -------------------------------------------------------------------------
// EJEMPLOS DE CÓMO DEBEN SER LAS PANTALLAS DEL IndexedStack
// CADA UNA DEBE SER UN SCAFFOLD CON SU PROPIA AppBar
// -------------------------------------------------------------------------

// Ejemplo para DeliveryDashboardContent:
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
    return Scaffold(
      // <--- DEBE SER UN SCAFFOLD
      appBar: AppBar(
        // <--- CON SU PROPIA AppBar
        title: Text(
          'Delivery Panel',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        automaticallyImplyLeading:
            false, // No botón de retroceso si es una pantalla base de la navbar
      ),
      body: Container(
        // El contenido del dashboard
        color: Colors.grey[100],
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _buildWelcomeHeader(context, repartidorNombre),
            const SizedBox(height: 20),
            _buildInfoSection(context, repartidorId),
            const SizedBox(height: 20),
            _buildActionsGrid(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, String repartidorNombre) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.delivery_dining_outlined, size: 48, color: Colors.grey.shade600),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Hello, $repartidorNombre!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, int repartidorId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            'Your Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: Icon(Icons.badge_outlined, color: Colors.grey.shade600, size: 28),
            title: Text(
              'Driver ID',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            subtitle: Text(
              '$repartidorId',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsGrid(BuildContext context) {
    Widget buildActionCardLocal({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
    }) {
      return Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 30, color: Colors.grey.shade600),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
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
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 1.1,
          children: <Widget>[
            buildActionCardLocal(
              icon: Icons.list_alt_rounded,
              label: 'Available\nOrders',
              onTap: () {
                /* ... */
              },
            ),
            buildActionCardLocal(
              icon: Icons.two_wheeler_rounded,
              label: 'My Assigned\nOrders',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeliveryRouteMapScreen()),
                );
              },
            ),
            buildActionCardLocal(
              icon: Icons.history_edu_rounded,
              label: 'Delivery\nHistory',
              onTap: () {
                /* ... */
              },
            ),
            buildActionCardLocal(
              icon: Icons.manage_accounts_rounded,
              label: 'Profile\nSettings',
              onTap: () {
                /* ... */
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Ejemplo para DeliveryRouteMapScreen:
// (Asegúrate que esté en su propio archivo o aquí, y que sea un Scaffold con AppBar)
class DeliveryRouteMapScreen extends StatelessWidget {
  const DeliveryRouteMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFf05000);
    final String mapImagePath = 'assets/images/england.png';

    return Scaffold(
      // <--- DEBE SER UN SCAFFOLD
      appBar: AppBar(
        // <--- CON SU PROPIA AppBar
        title: Text(
          'Route Map',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        // El contenido del mapa
        fit: StackFit.expand,
        children: [
          Image.asset(
            mapImagePath,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(child: Text('Map image not available')),
                ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Map Feature\nComing Soon!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Ejemplo para DeliveryHistoryScreen:
class DeliveryHistoryScreen extends StatelessWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFf05000);
    return Scaffold(
      // <--- DEBE SER UN SCAFFOLD
      appBar: AppBar(
        // <--- CON SU PROPIA AppBar
        title: Text(
          'Delivery History',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        automaticallyImplyLeading: false,
      ),
      body: const Center(child: Text('History Screen (Content)')), // El contenido del historial
    );
  }
}

// ProfileDelivery ya debería tener su propia estructura con un encabezado personalizado
// que actúa como AppBar y su propia BottomNavigationBar si esa es la intención final para ella.
// Si ProfileDelivery también va a ser una pestaña simple SIN su propia navbar inferior
// y usando el encabezado personalizado como AppBar, entonces su estructura interna
// (el Scaffold y el encabezado personalizado) está bien, y se incluye en widgetOptions.
