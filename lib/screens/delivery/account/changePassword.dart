import 'package:flutter/material.dart';
import '../../../auth/auth.dart'; // For user data

// Colors
const Color primaryColor = Color(0xFFf05000);
const Color lightAccentColor = Color(0xFFFEEAE6);
// const Color textFieldBackgroundColor = Color(0xFFF7F7F7); // Not explicitly used in client reference for field background

class DeliveryChangePasswordScreen extends StatefulWidget {
  const DeliveryChangePasswordScreen({super.key});

  @override
  State<DeliveryChangePasswordScreen> createState() => _DeliveryChangePasswordScreenState();
}

class _DeliveryChangePasswordScreenState extends State<DeliveryChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  String? _deliveryPersonName;
  String? _deliveryPersonEmail;

  @override
  void initState() {
    super.initState();
    _loadDeliveryUserProfile();
  }

  Future<void> _loadDeliveryUserProfile() async {
    final userName = await getUserName();
    final userEmail = await getUserEmail();
    if (mounted) {
      setState(() {
        _deliveryPersonName = userName;
        _deliveryPersonEmail = userEmail;
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
      // TODO: Implement delivery person password change logic
      print('Current Password (Delivery): ${_currentPasswordController.text}');
      print('New Password (Delivery): ${_newPasswordController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delivery password change functionality not yet implemented.'),
        ),
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
    required bool obscureTextState, // Renamed to avoid conflict
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
          obscureText: !obscureTextState, // Use the renamed state variable
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
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
                obscureTextState ? Icons.visibility_off_outlined : Icons.visibility_outlined,
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
                            color: Colors.white.withOpacity(0.8), // Adjusted
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
                          'Change Password', // Title
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 44), // Balance
                    ],
                  ),
                ),
                // User Info
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        // Delivery Icon
                        radius: 25,
                        backgroundColor: lightAccentColor,
                        child: Icon(Icons.delivery_dining_outlined, size: 25, color: primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _deliveryPersonName ?? 'Loading...',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _deliveryPersonEmail ?? 'Loading...',
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
                        color: Colors.white.withOpacity(0.95),
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
                              'Change password', // Sub-header
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
                              obscureTextState: _currentPasswordVisible,
                              toggleVisibility: _toggleCurrentPasswordVisibility,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Implement delivery forgot password
                                  print('Forgot Password? (Delivery) tapped');
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
                              obscureTextState: _newPasswordVisible,
                              toggleVisibility: _toggleNewPasswordVisibility,
                            ),
                            const SizedBox(height: 20),
                            _buildPasswordField(
                              controller: _confirmPasswordController,
                              labelText: 'Confirm Password',
                              hintText: 'Confirm your new password',
                              obscureTextState: _confirmPasswordVisible,
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
                                  minimumSize: const Size(double.infinity, 50),
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
