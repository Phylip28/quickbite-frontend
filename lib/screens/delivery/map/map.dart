import 'package:flutter/material.dart';

class DeliveryRouteMapScreen extends StatefulWidget {
  const DeliveryRouteMapScreen({super.key});

  @override
  State<DeliveryRouteMapScreen> createState() => _DeliveryRouteMapScreenState();
}

class _DeliveryRouteMapScreenState extends State<DeliveryRouteMapScreen> {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFf05000);
    final String mapImagePath = 'assets/images/england.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Route Map',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryColor),
        elevation: 1.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1: Background Image
          Image.asset(
            mapImagePath,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.grey.shade600, size: 50),
                      const SizedBox(height: 10),
                      Text(
                        'Could not load map image.\nPlease ensure the image exists at:\n$mapImagePath\nand is declared in pubspec.yaml',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Layer 2: Semi-transparent overlay for text readability
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          ),

          // Layer 3: "Coming Soon" Text
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(
                  0.7,
                ), // Slightly darker background for the text itself
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'Map Feature\nComing Soon!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
