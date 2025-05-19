import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart'; // Descomentar si añades funcionalidad de abrir email/teléfono

const primaryColor = Color(0xFFf05000); // O importa tus colores globales

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  // Función para intentar lanzar URLs (email, teléfono)
  // Future<void> _launchURL(String urlString) async {
  //   final Uri url = Uri.parse(urlString);
  //   if (!await launchUrl(url)) {
  //     // Podrías mostrar un SnackBar o un diálogo de error aquí
  //     print('Could not launch $urlString');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Get in Touch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              'We\'d love to hear from you! Whether you have a question about features, trials, pricing, need a demo, or anything else, our team is ready to answer all your questions.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildContactMethod(
              context,
              icon: Icons.email_outlined,
              title: 'Email Us',
              content:
                  'General Inquiries: info@quickbite.app\nSupport: support@quickbite.app\nPartnerships: partners@quickbite.app',
              // onTap: () => _launchURL('mailto:support@quickbite.app'), // Ejemplo de acción
            ),
            _buildContactMethod(
              context,
              icon: Icons.phone_outlined,
              title: 'Call Us',
              content:
                  'Customer Support: +1 (555) 123-4567\nSales: +1 (555) 987-6543\n(Mon-Fri, 9am - 6pm PST)',
              // onTap: () => _launchURL('tel:+15551234567'), // Ejemplo de acción
            ),
            _buildContactMethod(
              context,
              icon: Icons.location_on_outlined,
              title: 'Our Office',
              content:
                  'QuickBite Technologies Inc.\n123 Culinary Lane\nFoodie City, FS 98765\nUnited States',
            ),
            const SizedBox(height: 24),
            const Text(
              'Send Us a Message',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            // Formulario de contacto (simplificado)
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Your Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.subject_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Your Message',
                border: OutlineInputBorder(),
                alignLabelWithHint: true, // Para que el label se alinee bien con varias líneas
                prefixIcon: Icon(Icons.message_outlined),
              ),
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'Send Message',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  // TODO: Implementar la lógica de envío del formulario
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message sending functionality not implemented yet.'),
                    ),
                  );
                  print('Send message tapped');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
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
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        // Hacer toda la tarjeta tappable si se proporciona onTap
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
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
                    const SizedBox(height: 6),
                    Text(
                      content,
                      style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.4),
                    ),
                  ],
                ),
              ),
              if (onTap != null) // Mostrar flecha si es tappable
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
