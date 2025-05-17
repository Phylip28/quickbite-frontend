import 'package:flutter/material.dart';

import 'productDetail.dart';

import '../homeScreen.dart';

import '../customBottomNavigationBar.dart';

import '../profile.dart';

import '../cart/shoppingCart.dart';

class MenuTierraQuerida extends StatefulWidget {
  const MenuTierraQuerida({super.key});

  @override
  State<MenuTierraQuerida> createState() => _MenuTierraQueridaState();
}

class _MenuTierraQueridaState extends State<MenuTierraQuerida> {
  int _selectedIndex = 1;

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
      backgroundColor: const Color(0xFFFFFFFF), // Fondo similar a la imagen

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            Container(
              width: double.infinity,

              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(8.0),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),

                    spreadRadius: 1,

                    blurRadius: 5,

                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: Container(
                      padding: const EdgeInsets.all(8.0),

                      decoration: const BoxDecoration(
                        color: Color(0xFFFEEAE6),

                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),

                      child: const Icon(
                        Icons.arrow_back_ios_new,

                        color: Color(0xFFf05000),

                        size: 20,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Text(
                          'Deliver to',

                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),

                        const SizedBox(height: 2),

                        const Text(
                          'Transversal 51a #67B - 90', // Frase debajo del "Deliver to"

                          style: TextStyle(
                            fontSize: 16,

                            color: Color(0xFFf05000),

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Container(
                width: 120,

                height: 120,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  border: Border.all(color: Colors.black, width: 2),
                ),

                child: ClipOval(
                  child: Image.asset('assets/logos/tierraQuerida.png', fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text('Welcome to', style: TextStyle(fontSize: 20, color: Colors.black87)),

            const Text(
              'Tierra Querida',

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),

            const SizedBox(height: 8),

            const Text(
              // Frase debajo del nombre del restaurante
              'Let yourself be tempted!',

              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 24),

            GridView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,

                childAspectRatio: 0.75,

                crossAxisSpacing: 10,

                mainAxisSpacing: 10,
              ),

              itemCount: _menuItems.length,

              itemBuilder: (context, index) {
                final item = _menuItems[index];

                return Card(
                  color: Colors.white,

                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star, color: Color(0xFFf05000), size: 16),

                                const SizedBox(width: 4),

                                Text(item['rating']!, style: const TextStyle(fontSize: 12)),
                              ],
                            ),

                            const SizedBox(width: 8),
                          ],
                        ),

                        Expanded(
                          flex: 3,

                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder:
                                        (context) => ProductDetailTQ(
                                          productName: item['name']!,

                                          productDescription: _getProductDescription(item['name']!),

                                          productPrice: double.parse(item['price']!),

                                          imageUrl: item['image']!,
                                        ),
                                  ),
                                );
                              },

                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),

                                child: Image.asset(item['image']!, fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          item['name']!,

                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),

                          maxLines: 2,

                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Text(
                              '\$ ${item['price']}',

                              style: const TextStyle(color: Color(0xFFf05000), fontSize: 12),
                            ),

                            CircleAvatar(
                              backgroundColor: const Color(0xFFf05000),

                              radius: 14,

                              child: const Icon(Icons.add, color: Colors.white, size: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,

        onTabChanged: _onTabTapped,

        backgroundColor: Colors.white,
      ),
    );
  }

  final List<Map<String, String>> _menuItems = [
    {
      'name': 'Simple hamburger',

      'image': 'assets/images/cliente/tierraQuerida/simpleHamburgerDescription.png',

      'price': '3.40', // Precio modificado según la imagen

      'rating': '4.8',
    },

    {
      'name': 'Double hamburger',

      'image': 'assets/images/cliente/tierraQuerida/dobleHamburgerDescription.png',

      'price': '4.50', // Precio modificado según la imagen

      'rating': '4.7',
    },

    {
      'name': 'Triple hamburger',

      'image': 'assets/images/cliente/tierraQuerida/tripleHamburgerDescription.png',

      'price': '5.80', // Precio modificado según la imagen

      'rating': '4.6',
    },

    {
      'name': 'French fries',

      'image': 'assets/images/cliente/tierraQuerida/frenchFriesDescription.png',

      'price': '1.00', // Precio modificado según la imagen

      'rating': '4.8',
    },
  ];

  String _getProductDescription(String productName) {
    switch (productName) {
      case 'Simple hamburger':
        return 'Good sized beef (about 200 grams), cheddar cheese, American cheese, garlic sauce (which is usually one of its distinctive touches), crispy bacon, pickles, fresh tomato and crispy lettuce. All this on a soft bread.';

      case 'Double hamburger':
        return 'This burger includes double beef (about 400 grams), double portion of the cheeses, American cheese, garlic sauce (which is usually one of its distinctive touches), crispy bacon, pickles, fresh tomato and crispy lettuce. All this on a soft bread.';

      case 'Triple hamburger':
        return 'For true meat lovers! This option brings three beef meats (about 600 grams), American cheese, garlic sauce (which is usually one of its distinctive touches), crispy bacon, pickles, fresh tomato and crispy lettuce. All this on a soft bread.';

      case 'French fries':
        return 'They are the classic traditional side dish. There are natural with creamy cheddar cheese salt, chicken, sweet and sour BBQ, slightly spicy with jalapeño, refreshing with lemon and rich in bacon flavor. Check the availability.';

      default:
        return '';
    }
  }
}
