import 'package:flutter/material.dart';

const primaryColor = Color(0xFFf05000); // O el color primario de tu app

class MembershipTermsScreen extends StatelessWidget {
  const MembershipTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Asegurar que el fondo sea blanco
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Introduction'),
            _buildParagraph(
              'Welcome to the QuickBite Membership Program! These Terms and Conditions ("Terms") govern your participation in our membership program ("Membership"). By subscribing to the Membership, you agree to be bound by these Terms. Please read them carefully.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('2. Membership Benefits'),
            _buildParagraph(
              'As a QuickBite Member, you are entitled to exclusive benefits, which may include, but are not limited to: discounts on orders, free delivery on eligible orders, special promotions, early access to new restaurant partners, and other perks as determined by QuickBite from time to time. Specific benefits will be detailed within the app and may be subject to change.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('3. Subscription and Payment'),
            _buildParagraph(
              '3.1. Subscription Fee: The Membership requires a recurring subscription fee. The current fee will be displayed at the time of subscription and may be subject to change. You will be notified in advance of any fee changes.',
            ),
            _buildParagraph(
              '3.2. Billing Cycle: Your Membership will automatically renew at the end of each billing cycle (e.g., monthly, annually) unless canceled by you. You authorize QuickBite to charge your chosen payment method for the recurring subscription fee.',
            ),
            _buildParagraph(
              '3.3. Payment Information: You are responsible for providing accurate and up-to-date payment information. If a payment is not successfully processed, your Membership may be suspended or terminated.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('4. Cancellation and Refunds'),
            _buildParagraph(
              '4.1. Cancellation: You may cancel your Membership at any time through your account settings in the QuickBite app. Cancellation will be effective at the end of your current billing cycle. You will continue to receive benefits until the end of the current cycle.',
            ),
            _buildParagraph(
              '4.2. Refunds: Subscription fees are generally non-refundable, except as required by applicable law or as otherwise determined by QuickBite in its sole discretion. No refunds or credits will be provided for partially used Membership periods.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('5. Eligibility'),
            _buildParagraph(
              'To be eligible for Membership, you must have an active QuickBite account and be in good standing. QuickBite reserves the right to refuse or terminate Membership for any reason, including violation of these Terms or QuickBite\'s general Terms of Service.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('6. Changes to Terms or Membership'),
            _buildParagraph(
              'QuickBite reserves the right to modify these Terms or any aspect of the Membership program, including benefits and fees, at any time. We will provide reasonable notice of any material changes. Your continued use of the Membership after such changes constitutes your acceptance of the new Terms.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('7. Limitation of Liability'),
            _buildParagraph(
              'To the fullest extent permitted by law, QuickBite shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the Membership.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('8. Governing Law'),
            _buildParagraph(
              'These Terms shall be governed by and construed in accordance with the laws of United States, without regard to its conflict of law principles.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('9. Contact Information'),
            _buildParagraph(
              'If you have any questions about these Terms or the Membership program, please contact us at support@quickbite.app.',
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Last Updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
      ),
    );
  }
}
