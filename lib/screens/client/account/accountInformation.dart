import 'package:flutter/material.dart';
import '../../../auth/auth.dart';

const primaryColor = Color(0xFFf05000);
const lightAccentColor = Color(0xFFFEEAE6);

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  State<AccountInformationScreen> createState() => _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  String? _userName;
  String? _userEmail;
  String? _userPhoneNumber;
  String? _userDateOfBirth;

  @override
  void initState() {
    super.initState();
    _loadUserProfileData();
  }

  Future<void> _loadUserProfileData() async {
    final name = await getUserName();
    final email = await getUserEmail();
    final phoneNumber = await getUserPhone();
    // final dateOfBirth = await getUserDateOfBirth(); // Implement when available

    setState(() {
      _userName = name;
      _userEmail = email;
      _userPhoneNumber = phoneNumber ?? "Not available"; // CAMBIADO
      _userDateOfBirth = "Not available"; // CAMBIADO (y asumiendo que cargarás este dato después)
    });
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
                  value ?? 'Not available', // CAMBIADO
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
              'assets/images/fondoSemiTransparente.png', // Reutilizando el fondo
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context), // Regresar a la pantalla anterior
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: lightAccentColor,
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
                          'Account information',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 44), // Para balancear el botón de retroceso
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
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
                              child: Icon(Icons.person_outline, size: 40, color: primaryColor),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildInfoRow(Icons.badge_outlined, 'Full Name', _userName),
                          const Divider(),
                          _buildInfoRow(Icons.phone_outlined, 'Phone Number', _userPhoneNumber),
                          const Divider(),
                          _buildInfoRow(Icons.cake_outlined, 'Date of Birth', _userDateOfBirth),
                          const Divider(),
                          _buildInfoRow(Icons.email_outlined, 'Email Address', _userEmail),
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
                                // TODO: Implementar navegación o lógica para actualizar perfil
                                print('Update Profile tapped');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Función de actualizar perfil no implementada.'),
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
