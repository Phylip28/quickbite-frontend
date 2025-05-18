import 'package:flutter/material.dart';
import '../customBottomNavigationBar.dart';
import '../homeScreen.dart';
import '../cart/shoppingCart.dart';
import '../profile.dart';
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
      'name': 'Mega Familiar',
      'price': '22.99',
      'rating': '4.8',
      'image': 'assets/images/kfc/kfc_mega_familiar.png', // Reemplaza con tus rutas de imagen
    },
    {
      'name': 'Wow Duo Deluxe Nuggets',
      'price': '25.99',
      'rating': '4.7',
      'image': 'assets/images/kfc/kfc_wow_duo.png',
    },
    {
      'name': 'Combo Nuggets',
      'price': '11.50',
      'rating': '4.8',
      'image': 'assets/images/kfc/kfc_combo_nuggets.png',
    },
    {
      'name': 'Parte y Comparte Alas',
      'price': '25.99',
      'rating': '4.7',
      'image': 'assets/images/kfc/kfc_comparte_alas.png',
    },
    {
      'name': 'BigBox Kentucky Coronel',
      'price': '21.99',
      'rating': '4.8',
      'image': 'assets/images/kfc/kfc_bigbox_coronel.png',
    },
    {
      'name': 'Combo Pop Corn',
      'price': '14.99',
      'rating': '4.7',
      'image': 'assets/images/kfc/kfc_combo_popcorn.png',
    },
    // Puedes añadir más productos aquí si es necesario
  ];

  String _getProductDescription(String productName) {
    // Devuelve descripciones específicas para cada producto para la página de detalles
    switch (productName) {
      case 'Mega Familiar':
        return '8 Chicken Pieces + 4 Small Potatoes.'; // Assuming "Prey" was a typo for "Pieces"
      case 'Wow Duo Deluxe Nuggets':
        return '2 Deluxe BBQ Sandwiches (Brioche bread, 120gr breast, tomato, lettuce, Mayonnaise Sauce, 1 slice of American cheese) + 5 Nuggets + 2 Small Potatoes + 2 Pet Sodas + Colonel\'s Sauce.';
      case 'Combo Nuggets':
        return '10 Nuggets + 1 Small Potato + 1 Pet Soda 400ml + 1 BBQ Sauce + 1 Colonel\'s Sauce.';
      case 'Parte y Comparte Alas':
        // Using the description provided, though it's similar to Combo Nuggets.
        // Consider if this product should have a more distinct description for "Alas" (Wings).
        return '10 Nuggets + 1 Small Potato + 1 Pet Soda 400ml + 1 BBQ Sauce + 1 Colonel\'s Sauce.';
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
      // Si el índice 1 (Home en BottomNavBar) debe llevar al HomeScreen principal
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap:
                    () => Navigator.pushReplacement(
                      // Cambiado para navegar a HomeScreen
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: lightAccentColor, // Color de fondo suave
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
                ),
              ),
              const Column(
                children: [
                  Text("Deliver to", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Row(
                    children: [
                      Text(
                        "Transversal 51a #67B - 90",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: primaryColor, size: 16),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 40), // Espacio para balancear el botón de retroceso
            ],
          ),
        ),
        const SizedBox(height: 20),
        Image.asset(
          'assets/logos/kfc.png', // Reemplaza con la ruta de tu logo de KFC
          height: 80,
        ),
        const SizedBox(height: 10),
        const Text("Welcome to KFC", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
      backgroundColor: Colors.grey[100], // Un fondo ligeramente gris para la pantalla
      body: SafeArea(
        // SafeArea para evitar que el contenido se superponga con la barra de estado/notches
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll del GridView
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Dos columnas
                    childAspectRatio: 0.70, // Ajusta para el tamaño de tus tarjetas
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
