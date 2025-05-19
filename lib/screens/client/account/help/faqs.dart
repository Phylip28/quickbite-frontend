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
      appBar: AppBar(
        title: const Text(
          'FAQs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0), // Un poco de padding general
        itemCount: _faqItems.length,
        itemBuilder: (context, index) {
          final item = _faqItems[index];
          return Card(
            elevation: 1.0, // Sombra sutil para cada Card
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: ExpansionTile(
              key: PageStorageKey(item.question), // Para mantener el estado de expansión
              title: Text(
                item.question,
                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
              ),
              // Controlar el estado de expansión si es necesario para lógica más compleja
              // onExpansionChanged: (bool expanding) => setState(() => item.isExpanded = expanding),
              // initiallyExpanded: item.isExpanded,
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.answer,
                  style: TextStyle(
                    color: Colors.grey[700],
                    height: 1.4, // Espaciado de línea para mejor legibilidad
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
