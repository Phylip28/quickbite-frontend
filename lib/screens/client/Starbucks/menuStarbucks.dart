import 'package:flutter/material.dart';
import 'productDetailSB.dart';
import '../homeScreen.dart';
import '../customBottomNavigationBar.dart';
import '../account/profile.dart';
import '../cart/shoppingCart.dart';
import '../orders/orders.dart';
import '../../../auth/auth.dart';
import '../models/productModel.dart'; // <--- RUTA CONFIRMADA
import '../models/cartItemModel.dart'; // <--- RUTA CONFIRMADA

const primaryColor = Color(0xFFf05000);
const lightAccentColor = Color(0xFFFEEAE6);

class StarbucksMenuScreen extends StatefulWidget {
  const StarbucksMenuScreen({super.key});

  @override
  State<StarbucksMenuScreen> createState() => _StarbucksMenuScreenState();
}

class _StarbucksMenuScreenState extends State<StarbucksMenuScreen> {
  final int _selectedIndex = 1;
  String _userAddress = "Loading address...";
  OverlayEntry? _overlayEntry;

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
    final String imageUrl = productDataFromList['image']!; // <--- AÑADE ESTA LÍNEA
    const String restaurantName = 'Starbucks'; // Fijo para esta pantalla

    // Crear un ID único para el ProductModel
    final String productId = "${restaurantName}_$productName";

    // Crear la instancia de ProductModel
    final productToAdd = ProductModel(
      id: productId,
      name: productName,
      price: productPrice,
      imageUrl: imageUrl, // <--- PASAR LA URL DE LA IMAGEN AQUÍ
    );

    // Buscar si un CartItemModel con este ProductModel (basado en product.id) ya existe
    final existingItemIndex = globalCartItems.indexWhere(
      (cartItem) => cartItem.product.id == productToAdd.id, // Accede a cartItem.product.id
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
                            // Acción para cambiar dirección si es necesario
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
                                        _addToCart(
                                          item,
                                        ); // Llama a la función _addToCart actualizada
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
                  SizedBox(height: 60 + MediaQuery.of(context).padding.bottom),
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
