// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

// Importa MyApp y la pantalla que usarás como initialScreen para el test
import 'package:Quickbite/main.dart';
import 'package:Quickbite/screens/loginScreen.dart';

void main() {
  testWidgets('App builds and shows LoginScreen smoke test', (WidgetTester tester) async {
    // Build our app with LoginScreen as the initial screen.
    await tester.pumpWidget(const MyApp(initialScreen: LoginScreen()));

    // Verify that LoginScreen is present.
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
