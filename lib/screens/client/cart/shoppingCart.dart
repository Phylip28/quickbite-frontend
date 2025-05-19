import 'package:flutter/material.dart';
import '../customBottomNavigationBar.dart';
import '../homeScreen.dart';
import '../account/profile.dart';
import '../membership.dart'; // NUEVA IMPORTACIÓN
import 'paymentScreen.dart';

// --- Lista de ítems del carrito accesible estáticamente ---
// Esto permite que otras pantallas añadan productos al carrito.
// Para aplicaciones más grandes, considera un gestor de estado como Provider o Riverpod.
List<CartItem> globalCartItems = [];

// --- GlobalKey para acceder al estado del ShoppingCartScreen si es necesario ---
final GlobalKey<ShoppingCartScreenState> shoppingCartScreenKey =
    GlobalKey<ShoppingCartScreenState>();

class CartItem {
  // Asegúrate que esta es tu definición actualizada
  String name;
  double price;
  int quantity;
  String imageUrl;
  final String restaurant; // CAMBIO: Campo para el restaurante

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.restaurant, // CAMBIO: Parámetro requerido
  });

  @override
  String toString() {
    return 'CartItem(name: $name, price: $price, quantity: $quantity, imageUrl: $imageUrl, restaurant: $restaurant)';
  }
}

class ShoppingCartScreen extends StatefulWidget {
  // AÑADE const SI ES POSIBLE Y NO TIENES PARÁMETROS VARIABLES
  ShoppingCartScreen({Key? key})
    : super(key: key ?? shoppingCartScreenKey); // CAMBIO AQUÍ: Se eliminó 'const'

  @override
  ShoppingCartScreenState createState() => ShoppingCartScreenState();
}

class ShoppingCartScreenState extends State<ShoppingCartScreen> {
  // _cartItems ya no se usa localmente, se usa globalCartItems
  double _tipAmount = 0;
  final double _discountAmount = 0; // El descuento se mantiene, podrías hacerlo dinámico también
  final int _selectedIndex = 0; // ShoppingCartScreen es el índice 0
  final TextEditingController _tipController = TextEditingController(text: '0');
  // _deliveryFee se calculará dinámicamente en el método build, ya no es un campo fijo.

  // --- Método para añadir productos desde otras pantallas ---
  // Este método puede ser llamado desde cualquier pantalla de menú de restaurante.
  // Asegúrate de que este estado (ShoppingCartScreenState) se actualice si está visible
  // o que se reconstruya al navegar a él.
  void addProductToCart(
    String name,
    double price,
    String imageUrl,
    String restaurant, {
    int quantity = 1,
  }) {
    // Llama a setState para refrescar la UI si esta pantalla está activa.
    // Si no está activa, los cambios en globalCartItems se reflejarán cuando se abra.
    if (mounted) {
      setState(() {
        // CAMBIO: Pasar 'restaurant'
        _addProductInternal(name, price, imageUrl, restaurant, quantity: quantity);
      });
    } else {
      // CAMBIO: Pasar 'restaurant'
      _addProductInternal(name, price, imageUrl, restaurant, quantity: quantity);
    }
    print(
      'Producto añadido/actualizado en el carrito global: $name, Restaurante: $restaurant, Cantidad: $quantity',
    );
  }

  // CAMBIO: Añadir parámetro 'restaurant'
  void _addProductInternal(
    String name,
    double price,
    String imageUrl,
    String restaurant, {
    int quantity = 1,
  }) {
    final existingItemIndex = globalCartItems.indexWhere(
      (item) =>
          item.name == name &&
          item.restaurant == restaurant, // Considerar el restaurante para unicidad si es necesario
    );
    if (existingItemIndex != -1) {
      globalCartItems[existingItemIndex].quantity += quantity;
    } else {
      globalCartItems.add(
        CartItem(
          name: name,
          price: price,
          quantity: quantity,
          imageUrl: imageUrl,
          restaurant: restaurant, // CAMBIO: Usar el parámetro 'restaurant'
        ),
      );
    }
  }

