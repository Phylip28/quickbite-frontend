import 'package:flutter/material.dart';
import 'productDetailTQ.dart';
import '../homeScreen.dart';
import '../customBottomNavigationBar.dart';
import '../account/profile.dart';
import '../cart/shoppingCart.dart';
import '../orders/orders.dart';
import '../../../auth/auth.dart'; // Para _loadUserAddress
import '../models/productModel.dart'; // <--- RUTA CONFIRMADA
import '../models/cartItemModel.dart'; // <--- RUTA CONFIRMADA

const primaryColor = Color(0xFFf05000);
const lightAccentColor = Color(0xFFFEEAE6);

class MenuTierraQuerida extends StatefulWidget {
  const MenuTierraQuerida({super.key});

  @override
  State<MenuTierraQuerida> createState() => _MenuTierraQueridaState();
}

class _MenuTierraQueridaState extends State<MenuTierraQuerida> {
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
    const String restaurantName = 'Tierra Querida'; // Fijo para esta pantalla

    final String productId = "${restaurantName}_$productName";

    final productToAdd = ProductModel(id: productId, name: productName, price: productPrice);

    final existingItemIndex = globalCartItems.indexWhere(
      (cartItem) => cartItem.product.id == productToAdd.id,
    );

    if (existingItemIndex != -1) {
      globalCartItems[existingItemIndex].incrementQuantity();
    } else {
      globalCartItems.add(CartItemModel(product: productToAdd, quantity: 1));
    }

    if (shoppingCartScreenKey.currentState != null && shoppingCartScreenKey.currentState!.mounted) {
      shoppingCartScreenKey.currentState!.setState(() {});
    }

    _showAddedToCartOverlay(productName);
  }

  final List<Map<String, String>> _menuItems = [
    {
      'name': 'Simple hamburger',
      'image': 'assets/images/cliente/tierraQuerida/simpleHamburgerDescription.png',
      'price': '3.40',
      'rating': '4.8',
    },
    {
      'name': 'Double hamburger',
      'image': 'assets/images/cliente/tierraQuerida/dobleHamburgerDescription.png',
      'price': '4.50',
      'rating': '4.7',
    },
    {
      'name': 'Triple hamburger',
      'image': 'assets/images/cliente/tierraQuerida/tripleHamburgerDescription.png',
      'price': '5.80',
      'rating': '4.6',
    },
    {
      'name': 'French fries',
      'image': 'assets/images/cliente/tierraQuerida/frenchFriesDescription.png',
      'price': '1.00',
      'rating': '4.8',
    },
  ];

  String _getProductDescription(String productName) {
    switch (productName) {
      case 'Simple hamburger':
        return 'Good sized beef (about 200 grams), cheddar cheese, American cheese, garlic sauce (which is usually one of its distinctive touches), crispy bacon, pickles, fresh tomato and crispy lettuce. All this on a soft bread.';
      case 'Double hamburger':
        return 'This burger includes double beef (about 400 grams), double portion of the cheeses, American cheese, garlic sauce (which is usually one of its distinctive touches), crispy bacon, pickles, fresh tomato and crispy lettuce. All this on a soft bread.';
      case 'Triple hamburger':
        return 'For true meat lovers! This option brings three beef meats (about 600 grams), American cheese, garlic sauce (which is usually one of its distinctive touches), crispy bacon, pickles, fresh tomato and crispy lettuce. All this on a soft bread.';
      case 'French fries':
        return 'They are the classic traditional side dish. There are natural with creamy cheddar cheese salt, chicken, sweet and sour BBQ, slightly spicy with jalapeño, refreshing with lemon and rich in bacon flavor. Check the availability.';
      default:
        return '';
    }
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
                  (context) => ProductDetailTQ(
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
                    onTap: () => _addToCart(item),
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
      backgroundColor: const Color(0xFFFFFFFF),
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
                      decoration: const BoxDecoration(
                        color: lightAccentColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset('assets/logos/tierraQuerida.png', fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Welcome to', style: TextStyle(fontSize: 20, color: Colors.black87)),
            const Text(
              'Tierra Querida',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              'Let yourself be tempted!',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75, // Ajusta según el contenido de tus cards
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return _buildMenuItemCard(context, item);
              },
            ),
            SizedBox(height: 60 + MediaQuery.of(context).padding.bottom),
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
