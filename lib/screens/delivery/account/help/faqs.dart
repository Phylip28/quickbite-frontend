import 'package:flutter/material.dart';

const primaryColor = Color(0xFFf05000); // O importa tus colores globales

// Modelo para un item de FAQ (se puede reutilizar)
class FaqItem {
  final String question;
  final String answer;
  bool isExpanded;

  FaqItem({required this.question, required this.answer, this.isExpanded = false});
}

class DeliveryFaqsScreen extends StatefulWidget {
  const DeliveryFaqsScreen({super.key});

  @override
  State<DeliveryFaqsScreen> createState() => _DeliveryFaqsScreenState();
}

class _DeliveryFaqsScreenState extends State<DeliveryFaqsScreen> {
  // Lista de preguntas y respuestas para Repartidores
  final List<FaqItem> _faqItems = [
    FaqItem(
      question: 'How do I sign up to be a Delivery Partner?',
      answer:
          'You can sign up through the QuickBite Delivery Partner app or our website. You will need to provide some personal information, vehicle details, and consent to a background check as per local regulations.',
    ),
    FaqItem(
      question: 'What are the requirements to be a Delivery Partner?',
      answer:
          'Requirements typically include being of legal age to work and deliver, having a valid driver\'s license (for motor vehicles), valid vehicle registration and insurance, a smartphone with internet access, and passing a background check. Specific requirements may vary by region.',
    ),
    FaqItem(
      question: 'How do I receive delivery requests?',
      answer:
          'Delivery requests will appear in the QuickBite Delivery Partner app when you are online and available. You will see details such as pickup location, drop-off location, and estimated earnings before accepting a request.',
    ),
    FaqItem(
      question: 'How and when do I get paid?',
      answer:
          'Payments for completed deliveries are typically processed on a weekly or bi-weekly basis and deposited directly into your registered bank account. You can track your earnings in the "Earnings" section of the app. The payment schedule and methods will be detailed in your partner agreement.',
    ),
    FaqItem(
      question: 'What if I have an issue during a delivery?',
      answer:
          'If you encounter any issues during a delivery (e.g., restaurant delays, customer not available, app issues, accidents), please contact Delivery Partner Support immediately through the Help Center in your app. We are here to assist you.',
    ),
    FaqItem(
      question: 'Can I set my own schedule?',
      answer:
          'Yes, as an independent Delivery Partner, you generally have the flexibility to choose when and how often you want to deliver by going online in the app. Some regions might have options for scheduling blocks in advance for potentially higher demand periods.',
    ),
    FaqItem(
      question: 'What kind of vehicle can I use?',
      answer:
          'You can typically use a car, motorcycle, scooter, or bicycle, depending on local regulations and the options available in your city. Your vehicle must be in good working condition and meet all legal requirements.',
    ),
    FaqItem(
      question: 'How are my earnings calculated?',
      answer:
          'Earnings are typically calculated based on a combination of factors, which may include a base fare, distance traveled, time taken, and any applicable promotions or surge pricing during busy hours. Customers also have the option to tip, and you keep 100% of your tips.',
    ),
    FaqItem(
      question: 'What should I do if a customer is not available at the delivery location?',
      answer:
          'Follow the in-app prompts. Typically, you should try to contact the customer via the app. If you cannot reach them after a reasonable waiting period (as specified in the app or guidelines), the app will guide you on how to proceed, which might involve leaving the order in a safe place (if applicable and customer consented) or returning it.',
    ),
    FaqItem(
      question: 'Are there any performance standards or ratings?',
      answer:
          'Yes, maintaining a high level of service is important. Customer ratings, acceptance rates, and completion rates can affect your standing on the platform. Consistently high performance can lead to more opportunities. Detailed information about performance metrics can be found in the app or partner resources.',
    ),
    // Puedes añadir más preguntas y respuestas específicas para repartidores aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Delivery FAQs', // Título actualizado
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _faqItems.length,
        itemBuilder: (context, index) {
          final item = _faqItems[index];
          return Card(
            color: Colors.white,
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: ExpansionTile(
              key: PageStorageKey(item.question),
              iconColor: primaryColor,
              collapsedIconColor: Colors.grey[600],
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
                  style: TextStyle(color: Colors.grey[800], height: 1.5, fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
