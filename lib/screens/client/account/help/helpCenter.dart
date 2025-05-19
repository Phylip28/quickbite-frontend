import 'package:flutter/material.dart';
import 'faqs.dart';
import 'terms&conditions.dart';
import 'privacy&policy.dart';
import 'contactUs.dart';

const primaryColor = Color(0xFFf05000);

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo del Scaffold es blanco
      appBar: AppBar(
        title: const Text(
          'Help Center',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold), // LETRAS NARANJAS
        ),
        centerTitle: true, // <--- AÑADE ESTA LÍNEA PARA CENTRAR EL TÍTULO
        backgroundColor: Colors.white, // APPBAR BLANCA
        elevation: 1.0, // Sutil elevación para distinguir del cuerpo si es necesario
        iconTheme: const IconThemeData(color: primaryColor), // ICONO DE RETROCESO NARANJA
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), // Ícono actualizado para consistencia
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildHelpItem(
            context,
            icon: Icons.question_answer_outlined, // Icono Outlined
            title: 'FAQs',
            subtitle: 'Find answers to frequently asked questions.',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqsScreen()));
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.contact_phone_outlined, // Icono Outlined
            title: 'Contact Us',
            subtitle: 'Get in touch with our support team.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUsScreen()),
              );
            },
          ),
          _buildHelpItem(
            context,
            icon: Icons.article_outlined, // Icono Outlined (más genérico para documentos)
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
            icon: Icons.privacy_tip_outlined, // Icono Outlined
            title: 'Privacy Policy',
            subtitle: 'Understand how we handle your data.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
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
      color: Colors.white, // TARJETA BLANCA
      elevation: 2.0, // Elevación para que resalte del fondo blanco
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        leading: Icon(icon, color: primaryColor, size: 28), // Tamaño de icono ajustado
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
