import 'package:flutter/material.dart';
import '../customBottomNavigationBar.dart';
import '../homeScreen.dart';
import '../cart/shoppingCart.dart';
import '../account/profile.dart';
import '../orders/orders.dart';
import 'productDetailKfc.dart';
import '../../../auth/auth.dart';
import '../models/productModel.dart'; // <--- RUTA CONFIRMADA
import '../models/cartItemModel.dart'; // <--- RUTA CONFIRMADA

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
  final int _selectedIndex = 1;
  OverlayEntry? _overlayEntry;
  String _userAddress = "Loading address...";

  @override
  void initState() {
    super.initState();
    _loadUserAddress();
  }

  @override
  void dispose() {
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
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OrdersScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 3:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
          (Route<dynamic> route) => false,
        );
        break;
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
    const String restaurantName = 'KFC'; // Fijo para esta pantalla

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
    return Column(
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
                onTap: () => Navigator.pop(context),
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
                        // Acción para cambiar dirección
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
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 25),
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
      margin: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ProductDetailKFC(
                    productName: item['name']!,
                    productDescription: _getProductDescription(item['name']!),
                    productPrice: productPriceForDetail,
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
              SizedBox(
                height: 60 + MediaQuery.of(context).padding.bottom,
              ), // Espacio para el BottomNavBar
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
