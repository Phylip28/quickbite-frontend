import 'package:flutter/material.dart';
import './faqs.dart'; // Placeholder: Debería ser DeliveryFaqsScreen
import './terms&conditions.dart'; // Placeholder: Debería ser DeliveryTermsAndConditionsScreen
import './privacy&policy.dart'; // Placeholder: Debería ser DeliveryPrivacyPolicyScreen
import './contactUs.dart'; // Placeholder: Debería ser DeliveryContactUsScreen

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
              // TODO: Implement navigation to DeliveryFaqsScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeliveryFaqsScreen()),
              ); // Placeholder
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.contact_support_outlined, // Icono más específico para soporte
            title: 'Support & Contact',
            subtitle: 'Reach out for delivery-related assistance.',
            onTap: () {
              // TODO: Implement navigation to DeliveryContactUsScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeliveryContactUsScreen()),
              ); // Placeholder
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.article_outlined,
            title: 'Delivery Partner Agreement', // Más específico para repartidores
            subtitle: 'Review the terms of your partnership.',
            onTap: () {
              // TODO: Implement navigation to DeliveryTermsAndConditionsScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeliveryTermsAndConditionsScreen()),
              ); // Placeholder
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.shield_outlined, // Icono para privacidad/seguridad
            title: 'Data & Privacy (Delivery)',
            subtitle: 'How we handle your information as a delivery partner.',
            onTap: () {
              // TODO: Implement navigation to DeliveryPrivacyPolicyScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeliveryPrivacyPolicyScreen()),
              ); // Placeholder
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.school_outlined, // Icono para guías/tutoriales
            title: 'Delivery Guidelines & Best Practices',
            subtitle: 'Tips and rules for successful deliveries.',
            onTap: () {
              // TODO: Implement navigation to a DeliveryGuidelinesScreen or similar
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Delivery Guidelines - Coming Soon!')));
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

// Placeholder Screens (deberás crear estos archivos y widgets)

class DeliveryFaqsScreen extends StatelessWidget {
  const DeliveryFaqsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery FAQs')),
      body: const Center(child: Text('Delivery FAQs Content')),
    );
  }
}

class DeliveryContactUsScreen extends StatelessWidget {
  const DeliveryContactUsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us (Delivery)')),
      body: const Center(child: Text('Delivery Contact Us Content')),
    );
  }
}

class DeliveryTermsAndConditionsScreen extends StatelessWidget {
  const DeliveryTermsAndConditionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Partner Agreement')),
      body: const Center(child: Text('Delivery Terms Content')),
    );
  }
}

class DeliveryPrivacyPolicyScreen extends StatelessWidget {
  const DeliveryPrivacyPolicyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data & Privacy (Delivery)')),
      body: const Center(child: Text('Delivery Privacy Policy Content')),
    );
  }
}
