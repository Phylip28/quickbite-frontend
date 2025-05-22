import 'package:flutter/material.dart';
import 'productDetailPSY.dart'; // Necesitarás crear este archivo después
import '../homeScreen.dart';
import '../customBottomNavigationBar.dart';
import '../account/profile.dart';
import '../cart/shoppingCart.dart';
import '../orders/orders.dart';
import '../../../auth/auth.dart';
import '../models/productModel.dart'; // <--- RUTA CONFIRMADA
import '../models/cartItemModel.dart'; // <--- RUTA CONFIRMADA

// Definición de colores consistentes
const primaryColor = Color(0xFFf05000);
const lightAccentColor = Color(0xFFFEEAE6);
const popsyPinkColor = Color(0xFFD8005D); // Un color distintivo para Popsy si lo deseas

class PopsyMenuScreen extends StatefulWidget {
  const PopsyMenuScreen({super.key});

  @override
  State<PopsyMenuScreen> createState() => _PopsyMenuScreenState();
}

class _PopsyMenuScreenState extends State<PopsyMenuScreen> {
  final int _selectedIndex = 1; // PopsyMenuScreen es parte del flujo de Home (índice 1)
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
    if (_selectedIndex == index && index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
      return;
    }
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 2: // Orders
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OrdersScreen()),
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

  final List<Map<String, String>> _popsyMenuItems = [
    {
      'name': 'Cherrymania Milkshake',
      'price': '4.50',
      'rating': '4.8',
      'image': 'assets/images/cliente/popsy/cherrymaniaMilkshake.png',
    },
    {
      'name': 'Vainilla Gourmet Milkshake',
      'price': '4.60',
      'rating': '4.7',
      'image': 'assets/images/cliente/popsy/vainillaGourmetMilkshake.png',
    },
    {
      'name': 'M&M Milshake',
      'price': '4.50',
      'rating': '4.6',
      'image': 'assets/images/cliente/popsy/m&mMilkShake.png',
    },
    {
      'name': 'Cereza Italiana Milkshake',
      'price': '5.00',
      'rating': '4.8',
      'image': 'assets/images/cliente/popsy/cerezaItalianaMilkshakeFrappuccino.png',
    },
  ];

  String _getProductDescription(String productName) {
    const String defaultDescription =
        "Enjoy a great tasting 16 oz. ice cream, accompanied with whipped cream and sauce of your choice. Product consistency may vary due to delivery time.";
    switch (productName) {
      case 'Cherrymania Milkshake':
        return defaultDescription;
      case 'Vainilla Gourmet Milkshake':
        return defaultDescription;
      case 'M&M Milshake':
        return defaultDescription;
      case 'Cereza Italiana Milkshake':
        return defaultDescription;
      default:
        return 'Description not available.';
    }
  }

  void _showAddedToCartOverlay(String productName) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    final UniqueKey dismissibleKey = UniqueKey();

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Dismissible(
              key: dismissibleKey,
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
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

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  void _addToCart(Map<String, String> productDataFromList) {
    final String productName = productDataFromList['name']!;
    final double productPrice =
        double.tryParse(productDataFromList['price']!.replaceAll('€', '').replaceAll(',', '.')) ??
        0.0;
    const String restaurantName = 'Popsy'; // Fijo para esta pantalla

    // Crear un ID único para el ProductModel
    final String productId = "${restaurantName}_$productName";

    // Crear la instancia de ProductModel
    final productToAdd = ProductModel(
      id: productId,
      name: productName,
      price: productPrice,
      // imageUrl no es parte del ProductModel simplificado, se usa productDataFromList['image'] para la UI
    );

    // Buscar si un CartItemModel con este ProductModel (basado en product.id) ya existe
    final existingItemIndex = globalCartItems.indexWhere(
      (cartItem) => cartItem.product.id == productToAdd.id, // Compara por product.id
    );

    // No es necesario llamar a setState aquí si la UI de esta pantalla no depende directamente de globalCartItems
    if (existingItemIndex != -1) {
      globalCartItems[existingItemIndex].incrementQuantity();
    } else {
      globalCartItems.add(
        CartItemModel(
          // Usa CartItemModel
          product: productToAdd, // Pasa la instancia de ProductModel
          quantity: 1,
        ),
      );
    }

    // Actualizar la UI del carrito si la clave global está disponible y el widget montado
    if (shoppingCartScreenKey.currentState != null && shoppingCartScreenKey.currentState!.mounted) {
      shoppingCartScreenKey.currentState!.setState(() {});
    }

    _showAddedToCartOverlay(productName);
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
            onTap: () => Navigator.pop(context), // Vuelve a HomeScreen
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: lightAccentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Deliver to", style: TextStyle(fontSize: 12, color: Colors.grey)),
                InkWell(
                  onTap: () {
                    /* Lógica para cambiar dirección */
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
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMenuItemCard(BuildContext context, Map<String, String> item) {
    final double itemPriceForDetail =
        double.tryParse(item['price']!.replaceAll('€', '').replaceAll(',', '.')) ?? 0.0;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ProductDetailPSY(
                    productName: item['name']!,
                    productDescription: _getProductDescription(item['name']!),
                    productPrice: itemPriceForDetail,
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
                    child: Image.asset(
                      item['image']!,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => const Center(
                            child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                          ),
                    ),
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
                    onTap: () => _addToCart(item), // Llama a la función _addToCart actualizada
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: primaryColor, // O popsyPinkColor
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
              _buildHeader(context),
              const SizedBox(height: 20),
              Image.asset(
                'assets/logos/popsy.png',
                height: 80,
                errorBuilder:
                    (context, error, stackTrace) => const Center(
                      child: Icon(Icons.business_center, size: 60, color: Colors.grey),
                    ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Welcome to Popsy",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ice Cream Mastery since 1981 ",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Icon(Icons.icecream, color: popsyPinkColor, size: 16),
                ],
              ),
              const SizedBox(height: 25),
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
                  itemCount: _popsyMenuItems.length,
                  itemBuilder: (context, index) {
                    return _buildMenuItemCard(context, _popsyMenuItems[index]);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
