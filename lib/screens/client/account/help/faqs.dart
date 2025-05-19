import 'package:flutter/material.dart';

const primaryColor = Color(0xFFf05000); // O importa tus colores globales

// Modelo para un item de FAQ
class FaqItem {
  final String question;
  final String answer;
  bool isExpanded;

  FaqItem({required this.question, required this.answer, this.isExpanded = false});
}

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  // Lista de preguntas y respuestas
  final List<FaqItem> _faqItems = [
    FaqItem(
      question: 'How do I place an order?',
      answer:
          'To place an order, simply browse our restaurants, select your desired items, add them to your cart, and proceed to checkout. You will need to provide your delivery address and payment information.',
    ),
    FaqItem(
      question: 'What payment methods do you accept?',
      answer:
          'We accept various payment methods including credit/debit cards (Visa, MasterCard, American Express), PayPal, and other digital wallets depending on your region.',
    ),
    FaqItem(
      question: 'How can I track my order?',
      answer:
          'Once your order is confirmed, you can track its status in real-time through the "Order History" section in your account. You will receive notifications at key stages of the delivery process.',
    ),
    FaqItem(
      question: 'Can I cancel or modify my order?',
      answer:
          'You can cancel or modify your order within a short window after placing it, typically before the restaurant starts preparing your food. Please check the order details page for options or contact customer support immediately.',
    ),
    FaqItem(
      question: 'What if I have an issue with my order?',
      answer:
          'If you encounter any issues with your order (e.g., missing items, incorrect order, quality concerns), please contact our customer support through the Help Center. We are here to assist you.',
    ),
    FaqItem(
      question: 'How is the delivery fee calculated?',
      answer:
          'The delivery fee is calculated based on the distance between the restaurant and your delivery address. Some restaurants may also offer free delivery promotions.',
    ),
    // Puedes añadir más preguntas y respuestas aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // FONDO DEL SCAFFOLD BLANCO
      appBar: AppBar(
        title: const Text(
          'FAQs',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold), // TEXTO NARANJA
        ),
        centerTitle: true, // TÍTULO CENTRADO
        backgroundColor: Colors.white, // APPBAR BLANCA
        elevation: 1.0, // Sutil elevación
        iconTheme: const IconThemeData(color: primaryColor), // ICONO DE RETROCESO NARANJA
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), // Ícono actualizado
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0), // Padding general
        itemCount: _faqItems.length,
        itemBuilder: (context, index) {
          final item = _faqItems[index];
          return Card(
            color: Colors.white, // TARJETA BLANCA
            elevation: 2.0, // Elevación para que resalte
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ), // Bordes redondeados
            child: ExpansionTile(
              key: PageStorageKey(item.question), // Para mantener el estado de expansión
              iconColor: primaryColor, // Color del icono de expansión
              collapsedIconColor: Colors.grey[600], // Color del icono cuando está colapsado
              title: Text(
                item.question,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              childrenPadding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 0),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.answer,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.grey[800],
                    height: 1.5, // Espaciado de línea para mejor legibilidad
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
