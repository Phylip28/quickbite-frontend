import 'package:flutter/material.dart';

// Importa las pantallas de detalle de producto específicas
import 'Kfc/productDetailKfc.dart';
import 'Popsy/productDetailPSY.dart';
import 'Starbucks/productDetailSB.dart';
import 'Subway/productDetailSW.dart';
import 'TierraQuerida/productDetailTQ.dart';

// Importa lo necesario para el carrito y el overlay
import 'cart/shoppingCart.dart'; // Para globalCartItems y navegar a ShoppingCartScreen
import 'models/productModel.dart'; // <--- IMPORTA ProductModel
import 'models/cartItemModel.dart'; // <--- IMPORTA CartItemModel

// Define el color primario si no está ya accesible globalmente
const Color primaryColor = Color(0xFFf05000);

class CategoriesScreen extends StatefulWidget {
  final String categoryName;
  final List<Map<String, String>> allProducts;
  final List<Map<String, String>> restaurants;

  const CategoriesScreen({
    super.key,
    required this.categoryName,
    required this.allProducts,
    required this.restaurants,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Map<String, String>> _filteredProducts = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _filterProducts();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _filterProducts() {
    _filteredProducts =
        widget.allProducts.where((product) => product['category'] == widget.categoryName).toList();
  }

  double _parsePrice(String? priceString) {
    if (priceString == null) return 0.0;
    return double.tryParse(priceString.replaceAll('€', '').replaceAll(',', '')) ?? 0.0;
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
    final double productPrice = _parsePrice(productDataFromList['price']);
    final String imageUrl = productDataFromList['image']!; // <--- AÑADE O DESCOMENTA ESTA LÍNEA
    final String restaurantName =
        productDataFromList['restaurantName']!; // Usado para el ID del producto

    // Crear un ID único para el ProductModel
    final String productId = "${restaurantName}_$productName";

    // Crear la instancia de ProductModel, AHORA INCLUYENDO imageUrl
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

    if (mounted) {
      setState(() {
        if (existingItemIndex != -1) {
          // Si existe, solo incrementa la cantidad
          globalCartItems[existingItemIndex].incrementQuantity();
        } else {
          // Si no existe, añade un nuevo CartItemModel
          globalCartItems.add(
            CartItemModel(
              // <--- Cambiado de CartItem a CartItemModel
              product: productToAdd, // Pasa la instancia de ProductModel
              quantity: 1,
            ),
          );
        }
      });
    }
    _showAddedToCartOverlay(productName); // Esto puede seguir igual
  }

  Widget _buildCategoryProductItem(BuildContext context, Map<String, String> product) {
    final restaurantData = widget.restaurants.firstWhere(
      (r) => r['name'] == product['restaurantName'],
      orElse: () => {'image': '', 'name': 'Unknown Restaurant'},
    );
    final String? restaurantLogo = restaurantData['image'];

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          Widget? detailScreen;
          final String productName = product['name'] ?? 'Product without name';
          final String productDescription = product['description'] ?? productName;
          final double productPrice = _parsePrice(product['price']);
          final String imageUrl = product['image'] ?? 'assets/images/placeholder.png';

          switch (product['restaurantName']) {
            case 'KFC':
              detailScreen = ProductDetailKFC(
                productName: productName,
                productDescription: productDescription,
                productPrice: productPrice,
                imageUrl: imageUrl,
              );
              break;
            case 'Popsy':
              detailScreen = ProductDetailPSY(
                productName: productName,
                productDescription: productDescription,
                productPrice: productPrice,
                imageUrl: imageUrl,
              );
              break;
            case 'Starbucks':
              detailScreen = ProductDetailSB(
                productName: productName,
                productDescription: productDescription,
                productPrice: productPrice,
                imageUrl: imageUrl,
              );
              break;
            case 'Subway':
              detailScreen = ProductDetailSW(
                productName: productName,
                productDescription: productDescription,
                productPrice: productPrice,
                imageUrl: imageUrl,
              );
              break;
            case 'Tierra Querida':
              detailScreen = ProductDetailTQ(
                productName: productName,
                productDescription: productDescription,
                productPrice: productPrice,
                imageUrl: imageUrl,
              );
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Detail screen not available for ${product['restaurantName']}'),
                ),
              );
              return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => detailScreen!));
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey[100],
                      child: Image.asset(
                        product['image']!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 120,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: Icon(Icons.broken_image, color: Colors.grey[400], size: 50),
                          );
                        },
                      ),
                    ),
                  ),
                  if (restaurantLogo != null && restaurantLogo.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          restaurantLogo,
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                product['name']!,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      product['restaurantName'] ?? 'Restaurant',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (product['rating'] != null)
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          product['rating']!,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    product['price']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _addToCart(product); // Llama a la función _addToCart actualizada
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
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
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      backgroundColor: Colors.grey[100],
      body:
          _filteredProducts.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No products available in the "${widget.categoryName}" category.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return _buildCategoryProductItem(context, product);
                },
              ),
    );
  }
}
