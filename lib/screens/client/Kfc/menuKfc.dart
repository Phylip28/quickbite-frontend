import 'package:flutter/material.dart';
import '../customBottomNavigationBar.dart';
import '../homeScreen.dart';
import '../cart/shoppingCart.dart';
import '../account/profile.dart';
import '../orders/orders.dart';
import 'productDetailKfc.dart';
import '../../../auth/auth.dart';

// Definición de colores consistentes
const primaryColor = Color(0xFFf05000);
const kfcRedColor = Color(0xFFA00000);
const lightAccentColor = Color(0xFFFEEAE6);

class KfcMenuScreen extends StatefulWidget {
  const KfcMenuScreen({super.key});

  @override
  State<KfcMenuScreen> createState() => _KfcMenuScreenState();
}

class _KfcMenuScreenState extends State<KfcMenuScreen> {
  final int _selectedIndex = 1; // KfcMenuScreen es parte del flujo de Home (índice 1)
  OverlayEntry? _overlayEntry;
  String _userAddress = "Loading address...";

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

  final List<Map<String, String>> _kfcMenuItems = [
    {
      'name': 'Mega Family',
      'price': '22.99',
      'rating': '4.8',
      'image': 'assets/images/cliente/kfc/megaFamily.png',
    },
    {
      'name': 'Wow Duo Deluxe Nuggets',
      'price': '25.99',
      'rating': '4.7',
      'image': 'assets/images/cliente/kfc/wowDuoDeluxeNuggets.png',
    },
    {
      'name': 'Combo Nuggets',
      'price': '11.50',
      'rating': '4.8',
      'image': 'assets/images/cliente/kfc/comboNuggets.png',
    },
    {
      'name': 'Share and Split Wings',
      'price': '25.99',
      'rating': '4.7',
      'image': 'assets/images/cliente/kfc/shareAndSplitWings.png',
    },
    {
      'name': 'BigBox Kentucky Coronel',
      'price': '21.99',
      'rating': '4.8',
      'image': 'assets/images/cliente/kfc/bigBoxKentuckyCoronel.png',
    },
    {
      'name': 'Combo Pop Corn',
      'price': '14.99',
      'rating': '4.7',
      'image': 'assets/images/cliente/kfc/comboPopCorn.png',
    },
  ];

  String _getProductDescription(String productName) {
    switch (productName) {
      case 'Mega Family':
        return '8 Chicken Pieces + 4 Small Potatoes.';
      case 'Wow Duo Deluxe Nuggets':
        return '2 Deluxe BBQ Sandwiches (Brioche bread, 120gr breast, tomato, lettuce, Mayonnaise Sauce, 1 slice of American cheese) + 5 Nuggets + 2 Small Potatoes + 2 Pet Sodas + Colonel\'s Sauce.';
      case 'Combo Nuggets':
        return '10 Nuggets + 1 Small Potato + 1 Pet Soda 400ml + 1 BBQ Sauce + 1 Colonel\'s Sauce.';
      case 'Share and Split Wings':
        return '10 Chicken Wings + 1 Small Potato + 1 Pet Soda 400ml + 1 BBQ Sauce + 1 Colonel\'s Sauce.';
      case 'BigBox Kentucky Coronel':
        return '1 Kentucky Colonel Hamburger / Sandwich (1 Breaded Chicken Breast Fillet, Coleslaw, BBQ and Butter) + 1 Small Pop Corn + 1 Small Potato + 1 PET Soda 400ml.';
      case 'Combo Pop Corn':
        return '1 Medium Pop Corn (Breaded chicken breast chunks) + 1 Small Potato + 1 PET Soda 400ml.';
      default:
        return 'Description not available.';
    }
  }

  void _onTabTapped(int index) {
    // Si el índice seleccionado es el mismo que el actual Y es la pestaña Home (1),
    // y ya estamos en una pantalla del flujo de Home, no hacer nada o ir a la HomeScreen principal.
    // Si es otra pestaña, siempre navegar.
    if (_selectedIndex == index && index == 1) {
      // Si el usuario está en KfcMenuScreen y presiona "Home" de nuevo,
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
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 1: // Home
        // Si se llega aquí desde otra pestaña (Cart, Orders, Account),
        // o si se presionó Home estando en KfcMenuScreen (manejado arriba),
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
    final String restaurantName = 'KFC';

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
          price: productPrice,
          quantity: 1,
          imageUrl: product['image']!,
          restaurant: restaurantName,
        ),
      );
    }
    _showAddedToCartOverlay(product['name']!);
    // print('Added to cart: ${product['name']} from $restaurantName');
    // print('Current cart: $globalCartItems');
  }

  // Definición del método _buildHeader
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Contenedor blanco con sombra para la barra superior
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(
            top: 10.0,
            left: 15,
            right: 15,
            bottom: 0,
          ), // Margen para el contenedor
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ), // Padding interno del contenedor
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0), // Bordes redondeados para el contenedor
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2), // Sombra sutil
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Botón de retroceso
              InkWell(
                onTap:
                    () => Navigator.pop(
                      context,
                    ), // CAMBIO: Usar Navigator.pop para volver a la pantalla anterior (HomeScreen)
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: lightAccentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
                ),
              ),
              // Columna para "Deliver to" y la dirección
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Deliver to", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    InkWell(
                      onTap: () {
                        // print("Change address tapped"); // Acción para cambiar dirección si es necesario
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              _userAddress,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48), // Ajusta este valor si es necesario
            ],
          ),
        ),
        const SizedBox(height: 20), // Espacio antes del logo
        Image.asset('assets/logos/kfc.png', height: 80),
        const SizedBox(height: 10),
        const Text(
          "Welcome to KFC",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 5),
        const Text(
          "Life tastes better with KFC.",
          style: TextStyle(fontSize: 14, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 25), // Espacio antes de la lista de productos
      ],
    );
  }

  Widget _buildMenuItemCard(BuildContext context, Map<String, String> item) {
    final double productPriceForDetail =
        double.tryParse(item['price']!.replaceAll('€', '').replaceAll(',', '.')) ?? 0.0;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.all(4), // Pequeño margen alrededor de la tarjeta
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ProductDetailKFC(
                    productName: item['name']!,
                    productDescription: _getProductDescription(item['name']!),
                    productPrice: productPriceForDetail, // Usar el precio parseado
                    imageUrl: item['image']!,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
                    '€${item['price']}', // Cambiado de $ a €
                    style: const TextStyle(
                      color: primaryColor, // Color naranja para el precio
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    // CAMBIO: Envolver el icono de añadir en InkWell
                    onTap: () {
                      _addToCart(item); // LLAMADA a _addToCart
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: primaryColor, // Color naranja para el botón
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context), // Asegúrate de llamar a _buildHeader aquí
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _kfcMenuItems.length,
                  itemBuilder: (context, index) {
                    return _buildMenuItemCard(context, _kfcMenuItems[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex, // Sigue siendo 1 porque esta pantalla es del flujo "Home"
        onTabChanged: _onTabTapped,
        backgroundColor: Colors.white,
      ),
    );
  }
}
