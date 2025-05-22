import 'package:flutter/material.dart';

const primaryColor = Color(0xFFf05000); // O importa tus colores globales

class DeliveryPrivacyPolicyScreen extends StatelessWidget {
  const DeliveryPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Delivery Partner Privacy Policy', // Título específico
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildParagraph(
              'This Privacy Policy describes how QuickBite Technologies Inc. ("QuickBite," "we," "us," or "our") collects, uses, shares, and protects the personal information of our delivery partners ("Delivery Partners," "you," or "your") who use the QuickBite platform (the "Platform") to provide delivery services. Your privacy is important to us, and we are committed to protecting your personal data.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('1. Information We Collect'),
            _buildParagraph(
              'We collect information that you provide directly to us, information we collect automatically when you use our Platform, and information we may obtain from third-party sources. This includes:',
            ),
            _buildListItem(
              'Personal Identification Information: Name, address, email address, phone number, date of birth, government-issued identification (e.g., driver\'s license, national ID) for identity verification and background checks, social security number or tax identification number for payment processing.',
            ),
            _buildListItem(
              'Vehicle Information: Vehicle type, make, model, license plate number, vehicle registration details, and vehicle insurance information.',
            ),
            _buildListItem(
              'Location Data: Precise geolocation data from your mobile device when the Delivery Partner app is running (both in the foreground and background) to facilitate delivery assignments, track delivery progress, provide ETAs to customers and merchants, and for safety and fraud prevention purposes.',
            ),
            _buildListItem(
              'Financial Information: Bank account details or other payment information to process your earnings.',
            ),
            _buildListItem(
              'Usage and Device Information: Information about how you interact with our Platform, including IP address, device type, operating system, browser type, app version, access times, pages viewed, and features used. We may also collect information about crashes or other technical issues.',
            ),
            _buildListItem(
              'Communication Data: Records of communications between you and QuickBite support, or between you and customers/merchants through the Platform (where facilitated by us).',
            ),
            _buildListItem(
              'Performance and Ratings Data: Information related to your delivery performance, such as acceptance rates, completion rates, delivery times, customer ratings, and feedback.',
            ),
            _buildListItem(
              'Background Check Information: With your consent, we or our third-party service providers may collect information for background checks as permitted by applicable law.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('2. How We Use Your Information'),
            _buildParagraph(
              'QuickBite uses the collected information for various purposes, including:',
            ),
            _buildListItem(
              'To operate and maintain the Platform and provide delivery opportunities to you.',
            ),
            _buildListItem(
              'To verify your identity, conduct background checks, and ensure eligibility to be a Delivery Partner.',
            ),
            _buildListItem('To process your earnings and facilitate payments.'),
            _buildListItem('To assign delivery requests and manage the logistics of deliveries.'),
            _buildListItem(
              'To communicate with you about your account, delivery requests, updates to our services, and promotional offers (with your consent where required).',
            ),
            _buildListItem('To provide support to you, customers, and merchants.'),
            _buildListItem(
              'To monitor and improve the safety and security of our Platform, users, and the public.',
            ),
            _buildListItem('To personalize your experience on the Platform.'),
            _buildListItem(
              'To analyze usage trends, conduct research, and improve our services and offerings.',
            ),
            _buildListItem(
              'To detect, prevent, and address fraud, technical issues, or violations of our terms and policies.',
            ),
            _buildListItem(
              'To comply with legal obligations, resolve disputes, and enforce our agreements.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('3. How We Share Your Information'),
            _buildParagraph('We may share your information in the following circumstances:'),
            _buildListItem(
              'With Customers and Merchants: To facilitate deliveries, we share certain information such as your name, vehicle type, license plate (in some regions), real-time location, and ETA with customers and merchants associated with the delivery orders you accept.',
            ),
            _buildListItem(
              'With Service Providers: We share information with third-party service providers who perform services on our behalf, such as payment processors, background check providers, cloud storage providers, mapping services, analytics providers, and customer support services. These providers are contractually obligated to protect your information and use it only for the purposes for which it was disclosed.',
            ),
            _buildListItem(
              'For Legal Reasons and Safety: We may disclose your information if required by law, regulation, legal process, or governmental request, or if we believe in good faith that disclosure is necessary to protect the rights, property, or safety of QuickBite, our users, or the public.',
            ),
            _buildListItem(
              'In Connection with a Business Transfer: If QuickBite is involved in a merger, acquisition, financing, reorganization, bankruptcy, or sale of all or a portion of our assets, your information may be sold or transferred as part of that transaction.',
            ),
            _buildListItem(
              'With Your Consent: We may share your information for other purposes with your explicit consent.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('4. Data Retention and Security'),
            _buildParagraph(
              'We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law (e.g., for tax, accounting, or other legal requirements). When we no longer need your information, we will securely delete or anonymize it.',
            ),
            _buildParagraph(
              'The security of your data is important to us. We implement reasonable administrative, technical, and physical security measures designed to protect your personal information from unauthorized access, use, alteration, and disclosure. However, please be aware that no method of transmission over the Internet or method of electronic storage is 100% secure, and we cannot guarantee absolute security.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('5. Your Rights and Choices'),
            _buildParagraph(
              'Depending on your jurisdiction, you may have certain rights regarding your personal information, such as the right to access, correct, update, delete, or restrict its processing. You may also have the right to object to processing or to data portability. You can typically manage some of your information and communication preferences through your account settings in the Delivery Partner app.',
            ),
            _buildParagraph(
              'Location Information: You can control the collection of location data through your mobile device settings. However, disabling location services may prevent you from using the Platform to receive delivery opportunities.',
            ),
            _buildParagraph(
              'Marketing Communications: You can opt-out of receiving promotional emails from us by following the unsubscribe instructions in those emails. You may still receive non-promotional communications related to your account and services.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('6. Children\'s Privacy'),
            _buildParagraph(
              'Our services are not intended for individuals under the age of 18 (or the applicable age of majority for providing delivery services in your jurisdiction). We do not knowingly collect personal information from children. If we become aware that we have inadvertently collected personal information from a child, we will take steps to delete it.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('7. International Data Transfers'),
            _buildParagraph(
              'Your information may be transferred to, stored, and processed in countries other than your own, including the United Kingdom, where our servers are located and our central database is operated. These countries may have data protection laws that are different from those in your country. We will take appropriate safeguards to ensure that your personal information remains protected in accordance with this Privacy Policy and applicable law.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('8. Changes to This Privacy Policy'),
            _buildParagraph(
              'We may update this Privacy Policy from time to time. We will notify you of any material changes by posting the new Privacy Policy on the Platform, by email, or through other communication channels. We encourage you to review this Privacy Policy periodically for any updates. Your continued use of the Platform after such modifications will constitute your acknowledgment of the modified Policy and agreement to abide and be bound by it.',
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle('Contact Us'),
            _buildParagraph(
              'If you have any questions, concerns, or requests regarding this Delivery Partner Privacy Policy or our data practices, please contact us at: privacy.delivery@quickbite.app or through the support section in the Delivery Partner application.',
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                'Last Updated: May 21, 2025', // Fecha actualizada
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 2.0,
        bottom: 2.0,
      ), // Ajustado para consistencia
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 2.0), // Ajustado para consistencia
            child: Text('•', style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5)),
          ),
          Expanded(
            child: Text(
              text,
              // textAlign: TextAlign.justify, // Puede ser opcional para listas
              style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
