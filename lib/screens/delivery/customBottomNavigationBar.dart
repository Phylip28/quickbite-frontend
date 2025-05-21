import 'package:flutter/material.dart';

class DeliveryCustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const DeliveryCustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color orangeColor = const Color(0xFFf05000); // Color principal de tu app

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Orders', // Traducido
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map', // Traducido
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History', // Traducido
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile', // Traducido
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: orangeColor,
      unselectedItemColor: Colors.grey[600], // Un gris un poco más oscuro para mejor contraste
      onTap: onTap,
      type: BottomNavigationBarType.fixed, // Muestra labels para todos los ítems
      backgroundColor: Colors.white, // Fondo blanco por defecto
      elevation: 8.0, // Una ligera elevación
    );
  }
}
