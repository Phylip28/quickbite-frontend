import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import '../models/orderModel.dart'; // Ajusta la ruta si es necesario
import '../services/orderService.dart'; // Ajusta la ruta si es necesario
import '../customBottomNavigationBar.dart';
import '../homeScreen.dart';
import '../cart/shoppingCart.dart';
import '../account/profile.dart';

// Define el color primario si no está ya accesible globalmente
// o importa tu archivo de constantes de color.
const Color primaryColor = Color(0xFFf05000);

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final int _selectedIndex = 2;
  late Future<List<Order>> _ordersFuture;
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    setState(() {
      _ordersFuture = _orderService.getOrdersByClientId();
    });
  }

  void _onTabTapped(int index) {
    if (index == _selectedIndex) {
      // Ya estamos en esta pantalla, no hacer nada o refrescar si es necesario.
      return;
    }

    // Navegación usando pushReplacement para evitar acumular pantallas en la pila
    // si el usuario navega mucho entre las pestañas principales.
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
      // case 2: // Orders - Ya estamos aquí, no se necesita acción.
      //   break;
      case 3: // Account (Profile)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- INICIO DE CAMBIOS ---
      backgroundColor: Colors.white, // Fondo del Scaffold blanco
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ), // Texto naranja y negrita
        ),
        centerTitle: true, // Título centrado
        backgroundColor: Colors.white, // AppBar blanca
        elevation: 1.0, // Sutil elevación para distinguir del cuerpo
        automaticallyImplyLeading: false, // No mostrar botón de retroceso
        // iconTheme: const IconThemeData(color: primaryColor), // Si tuvieras otros iconos en el AppBar
      ),
      // --- FIN DE CAMBIOS ---
      body: RefreshIndicator(
        onRefresh: () async {
          _loadOrders();
        },
        child: FutureBuilder<List<Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: primaryColor));
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error loading orders: ${snapshot.error}'),
                    ),
                    ElevatedButton(
                      onPressed: _loadOrders,
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                      child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 20),
                    Text(
                      'You have no orders yet.',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Start shopping to see your orders here!',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              final orders = snapshot.data!;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderCard(order: order); // Usaremos este widget personalizado
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChanged: _onTabTapped,
        // backgroundColor: Colors.white, // Puedes definir el color de fondo aquí también si es necesario
      ),
    );
  }
}

// --- WIDGET PARA MOSTRAR UN PEDIDO INDIVIDUAL ---
class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  Color _getStatusColor(String status) {
    // Esta función ya está bien y se basa en los valores internos del estado
    switch (status.toLowerCase()) {
      case 'pendiente_confirmacion':
        return Colors.orange;
      case 'confirmado_por_restaurante':
      case 'confirmado':
      case 'en_preparacion':
        return Colors.blue;
      case 'listo_para_recoger':
        return Colors.teal;
      case 'recogido_por_repartidor':
      case 'en_camino':
        return Colors.deepPurple;
      case 'entregado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    // CAMBIO: Mapear claves de estado a texto en inglés para el usuario
    switch (status.toLowerCase()) {
      case 'pendiente_confirmacion':
        return 'Pending Confirmation';
      case 'confirmado_por_restaurante':
        return 'Confirmed by Restaurant';
      case 'confirmado': // Por si acaso
        return 'Confirmed';
      case 'en_preparacion':
        return 'In Preparation';
      case 'listo_para_recoger':
        return 'Ready for Pickup';
      case 'recogido_por_repartidor':
        return 'Picked up by Rider';
      case 'en_camino':
        return 'On its Way';
      case 'entregado':
        return 'Delivered';
      case 'cancelado':
        return 'Cancelled';
      default:
        // Si es un estado desconocido, lo formateamos genéricamente
        return status.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM d, yyyy \'at\' hh:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${order.idPedido}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Date: ${dateFormat.format(order.fechaPedido)}',
              style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Total: €${order.totalPedido.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Payment: ${order.metodoPago}',
              style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Items:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 6.0),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.cantidad}x ${item.nombreProducto}',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '€${(item.cantidad * item.precioUnitario).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _formatStatus(order.estadoPedido), // Esta función ahora traduce
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(order.estadoPedido),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
