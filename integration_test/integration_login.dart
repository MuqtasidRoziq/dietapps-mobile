import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:diet_apps/pages/auth/login_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow Basic Integration Test', () {

    Future<void> pumpLoginPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
          routes: {
            '/register': (context) => Scaffold(body: Center(child: Text('Register Page'))),
            '/forgot-password': (context) => Scaffold(body: Center(child: Text('Forgot Password Page'))),
          },
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Basic UI elements are present', (tester) async {
      await pumpLoginPage(tester);

      // Cek elemen-elemen utama
      expect(find.text('Login'), findsAtLeast(1));
      expect(find.byKey(Key('email')), findsOneWidget);
      expect(find.byKey(Key('password')), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Login with Google'), findsOneWidget);
    });

    testWidgets('Can input text into fields', (tester) async {
      await pumpLoginPage(tester);

      // Input email
      await tester.enterText(find.byKey(Key('email')), 'test@example.com');
      await tester.pump();
      
      // Input password
      await tester.enterText(find.byKey(Key('password')), 'password123');
      await tester.pump();
      
      // Pastikan tidak ada error
      expect(tester.takeException(), isNull);
    });

    testWidgets('Password visibility can be toggled', (tester) async {
      await pumpLoginPage(tester);

      // Awalnya password tersembunyi
      final passwordField = tester.widget<TextField>(find.byKey(Key('password')));
      expect(passwordField.obscureText, isTrue);
      
      // Tap visibility icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      
      // Sekarang password terlihat
      final updatedPasswordField = tester.widget<TextField>(find.byKey(Key('password')));
      expect(updatedPasswordField.obscureText, isFalse);
    });

    testWidgets('Can navigate to register page', (tester) async {
      await pumpLoginPage(tester);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      
      expect(find.text('Register Page'), findsOneWidget);
    });

    testWidgets('Can navigate to forgot password page', (tester) async {
      await pumpLoginPage(tester);

      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();
      
      expect(find.text('Forgot Password Page'), findsOneWidget);
    });

    testWidgets('Login button exists and can be pressed', (tester) async {
      await pumpLoginPage(tester);

      // Cari semua ElevatedButton
      final elevatedButtons = find.byType(ElevatedButton);
      expect(elevatedButtons, findsAtLeast(1));
      
      // Cari yang memiliki teks "Login" (bukan judul)
      final loginTextFinder = find.text('Login');
      // Ada 2: judul dan tombol. Ambil yang kedua
      final loginTexts = loginTextFinder.evaluate().toList();
      expect(loginTexts.length >= 2, isTrue);
      
      // Tidak crash saat tap tombol
      await tester.tap(find.text('Login').last);
      await tester.pump();
      
      expect(tester.takeException(), isNull);
    });

    testWidgets('Google login button exists', (tester) async {
      await pumpLoginPage(tester);

      expect(find.text('Login with Google'), findsOneWidget);
      
      // Tidak crash saat tap tombol Google
      await tester.tap(find.text('Login with Google'));
      await tester.pump();
      
      expect(tester.takeException(), isNull);
    });
  });
}