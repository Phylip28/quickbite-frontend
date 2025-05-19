import 'package:flutter/material.dart';
import '../homeScreen.dart';
import '../customBottomNavigationBar.dart';
import '../account/profile.dart';
import '../cart/shoppingCart.dart';
import '../membership.dart'; // NUEVA IMPORTACIÓN

// Definición de colores consistentes
const primaryColor = Color(0xFFf05000);
const lightAccentColor = Color(0xFFFEEAE6); // Para el botón de retroceso
const quantitySelectorBackgroundColor = Color(0xFFFDF0E8); // Para el selector de cantidad

class ProductDetailTQ extends StatefulWidget {
  final String productName;
  final String productDescription;
  final double productPrice;
  final String imageUrl;
  final Function(String, double, int)? onAddToCart; // Callback function

  const ProductDetailTQ({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.imageUrl,
    this.onAddToCart, // Make the callback optional
  });

  @override
  State<ProductDetailTQ> createState() => _ProductDetailTQState();
}

class _ProductDetailTQState extends State<ProductDetailTQ> {
  final int _selectedIndex = 1; // ProductDetailTQ es parte del flujo de Home (índice 1)
  int _quantity = 1;
  OverlayEntry? _overlayEntry; // Para el overlay

  void _onTabTapped(int index) {
    // No es necesario llamar a setState para _selectedIndex aquí si siempre usas
    // pushReplacement o pushAndRemoveUntil, ya que la nueva pantalla se reconstruirá.
    // Sin embargo, si alguna navegación no reemplaza la pantalla actual (ej. un Navigator.push simple
    // a una sub-pantalla dentro de la misma pestaña), entonces sí sería útil.

    if (_selectedIndex == index && index != 1)
      return; // Evitar recarga innecesaria si ya está en la pestaña (excepto Home)

    if (index == 1 && _selectedIndex == 1) {
      // Si ya está en Home y tapea Home, ir a la raíz de Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
      return;
    }

    switch (index) {
      case 0: // Cart
        // Usar push para poder volver a ProductDetail si el usuario quiere seguir comprando
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingCartScreen()));
        // Si se usa push, y quieres que el ícono del carrito se active inmediatamente:
        // if (mounted) setState(() => _selectedIndex = index);
        break;
      case 1: // Home
        // Navegar a la pantalla principal de Home, limpiando la pila.
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 2: // Membership
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MembershipScreen()),
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

  void _incrementQuantity() {
    if (_quantity < 10) {
      // Límite de cantidad, ajusta si es necesario
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

  void _showAddedToCartOverlay(String productName, int quantity) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
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
                        '$productName (x$quantity) added to cart!',
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
                        _overlayEntry?.remove();
                        _overlayEntry = null;
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
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  void _handleAddToCart() {
    final String name = widget.productName;
    final double price = widget.productPrice;
    final String imageUrl = widget.imageUrl;
    final int quantityToAdd = _quantity;
    const String restaurantName = 'Tierra Querida'; // O el nombre del restaurante

    // Lógica para añadir al carrito global
    final existingItemIndex = globalCartItems.indexWhere(
      (item) => item.name == name && item.restaurant == restaurantName,
    );

    if (existingItemIndex != -1) {
      setState(() {
        // Asegúrate de que esto esté dentro de un setState si actualizas la UI localmente
        globalCartItems[existingItemIndex].quantity += quantityToAdd;
      });
    } else {
      setState(() {
        globalCartItems.add(
          CartItem(
            name: name,
            price: price,
            quantity: quantityToAdd,
            imageUrl: imageUrl,
            restaurant: restaurantName,
          ),
        );
      });
    }

    // Actualizar el estado del ShoppingCartScreen si está montado
    if (shoppingCartScreenKey.currentState != null && shoppingCartScreenKey.currentState!.mounted) {
      shoppingCartScreenKey.currentState!.setState(() {});
    }

    // Mostrar overlay
    _showAddedToCartOverlay(name, quantityToAdd);

    // Llamar al callback si existe (para la pantalla de menú)
    widget.onAddToCart?.call(name, price, quantityToAdd);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSectionHeight = screenHeight * 0.40;
    const double overlapAmount = 30.0; // Cantidad de superposición, igual al radio del borde

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
                color: lightAccentColor.withOpacity(0.8), // Fondo semitransparente
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Sección de la imagen
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageSectionHeight + MediaQuery.of(context).padding.top,
            child: Container(
              color: Colors.white,
              child: Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder:
                    (context, error, stackTrace) => const Center(
                      child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
              ),
            ),
          ),

          // Sección de detalles del producto
          Positioned(
            top:
                imageSectionHeight +
                MediaQuery.of(context).padding.top -
                overlapAmount, // Modificado aquí
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(overlapAmount),
                ), // Usar overlapAmount para el radio
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 5,
                        width: 50,
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, primaryColor.withOpacity(0.3)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.productDescription,
                      style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${(widget.productPrice * _quantity).toStringAsFixed(2)}', // Precio total
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: quantitySelectorBackgroundColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: primaryColor),
                                onPressed: _decrementQuantity,
                                iconSize: 20,
                                splashRadius: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: primaryColor),
                                onPressed: _incrementQuantity,
                                iconSize: 20,
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleAddToCart, // Usar el nuevo método
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
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
                    SizedBox(
                      height: 60 + MediaQuery.of(context).padding.bottom,
                    ), // Espacio para la barra de navegación
                  ],
                ),
              ),
            ),
          ),

          // Barra de navegación inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavigationBar(
              currentIndex: _selectedIndex, // Asegúrate que sea 1
              onTabChanged: _onTabTapped,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
