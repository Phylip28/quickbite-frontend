import 'package:flutter/material.dart';
import '../customBottomNavigationBar.dart'; // Importa la navbar personalizada
import '../homeScreen.dart'; // Importa la pantalla de inicio
import '../profile.dart'; // Importa la pantalla de perfil

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  ShoppingCartScreenState createState() => ShoppingCartScreenState();
}

class ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final List<CartItem> _cartItems = [
    CartItem(name: 'Double hamburger', price: 42000, quantity: 2),
    CartItem(name: 'French Fries', price: 5900, quantity: 1),
    CartItem(name: 'Soda', price: 3000, quantity: 3),
    // Puedes añadir más ítems para simular una pantalla más larga
  ];
  double _tipAmount = 0;
  final double _discountAmount = 6000;
  int _selectedIndex = 0; // El índice del carrito es 0

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileClient()),
      );
    }
    // El índice 0 ya es el carrito
  }

  // Función para aumentar la cantidad de un producto
  void _increaseQuantity(int index) {
    setState(() {
      _cartItems[index].quantity++;
    });
  }

  // Función para disminuir la cantidad de un producto
  void _decreaseQuantity(int index) {
    setState(() {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _showRemoveConfirmation(index);
      }
    });
  }

  // Función para mostrar la confirmación de eliminación
  Future<void> _showRemoveConfirmation(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Eliminar del carrito?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '¿Estás seguro de que quieres eliminar ${_cartItems[index].name} del carrito?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                setState(() {
                  _cartItems.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Función para eliminar un producto deslizando
  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  // Controlador para el campo de propina
  final TextEditingController _tipController = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    double subtotal = _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double deliveryFee = 14500;
    double total = subtotal + deliveryFee + _tipAmount - _discountAmount;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondoSemiTransparente.png', // Reemplaza con la ruta de tu imagen de fondo
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              // <-- Envolvemos la Column con SingleChildScrollView
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFEEAE6,
                              ), // Un color de fondo claro para el botón
                              borderRadius: BorderRadius.circular(8.0),
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
                            'Confirm your order!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 40), // Espacio para alinear el título
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true, // Importante para usar dentro de un SingleChildScrollView
                    physics:
                        const NeverScrollableScrollPhysics(), // Deshabilita el scroll propio del ListView
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Dismissible(
                        key: Key(item.name),
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          _removeItem(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item.name} eliminado del carrito')),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.asset(
                                  'assets/images/hamburger.png', // Reemplaza con la imagen real
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Tierra querida',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '\$${item.price.toStringAsFixed(0)}',
                                      style: const TextStyle(color: Color(0xFFf05000)),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => _decreaseQuantity(index),
                                  ),
                                  Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () => _increaseQuantity(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _tipController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Propina (Opcional)',
                            prefixText: '\$',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _tipAmount = double.tryParse(value) ?? 0;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery'),
                            Text('\$${deliveryFee.toStringAsFixed(0)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Detalle del Descuento'),
                                  content: const Text('Se aplicó un descuento de \$6.000'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cerrar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Discounts', style: TextStyle(color: Colors.green)),
                              Text(
                                '- \$${_discountAmount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(thickness: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFf05000),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              // Navegar a la pantalla de pago
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaymentMethodScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Go to pay',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 80), // Añade espacio al final para el botón inferior
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavigationBar(
              currentIndex: _selectedIndex,
              onTabChanged: _onTabTapped,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  String name;
  double price;
  int quantity;

  CartItem({required this.name, required this.price, required this.quantity});
}

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Método de Pago')),
      body: const Center(child: Text('Pantalla de Selección de Método de Pago')),
    );
  }
}
