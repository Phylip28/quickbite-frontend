import 'package:flutter/material.dart';
import '../../loginScreen.dart';
import 'menuTierraQuerida.dart'; // Importa la nueva pantalla

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Deliver to', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(width: 5),
            Row(
              children: [
                const Text(
                  'Your Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text('Register to get started', style: TextStyle(color: Colors.orange)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Bloque de Categorías
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
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
                        final category = _categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            children: [
                              Image.asset(category['image']!, height: 80),
                              const SizedBox(height: 8),
                              Text(category['name']!, style: const TextStyle(fontSize: 12)),
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
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
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
                        final restaurant = _restaurants[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            children: [
                              InkWell(
                                // Envolvemos el Column con InkWell
                                onTap: () {
                                  if (restaurant['name'] == 'Tierra Querida') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MenuTierraQuerida()),
                                    );
                                  } else {
                                    // Lógica para otros restaurantes si es necesario
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
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/cart.png')),
            activeIcon: ImageIcon(AssetImage('assets/icons/cart.png'), color: Colors.orange),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/home.png')),
            activeIcon: ImageIcon(AssetImage('assets/icons/home.png'), color: Colors.orange),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/profile.png')),
            activeIcon: ImageIcon(AssetImage('assets/icons/profile.png'), color: Colors.orange),
            label: 'Account',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.orange.withAlpha(
          100,
        ), // Ajusta el valor de alpha para la opacidad deseada
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
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
