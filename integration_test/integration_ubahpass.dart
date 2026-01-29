import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:diet_apps/pages/ubahpass.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Ubah Password Integration Test', () {

    Future<void> pumpUbahPasswordPage(WidgetTester tester) async {
      // PERBAIKAN: Jangan bungkus dengan Scaffold lagi
      await tester.pumpWidget(
        MaterialApp(
          home: Ubahpass(), // Ubahpass sudah punya Scaffold sendiri
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('1. Page loads without errors', (tester) async {
      await pumpUbahPasswordPage(tester);
      expect(tester.takeException(), isNull);
      expect(find.text('Ubah Password'), findsOneWidget);
    });

    testWidgets('2. All form fields are present', (tester) async {
      await pumpUbahPasswordPage(tester);
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.text('Simpan Perubahan'), findsOneWidget);
    });

    testWidgets('3. Can type in password fields', (tester) async {
      await pumpUbahPasswordPage(tester);
      final textFields = find.byType(TextField);
      
      await tester.enterText(textFields.at(0), 'passwordLama123');
      await tester.enterText(textFields.at(1), 'passwordBaru123');
      await tester.enterText(textFields.at(2), 'passwordBaru123');
      await tester.pump();
      
      expect(tester.takeException(), isNull);
    });

    testWidgets('4. Toggle password visibility works', (tester) async {
      await pumpUbahPasswordPage(tester);
      
      // Awalnya semua password tersembunyi
      final textFields = find.byType(TextField);
      expect(tester.widget<TextField>(textFields.at(0)).obscureText, isTrue);
      
      // Tap icon visibility pertama
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pump();
      
      // Sekarang semua password terlihat
      expect(tester.widget<TextField>(textFields.at(0)).obscureText, isFalse);
    });

    testWidgets('5. Save button is clickable', (tester) async {
      await pumpUbahPasswordPage(tester);
      await tester.tap(find.text('Simpan Perubahan'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('6. AppBar exists with title', (tester) async {
      await pumpUbahPasswordPage(tester);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Ubah Password'), findsOneWidget);
    });
  });
}