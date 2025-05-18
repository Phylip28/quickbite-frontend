import 'package:flutter/material.dart';
import '../../../auth/auth.dart'; // Para obtener los datos del usuario

// Colores (asegúrate que estén definidos o importados)
const primaryColor = Color(0xFFf05000);
const lightAccentColor = Color(0xFFFEEAE6);
const textFieldBackgroundColor = Color(0xFFF7F7F7);

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userName = await getUserName(); // Asume que tienes esta función en auth.dart
    final userEmail = await getUserEmail(); // Asume que tienes esta función en auth.dart
    if (mounted) {
      setState(() {
        _userName = userName;
        _userEmail = userEmail;
      });
    }
  }

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      _currentPasswordVisible = !_currentPasswordVisible;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _newPasswordVisible = !_newPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _confirmPasswordVisible = !_confirmPasswordVisible;
    });
  }

  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement password change logic here
      // 1. Verify current password
      // 2. If new passwords match and meet criteria, update password
      print('Current Password: ${_currentPasswordController.text}');
      print('New Password: ${_newPasswordController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password change functionality not yet implemented.')),
      );
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white, // Fondo blanco para los campos
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.grey,
              ),
              onPressed: toggleVisibility,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $labelText';
            }
            if (labelText == "New Password" && value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            if (labelText == "Confirm Password" && value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
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
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
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
                          'Change password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 44), // Balance for back button
                    ],
                  ),
                ),
                // User Info
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: lightAccentColor,
                        child: Icon(Icons.person_outline, size: 25, color: primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userName ?? 'Loading...',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _userEmail ?? 'Loading...',
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95), // Ligera transparencia
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Change password',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildPasswordField(
                              controller: _currentPasswordController,
                              labelText: 'Current Password',
                              hintText: 'Enter your current password',
                              obscureText: _currentPasswordVisible,
                              toggleVisibility: _toggleCurrentPasswordVisibility,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Implement forgot password navigation/logic
                                  print('Forgot Password? tapped');
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: primaryColor, fontSize: 13),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildPasswordField(
                              controller: _newPasswordController,
                              labelText: 'New Password',
                              hintText: 'Enter your new password',
                              obscureText: _newPasswordVisible,
                              toggleVisibility: _toggleNewPasswordVisibility,
                            ),
                            const SizedBox(height: 20),
                            _buildPasswordField(
                              controller: _confirmPasswordController,
                              labelText: 'Confirm Password',
                              hintText: 'Confirm your new password',
                              obscureText: _confirmPasswordVisible,
                              toggleVisibility: _toggleConfirmPasswordVisibility,
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
                                  minimumSize: const Size(double.infinity, 50), // Full width
                                ),
                                onPressed: _handleChangePassword,
                                child: const Text(
                                  'Change Password',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
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
