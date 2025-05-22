import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const primaryColor = Color(0xFFf05000); // O importa tus colores globales

class DeliveryContactUsScreen extends StatefulWidget {
  const DeliveryContactUsScreen({super.key});

  @override
  State<DeliveryContactUsScreen> createState() => _DeliveryContactUsScreenState();
}

class _DeliveryContactUsScreenState extends State<DeliveryContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // O ID de repartidor
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    final String name = _nameController.text;
    final String emailOrId = _emailController.text; // Podría ser email o ID de repartidor
    final String subject = _subjectController.text;
    final String message = _messageController.text;

    // Email específico para soporte a repartidores
    const String recipientEmail = 'deliverypartnersupport@quickbite.app';

    final String emailBody = '''
Name/Partner ID: $name 
Contact Email (if provided): $emailOrId 
----------------------------------
Subject: $subject
----------------------------------
Message:
$message
''';

    final String encodedSubject = Uri.encodeComponent("Delivery Partner Inquiry: $subject");
    final String encodedBody = Uri.encodeComponent(emailBody);

    final Uri emailLaunchUri = Uri.parse(
      'mailto:$recipientEmail?subject=$encodedSubject&body=$encodedBody',
    );

    if (mounted) {
      try {
        if (await canLaunchUrl(emailLaunchUri)) {
          await launchUrl(emailLaunchUri);
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Opening email client...')));
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not open email client. Please check your settings.'),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error launching email: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Support & Contact', // Título actualizado
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
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Contact Delivery Partner Support', // Título actualizado
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Have questions about your deliveries, earnings, app features, or your partnership? Our dedicated support team for delivery partners is here to help.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
              ),
              const SizedBox(height: 24),
              _buildContactMethod(
                context,
                icon: Icons.support_agent_outlined, // Icono más específico
                title: 'In-App Support',
                content:
                    'For urgent issues during a delivery, please use the "Help" or "Support" button directly within the QuickBite Delivery Partner app for the fastest assistance.',
              ),
              _buildContactMethod(
                context,
                icon: Icons.email_outlined,
                title: 'Email Us',
                content:
                    'Delivery Partner Support:\ndeliverypartnersupport@quickbite.app\nAccount & Payments: deliverypayments@quickbite.app',
              ),
              _buildContactMethod(
                context,
                icon: Icons.phone_outlined,
                title: 'Call Us (Partner Support Line)',
                content:
                    'Partner Support Hotline:\n+44 20 1234 5678 (UK Example)\n(Mon-Sun, 8am - 10pm GMT)', // Ejemplo para UK
              ),
              // Podrías omitir la dirección física si no es relevante para el soporte a repartidores,
              // o si es la misma, mantenerla.
              // _buildContactMethod(
              //   context,
              //   icon: Icons.location_on_outlined,
              //   title: 'Our Office',
              //   content:
              //       'QuickBite Technologies Ltd.\n456 Delivery Hub Road\nLondon, E1 6AN\nUnited Kingdom', // Ejemplo para UK
              // ),
              const SizedBox(height: 24),
              const Text(
                'Send Us a Message',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name / Partner ID', // Etiqueta actualizada
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge_outlined), // Icono actualizado
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name or Partner ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Your Registered Email (Optional)', // Etiqueta actualizada
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                keyboardType: TextInputType.emailAddress,
                // No es estrictamente obligatorio si se proporciona el ID
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject of Inquiry', // Etiqueta actualizada
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.help_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Your Message / Question', // Etiqueta actualizada
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.textsms_outlined),
                ),
                maxLines: 5,
                minLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send_rounded, color: Colors.white), // Icono actualizado
                  label: const Text(
                    'Send Inquiry', // Texto actualizado
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _sendEmail();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all required fields.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactMethod(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    VoidCallback? onTap,
  }) {
    final List<String> contentLines = content.split('\n');
    return Card(
      color: Colors.white,
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: primaryColor, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...contentLines.map((line) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          line,
                          style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.4),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              if (onTap != null) const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
