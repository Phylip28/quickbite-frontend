import 'package:flutter/material.dart';
import 'productDetailSW.dart';
import '../homeScreen.dart';
import '../customBottomNavigationBar.dart';
import '../account/profile.dart';
import '../cart/shoppingCart.dart'; // Asegúrate que globalCartItems y CartItem estén aquí

const primaryColor = Color(0xFFf05000);

class SubwayMenuScreen extends StatefulWidget {
  const SubwayMenuScreen({super.key});

  @override
  State<SubwayMenuScreen> createState() => _SubwayMenuScreenState();
}

class _SubwayMenuScreenState extends State<SubwayMenuScreen> {
  int _selectedIndex = 1;
  OverlayEntry? _overlayEntry; // Para la notificación flotante

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
      );
    } else if (index == 1) {
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
  }

  void _showAddedToCartOverlay(String productName) {
    _overlayEntry?.remove(); // Remover overlay anterior si existe
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 10, // Debajo de la barra de estado
            left: 20,
            right: 20,
            child: Material(
              // Necesario para elevación y otros efectos de Material
              elevation: 4.0,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade700, // Un color verde para éxito
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$productName added to cart!',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Fondo blanco para el botón
                        foregroundColor: Colors.green.shade700, // Texto verde
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _overlayEntry?.remove();
                        _overlayEntry = null; // Marcar como nulo para evitar remoción futura
                        Navigator.push(
                          // Navegar al carrito
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
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Remover el overlay después de unos segundos
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _overlayEntry != null) {
        // Verificar si aún está montado y el overlay existe
        _overlayEntry?.remove();
        _overlayEntry = null; // Marcar como nulo después de removerlo
      }
    });
  }

  void _addToCart(Map<String, String> product) {
    final String name = product['name']!;
    final double price = double.tryParse(product['price']!) ?? 0.0;
    final String imageUrl = product['image']!;

    final existingItemIndex = globalCartItems.indexWhere((item) => item.name == name);

    if (existingItemIndex != -1) {
      // Si el ítem ya existe, incrementa la cantidad
      globalCartItems[existingItemIndex].quantity++;
    } else {
      // Si no existe, añádelo
      globalCartItems.add(
        CartItem(
          name: name,
          price: price,
          quantity: 1,
          imageUrl: imageUrl, // Asegúrate que CartItem tenga este campo
        ),
      );
    }
    // Llama a setState en ShoppingCartScreen si es necesario para actualizar su UI
    // Esto se puede hacer a través de la GlobalKey si la tienes configurada
    // o simplemente se reflejará cuando se navegue al carrito.
    shoppingCartScreenKey.currentState?.setState(() {});

    print('Producto añadido al carrito: $name');
    _showAddedToCartOverlay(name); // Muestra la notificación
  }

  // Helper method to build cards for regular grid items
  Widget _buildRegularItemCard(BuildContext context, Map<String, String> item) {
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
                              productPrice: double.tryParse(item['price']!) ?? 0.0,
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
                  '\$${item['price']}',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  // MODIFICADO: Envolver en GestureDetector
                  onTap: () {
                    _addToCart(item); // LLAMAR A _addToCart
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

  // Helper method to build the spanning card for "Subs Footlong Bacon Melt"
  Widget _buildSpanningItemCard(BuildContext context, Map<String, String> item) {
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
                            productPrice: double.tryParse(item['price']!) ?? 0.0,
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
                  '\$${item['price']}',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  // MODIFICADO: Envolver en GestureDetector
                  onTap: () {
                    _addToCart(item); // LLAMAR A _addToCart
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

  // Method to build the list of product widgets with custom layout
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Deliver to', style: TextStyle(fontSize: 14, color: Colors.black54)),
                        SizedBox(height: 2),
                        Text(
                          'Transversal 51a #67B - 90',
                          style: TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40), // Para balancear el botón de atrás
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
      'image':
          'assets/images/cliente/subway/subsFootlongBaconMelt.png', // Ensure this image is wide
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
        return 'Freshly made sub with quality ingredients.'; // Descripción por defecto
    }
  }
}
