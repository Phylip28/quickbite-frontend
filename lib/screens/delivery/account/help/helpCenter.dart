import 'package:flutter/material.dart';
import './faqs.dart'; // Este archivo debe definir DeliveryFaqsScreen
import 'terms&conditions.dart'; // Este archivo debe definir DeliveryTermsAndConditionsScreen
import 'privacy&policy.dart'; // Este archivo debe definir DeliveryPrivacyPolicyScreen
import 'contactUs.dart'; // Este archivo debe definir DeliveryContactUsScreen
import 'bestPractices.dart'; // Asegúrate que este archivo define DeliveryGuidelinesScreen

const Color primaryColor = Color(0xFFf05000);

class DeliveryHelpCenterScreen extends StatelessWidget {
  const DeliveryHelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Help Center (Delivery)',
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildHelpItem(
            context,
            icon: Icons.question_answer_outlined,
            title: 'Delivery FAQs',
            subtitle: 'Common questions about deliveries and app usage.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeliveryFaqsScreen()),
              );
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.contact_support_outlined,
            title: 'Support & Contact',
            subtitle: 'Reach out for delivery-related assistance.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeliveryContactUsScreen()),
              );
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.article_outlined,
            title: 'Delivery Partner Agreement',
            subtitle: 'Review the terms of your partnership.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeliveryTermsAndConditionsScreen()),
              );
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.shield_outlined,
            title: 'Data & Privacy (Delivery)',
            subtitle: 'How we handle your information as a delivery partner.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeliveryPrivacyPolicyScreen()),
              );
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.school_outlined,
            title: 'Delivery Guidelines & Best Practices',
            subtitle: 'Tips and rules for successful deliveries.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeliveryGuidelinesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        leading: Icon(icon, color: primaryColor, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
