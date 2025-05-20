import 'package:flutter/material.dart';
import 'productDetailSB.dart';
import '../homeScreen.dart';
import '../customBottomNavigationBar.dart';
import '../account/profile.dart';
import '../cart/shoppingCart.dart';
import '../orders/orders.dart';
import '../../../auth/auth.dart';

const primaryColor = Color(0xFFf05000);
const lightAccentColor = Color(0xFFFEEAE6);

class StarbucksMenuScreen extends StatefulWidget {
  const StarbucksMenuScreen({super.key});

  @override
  State<StarbucksMenuScreen> createState() => _StarbucksMenuScreenState();
}

class _StarbucksMenuScreenState extends State<StarbucksMenuScreen> {
  final int _selectedIndex = 1; // StarbucksMenuScreen es parte del flujo de Home (índice 1)
  String _userAddress = "Loading address...";
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _loadUserAddress();
  }

  @override
  void dispose() {
    // Limpiar el overlay si aún está visible al salir de la pantalla
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  Future<void> _loadUserAddress() async {
    final address = await getUserAddress();
    if (mounted) {
      setState(() {
        _userAddress = address ?? "Address not found";
      });
    }
  }

  void _onTabTapped(int index) {
    // Si el índice seleccionado es el mismo que el actual Y es la pestaña Home (1),
    // y ya estamos en una pantalla del flujo de Home, no hacer nada o ir a la HomeScreen principal.
    // Si es otra pestaña, siempre navegar.
    if (_selectedIndex == index && index == 1) {
      // Si el usuario está en StarbucksMenuScreen y presiona "Home" de nuevo,
      // lo llevamos a la HomeScreen principal, limpiando la pila.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
      return;
    }
    // Si se presiona una pestaña diferente a la actual (_selectedIndex), navegar.
    if (_selectedIndex == index) return;

    switch (index) {
      case 0: // Cart
        Navigator.pushAndRemoveUntil(
          // Cambiado a pushAndRemoveUntil para consistencia
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 1: // Home
        // Si se llega aquí desde otra pestaña (Cart, Orders, Account),
        // o si se presionó Home estando en StarbucksMenuScreen (manejado arriba),
        // ir a la HomeScreen principal.
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 2: // Orders (ANTERIORMENTE Membership)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OrdersScreen()), // NAVEGAR A OrdersScreen
          (Route<dynamic> route) => false,
        );
        break;
      case 3: // Account (Profile)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
          (Route<dynamic> route) => false,
        );
        break;
    }
  }

  void _showAddedToCartOverlay(String productName) {
    _overlayEntry?.remove(); // Elimina cualquier overlay anterior
    _overlayEntry = null; // Asegura que la referencia se limpie

    // Crear una clave única para el Dismissible
    final UniqueKey dismissibleKey = UniqueKey();

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Dismissible(
              // ENVOLVER CON DISMISSIBLE
              key: dismissibleKey, // Usar la clave única
              direction: DismissDirection.horizontal, // Permitir deslizar horizontalmente
              onDismissed: (direction) {
                // Cuando se descarta, eliminar el overlay
                if (mounted && _overlayEntry != null) {
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                }
              },
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryColor, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '$productName added to cart!',
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (mounted && _overlayEntry != null) {
                            _overlayEntry?.remove();
                            _overlayEntry = null;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
                          );
                        },
                        child: const Text('VIEW CART'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // El temporizador para auto-eliminar sigue siendo útil como fallback
    Future.delayed(const Duration(seconds: 4), () {
      // Solo remover si el overlay todavía existe (no fue descartado manualmente)
      // y si el widget todavía está montado
      if (mounted && _overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  void _addToCart(Map<String, String> product) {
    const String restaurantName = 'Starbucks';

    final existingItemIndex = globalCartItems.indexWhere(
      (item) => item.name == product['name'] && item.restaurant == restaurantName,
    );

    final double productPrice =
        double.tryParse(product['price']!.replaceAll('€', '').replaceAll(',', '.')) ?? 0.0;

    // No es necesario llamar a setState aquí si la UI de esta pantalla no depende directamente de globalCartItems
    // para reconstruirse al añadir un ítem. El cambio se reflejará en ShoppingCartScreen.
    if (existingItemIndex != -1) {
      globalCartItems[existingItemIndex].quantity++;
    } else {
      globalCartItems.add(
        CartItem(
          name: product['name']!,
          price: productPrice, // Usar el precio parseado
          quantity: 1,
          imageUrl: product['image']!,
          restaurant: restaurantName,
        ),
      );
    }

    // Actualizar la UI del carrito si la clave global está disponible y el widget montado
    if (shoppingCartScreenKey.currentState != null && shoppingCartScreenKey.currentState!.mounted) {
      shoppingCartScreenKey.currentState!.setState(() {});
    }

    _showAddedToCartOverlay(product['name']!);
    // print('Added to cart: ${product['name']} from $restaurantName');
    // print('Current cart: $globalCartItems');
  }

  final List<Map<String, String>> _starbucksMenuItems = [
    {
      'name': 'Fresa Cream Frappuccino',
      'image': 'assets/images/cliente/starbucks/fresaCreamFrappuccino.png',
      'price': '4.50',
      'rating': '4.8',
    },
    {
      'name': 'Cookies & Cream Frappuccino',
      'image': 'assets/images/cliente/starbucks/cookies&CreamFrappuccino.png',
      'price': '5.95',
      'rating': '4.7',
    },
    {
      'name': 'Mocha Blanco Frappuccino',
      'image': 'assets/images/cliente/starbucks/mochaBlancoFrappuccino.png',
      'price': '4.50',
      'rating': '4.6',
    },
    {
      'name': 'Caramel Frappuccino',
      'image': 'assets/images/cliente/starbucks/caramelFrappuccino.png',
      'price': '5.00',
      'rating': '4.8',
    },
  ];

  String _getProductDescription(String productName) {
    switch (productName) {
      case 'Fresa Cream Frappuccino':
        return 'A new way to drink a strawberry frappé drink, mixed with ice and milk, finished with whipped cream.';
      case 'Cookies & Cream Frappuccino':
        return 'Blended drink with the perfect combination of milk of your choice, white mocha sauce, chocolate chips. Topped with whipped cream and crushed cookies.';
      case 'Mocha Blanco Frappuccino':
        return 'White chocolate sauce drink, combined with coffee, milk and ice, topped with whipped cream.';
      case 'Caramel Frappuccino':
        return 'Caramel, coffee and milk based drink. Finished with whipped cream and caramel swirl.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10.0, left: 15, right: 15, bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        // O Navigator.pop(context) si es más apropiado
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: lightAccentColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Deliver to',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        InkWell(
                          onTap: () {
                            print("Change address tapped - Starbucks");
                          },
                          child: Text(
                            _userAddress,
                            style: const TextStyle(
                              fontSize: 14,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/logos/starbucks.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Welcome to', style: TextStyle(fontSize: 20, color: Colors.black87)),
                  const Text(
                    'Starbucks',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Every name is a story',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _starbucksMenuItems.length,
                    itemBuilder: (context, index) {
                      final item = _starbucksMenuItems[index];
                      final double itemPrice =
                          double.tryParse(
                            item['price']!.replaceAll('€', '').replaceAll(',', '.'),
                          ) ??
                          0.0;
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ProductDetailSB(
                                      productName: item['name']!,
                                      productDescription: _getProductDescription(item['name']!),
                                      productPrice: itemPrice,
                                      imageUrl: item['image']!,
                                    ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['rating']!,
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Image.asset(item['image']!, fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                                Text(
                                  item['name']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '€${item['price']}',
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _addToCart(item);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChanged: _onTabTapped,
        backgroundColor: Colors.white,
      ),
    );
  }
}
