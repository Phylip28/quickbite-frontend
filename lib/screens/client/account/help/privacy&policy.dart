import 'package:flutter/material.dart';

const primaryColor = Color(0xFFf05000); // O importa tus colores globales

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // FONDO DEL SCAFFOLD BLANCO
      appBar: AppBar(
        title: const Text(
          'Privacy Policy', // TÍTULO CAMBIADO
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold), // TEXTO NARANJA
        ),
        centerTitle: true, // TÍTULO CENTRADO
        backgroundColor: Colors.white, // APPBAR BLANCA
        elevation: 1.0, // Sutil elevación
        iconTheme: const IconThemeData(color: primaryColor), // ICONO DE RETROCESO NARANJA
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
            // Aquí iría el contenido de tu política de privacidad
            // Ejemplo de estructura:
            _buildSectionTitle('1. Information We Collect'),
            _buildParagraph(
              'We collect several different types of information for various purposes to provide and improve our Service to you. This may include, but is not limited to, personal data such as email address, name, phone number, usage data, etc.',
            ),
            const SizedBox(height: 16.0),

            _buildSectionTitle('2. How We Use Your Information'),
            _buildParagraph(
              'QuickBite uses the collected data for various purposes: to provide and maintain the Service, to notify you about changes to our Service, to allow you to participate in interactive features of our Service when you choose to do so, to provide customer care and support, to provide analysis or valuable information so that we can improve the Service, to monitor the usage of the Service, to detect, prevent and address technical issues.',
            ),
            const SizedBox(height: 16.0),

            _buildSectionTitle('3. Data Security'),
            _buildParagraph(
              'The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.',
            ),

            // ... Agrega más secciones de tu política de privacidad aquí ...
            const SizedBox(height: 24.0), // Espacio antes de la información de contacto (si aplica)
            _buildSectionTitle('Contact Us'),
            _buildParagraph(
              'If you have any questions about this Privacy Policy, please contact us at privacy@quickbite.app.',
            ),

            const SizedBox(height: 24.0), // Espacio antes de la fecha de "Last Updated"
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                'Last Updated: May 19, 2025', // Ejemplo de fecha
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Puedes reutilizar estos widgets de ayuda o definirlos aquí si son específicos
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryColor, // O un color oscuro como Colors.black87
        ),
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
}
