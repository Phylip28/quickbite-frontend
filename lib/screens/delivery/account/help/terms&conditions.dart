import 'package:flutter/material.dart';

const primaryColor = Color(0xFFf05000); // O importa tus colores globales

class DeliveryTermsAndConditionsScreen extends StatelessWidget {
  const DeliveryTermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Delivery Partner Agreement', // Título específico para repartidores
          // --- INICIO DE CAMBIOS ---
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16.0, // Reducir el tamaño de la fuente
          ),
          // --- FIN DE CAMBIOS ---
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
            _buildSectionTitle('1. Partnership Agreement'),
            _buildParagraph(
              'This Delivery Partner Agreement ("Agreement") is entered into by and between you ("Delivery Partner," "you," or "your") and QuickBite Technologies Inc. ("QuickBite," "we," "us," or "our"), a company registered in Delaware, USA. This Agreement governs your use of the QuickBite platform (the "Platform") to provide independent delivery services for orders placed by customers ("Customers") with restaurants, stores, and other merchants partnered with QuickBite (collectively, "Merchants"). By accepting a delivery opportunity through the Platform, you acknowledge that you have read, understood, and agree to be bound by this Agreement, as well as our Privacy Policy and any other applicable guidelines or policies made available to you.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('2. Delivery Partner Obligations & Conduct'),
            _buildParagraph('As an independent Delivery Partner, you agree to:'),
            _buildListItem(
              'Perform delivery services with a high degree of professionalism, courtesy, timeliness, and safety, adhering to all reasonable customer requests communicated through the Platform.',
            ),
            _buildListItem(
              'Maintain, at your own expense, a valid driver\'s license, vehicle registration, and vehicle insurance (meeting or exceeding statutory minimums) for the vehicle (car, motorcycle, bicycle, etc.) you use to perform deliveries. You must provide proof of such documentation to QuickBite upon request.',
            ),
            _buildListItem(
              'Ensure your vehicle is in good operating condition, clean, and suitable for performing delivery services, complying with all applicable safety standards.',
            ),
            _buildListItem(
              'Comply with all applicable local, state, and federal laws, rules, and regulations, including but not limited to traffic laws, food safety handling guidelines (if applicable), and regulations concerning independent contractors.',
            ),
            _buildListItem(
              'Use the QuickBite Delivery Partner application as intended, maintain the confidentiality and security of your login credentials, and not allow any other person to use your account.',
            ),
            _buildListItem(
              'Not engage in any activity that could harm or negatively impact the reputation or business of QuickBite, its Merchants, or Customers. This includes, but is not limited to, discrimination, harassment, theft, or any unlawful conduct.',
            ),
            _buildListItem(
              'Promptly and accurately notify QuickBite through the designated channels of any accidents, incidents, significant delays, or issues that occur during the performance of delivery services that may affect the order or safety.',
            ),
            _buildListItem(
              'Maintain a high standard of personal hygiene and, if applicable, use appropriate insulated delivery bags to maintain food temperature and quality.',
            ),
            _buildListItem(
              'Not to be under the influence of alcohol, illegal drugs, or any substance that impairs your ability to operate a vehicle safely while providing delivery services.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('3. Service Fees, Payments, and Relationship'),
            _buildParagraph(
              'QuickBite will facilitate payments to you for the delivery services you complete. The fee structure, which may include base pay, distance-based fees, time-based fees, and any applicable promotions, tips (paid by Customers), or incentives, will be clearly communicated to you through the Platform prior to accepting a delivery opportunity. Payments will be processed according to the schedule outlined by QuickBite, typically on a weekly or bi-weekly basis, to your designated bank account or payment method.',
            ),
            _buildParagraph(
              'You acknowledge and agree that you are an independent contractor and not an employee, agent, joint venturer, or partner of QuickBite. Nothing in this Agreement creates an employment relationship. You are solely responsible for your own business expenses, including fuel, vehicle maintenance, insurance, and any tools or equipment necessary to perform the delivery services. You are also solely responsible for determining and remitting any applicable income taxes, self-employment taxes, sales taxes, or other withholdings on the payments you receive. QuickBite will not withhold any taxes on your behalf, except as may be strictly required by law.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('4. Use of the QuickBite Platform'),
            _buildParagraph(
              'QuickBite grants you a limited, non-exclusive, non-sublicensable, non-transferable, revocable license to access and use the QuickBite Delivery Partner application on your personal device solely for the purpose of receiving and fulfilling delivery opportunities in accordance with this Agreement. You may not:',
            ),
            _buildListItem(
              'Modify, adapt, translate, copy, or create derivative works based on the Platform or any part thereof.',
            ),
            _buildListItem(
              'Use the Platform for any commercial purpose other than providing delivery services as contemplated by this Agreement, or for any unlawful or fraudulent purpose.',
            ),
            _buildListItem(
              'Attempt to decompile, reverse engineer, disassemble, or otherwise access or determine the source code of the Platform.',
            ),
            _buildListItem(
              'Remove, alter, or obscure any copyright, trademark, or other proprietary notices on the Platform.',
            ),
            _buildListItem(
              'Transfer, lease, lend, sell, redistribute, or sublicense your access to the Platform or your account to another person or entity.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('5. Confidentiality, Data, and Intellectual Property'),
            _buildParagraph(
              'In the course of providing delivery services, you may have access to confidential information, including but not limited to Customer personal data (names, addresses, phone numbers), order details, Merchant information, and QuickBite operational data. You agree to maintain the strict confidentiality of this information and use it solely for the purpose of fulfilling delivery orders as per this Agreement. You must comply with QuickBite\'s data privacy policies applicable to Delivery Partners and all applicable data protection laws. Unauthorized disclosure or use of confidential information is strictly prohibited and may result in termination of this Agreement and legal action.',
            ),
            _buildParagraph(
              'All intellectual property rights in the QuickBite Platform, including its software, design, branding, and content, are owned by or licensed to QuickBite. This Agreement does not grant you any rights to QuickBite\'s intellectual property except for the limited license to use the Platform as described herein.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('6. Termination and Deactivation'),
            _buildParagraph(
              'You may terminate this Agreement and cease providing delivery services at any time by providing written notice to QuickBite or by ceasing to use the Platform. QuickBite reserves the right to deactivate your access to the Platform and terminate this Agreement with or without notice for any material breach of this Agreement, including but not limited to violations of safety standards, fraudulent activity, consistent poor performance, customer complaints, or other reasons as determined by QuickBite in its reasonable discretion. QuickBite may also suspend or deactivate your account temporarily pending investigation of any alleged misconduct.',
            ),
            _buildParagraph(
              'Upon termination or deactivation, your right to access and use the Platform will immediately cease. You must promptly return any QuickBite property in your possession, if any. Obligations regarding confidentiality, data protection, and any outstanding payment obligations shall survive the termination of this Agreement.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('7. Disclaimer of Warranties & Limitation of Liability'),
            _buildParagraph(
              'THE QUICKBITE PLATFORM AND DELIVERY OPPORTUNITIES ARE PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT ANY WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT, AND ANY WARRANTIES ARISING OUT OF COURSE OF DEALING OR USAGE OF TRADE. QUICKBITE MAKES NO REPRESENTATIONS OR WARRANTIES REGARDING THE AVAILABILITY, RELIABILITY, ACCURACY, OR COMPLETENESS OF THE PLATFORM, THE VOLUME OR FREQUENCY OF DELIVERY OPPORTUNITIES, OR THE EARNINGS YOU MAY GENERATE.',
            ),
            _buildParagraph(
              'TO THE FULLEST EXTENT PERMITTED BY APPLICABLE LAW, QUICKBITE, ITS AFFILIATES, OFFICERS, DIRECTORS, EMPLOYEES, AGENTS, AND LICENSORS SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, PUNITIVE, OR EXEMPLARY DAMAGES, INCLUDING BUT NOT LIMITED TO DAMAGES FOR LOSS OF PROFITS, GOODWILL, USE, DATA, OR OTHER INTANGIBLE LOSSES, ARISING OUT OF OR RELATED TO YOUR PROVISION OF DELIVERY SERVICES, YOUR USE OF OR INABILITY TO USE THE PLATFORM, OR THIS AGREEMENT, EVEN IF QUICKBITE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. QUICKBITE\'S TOTAL CUMULATIVE LIABILITY TO YOU FOR ANY AND ALL CLAIMS ARISING OUT OF OR RELATING TO THIS AGREEMENT OR YOUR USE OF THE PLATFORM SHALL NOT EXCEED THE TOTAL AMOUNT OF SERVICE FEES PAID BY QUICKBITE TO YOU IN THE THREE (3) MONTHS IMMEDIATELY PRECEDING THE EVENT GIVING RISE TO THE CLAIM.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('8. Indemnification'),
            _buildParagraph(
              'You agree to indemnify, defend, and hold harmless QuickBite and its affiliates, officers, directors, employees, and agents from and against any and all claims, liabilities, damages, losses, costs, expenses, and fees (including reasonable attorneys\' fees) that such parties may incur as a result of or arising from (a) your breach of any provision of this Agreement; (b) your provision of delivery services; (c) any accident, injury (including death), or property damage caused by you or your vehicle while providing delivery services; (d) your violation of any law or the rights of a third party, including Customers or Merchants.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('9. Governing Law and Dispute Resolution'),
            _buildParagraph(
              'This Agreement shall be governed by and construed in accordance with the laws of the State of California, USA, without regard to its conflict of law principles. Any dispute, claim, or controversy arising out of or relating to this Agreement or the breach, termination, enforcement, interpretation, or validity thereof, including the determination of the scope or applicability of this agreement to arbitrate, shall be determined by arbitration in San Francisco, California before one arbitrator. The arbitration shall be administered by JAMS pursuant to its Comprehensive Arbitration Rules and Procedures. Judgment on the Award may be entered in any court having jurisdiction. This clause shall not preclude parties from seeking provisional remedies in aid of arbitration from a court of appropriate jurisdiction.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('10. Changes to Agreement'),
            _buildParagraph(
              'QuickBite reserves the right to modify this Agreement at any time. We will provide you with notice of significant changes, which may be communicated through the Platform, by email, or other reasonable means. Your continued use of the Platform to provide delivery services after such modifications have been made and communicated will constitute your acceptance of the new terms. If you do not agree to the modified terms, you must stop using the Platform and terminate this Agreement.',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('11. Entire Agreement & Severability'),
            _buildParagraph(
              'This Agreement, together with any policies or guidelines referenced herein, constitutes the entire agreement between you and QuickBite with respect to the subject matter hereof and supersedes all prior or contemporaneous communications and proposals, whether electronic, oral, or written, between you and QuickBite. If any provision of this Agreement is found to be unenforceable or invalid, that provision will be limited or eliminated to the minimum extent necessary so that this Agreement will otherwise remain in full force and effect and enforceable.',
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle('Contact Information'),
            _buildParagraph(
              'If you have any questions about this Delivery Partner Agreement, please contact us at deliverypartners@quickbite.app or through the support channels provided in the QuickBite Delivery Partner application.',
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                'Last Updated: May 21, 2025',
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
      padding: const EdgeInsets.only(bottom: 4.0),
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
      padding: const EdgeInsets.only(left: 16.0, top: 2.0, bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 2.0),
            child: Text('•', style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5)),
          ),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5)),
          ),
        ],
      ),
    );
  }
}
