import 'package:flutter/material.dart';
import '../../../auth/auth.dart'; // For getUserName, getUserEmail, getUserPhone, getUserLastName

const Color primaryColor = Color(0xFFf05000); // Orange color
const Color lightAccentColor = Color(0xFFFEEAE6); // Light orange accent

class DeliveryAccountInformationScreen extends StatefulWidget {
  const DeliveryAccountInformationScreen({super.key});

  @override
  State<DeliveryAccountInformationScreen> createState() => _DeliveryAccountInformationScreenState();
}

class _DeliveryAccountInformationScreenState extends State<DeliveryAccountInformationScreen> {
  String? _deliveryPersonFullName; // Cambiado para reflejar nombre completo
  String? _deliveryPersonEmail;
  String? _deliveryPersonPhoneNumber;
  String? _vehicleDetails; // Example delivery-specific field

  @override
  void initState() {
    super.initState();
    _loadDeliveryUserProfileData();
  }

  Future<void> _loadDeliveryUserProfileData() async {
    final firstName = await getUserName(); // Obtiene el primer nombre
    final lastName = await getUserLastName(); // Obtiene el apellido
    final email = await getUserEmail();
    final phoneNumber = await getUserPhone();
    final vehicle = await getDeliveryVehicleDetails(); // Usa la nueva función de auth.dart

    String fullName = "";
    if (firstName != null && firstName.isNotEmpty) {
      fullName += firstName;
    }
    if (lastName != null && lastName.isNotEmpty) {
      if (fullName.isNotEmpty) {
        fullName += " "; // Añade un espacio si ya hay un primer nombre
      }
      fullName += lastName;
    }
    if (fullName.isEmpty) {
      fullName = "Not available";
    }

    if (mounted) {
      setState(() {
        _deliveryPersonFullName = fullName; // Asigna el nombre completo
        _deliveryPersonEmail = email;
        _deliveryPersonPhoneNumber = phoneNumber ?? "Not available";
        _vehicleDetails = vehicle ?? "Not available"; // Asigna los detalles del vehículo
      });
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? 'Not available',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondoSemiTransparente.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.grey.shade200);
              },
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Custom Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context), // Go back
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8), // Adjusted for visibility
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Account Information', // Title
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 44), // Spacer to balance the back button
                    ],
                  ),
                ),
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95), // Slightly more opaque
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2), // Softer shadow
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: lightAccentColor,
                              child: Icon(
                                Icons.delivery_dining_outlined, // Delivery icon
                                size: 40,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildInfoRow(
                            Icons.badge_outlined,
                            'Full Name',
                            _deliveryPersonFullName,
                          ), // Usa la nueva variable
                          const Divider(),
                          _buildInfoRow(
                            Icons.phone_outlined,
                            'Phone Number',
                            _deliveryPersonPhoneNumber,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            Icons.email_outlined,
                            'Email Address',
                            _deliveryPersonEmail,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            Icons.motorcycle_outlined,
                            'Vehicle Details',
                            _vehicleDetails,
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () {
                                print('Update Delivery Profile tapped');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Update delivery profile functionality not yet implemented.',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Update Profile',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
