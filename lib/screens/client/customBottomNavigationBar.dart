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
          activeIcon: ImageIcon(AssetImage('assets/icons/cart.png'), color: Color(0xFFf05000)),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/home.png')),
          activeIcon: ImageIcon(AssetImage('assets/icons/home.png'), color: Color(0xFFf05000)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/profile.png')),
          activeIcon: ImageIcon(AssetImage('assets/icons/profile.png'), color: Color(0xFFf05000)),
          label: 'Account',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFFf05000),
      unselectedItemColor: const Color(0xFFf05000).withAlpha(100),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: onTabChanged,
    );
  }
}
