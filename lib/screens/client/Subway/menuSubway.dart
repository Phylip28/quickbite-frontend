import 'package:flutter/material.dart';
import 'productDetailSW.dart';
import '../homeScreen.dart';
import '../customBottomNavigationBar.dart';
import '../account/profile.dart';
import '../cart/shoppingCart.dart';
import '../orders/orders.dart';
import '../../../auth/auth.dart';
import '../models/productModel.dart'; // <--- IMPORTA ProductModel
import '../models/cartItemModel.dart'; // <--- IMPORTA CartItemModel

const primaryColor = Color(0xFFf05000);

class SubwayMenuScreen extends StatefulWidget {
  const SubwayMenuScreen({super.key});

  @override
  State<SubwayMenuScreen> createState() => _SubwayMenuScreenState();
}

class _SubwayMenuScreenState extends State<SubwayMenuScreen> {
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
    // Extraer datos del mapa del producto
    final String productName = productDataFromList['name']!;
    final double productPrice =
        double.tryParse(productDataFromList['price']!.replaceAll('€', '').replaceAll(',', '.')) ??
        0.0;
    final String imageUrl = productDataFromList['image']!; // <--- AÑADE ESTA LÍNEA
    const String restaurantName = 'Subway'; // El restaurante es fijo para esta pantalla

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
      (cartItem) => cartItem.product.id == productToAdd.id,
    );

    // No es necesario llamar a setState aquí si la UI de esta pantalla no depende directamente de globalCartItems
    // para reconstruirse al añadir un ítem. El cambio se reflejará en ShoppingCartScreen.
    if (existingItemIndex != -1) {
      globalCartItems[existingItemIndex].incrementQuantity();
    } else {
      globalCartItems.add(
        CartItemModel(
          // <--- Cambiado de CartItem a CartItemModel
          product: productToAdd, // Pasa la instancia de ProductModel
          quantity: 1,
          // imageUrl y restaurant ya no son parte de CartItemModel directamente,
          // están en ProductModel (aunque imageUrl no lo estamos usando en el ProductModel MVP)
        ),
      );
    }
    _showAddedToCartOverlay(productName);
  }

  Widget _buildRegularItemCard(BuildContext context, Map<String, String> item) {
    final double productPriceForDetail =
        double.tryParse(item['price']!.replaceAll('€', '').replaceAll(',', '.')) ?? 0.0;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(item['rating']!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ProductDetailSW(
                              productName: item['name']!,
                              productDescription: _getProductDescription(item['name']!),
                              productPrice: productPriceForDetail,
                              imageUrl: item['image']!,
                            ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset(
                      item['image']!,
                      fit: BoxFit.contain,
                      height: 120,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.fastfood, size: 50, color: Colors.grey),
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
                GestureDetector(
                  onTap: () {
                    _addToCart(item); // Llama a la función _addToCart actualizada
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
    );
  }

  Widget _buildSpanningItemCard(BuildContext context, Map<String, String> item) {
    final double productPriceForDetail =
        double.tryParse(item['price']!.replaceAll('€', '').replaceAll(',', '.')) ?? 0.0;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(item['rating']!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProductDetailSW(
                            productName: item['name']!,
                            productDescription: _getProductDescription(item['name']!),
                            productPrice: productPriceForDetail,
                            imageUrl: item['image']!,
                          ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    item['image']!,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.fastfood, size: 80, color: Colors.grey),
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
                GestureDetector(
                  onTap: () {
                    _addToCart(item); // Llama a la función _addToCart actualizada
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
    );
  }

  List<Widget> _buildProductLayoutWidgets(BuildContext context) {
    List<Widget> productLayoutWidgets = [];
    List<Map<String, String>> regularItemsBatch = [];

    for (int i = 0; i < _subwayMenuItems.length; i++) {
      final itemData = _subwayMenuItems[i];
      if (itemData['name'] == 'Subs Footlong Bacon Melt') {
        if (regularItemsBatch.isNotEmpty) {
          final List<Map<String, String>> currentBatch = List.from(regularItemsBatch);
          productLayoutWidgets.add(
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: currentBatch.length,
              itemBuilder: (ctx, index) => _buildRegularItemCard(ctx, currentBatch[index]),
            ),
          );
          regularItemsBatch.clear();
        }
        productLayoutWidgets.add(_buildSpanningItemCard(context, itemData));
      } else {
        regularItemsBatch.add(itemData);
      }
    }

    if (regularItemsBatch.isNotEmpty) {
      final List<Map<String, String>> currentBatch = List.from(regularItemsBatch);
      productLayoutWidgets.add(
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: currentBatch.length,
          itemBuilder: (ctx, index) => _buildRegularItemCard(ctx, currentBatch[index]),
        ),
      );
    }
    return productLayoutWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEEAE6),
                        borderRadius: BorderRadius.circular(8.0),
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
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _userAddress,
                          style: const TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(child: Image.asset('assets/logos/subway.png', fit: BoxFit.contain)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Welcome to', style: TextStyle(fontSize: 20, color: Colors.black87)),
            const Text(
              'Subway',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you are eating at Subway, then you are eating fresh.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            // Spread the dynamically built product layout widgets here
            ..._buildProductLayoutWidgets(context),
            const SizedBox(height: 80), // Espacio para el BottomNavigationBar
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

  final List<Map<String, String>> _subwayMenuItems = [
    {
      'name': 'Turkey and Ham Subs',
      'image': 'assets/images/cliente/subway/turkeyAndHamSubsFootlong.png',
      'price': '6.50',
      'rating': '4.8',
    },
    {
      'name': 'Rotisserie Style Chicken Subs',
      'image': 'assets/images/cliente/subway/rotisserieStyleChickenSubs.png',
      'price': '6.60',
      'rating': '4.7',
    },
    {
      'name': 'Subs Footlong Bacon Melt',
      'image': 'assets/images/cliente/subway/subsFootlongBaconMelt.png',
      'price': '5.50',
      'rating': '4.6',
    },
  ];

  String _getProductDescription(String productName) {
    switch (productName) {
      case 'Turkey and Ham Subs':
        return 'Tender turkey breast and delicious slices of ham, along with your favorite vegetables and sauces.';
      case 'Rotisserie Style Chicken Subs':
        return 'Enjoy a great tasting 16 oz. ice cream, accompanied with whipped cream and sauce of your choice. Product consistency may vary due to delivery time.';
      case 'Subs Footlong Bacon Melt':
        return 'New Subway Melts! With Double Cheese and Grilled Melts. Try it with bacon and the touch of mayonnaise.';
      default:
        return 'Freshly made sub with quality ingredients.';
    }
  }
}
