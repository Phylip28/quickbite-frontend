import 'package:flutter/material.dart';

const primaryColor = Color(0xFFf05000); // O importa tus colores globales

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy & Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle('Last Updated: May 19, 2025'), // Ejemplo de fecha
            const SizedBox(height: 16.0),
            _buildSectionTitle('1. Introduction'),
            _buildParagraph(
              'Welcome to QuickBite! We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about our policy, or our practices with regards to your personal information, please contact us.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('2. Information We Collect'),
            _buildParagraph(
              'We collect personal information that you voluntarily provide to us when you register on the Application, express an interest in obtaining information about us or our products and services, when you participate in activities on the Application or otherwise when you contact us.',
            ),
            _buildParagraph(
              'The personal information that we collect depends on the context of your interactions with us and the Application, the choices you make and the products and features you use. The personal information we collect may include the following: Name, Phone Number, Email Address, Mailing Address, Usernames, Passwords, Contact Preferences, Contact or Authentication Data, Billing Addresses, Debit/Credit Card Numbers, and other similar information.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('3. How We Use Your Information'),
            _buildParagraph(
              'We use personal information collected via our Application for a variety of business purposes described below. We process your personal information for these purposes in reliance on our legitimate business interests, in order to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations.',
            ),
            _buildListItem('To facilitate account creation and logon process.'),
            _buildListItem('To send administrative information to you.'),
            _buildListItem('To fulfill and manage your orders.'),
            _buildListItem('To post testimonials (with your consent).'),
            _buildListItem('To request feedback.'),
            // Añade más puntos según sea necesario
            const SizedBox(height: 16.0),
            _buildSectionTitle('4. Will Your Information Be Shared With Anyone?'),
            _buildParagraph(
              'We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations.',
            ),

            const SizedBox(height: 24.0),
            _buildSectionTitle('Contact Us'),
            _buildParagraph(
              'If you have questions or comments about this policy, you may email us at legal@quickbite.app or support@quickbite.app, or by post to:', // CAMBIO AQUÍ
            ),
            _buildParagraph(
              'QuickBite Technologies Inc.\n123 Culinary Lane\nFoodie City, FS 98765\nUnited States', // CAMBIO AQUÍ
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primaryColor, // O un color oscuro como Colors.black87
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[800],
          height: 1.5, // Espaciado de línea
        ),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 15, color: Colors.grey[800])),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5)),
          ),
        ],
      ),
    );
  }
}