  void _onTabTapped(int index) {
    if (_selectedIndex == index) return; // Evitar reconstrucción si ya está en la pestaña

    // setState(() { // No es estrictamente necesario si siempre usas pushReplacement
    //   _selectedIndex = index;
    // });

    switch (index) {
      case 0: // Cart
        // Ya estamos en ShoppingCartScreen
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
        );
        break;
    }
  }

  void _increaseQuantity(int index) {
    setState(() {
      globalCartItems[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (globalCartItems[index].quantity > 1) {
        globalCartItems[index].quantity--;
      } else {
        _showRemoveConfirmation(index);
      }
    });
  }

  Future<void> _showRemoveConfirmation(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Usar un context diferente para el dialog
        return AlertDialog(
          title: const Text('Remove from cart?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to remove ${globalCartItems[index].name} from the cart?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Remove'),
              onPressed: () {
                _removeItem(index); // Llama a la función que actualiza el estado
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _removeItem(int index) {
    setState(() {
      final item = globalCartItems[index];
      globalCartItems.removeAt(index);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${item.name} removed from cart')));
    });
  }

  void _goToPayment() {
    if (globalCartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please add items to your cart.')));
    } else {
      // Aquí se navega a la nueva PaymentScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentScreen(),
        ), // ESTA LÍNEA DEBERÍA ESTAR ASÍ
      );
    }
  }

  // La función anterior 'addItemToCart' se reemplaza/unifica con 'addProductToCart'
  // para consistencia y para incluir imageUrl.

  @override
  Widget build(BuildContext context) {
    // --- CÁLCULOS AUTOMÁTICOS ---
    double subtotal = globalCartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    // --- LÓGICA DE TARIFA DE ENVÍO DINÁMICA ---
    double deliveryFee;
    if (subtotal >= 25.00) {
      deliveryFee = 0.00; // Envío gratis
    } else {
      deliveryFee = subtotal * 0.20; // 20% del subtotal
    }

    double total = subtotal + deliveryFee + _tipAmount - _discountAmount;
    bool isCartEmpty = globalCartItems.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              // MODIFICADO: SafeArea ahora tiene un Column como hijo directo
              children: [
                Padding(
                  // Cabecera
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Centrar el contenido de la Row
                    children: [
                      // InkWell para la flecha de retroceso ELIMINADO
                      const Expanded(
                        child: Text(
                          'Your Cart',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // SizedBox(width: 40) ELIMINADO ya que no hay flecha que balancear
                    ],
                  ),
                ),
                Expanded(
                  // MODIFICADO: El contenido principal ahora está dentro de un Expanded
                  child:
                      isCartEmpty
                          ? Center(
                            // MODIFICADO: Centra el contenido si el carrito está vacío
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center, // Centra verticalmente los elementos de la columna
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .center, // Centra horizontalmente los elementos de la columna
                                children: [
                                  const Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Your cart is currently empty.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFf05000),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Navegar a HomeScreen usando el método _onTabTapped para mantener la consistencia
                                      _onTabTapped(1);
                                    },
                                    child: const Text(
                                      'Go to the menu',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : SingleChildScrollView(
                            // Mantenemos SingleChildScrollView para la lista y totales
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: globalCartItems.length,
                                  itemBuilder: (context, index) {
                                    final item = globalCartItems[index];
                                    return Dismissible(
                                      key: Key(
                                        item.name +
                                            item.price.toString() +
                                            DateTime.now().millisecondsSinceEpoch.toString(),
                                      ),
                                      direction: DismissDirection.startToEnd,
                                      background: Container(
                                        color: Colors.redAccent,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: const Icon(Icons.delete_sweep, color: Colors.white),
                                      ),
                                      onDismissed: (direction) {
                                        _removeItem(index);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 8.0,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: Image.asset(
                                                  item.imageUrl.isNotEmpty
                                                      ? item.imageUrl
                                                      : 'assets/images/default_product.png',
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/default_product.png',
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.name,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    '\$${item.price.toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      color: Color(0xFFf05000),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed: () => _decreaseQuantity(index),
                                                ),
                                                Text(
                                                  '${item.quantity}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.add_circle_outline,
                                                    color: Colors.green,
                                                  ),
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
                                // --- SECCIÓN DE TOTALES ---
                                // if (!isCartEmpty) // Esta condición ya está cubierta por el if/else principal
                                Padding(
                                  // Solo se muestra si el carrito NO está vacío
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                        controller: _tipController,
                                        keyboardType: const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: 'Tip (Optional)',
                                          prefixText: '\$',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _tipAmount = double.tryParse(value) ?? 0;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Subtotal', style: TextStyle(fontSize: 16)),
                                          Text(
                                            '\$${subtotal.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Delivery Fee',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            deliveryFee == 0.00
                                                ? 'Free'
                                                : '\$${deliveryFee.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  deliveryFee == 0.00
                                                      ? Colors.green
                                                      : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Discount Detail'),
                                                content: Text(
                                                  'A discount of \$${_discountAmount.toStringAsFixed(2)} was applied.',
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('Close'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Discounts',
                                              style: TextStyle(color: Colors.green, fontSize: 16),
                                            ),
                                            Text(
                                              '- \$${_discountAmount.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(thickness: 1, height: 24),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            '\$${total.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Color(0xFFf05000),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFf05000),
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          onPressed:
                                              _goToPayment, // isCartEmpty ya se maneja arriba
                                          child: const Text(
                                            'Go to pay',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 80,
                                      ), // Espacio para el BottomNavigationBar
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ],
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
