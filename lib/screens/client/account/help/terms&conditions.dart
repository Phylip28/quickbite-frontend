import 'package:flutter/material.dart';

const primaryColor = Color(0xFFf05000); // O importa tus colores globales

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // FONDO DEL SCAFFOLD BLANCO
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold), // TEXTO NARANJA
        ),
        centerTitle: true, // TÍTULO CENTRADO
        backgroundColor: Colors.white, // APPBAR BLANCA
        elevation: 1.0, // Sutil elevación
        iconTheme: const IconThemeData(color: primaryColor), // ICONO DE RETROCESO NARANJA
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), // Ícono actualizado para consistencia
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // "Last Updated" se moverá al final
            // const SizedBox(
            //   height: 16.0, // Este SizedBox puede ajustarse o eliminarse si el Padding anterior es suficiente
            // ),
            _buildSectionTitle('1. Acceptance of Terms'),
            _buildParagraph(
              'By accessing or using the QuickBite mobile application (the "Service"), you agree to be bound by these Terms and Conditions ("Terms"). If you disagree with any part of the terms, then you may not access the Service. These Terms apply to all visitors, users, and others who access or use the Service.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('2. Use License'),
            _buildParagraph(
              'Permission is granted to temporarily download one copy of the materials (information or software) on QuickBite\'s Service for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:',
            ),
            _buildListItem('modify or copy the materials;'),
            _buildListItem(
              'use the materials for any commercial purpose, or for any public display (commercial or non-commercial);',
            ),
            _buildListItem(
              'attempt to decompile or reverse engineer any software contained on QuickBite\'s Service;',
            ),
            _buildListItem(
              'remove any copyright or other proprietary notations from the materials; or',
            ),
            _buildListItem(
              'transfer the materials to another person or "mirror" the materials on any other server.',
            ),
            _buildParagraph(
              'This license shall automatically terminate if you violate any of these restrictions and may be terminated by QuickBite at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('3. User Accounts'),
            _buildParagraph(
              'When you create an account with us, you must provide us information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.',
            ),
            _buildParagraph(
              'You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password, whether your password is with our Service or a third-party service. You agree not to disclose your password to any third party. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('4. Orders and Payments'),
            _buildParagraph(
              'QuickBite provides a platform to connect users with restaurants. All orders are subject to availability and confirmation by the restaurant. Prices for products are described on our Service and are incorporated into these Terms by reference. All prices are in [Your Currency] and subject to change.',
            ),
            _buildParagraph(
              'Payment can be made through various methods we have available, such as Visa, MasterCard, or online payment methods (PayPal, etc.). Payment cards (credit cards or debit cards) are subject to validation checks and authorization by Card Issuer. If we do not receive the required authorization, we will not be liable for any delay or non-delivery of Your Order.',
            ),

            // Continúa con más secciones de tus términos y condiciones...
            // Por ejemplo:
            // 5. Cancellations and Refunds
            // 6. Intellectual Property
            // 7. Termination
            // 8. Limitation of Liability
            // 9. Governing Law
            // 10. Changes to Terms
            // 11. Contact Information
            const SizedBox(height: 24.0), // Espacio antes de la información de contacto
            _buildSectionTitle('Contact Information'),
            _buildParagraph(
              'If you have any questions about these Terms, please contact us at legal@quickbite.app or by post to:',
            ),
            _buildParagraph(
              'QuickBite Technologies Inc.\n123 Culinary Lane\nFoodie City, FS 98765\nthe United Kingdom',
            ),
            const SizedBox(height: 24.0), // Espacio antes de la fecha de "Last Updated"
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ), // Ajusta el padding según sea necesario
              child: Text(
                'Last Updated: May 19, 2025', // Ejemplo de fecha
                style: TextStyle(
                  fontSize: 14, // Tamaño más pequeño
                  fontStyle: FontStyle.italic, // Cursiva
                  color: Colors.grey[700], // Color gris
                ),
              ),
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
