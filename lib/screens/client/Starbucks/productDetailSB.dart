import 'package:flutter/material.dart';
import '../customBottomNavigationBar.dart'; // Importa la barra de navegación

class ProductDetailSB extends StatefulWidget {
  final String productName;
  final String productDescription;
  final double productPrice;
  final String imageUrl;
  final Function(String, double, int)? onAddToCart;

  const ProductDetailSB({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.imageUrl,
    this.onAddToCart,
  });

  @override
  State<ProductDetailSB> createState() => _ProductDetailSBState();
}

class _ProductDetailSBState extends State<ProductDetailSB> {
  int _quantity = 1;
  int _selectedIndex = 1; // Índice para la barra de navegación

  void _incrementQuantity() {
    if (_quantity < 10) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _onTabTapped(int index) {
    // Lógica de navegación para la barra inferior
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/cart'); // Reemplaza '/cart' con tu ruta
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/home'); // Reemplaza '/home' con tu ruta
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile'); // Reemplaza '/profile' con tu ruta
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSectionHeight = screenHeight * 0.45; // Aumentado para dar más espacio a la imagen
    const primaryColor = Color(0xFFf05000);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFEEAE6), // Aplicado el color de menuStarbucks
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: primaryColor, // El icono ya es naranja
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Añadir este Container como primer elemento del Stack
          Container(color: Colors.white, width: double.infinity, height: double.infinity),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageSectionHeight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(color: Colors.white),
              child: Image.asset(
                widget.imageUrl,
                fit: BoxFit.contain,
                height: imageSectionHeight * 0.9, // Aumentado para hacer la imagen más grande
              ),
            ),
          ),
          Positioned(
            top: imageSectionHeight - 40,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8), // Reducido de 16
                  Text(
                    widget.productName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ), // Reducido de 28
                  ),
                  const SizedBox(height: 4), // Reducido de 8
                  Text(
                    widget.productDescription,
                    style: const TextStyle(fontSize: 14, color: Colors.black87), // Reducido de 16
                  ),
                  const SizedBox(height: 12), // Reducido de 20
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.productPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28, // Reducido de 32
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.orange[300] ?? Colors.orange),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: primaryColor),
                              onPressed: _decrementQuantity,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: primaryColor),
                              onPressed: _incrementQuantity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Reducido de 32
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Botón "Add to cart" presionado');
                        if (widget.onAddToCart != null) {
                          print(
                            'Llamando a onAddToCart con: ${widget.productName}, ${widget.productPrice}, $_quantity',
                          );
                          widget.onAddToCart!(widget.productName, widget.productPrice, _quantity);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14), // Reducido de 18
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Add to cart',
                        style: TextStyle(
                          fontSize: 16, // Reducido de 18
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), // Reducido de 80
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
