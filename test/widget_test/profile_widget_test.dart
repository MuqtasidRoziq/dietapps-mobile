import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:diet_apps/pages/profile.dart';

void main() {
  testWidgets('Profile page tampil', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(430, 932)),
          child: Profile(),
        ),
      ),
    );

    expect(find.byType(Profile), findsOneWidget);
  });
}
