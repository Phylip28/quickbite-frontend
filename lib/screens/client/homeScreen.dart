import 'package:flutter/material.dart';
import '../registerScreen.dart';
import 'TierraQuerida/menuTierraQuerida.dart';
import 'account/profile.dart';
import 'customBottomNavigationBar.dart';
import 'cart/shoppingCart.dart';
import 'Starbucks/menuStarbucks.dart';
import 'Subway/menuSubway.dart';
import 'Kfc/menuKfc.dart';
import '../../auth/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  bool _isLoggedIn = false;
  String? _userAddress;

  @override
  void initState() {
    super.initState();
    print("[HomeScreen] initState called"); // DEBUG
    _checkLoginStatusAndLoadData();
  }

  Future<void> _checkLoginStatusAndLoadData() async {
    print("[HomeScreen] _checkLoginStatusAndLoadData called"); // DEBUG
    final token = await getAuthToken();
    print("[HomeScreen] Token from SharedPreferences: $token"); // DEBUG

    if (token != null && token.isNotEmpty) {
      final address = await getUserAddress();
      print("[HomeScreen] Address from SharedPreferences: $address"); // DEBUG
      if (mounted) {
        setState(() {
          _isLoggedIn = true;
          _userAddress = address;
          print(
            "[HomeScreen] setState called: _isLoggedIn=true, _userAddress=$_userAddress",
          ); // DEBUG
        });
      } else {
        print("[HomeScreen] NOT MOUNTED when trying to setState after getting address."); // DEBUG
      }
    } else {
      print("[HomeScreen] No valid token found."); // DEBUG
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _userAddress = null;
          print(
            "[HomeScreen] setState called: _isLoggedIn=false, _userAddress=null (no token)",
          ); // DEBUG
        });
      } else {
        print("[HomeScreen] NOT MOUNTED when trying to setState (no token)."); // DEBUG
      }
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
      );
      // print('Navegar al carrito'); // Puedes mantener o quitar este print
    } else if (index == 1) {
      // Ya estamos en HomeScreen
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileClient()),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    print(
      "[HomeScreen] build method called. _isLoggedIn: $_isLoggedIn, _userAddress: $_userAddress",
    ); // DEBUG
    return Scaffold(
      backgroundColor: Colors.white,
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
                    color: const Color.fromRGBO(0, 0, 0, 0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
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
                                  ? const Color(
                                    0xFFf05000,
                                  ) // Naranja si está logueado y hay dirección
                                  : Colors
                                      .black, // Negro por defecto o si no hay dirección/no logueado
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Lógica para mostrar "Register to get started" o un Container vacío
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
                    // Si está logueado, no mostramos el mensaje "Register to get started"
                    // Mostramos un Container para mantener el espacio si es necesario,
                    // o simplemente nada si la dirección ya se muestra arriba.
                    // El Container(height:14) que tenías podría ser para esto.
                    Container(height: 14), // O ajusta según tu diseño
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(158, 158, 158, 0.1),
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
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        category['image']!,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(158, 158, 158, 0.1),
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
                                      } else {
                                        // print('Clicked on ${restaurant['name']}');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Menu for ${restaurant['name']} not available yet.',
                                            ),
                                            duration: const Duration(seconds: 2),
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
