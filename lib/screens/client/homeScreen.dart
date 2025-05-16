import 'package:flutter/material.dart';
import '../loginScreen.dart';
import 'TierraQuerida/menuTierraQuerida.dart';
import 'profile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(child: Image.asset('assets/images/fondoCarga.png', fit: BoxFit.cover)),
          SafeArea(
            child: Column(
              // Cambiamos SingleChildScrollView por Column para controlar mejor el espacio
              children: <Widget>[
                // Recuadro blanco superior
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.2), // Reemplazo de withOpacity
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Deliver to', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Your Location',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          'Register to get started',
                          style: TextStyle(color: Colors.orange, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // Usamos Expanded para que el contenido principal ocupe el espacio restante
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bloque de Categorías
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'Categories',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _categories.length,
                                  itemBuilder: (context, index) {
                                    final category = _categories.elementAt(index);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: Column(
                                        children: [
                                          Image.asset(category['image']!, height: 80),
                                          const SizedBox(height: 8),
                                          Text(
                                            category['name']!,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Bloque de Restaurantes
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'Restaurants',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _restaurants.length,
                                  itemBuilder: (context, index) {
                                    final restaurant = _restaurants.elementAt(index);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (restaurant['name'] == 'Tierra Querida') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => MenuTierraQuerida(),
                                                  ),
                                                );
                                              } else {
                                                print('Clicked on ${restaurant['name']}');
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(restaurant['image']!, height: 80),
                                                const SizedBox(height: 8),
                                                Text(
                                                  restaurant['name']!,
                                                  style: const TextStyle(fontSize: 12),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20), // Espacio al final del contenido
                      ],
                    ),
                  ),
                ),
                // BottomNavigationBar fuera del SingleChildScrollView para que esté siempre abajo
                BottomNavigationBar(
                  backgroundColor: Colors.white,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage('assets/icons/cart.png')),
                      activeIcon: ImageIcon(
                        AssetImage('assets/icons/cart.png'),
                        color: Colors.orange,
                      ),
                      label: 'Cart',
                    ),
                    BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage('assets/icons/home.png')),
                      activeIcon: ImageIcon(
                        AssetImage('assets/icons/home.png'),
                        color: Colors.orange,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage('assets/icons/profile.png')),
                      activeIcon: ImageIcon(
                        AssetImage('assets/icons/profile.png'),
                        color: Colors.orange,
                      ),
                      label: 'Account',
                    ),
                  ],
                  currentIndex: 1,
                  selectedItemColor: Colors.orange,
                  unselectedItemColor: Colors.orange.withAlpha(100),
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  onTap: (index) {
                    if (index == 1) {
                      // No es necesario navegar a la misma pantalla
                    } else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileClient()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, String>> _categories = [
    {'name': 'Ice cream', 'image': 'assets/images/cliente/iceCream.png'},
    {'name': 'Sushi', 'image': 'assets/images/cliente/sushi.png'},
    {'name': 'Hamburgers', 'image': 'assets/images/cliente/hamburger.png'},
  ];

  final List<Map<String, String>> _restaurants = [
    {'name': 'Subway', 'image': 'assets/logos/subway.png'},
    {'name': 'KFC', 'image': 'assets/logos/kfc.png'},
    {'name': 'Starbucks', 'image': 'assets/logos/starbucks.png'},
    {'name': 'Tierra Querida', 'image': 'assets/logos/tierraQuerida.png'},
    {'name': 'Popsy', 'image': 'assets/logos/popsy.png'},
  ];
}
