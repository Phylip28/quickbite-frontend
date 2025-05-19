import 'package:flutter/material.dart';
import '../customBottomNavigationBar.dart'; // Importa la barra de navegación
// Asegúrate de que las rutas de importación sean correctas para tu estructura de proyecto.
import '../homeScreen.dart'; // Ejemplo, ajusta si es necesario
import '../cart/shoppingCart.dart'; // Para globalCartItems y CartItem
import '../account/profile.dart'; // Ejemplo, ajusta si es necesario

// Definición del color primario, consistente con las pantallas anteriores.
// Este color se usa para el botón "Add to cart" y elementos activos.
const primaryColor = Color(0xFFf05000);
// Color para el fondo del botón de retroceso y el selector de cantidad.
const lightAccentColor = Color(0xFFFEEAE6); // Un tono naranja/durazno muy claro
const quantitySelectorBackgroundColor = Color(
  0xFFFDF0E8,
); // Un tono durazno/rosado pálido para el selector de cantidad

class ProductDetailSW extends StatefulWidget {
  final String productName;
  final String productDescription;
  final double productPrice;
  final String imageUrl;
  // Eliminamos onAddToCart ya que manejaremos la lógica directamente aquí
  // final Function(String, double, int)? onAddToCart;

  const ProductDetailSW({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.imageUrl,
    // this.onAddToCart,
  });

  @override
  State<ProductDetailSW> createState() => _ProductDetailSubwayState();
}

class _ProductDetailSubwayState extends State<ProductDetailSW> {
  int _quantity = 1; // Cantidad inicial del producto
  int _selectedIndex = 1; // Índice seleccionado en la barra de navegación inferior (ej. Home)
  OverlayEntry? _overlayEntry; // Para la notificación flotante

  // Incrementa la cantidad del producto, con un límite de 10.
  void _incrementQuantity() {
    if (_quantity < 10) {
      setState(() {
        _quantity++;
      });
    }
  }

  // Decrementa la cantidad del producto, con un mínimo de 1.
  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  // Maneja el cambio de pestaña en la barra de navegación inferior.
  void _onTabTapped(int index) {
    // setState(() { // No es necesario si la navegación reemplaza la pantalla
    //   _selectedIndex = index;
    // });

    if (index == 0) {
      // Navegar al carrito
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
      );
    } else if (index == 1) {
      // Si estamos en ProductDetail, "Home" probablemente signifique volver al menú anterior o a HomeScreen
      // Si SubwayMenuScreen es la pantalla anterior:
      // Navigator.pop(context); // O
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ), // O SubwayMenuScreen si es más apropiado
      );
    } else if (index == 2) {
      // Navegar al perfil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileClient()),
      );
    }
    // Actualizar el índice después de la navegación si es necesario para la UI
    if (mounted && _selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
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
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$productName (x$quantity) added to cart!',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green.shade700,
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
    final int quantity = _quantity;

    final existingItemIndex = globalCartItems.indexWhere((item) => item.name == name);

    if (existingItemIndex != -1) {
      // Si el ítem ya existe, actualiza la cantidad
      globalCartItems[existingItemIndex].quantity += quantity;
    } else {
      // Si no existe, añádelo con la cantidad seleccionada
      globalCartItems.add(
        CartItem(name: name, price: price, quantity: quantity, imageUrl: imageUrl),
      );
    }

    // Actualizar la UI del ShoppingCartScreen si está en la pila y montado
    if (shoppingCartScreenKey.currentState != null && shoppingCartScreenKey.currentState!.mounted) {
      shoppingCartScreenKey.currentState!.setState(() {});
    }

    print('$name (x$quantity) added to cart.');
    _showAddedToCartOverlay(name, quantity);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Altura de la sección de la imagen, puedes ajustar este valor (e.g., 0.45 o 0.50)
    final imageSectionHeight = screenHeight * 0.45;
    // Cantidad de superposición del contenedor de descripción sobre la imagen
    const double overlapAmount = 30.0;

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
                color: lightAccentColor.withOpacity(
                  0.8,
                ), // Un poco de opacidad si hay imagen detrás
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Sección superior para la imagen del producto.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height:
                imageSectionHeight +
                MediaQuery.of(context).padding.top, // Incluye el padding superior
            child: Container(
              // Se elimina el padding interno para que la imagen llene el contenedor.
              color: Colors.white, // Fondo blanco para la sección de la imagen
              child: Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover, // Cambiado a BoxFit.cover
                width: double.infinity, // Asegura que la imagen llene el ancho
                height: double.infinity, // Asegura que la imagen llene la altura
                errorBuilder:
                    (context, error, stackTrace) => const Center(
                      child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
              ),
            ),
          ),
          // Sección inferior para los detalles del producto y acciones.
          Positioned(
            top:
                imageSectionHeight +
                MediaQuery.of(context).padding.top -
                overlapAmount, // Ajustado para superposición
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                // BoxDecoration movida aquí
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(overlapAmount), // Usar overlapAmount para el radio
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ), // Padding ajustado
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barra estética naranja desvanecida
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
                    // Nombre del producto
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        fontSize: 26, // Tamaño de fuente ligeramente mayor
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Descripción del producto
                    Text(
                      widget.productDescription,
                      style: TextStyle(
                        fontSize: 15, // Tamaño de fuente ligeramente mayor
                        color: Colors.grey[700], // Color de texto más suave
                        height: 1.4, // Altura de línea para mejor legibilidad
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Precio y selector de cantidad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Precio del producto
                        Text(
                          '\$${(widget.productPrice * _quantity).toStringAsFixed(2)}', // Precio total por cantidad
                          style: const TextStyle(
                            fontSize: 30, // Tamaño de fuente destacado para el precio
                            fontWeight: FontWeight.bold,
                            color: primaryColor, // Precio en color primario
                          ),
                        ),
                        // Selector de cantidad
                        Container(
                          decoration: BoxDecoration(
                            color: quantitySelectorBackgroundColor, // Fondo claro para el selector
                            borderRadius: BorderRadius.circular(25),
                            // border: Border.all(color: primaryColor.withOpacity(0.5)), // Borde sutil opcional
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: primaryColor),
                                onPressed: _decrementQuantity,
                                iconSize: 20, // Tamaño de icono ajustado
                                splashRadius: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ), // Padding ajustado
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    fontSize: 18, // Tamaño de fuente ajustado
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: primaryColor),
                                onPressed: _incrementQuantity,
                                iconSize: 20, // Tamaño de icono ajustado
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24), // Espacio antes del botón
                    // Botón para añadir al carrito
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleAddToCart, // MODIFICADO: Llamar a _handleAddToCart
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor, // Color primario para el botón
                          padding: const EdgeInsets.symmetric(vertical: 16), // Padding vertical
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Bordes redondeados para el botón
                          ),
                          elevation: 2, // Sombra ligera para el botón
                        ),
                        child: const Text(
                          'Add to cart',
                          style: TextStyle(
                            fontSize: 18, // Tamaño de fuente
                            color: Colors.white, // Texto en color blanco
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
          // Barra de navegación inferior personalizada, alineada al fondo.
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavigationBar(
              currentIndex: _selectedIndex,
              onTabChanged: _onTabTapped,
              backgroundColor: Colors.white, // Fondo blanco para la barra de navegación
            ),
          ),
        ],
      ),
    );
  }
}
