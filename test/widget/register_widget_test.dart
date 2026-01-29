import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:diet_apps/pages/auth/register_page.dart';

void main() {
  testWidgets('Register page loads', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(430, 932)),
          child: RegisterPage(),
        ),
      ),
    );

    expect(find.byType(RegisterPage), findsOneWidget);
  });
}
