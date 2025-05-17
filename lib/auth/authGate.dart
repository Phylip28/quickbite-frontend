import 'package:flutter/material.dart';
import 'auth.dart';
import '../screens/loginScreen.dart';
import '../screens/client/homeScreen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<Widget> _navigationFuture;

  @override
  void initState() {
    super.initState();
    _navigationFuture = _checkAuthAndNavigate();
  }

  Future<Widget> _checkAuthAndNavigate() async {
    String? token = await getAuthToken();

    if (token != null && token.isNotEmpty) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _navigationFuture,
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          print('Error checking auth: ${snapshot.error}');
          return const LoginScreen();
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const LoginScreen(); // Fallback
        }
      },
    );
  }
}
