import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:diet_apps/pages/homepage.dart';
import 'package:diet_apps/controllers/article_controller.dart';

void main() {
  testWidgets('Homepage tampil', (WidgetTester tester) async {
    // 🔥 INJECT CONTROLLER
    Get.put(ArticleController());

    await tester.pumpWidget(
      GetMaterialApp(
        home: Homepage(),
      ),
    );

    expect(find.byType(Homepage), findsOneWidget);
  });
}
