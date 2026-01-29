import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:diet_apps/pages/auth/register_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Register Flow Integration Test', () {

    Future<void> pumpRegisterPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RegisterPage(),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Display all register form elements', (tester) async {
      await pumpRegisterPage(tester);

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Jenis Kelamin'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.byIcon(Icons.app_registration_rounded), findsOneWidget);
    });

    testWidgets('Show validation error when form is empty', (tester) async {
      await pumpRegisterPage(tester);

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining('field'), findsOneWidget);
    });

    testWidgets('Show error when passwords do not match', (tester) async {
      await pumpRegisterPage(tester);

      await tester.enterText(find.byKey(const ValueKey('fullname')), 'John Doe');

      await tester.tap(find.byKey(const ValueKey('jenis_kelamin')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Laki-laki').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('email')), 'john@mail.com');
      await tester.enterText(find.byKey(const ValueKey('password')), 'password123');
      await tester.enterText(find.byKey(const ValueKey('confirm_password')), 'beda123');

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Perbaikan: Gunakan teks error yang spesifik
      expect(find.text('Password tidak sama'), findsOneWidget);
    });

    testWidgets('Toggle password visibility', (tester) async {
      await pumpRegisterPage(tester);

      // Cari icon visibility untuk password field (gunakan first)
      final visibilityIcons = find.byIcon(Icons.visibility_off);
      await tester.tap(visibilityIcons.first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsWidgets);
    });

    testWidgets('Toggle confirm password visibility', (tester) async {
      await pumpRegisterPage(tester);

      // Cari icon visibility untuk confirm password field (gunakan last)
      final visibilityIcons = find.byIcon(Icons.visibility_off);
      await tester.tap(visibilityIcons.last);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsWidgets);
    });

    testWidgets('Select gender from dropdown', (tester) async {
      await pumpRegisterPage(tester);

      await tester.tap(find.byKey(const ValueKey('jenis_kelamin')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Perempuan').last);
      await tester.pumpAndSettle();

      expect(find.text('Perempuan'), findsOneWidget);
    });

    testWidgets('Show loading indicator when register pressed', (tester) async {
      await pumpRegisterPage(tester);

      await tester.enterText(find.byKey(const ValueKey('fullname')), 'John Doe');

      await tester.tap(find.byKey(const ValueKey('jenis_kelamin')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Laki-laki').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('email')), 'john@mail.com');
      await tester.enterText(find.byKey(const ValueKey('password')), 'password123');
      await tester.enterText(find.byKey(const ValueKey('confirm_password')), 'password123');

      await tester.tap(find.text('Register'));
      await tester.pump(const Duration(milliseconds: 300));

      // Cek loading indicator muncul
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Tunggu proses selesai untuk menghindari setState after dispose
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('Disable register button while loading', (tester) async {
      await pumpRegisterPage(tester);

      await tester.enterText(find.byKey(const ValueKey('fullname')), 'John Doe');

      await tester.tap(find.byKey(const ValueKey('jenis_kelamin')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Laki-laki').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('email')), 'john@mail.com');
      await tester.enterText(find.byKey(const ValueKey('password')), 'password123');
      await tester.enterText(find.byKey(const ValueKey('confirm_password')), 'password123');

      await tester.tap(find.text('Register'));
      await tester.pump(const Duration(milliseconds: 300));

      // Cek jika tombol masih ada, pastikan disabled
      final buttonFinder = find.byType(ElevatedButton);
      if (buttonFinder.evaluate().isNotEmpty) {
        final button = tester.widget<ElevatedButton>(buttonFinder.first);
        expect(button.onPressed, isNull);
      }
      
      // Atau cek loading indicator muncul
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

  });
}