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
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(
            const AssetImage('assets/icons/cart.png'), // Índice 0
            color: currentIndex == 0 ? activeColor : inactiveColor,
          ),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            const AssetImage('assets/icons/home.png'), // Índice 1
            color: currentIndex == 1 ? activeColor : inactiveColor,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          // ÍTEM DE ÓRDENES - Índice 2
          icon: Icon(
            // Usando un ícono de Material Design
            Icons.receipt_long, // O Icons.list_alt, Icons.article, etc.
            color: currentIndex == 2 ? activeColor : inactiveColor,
          ),
          label: 'Orders', // Cambia la etiqueta a 'Orders'
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            const AssetImage('assets/icons/profile.png'), // Índice 3
            color: currentIndex == 3 ? activeColor : inactiveColor,
          ),
          label: 'Account',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: activeColor,
      unselectedItemColor: inactiveColor,
      showSelectedLabels: true, // <--- CAMBIO AQUÍ
      showUnselectedLabels: true, // <--- CAMBIO AQUÍ
      onTap: onTabChanged,
    );
  }
}
