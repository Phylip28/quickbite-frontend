import 'package:flutter/material.dart';
import '../../auth/auth.dart' as auth_service; // Importado con alias
import '../loginScreen.dart'; // For navigation after logout

class DeliveryHomeScreen extends StatelessWidget {
  final String repartidorNombre;
  final int repartidorId;
  // Considerar pasar también el correo si se va a mostrar:
  // final String repartidorCorreo;

  const DeliveryHomeScreen({
    super.key,
    required this.repartidorNombre,
    required this.repartidorId,
    // required this.repartidorCorreo,
  });

  static const String routeName = '/delivery-home';

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFf05000);
    final Color cardBackgroundColor = Colors.white;
    final Color textColorOnPrimary = Colors.white;
    final Color subtleTextColor = Colors.grey.shade700;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Panel de Repartidor',
          style: TextStyle(color: textColorOnPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 4.0,
        iconTheme: IconThemeData(
          color: textColorOnPrimary,
        ), // Para el botón de "atrás" si es aplicable
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: textColorOnPrimary),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              await auth_service.deleteAuthToken();
              // Es buena práctica también limpiar el rol si se guarda por separado
              // Si no tienes deleteUserRole, puedes comentarlo o añadir la función en auth.dart
              await auth_service.deleteUserRole();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        // Fondo con un gradiente sutil para dar profundidad
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor.withOpacity(0.05), Colors.grey.shade100.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          children: <Widget>[
            _buildWelcomeHeader(context, primaryColor, textColorOnPrimary, cardBackgroundColor),
            const SizedBox(height: 24),
            _buildInfoSection(context, primaryColor, subtleTextColor),
            const SizedBox(height: 24),
            _buildActionsGrid(context, primaryColor, textColorOnPrimary),
            const SizedBox(height: 20),
            // Puedes añadir más secciones aquí, como "Estadísticas Rápidas" o "Notificaciones"
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(
    BuildContext context,
    Color primaryColor,
    Color textColorOnPrimary,
    Color cardBackgroundColor,
  ) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: primaryColor,
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
              '¡Hola, $repartidorNombre!',
              style: TextStyle(fontSize: 20, color: textColorOnPrimary.withOpacity(0.9)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Color primaryColor, Color subtleTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tu Información',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: ListTile(
            leading: Icon(Icons.badge_outlined, color: primaryColor),
            title: const Text('ID de Repartidor'),
            subtitle: Text(
              '$repartidorId',
              style: TextStyle(fontSize: 16, color: subtleTextColor, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        // Podrías añadir más información aquí si la pasas a la pantalla
        // Card(
        //   elevation: 2.0,
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        //   child: ListTile(
        //     leading: Icon(Icons.email_outlined, color: primaryColor),
        //     title: const Text('Correo Electrónico'),
        //     subtitle: Text(repartidorCorreo, style: TextStyle(fontSize: 16, color: subtleTextColor, fontWeight: FontWeight.w500)),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildActionsGrid(BuildContext context, Color primaryColor, Color textColorOnPrimary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // Para deshabilitar el scroll de GridView dentro de ListView
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          children: <Widget>[
            _buildActionCard(
              context,
              icon: Icons.list_alt_rounded,
              label: 'Pedidos\nDisponibles',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad: Ver Pedidos Disponibles (Próximamente)'),
                  ),
                );
              },
              backgroundColor: primaryColor,
              iconColor: textColorOnPrimary,
              textColor: textColorOnPrimary,
            ),
            _buildActionCard(
              context,
              icon: Icons.two_wheeler_rounded, // Icono más específico
              label: 'Mis Pedidos\nAsignados',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad: Mis Pedidos Asignados (Próximamente)'),
                  ),
                );
              },
              backgroundColor: primaryColor,
              iconColor: textColorOnPrimary,
              textColor: textColorOnPrimary,
            ),
            _buildActionCard(
              context,
              icon: Icons.history_edu_rounded, // Icono diferente
              label: 'Historial de\nEntregas',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad: Historial de Entregas (Próximamente)'),
                  ),
                );
              },
              backgroundColor: Colors.white,
              iconColor: primaryColor,
              textColor: primaryColor,
              borderColor: primaryColor,
            ),
            _buildActionCard(
              context,
              icon: Icons.manage_accounts_rounded, // Icono más específico
              label: 'Configurar\nPerfil',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad: Configuración (Próximamente)')),
                );
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

  Widget _buildActionCard(
    BuildContext context, {
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
      color: backgroundColor,
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
}
