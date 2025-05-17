import 'package:flutter/material.dart';
import '../homeScreen.dart'; // Importa tu pantalla principal
import '../customBottomNavigationBar.dart'; // Importa la navbar personalizada
import '../profile.dart'; // Importa la pantalla de perfil
import '../cart/shoppingCart.dart'; // Importa la pantalla del carrito

class ProductDetailTQ extends StatefulWidget {
  final String productName;
  final String productDescription;
  final double productPrice;
  final String imageUrl;

  const ProductDetailTQ({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.imageUrl,
  });

  @override
  State<ProductDetailTQ> createState() => _ProductDetailTQState();
}

class _ProductDetailTQState extends State<ProductDetailTQ> {
  int _selectedIndex = 1; // El índice de "Home" es 1 (asumimos que vienes del menú)

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: true,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Image.asset(widget.imageUrl, fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset('assets/icons/backArrow.png', height: 30, width: 30),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productName,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.productDescription,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '\$${widget.productPrice.toStringAsFixed(3)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.orange.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'x1',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.orange),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              print('Added to cart');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Add to cart',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
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
