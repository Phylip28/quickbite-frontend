import 'package:flutter/material.dart';

// Importa las pantallas de detalle de producto específicas
import 'Kfc/productDetailKfc.dart';
import 'Popsy/productDetailPSY.dart';
import 'Starbucks/productDetailSB.dart';
import 'Subway/productDetailSW.dart';
import 'TierraQuerida/productDetailTQ.dart';

class CategoriesScreen extends StatefulWidget {
  final String categoryName;
  final List<Map<String, String>> allProducts;
  final List<Map<String, String>> restaurants; // Necesario para los logos

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

  @override
  void initState() {
    super.initState();
    _filterProducts();
  }

  void _filterProducts() {
    // Filtra los productos que coinciden con el categoryName.
    // Asegúrate de que el campo 'category' en tus Mapas de producto
    // coincida exactamente con los categoryName que pasas (ej. 'Ice cream', 'Hamburgers').
    _filteredProducts =
        widget.allProducts.where((product) => product['category'] == widget.categoryName).toList();
    // No es necesario llamar a setState aquí si _filteredProducts solo se usa en el build,
    // pero si la lista pudiera cambiar dinámicamente después de initState, setState sería necesario.
    // Para este caso, filtrar en initState es suficiente. Si quisieras re-filtrar
    // en respuesta a alguna acción del usuario, entonces setState sería crucial.
  }

  // Helper para convertir precio String a double
  double _parsePrice(String? priceString) {
    if (priceString == null) return 0.0;
    return double.tryParse(priceString.replaceAll('\$', '').replaceAll(',', '')) ?? 0.0;
  }

  Widget _buildCategoryProductItem(BuildContext context, Map<String, String> product) {
    final restaurantData = widget.restaurants.firstWhere(
      (r) => r['name'] == product['restaurantName'],
      orElse: () => {'image': '', 'name': 'Unknown Restaurant'}, // Fallback
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
          final String productName = product['name'] ?? 'Producto sin nombre';
          // Usa la descripción del producto si existe, sino el nombre del producto.
          final String productDescription = product['description'] ?? productName;
          final double productPrice = _parsePrice(product['price']);
          final String imageUrl =
              product['image'] ?? 'assets/images/placeholder.png'; // Imagen de fallback

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
              // Si el restaurante no está en la lista, muestra un mensaje y no navegues.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Pantalla de detalle no disponible para ${product['restaurantName']}',
                  ),
                ),
              );
              return; // No continúa a Navigator.push
          }

          // El `return` en el caso default asegura que detailScreen no será null aquí si se llega a este punto.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => detailScreen!,
            ), // Usamos ! porque estamos seguros que no es null.
          );
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
                      color: Colors.grey[100], // Fondo para BoxFit.contain
                      child: Image.asset(
                        product['image']!, // Asumimos que la imagen siempre existe
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.contain, // Para mostrar la imagen completa
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            // Fallback si la imagen no carga
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
                      product['restaurantName'] ?? 'Restaurante',
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
                      color: Color(0xFFf05000),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Lógica para añadir al carrito (a implementar)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Añadir ${product['name']} al carrito (no implementado)'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf05000),
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
          style: const TextStyle(
            color: Color(0xFFf05000), // Color naranja para el título
            fontWeight: FontWeight.bold, // Opcional: si quieres que sea negrita
          ),
        ),
        centerTitle: true, // Centra el título
        backgroundColor: Colors.white, // Fondo blanco
        elevation: 1, // Sombra ligera, puedes ajustarla o quitarla (elevation: 0)
        iconTheme: const IconThemeData(
          color: Color(0xFFf05000), // Color naranja para el icono de "atrás"
        ),
      ),
      backgroundColor: Colors.grey[100],
      body:
          _filteredProducts.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No products available in the "${widget.categoryName}" category.', // Translated
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
