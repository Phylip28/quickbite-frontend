import 'package:flutter/material.dart';
import '../customBottomNavigationBar.dart';
import '../homeScreen.dart';
import '../cart/shoppingCart.dart';
import '../account/profile.dart';
import 'productDetailKfc.dart'; // Asegúrate de crear este archivo para los detalles del producto

// Definición de colores consistentes
const primaryColor = Color(0xFFf05000); // Naranja principal de la temática
const kfcRedColor = Color(0xFFA00000); // Un rojo oscuro para KFC, si se necesita
const lightAccentColor = Color(0xFFFEEAE6); // Para el botón de retroceso en AppBar

class KfcMenuScreen extends StatefulWidget {
  const KfcMenuScreen({super.key});

  @override
  State<KfcMenuScreen> createState() => _KfcMenuScreenState();
}

class _KfcMenuScreenState extends State<KfcMenuScreen> {
  int _selectedIndex = 1; // Índice para Home en la barra de navegación

  final List<Map<String, String>> _kfcMenuItems = [
    {
      'name': 'Mega Family', // Nombre corregido de 'Mega Familiar' si es necesario
      'price': '22.99',
      'rating': '4.8',
      'image': 'assets/images/cliente/kfc/megaFamily.png',
    },
    {
      'name': 'Wow Duo Deluxe Nuggets',
      'price': '25.99',
      'rating': '4.7',
      'image': 'assets/images/cliente/kfc/wowDuoDeluxeNuggets.png',
    },
    {
      'name': 'Combo Nuggets',
      'price': '11.50',
      'rating': '4.8',
      'image': 'assets/images/cliente/kfc/comboNuggets.png',
    },
    {
      'name': 'Share and Split Wings', // Nombre corregido de 'Parte y Comparte Alas'
      'price': '25.99',
      'rating': '4.7',
      'image': 'assets/images/cliente/kfc/shareAndSplitWings.png',
    },
    {
      'name': 'BigBox Kentucky Coronel',
      'price': '21.99',
      'rating': '4.8',
      'image': 'assets/images/cliente/kfc/bigBoxKentuckyCoronel.png',
    },
    {
      'name': 'Combo Pop Corn',
      'price': '14.99',
      'rating': '4.7',
      'image': 'assets/images/cliente/kfc/comboPopCorn.png',
    },
    // Puedes añadir más productos aquí si es necesario
  ];

  String _getProductDescription(String productName) {
    // Devuelve descripciones específicas para cada producto para la página de detalles
    switch (productName) {
      case 'Mega Family': // Asegúrate que coincida con el nombre en _kfcMenuItems
        return '8 Chicken Pieces + 4 Small Potatoes.';
      case 'Wow Duo Deluxe Nuggets':
        return '2 Deluxe BBQ Sandwiches (Brioche bread, 120gr breast, tomato, lettuce, Mayonnaise Sauce, 1 slice of American cheese) + 5 Nuggets + 2 Small Potatoes + 2 Pet Sodas + Colonel\'s Sauce.';
      case 'Combo Nuggets':
        return '10 Nuggets + 1 Small Potato + 1 Pet Soda 400ml + 1 BBQ Sauce + 1 Colonel\'s Sauce.';
      case 'Share and Split Wings': // Asegúrate que coincida con el nombre en _kfcMenuItems
        return '10 Chicken Wings + 1 Small Potato + 1 Pet Soda 400ml + 1 BBQ Sauce + 1 Colonel\'s Sauce.'; // Descripción ajustada para alas
      case 'BigBox Kentucky Coronel':
        return '1 Kentucky Colonel Hamburger / Sandwich (1 Breaded Chicken Breast Fillet, Coleslaw, BBQ and Butter) + 1 Small Pop Corn + 1 Small Potato + 1 PET Soda 400ml.';
      case 'Combo Pop Corn':
        return '1 Medium Pop Corn (Breaded chicken breast chunks) + 1 Small Potato + 1 PET Soda 400ml.';
      default:
        return 'Description not available.';
    }
  }

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

  // Definición del método _buildHeader
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 15,
            right: 15,
            bottom: 0,
          ), // Ajustado el padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: lightAccentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
                ),
              ),
              Expanded(
                // Para que la columna de "Deliver to" pueda centrarse si es necesario
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Para que la columna no ocupe más espacio del necesario
                  crossAxisAlignment: CrossAxisAlignment.center, // Centra el texto "Deliver to"
                  children: [
                    const Text("Deliver to", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    InkWell(
                      // Para hacer la dirección clickeable si se desea en el futuro
                      onTap: () {
                        // Lógica para cambiar dirección si se implementa
                        print("Change address tapped");
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Para centrar la fila
                        children: [
                          Text(
                            "Transversal 51a #67B - 90", // Dirección
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down, color: primaryColor, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 48,
              ), // Espacio para balancear el botón de retroceso (ajustar si es necesario)
            ],
          ),
        ),
        const SizedBox(height: 20),
        Image.asset(
          'assets/logos/kfc.png', // Asegúrate que esta ruta sea correcta
          height: 80,
        ),
        const SizedBox(height: 10),
        const Text(
          "Welcome to KFC",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 5),
        const Text(
          "Life tastes better with KFC.",
          style: TextStyle(fontSize: 14, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildMenuItemCard(BuildContext context, Map<String, String> item) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.all(4), // Pequeño margen alrededor de la tarjeta
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ProductDetailKFC(
                    productName: item['name']!,
                    productDescription: _getProductDescription(item['name']!),
                    productPrice: double.parse(item['price']!),
                    imageUrl: item['image']!,
                    // onAddToCart: (name, price, quantity) { Lógica para añadir al carrito }
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
                      // height: 100, // Puedes ajustar la altura si es necesario
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
                      color: primaryColor, // Color naranja para el precio
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: primaryColor, // Color naranja para el botón
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context), // Asegúrate de llamar a _buildHeader aquí
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _kfcMenuItems.length,
                  itemBuilder: (context, index) {
                    return _buildMenuItemCard(context, _kfcMenuItems[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChanged: _onTabTapped,
      ),
    );
  }
}
