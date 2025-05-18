import 'package:flutter/material.dart';
import 'productDetailSW.dart'; // Importa la pantalla de detalles de Subway (Asegúrate de crear este archivo)
import '../homeScreen.dart';
import '../customBottomNavigationBar.dart';
import '../profile.dart';
import '../cart/shoppingCart.dart';

const primaryColor = Color(0xFFf05000); // Naranja similar al de la imagen y botones

class SubwayMenuScreen extends StatefulWidget {
  const SubwayMenuScreen({super.key});

  @override
  State<SubwayMenuScreen> createState() => _SubwayMenuScreenState();
}

class _SubwayMenuScreenState extends State<SubwayMenuScreen> {
  int _selectedIndex = 1;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ShoppingCartScreen()),
      );
    } else if (index == 1) {
      // Ya estamos en la pantalla de menú (o HomeScreen si esta es una subpantalla de HomeScreen)
      // Si esta pantalla es independiente y el índice 1 es para HomeScreen:
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
                              productPrice: double.parse(item['price']!),
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
                      height: 120, // Aumentado de 100 a 120
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
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
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
                            productPrice: double.parse(item['price']!),
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
                    height: 180, // Aumentado de 150 a 180
                    fit: BoxFit.cover,
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
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
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
        // First, process any accumulated regular items into a grid
        if (regularItemsBatch.isNotEmpty) {
          // Create a copy of the batch for this GridView instance
          final List<Map<String, String>> currentBatch = List.from(regularItemsBatch);
          productLayoutWidgets.add(
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75, // Puedes ajustar esto si hay problemas de overflow visual
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: currentBatch.length, // Usar currentBatch.length
              itemBuilder:
                  (ctx, index) =>
                      _buildRegularItemCard(ctx, currentBatch[index]), // Usar currentBatch
            ),
          );
          regularItemsBatch.clear(); // Ahora es seguro limpiar el lote original
        }
        // Then, add the spanning item
        productLayoutWidgets.add(_buildSpanningItemCard(context, itemData));
      } else {
        regularItemsBatch.add(itemData);
      }
    }

    // After the loop, process any remaining regular items in the batch
    if (regularItemsBatch.isNotEmpty) {
      // Crear una copia aquí también
      final List<Map<String, String>> currentBatch = List.from(regularItemsBatch);
      productLayoutWidgets.add(
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75, // Puedes ajustar esto si hay problemas de overflow visual
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: currentBatch.length, // Usar currentBatch.length
          itemBuilder:
              (ctx, index) => _buildRegularItemCard(ctx, currentBatch[index]), // Usar currentBatch
        ),
      );
      // No es necesario regularItemsBatch.clear() aquí ya que es el final del método
      // y la variable regularItemsBatch se descartará de todos modos.
    }
    return productLayoutWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Keep overall padding
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
                      children: const [
                        Text('Deliver to', style: TextStyle(fontSize: 14, color: Colors.black54)),
                        SizedBox(height: 2),
                        Text(
                          'Transversal 51a #67B - 90',
                          style: TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
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
