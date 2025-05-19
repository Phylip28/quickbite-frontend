import 'package:flutter/material.dart';
import 'faqs.dart';
import 'terms&conditions.dart';
import 'privacy&policy.dart';
import 'contactUs.dart';

const primaryColor = Color(0xFFf05000); // O importa tus colores globales

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help Center',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white), // Para el color del botón de retroceso
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildHelpItem(
            context,
            icon: Icons.question_answer,
            title: 'FAQs',
            subtitle: 'Find answers to frequently asked questions.',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqsScreen()));
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.contact_phone,
            title: 'Contact Us',
            subtitle: 'Get in touch with our support team.',
            onTap: () {
              // CAMBIO AQUÍ
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUsScreen()),
              );
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.policy, // Icono para Términos y Condiciones
            title: 'Terms & Conditions',
            subtitle: 'Read our terms and conditions.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()),
              );
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.privacy_tip, // Icono para Política de Privacidad
            title: 'Privacy Policy',
            subtitle: 'Understand how we handle your data.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
              );
            },
          ),
          // Puedes añadir más ítems aquí
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
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: primaryColor, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
