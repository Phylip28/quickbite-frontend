import 'package:flutter/material.dart';

const primaryColor = Color(0xFFf05000); // O importa tus colores globales

class DeliveryGuidelinesScreen extends StatelessWidget {
  const DeliveryGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Guidelines & Best Practices',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: primaryColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle('Professionalism & Customer Service'),
            _buildGuidelineItem(
              icon: Icons.sentiment_satisfied_alt_outlined,
              title: 'Be Courteous and Respectful',
              description:
                  'Always greet customers and restaurant staff politely. A positive attitude can greatly improve the delivery experience for everyone.',
            ),
            _buildGuidelineItem(
              icon: Icons.checkroom_outlined,
              title: 'Maintain a Professional Appearance',
              description:
                  'While there might not be a strict dress code, maintaining a clean and presentable appearance is recommended.',
            ),
            _buildGuidelineItem(
              icon: Icons.chat_bubble_outline,
              title: 'Communicate Clearly',
              description:
                  'If you anticipate delays or have issues finding the customer, communicate promptly and clearly through the app. Keep customers informed.',
            ),
            _buildGuidelineItem(
              icon: Icons.delivery_dining_outlined,
              title: 'Handle Orders with Care',
              description:
                  'Ensure food items are handled carefully to prevent spills or damage. Use appropriate delivery bags to maintain food temperature (hot or cold).',
            ),
            _buildGuidelineItem(
              icon: Icons.thumb_up_alt_outlined,
              title: 'Follow Customer Instructions',
              description:
                  'Pay close attention to any special delivery instructions provided by the customer (e.g., "leave at door," "call upon arrival," "avoid knocking").',
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle('Safety & Vehicle Operation'),
            _buildGuidelineItem(
              icon: Icons.health_and_safety_outlined,
              title: 'Prioritize Safety',
              description:
                  'Your safety and the safety of others is paramount. Always obey traffic laws, speed limits, and signals. Avoid distractions while driving or riding.',
            ),
            _buildGuidelineItem(
              icon: Icons.no_food_outlined, // Placeholder, could be better
              title: 'Never Deliver Under the Influence',
              description:
                  'Do not operate your vehicle or perform deliveries if you are under the influence of alcohol, drugs, or any medication that impairs your ability.',
            ),
            _buildGuidelineItem(
              icon: Icons.miscellaneous_services_outlined,
              title: 'Regular Vehicle Maintenance',
              description:
                  'Keep your vehicle (car, motorcycle, bicycle) in good working condition. Regularly check tires, brakes, lights, and other essential components.',
            ),
            _buildGuidelineItem(
              icon: Icons.location_searching_outlined,
              title: 'Be Aware of Your Surroundings',
              description:
                  'Especially during pickups and drop-offs, be mindful of your surroundings. Park in safe, well-lit areas whenever possible.',
            ),
            _buildGuidelineItem(
              icon: Icons.phone_android_outlined,
              title: 'Secure Your Phone',
              description:
                  'If using your phone for navigation, ensure it is securely mounted and does not obstruct your view or distract you.',
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle('Food Handling & Hygiene'),
            _buildGuidelineItem(
              icon: Icons.thermostat_outlined,
              title: 'Use Insulated Delivery Bags',
              description:
                  'Always use clean, insulated bags to transport food, maintaining appropriate temperatures for hot and cold items to ensure food safety and quality.',
            ),
            _buildGuidelineItem(
              icon: Icons.clean_hands_outlined,
              title: 'Maintain Good Personal Hygiene',
              description:
                  'Wash or sanitize your hands frequently, especially before handling food orders and after deliveries.',
            ),
            _buildGuidelineItem(
              icon: Icons.no_drinks_outlined, // Placeholder
              title: 'Separate Orders',
              description:
                  'If carrying multiple orders, ensure they are clearly separated to prevent cross-contamination and mix-ups.',
            ),
            _buildGuidelineItem(
              icon: Icons.verified_user_outlined,
              title: 'Check Order Accuracy (If Possible)',
              description:
                  'While you may not always be able to open sealed bags, double-check order numbers and items with restaurant staff if feasible to minimize errors.',
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle('App Usage & Efficiency'),
            _buildGuidelineItem(
              icon: Icons.app_settings_alt_outlined,
              title: 'Keep Your App Updated',
              description:
                  'Ensure you have the latest version of the QuickBite Delivery Partner app for optimal performance and access to new features.',
            ),
            _buildGuidelineItem(
              icon: Icons.battery_charging_full_outlined,
              title: 'Maintain Sufficient Battery',
              description:
                  'Keep your phone charged or carry a portable charger, as the app (especially GPS) can consume significant battery.',
            ),
            _buildGuidelineItem(
              icon: Icons.map_outlined,
              title: 'Familiarize Yourself with Delivery Zones',
              description:
                  'Understanding your common delivery areas can help you navigate more efficiently and anticipate potential traffic or parking issues.',
            ),
            _buildGuidelineItem(
              icon: Icons.notifications_active_outlined,
              title: 'Manage Your Availability',
              description:
                  'Go online when you are ready to accept deliveries and go offline if you need to take a break or are done for the day to avoid missing requests.',
            ),
            const SizedBox(height: 24.0),
            Text(
              'Following these guidelines will help ensure a smooth, safe, and successful delivery experience for you, our restaurant partners, and our customers. Thank you for being a valued QuickBite Delivery Partner!',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
      ),
    );
  }

  Widget _buildGuidelineItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: primaryColor.withOpacity(0.8), size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
