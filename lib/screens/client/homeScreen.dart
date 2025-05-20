import 'package:flutter/material.dart';
import '../registerScreen.dart';
import 'TierraQuerida/menuTierraQuerida.dart';
import 'account/profile.dart';
import 'customBottomNavigationBar.dart';
import 'cart/shoppingCart.dart';
import 'Starbucks/menuStarbucks.dart';
import 'Subway/menuSubway.dart';
import 'Kfc/menuKfc.dart';
import 'Popsy/menuPopsy.dart';
import 'membership.dart';
import '../../auth/auth.dart';

// Imports específicos para ProductDetail de cada restaurante
import 'Kfc/productDetailKfc.dart';
import 'Popsy/productDetailPSY.dart';
import 'Starbucks/productDetailSB.dart';
import 'Subway/productDetailSW.dart';
import 'TierraQuerida/productDetailTQ.dart';
import 'categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 1; // Home es el índice 1 por defecto
  bool _isLoggedIn = false;
  String? _userAddress;

  @override
  void initState() {
    super.initState();
    _checkLoginStatusAndLoadData();
  }

  Future<void> _checkLoginStatusAndLoadData() async {
    final token = await getAuthToken();
    if (mounted) {
      if (token != null && token.isNotEmpty) {
        final address = await getUserAddress();
        setState(() {
          _isLoggedIn = true;
          _userAddress = address;
        });
      } else {
        setState(() {
          _isLoggedIn = false;
          _userAddress = null;
        });
      }
    }
  }

  void _onTabTapped(int index) {
    switch (index) {
      case 0: // Cart
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingCartScreen()));
        break;
      case 1: // Home
        // Ya estamos en HomeScreen
        break;
      case 2: // Membership
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MembershipScreen()),
        );
        break;
      case 3: // Account (Profile)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
        );
        break;
    }
  }

  final List<Map<String, String>> _categories = [
    {'name': 'Ice cream', 'image': 'assets/images/cliente/iceCream.png'},
    {'name': 'Frappuccino', 'image': 'assets/images/cliente/frappuccino.png'},
    {'name': 'Hamburgers', 'image': 'assets/images/cliente/hamburger.png'},
  ];

  final List<Map<String, String>> _restaurants = [
    {'name': 'Subway', 'image': 'assets/logos/subway.png'},
    {'name': 'KFC', 'image': 'assets/logos/kfc.png'},
    {'name': 'Starbucks', 'image': 'assets/logos/starbucks.png'},
    {'name': 'Tierra Querida', 'image': 'assets/logos/tierraQuerida.png'},
    {'name': 'Popsy', 'image': 'assets/logos/popsy.png'},
  ];

  final List<Map<String, String>> _allProducts = [
    // KFC
    {
      'name': 'Mega Familiar',
      'image': 'assets/images/cliente/kfc/megaFamily.png',
      'price': '\$22.99',
      'restaurantName': 'KFC',
      'rating': '4.8',
      'description': 'A family feast with the unique KFC flavor.', // Translated
      'category': 'Chicken',
    },
    {
      'name': 'Wow Duo Deluxe Nuggets',
      'image': 'assets/images/cliente/kfc/wowDuoDeluxeNuggets.png',
      'price': '\$25.99',
      'restaurantName': 'KFC',
      'rating': '4.7',
      'description': 'Delicious nuggets to share, deluxe style.', // Translated
      'category': 'Hamburgers', // Assuming this is a general "main course" type category
    },
    {
      'name': 'Combo Nuggets',
      'image': 'assets/images/cliente/kfc/comboNuggets.png',
      'price': '\$11.50',
      'restaurantName': 'KFC',
      'rating': '4.8',
      'description': 'The perfect combo of crispy nuggets.', // Translated
      'category': 'Chicken',
    },
    {
      'name': 'Parte y Comparte Alas',
      'image': 'assets/images/cliente/kfc/shareAndSplitWings.png',
      'price': '\$25.99',
      'restaurantName': 'KFC',
      'rating': '4.7',
      'description': 'Spicy and tasty wings, ideal for sharing.', // Translated
      'category': 'Chicken',
    },
    {
      'name': 'BigBox Kentucky Coronel',
      'image': 'assets/images/cliente/kfc/bigBoxKentuckyCoronel.png',
      'price': '\$21.99',
      'restaurantName': 'KFC',
      'rating': '4.8',
      'description': "A box full of the Colonel's favorites.", // Translated
      'category': 'Hamburgers',
    },
    {
      'name': 'Combo Pop Corn',
      'image': 'assets/images/cliente/kfc/comboPopCorn.png',
      'price': '\$14.99',
      'restaurantName': 'KFC',
      'rating': '4.7',
      'description': 'Crispy Pop Corn chicken in an irresistible combo.', // Translated
      'category': 'Chicken',
    },
    // Subway
    {
      'name': 'Turkey and Ham Subs',
      'image': 'assets/images/cliente/subway/turkeyAndHamSubsFootlong.png',
      'price': '\$6.50',
      'restaurantName': 'Subway',
      'rating': '4.8',
      'description': 'Classic turkey and ham sub, fresh and delicious.', // Translated
      'category': 'Sandwich',
    },
    {
      'name': 'Rotisserie Style Chicken Subs',
      'image': 'assets/images/cliente/subway/rotisserieStyleChickenSubs.png',
      'price': '\$6.60',
      'restaurantName': 'Subway',
      'rating': '4.7',
      'description': 'Tasty rotisserie-style chicken in your favorite sub.', // Translated
      'category': 'Sandwich',
    },
    {
      'name': 'Subs Footlong Bacon Melt',
      'image': 'assets/images/cliente/subway/subsFootlongBaconMelt.png',
      'price': '\$5.50',
      'restaurantName': 'Subway',
      'rating': '4.6',
      'description': 'Irresistible sub with melted bacon.', // Translated
      'category': 'Sandwich',
    },
    // Popsy
    {
      'name': 'Cherrymania Milkshake',
      'image': 'assets/images/cliente/popsy/cherrymaniaMilkshake.png',
      'price': '\$4.50',
      'restaurantName': 'Popsy',
      'rating': '4.8',
      'description': 'Refreshing milkshake with the sweet taste of cherry.', // Translated
      'category': 'Ice cream',
    },
    {
      'name': 'Vainilla Gourmet Milkshake',
      'image': 'assets/images/cliente/popsy/vainillaGourmetMilkshake.png',
      'price': '\$4.60',
      'restaurantName': 'Popsy',
      'rating': '4.7',
      'description': 'Classic vanilla milkshake with a gourmet touch.', // Translated
      'category': 'Ice cream',
    },
    {
      'name': 'M&M Milkshake',
      'image': 'assets/images/cliente/popsy/m&mMilkShake.png',
      'price': '\$4.50',
      'restaurantName': 'Popsy',
      'rating': '4.6',
      'description': 'Fun and delicious milkshake with M&M pieces.', // Translated
      'category': 'Ice cream',
    },
    {
      'name': 'Cereza Italiana Milkshake',
      'image': 'assets/images/cliente/popsy/cerezaItalianaMilkshakeFrappuccino.png',
      'price': '\$5.00',
      'restaurantName': 'Popsy',
      'rating': '4.8',
      'description': 'Exquisite Italian-style cherry milkshake.', // Translated
      'category': 'Ice cream',
    },
    // Starbucks
    {
      'name': 'Fresa Cream Frappuccino',
      'image': 'assets/images/cliente/starbucks/fresaCreamFrappuccino.png',
      'price': '\$4.50',
      'restaurantName': 'Starbucks',
      'rating': '4.8',
      'description': 'Creamy Frappuccino with the sweet taste of strawberry.', // Translated
      'category': 'Frappuccino',
    },
    {
      'name': 'Cookies&Cream Frappuccino',
      'image': 'assets/images/cliente/starbucks/cookies&CreamFrappuccino.png',
      'price': '\$5.20',
      'restaurantName': 'Starbucks',
      'rating': '4.7',
      'description': 'Delicious Frappuccino with cookie pieces and cream.', // Translated
      'category': 'Frappuccino',
    },
    {
      'name': 'Mocha Blanco Frappuccino',
      'image': 'assets/images/cliente/starbucks/mochaBlancoFrappuccino.png',
      'price': '\$4.80',
      'restaurantName': 'Starbucks',
      'rating': '4.6',
      'description': 'Smooth and sweet white mocha Frappuccino.', // Translated
      'category': 'Frappuccino',
    },
    {
      'name': 'Caramel Frappuccino',
      'image': 'assets/images/cliente/starbucks/caramelFrappuccino.png',
      'price': '\$5.00',
      'restaurantName': 'Starbucks',
      'rating': '4.8',
      'description': 'The classic and beloved Caramel Frappuccino.', // Translated
      'category': 'Frappuccino',
    },
    // Tierra Querida
    {
      'name': 'Simple hamburger',
      'image': 'assets/images/cliente/tierraQuerida/simpleHamburgerDescription.png',
      'price': '\$3.40',
      'restaurantName': 'Tierra Querida',
      'rating': '4.8',
      'description': 'Classic hamburger with fresh ingredients.', // Translated
      'category': 'Hamburgers',
    },
    {
      'name': 'Double hamburger',
      'image': 'assets/images/cliente/tierraQuerida/dobleHamburgerDescription.png',
      'price': '\$4.50',
      'restaurantName': 'Tierra Querida',
      'rating': '4.7',
      'description': 'Double meat, double flavor in this hamburger.', // Translated
      'category': 'Hamburgers',
    },
    {
      'name': 'Triple hamburger',
      'image': 'assets/images/cliente/tierraQuerida/tripleHamburgerDescription.png',
      'price': '\$5.80',
      'restaurantName': 'Tierra Querida',
      'rating': '4.6',
      'description': 'For the hungriest, a triple hamburger.', // Translated
      'category': 'Hamburgers',
    },
    {
      'name': 'French fries',
      'image': 'assets/images/cliente/tierraQuerida/frenchFriesDescription.png',
      'price': '\$1.00',
      'restaurantName': 'Tierra Querida',
      'rating': '4.8',
      'description': 'Crispy and golden french fries.', // Translated
      'category': 'Fries',
    },
  ];

  Widget _buildProductItem(BuildContext context, Map<String, String> product) {
    final restaurantData = _restaurants.firstWhere(
      (r) => r['name'] == product['restaurantName'],
      orElse: () => {'image': '', 'name': 'Unknown'},
    );
    final String? restaurantLogo = restaurantData['image'];

    double parsePrice(String? priceString) {
      if (priceString == null) return 0.0;
      return double.tryParse(priceString.replaceAll('\$', '').replaceAll(',', '')) ?? 0.0;
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          Widget? detailScreen;
          final String productName = product['name'] ?? 'No Name';
          final String productDescription = product['description'] ?? productName;
          final double productPrice = parsePrice(product['price']);
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
                SnackBar(content: Text('No detail screen for ${product['restaurantName']}')),
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
                            child: Icon(Icons.fastfood, color: Colors.grey[400], size: 50),
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
                      color: Color(0xFFf05000),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Add ${product['name']} to cart (not implemented globally)',
                            ),
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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('Deliver to', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLoggedIn && _userAddress != null && _userAddress!.isNotEmpty
                            ? _userAddress!
                            : 'Your Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              _isLoggedIn && _userAddress != null && _userAddress!.isNotEmpty
                                  ? const Color(0xFFf05000)
                                  : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (!_isLoggedIn)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Register to get started',
                        style: TextStyle(color: Color(0xFFf05000), fontSize: 12),
                      ),
                    )
                  else
                    Container(height: 14),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
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
                                  child: InkWell(
                                    // <-- CAMBIO: InkWell para hacer la categoría tappable
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => CategoriesScreen(
                                                categoryName: category['name']!,
                                                allProducts: _allProducts,
                                                restaurants: _restaurants,
                                              ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    ), // Para el efecto ripple
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          category['image']!,
                                          height: 80,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          category['name']!,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
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
                            height: 130,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _restaurants.length,
                              itemBuilder: (context, index) {
                                final restaurant = _restaurants.elementAt(index);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: InkWell(
                                    onTap: () {
                                      if (restaurant['name'] == 'Tierra Querida') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const MenuTierraQuerida(),
                                          ),
                                        );
                                      } else if (restaurant['name'] == 'Starbucks') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const StarbucksMenuScreen(),
                                          ),
                                        );
                                      } else if (restaurant['name'] == 'Subway') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SubwayMenuScreen(),
                                          ),
                                        );
                                      } else if (restaurant['name'] == 'KFC') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const KfcMenuScreen(),
                                          ),
                                        );
                                      } else if (restaurant['name'] == 'Popsy') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const PopsyMenuScreen(),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Menu for ${restaurant['name']} not available yet.',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          restaurant['image']!,
                                          height: 80,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            restaurant['name']!,
                                            style: const TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                      child: Text(
                        "Featured Products",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[850],
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: _allProducts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final product = _allProducts[index];
                        return _buildProductItem(context, product);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
}
