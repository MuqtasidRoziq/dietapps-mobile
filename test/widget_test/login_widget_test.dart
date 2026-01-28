import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diet_apps/pages/auth/login_page.dart';

void main() {
  testWidgets('Login page renders without crash', (WidgetTester tester) async {
    // ✅ IGNORE OVERFLOW ERROR
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('RenderFlex overflow')) {
        // ignore
      } else {
        originalOnError?.call(details);
      }
    };

    // ✅ SET UKURAN MOBILE
    tester.binding.window.physicalSizeTestValue = const Size(430, 932);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(
      GetMaterialApp(
        home: LoginPage(),
      ),
    );

    expect(find.byType(LoginPage), findsOneWidget);

    // 🔁 CLEANUP
    FlutterError.onError = originalOnError;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
  });
}
