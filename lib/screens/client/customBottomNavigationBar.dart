import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;
  final Color? backgroundColor;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFFf05000);
    const Color inactiveColor = Colors.grey;

    return BottomNavigationBar(
      backgroundColor: backgroundColor ?? Colors.white,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(
            const AssetImage('assets/icons/cart.png'),
            color: currentIndex == 0 ? activeColor : inactiveColor,
          ),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            const AssetImage('assets/icons/home.png'),
            color: currentIndex == 1 ? activeColor : inactiveColor,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            const AssetImage('assets/icons/profile.png'),
            color: currentIndex == 2 ? activeColor : inactiveColor,
          ),
          label: 'Account',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: activeColor, // Aunque ya no se usa directamente para el icono
      unselectedItemColor: inactiveColor, // Aunque ya no se usa directamente para el icono
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: onTabChanged,
    );
  }
}
