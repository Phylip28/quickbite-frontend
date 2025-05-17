import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;
  final Color? backgroundColor; // Nuevo parámetro opcional

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    this.backgroundColor, // Inicializa el parámetro
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: backgroundColor ?? Colors.white, // Usa el color pasado o blanco por defecto
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
      currentIndex: currentIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.orange.withAlpha(100),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: onTabChanged,
    );
  }
}
