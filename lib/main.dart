import 'package:diet_apps/controllers/article_controller.dart';
import 'package:diet_apps/notification_services.dart';
import 'package:diet_apps/pages/all_article.dart';
import 'package:diet_apps/pages/auth/forgot/input_email.dart';
import 'package:diet_apps/pages/auth/login_page.dart';
import 'package:diet_apps/pages/auth/register_page.dart';
import 'package:diet_apps/pages/history.dart';
import 'package:diet_apps/pages/scan/inputbmi.dart';
import 'package:diet_apps/pages/chatbot.dart';
import 'package:diet_apps/pages/details-article.dart';
import 'package:diet_apps/pages/report.dart';
import 'package:diet_apps/pages/homepage.dart';
import 'package:diet_apps/pages/polahidup.dart';
import 'package:diet_apps/pages/profile.dart';
import 'package:diet_apps/pages/scan/camera/open_camera.dart';
import 'package:diet_apps/pages/scan/preview_page.dart';
import 'package:diet_apps/pages/scan/result_scan.dart';
import 'package:diet_apps/pages/ubahpass.dart';
import 'package:diet_apps/pages/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:diet_apps/pages/info_apps.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:diet_apps/pages/feedback.dart';
import 'package:permission_handler/permission_handler.dart';

late List<CameraDescription> cameras; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize cameras
  cameras = await availableCameras();
  Get.put(ArticleController());
  
  // Initialize notification service
  await NotifService.init();
  
  // Request permissions
  await _requestPermissions();
  
  // Check login status
  final storage = const FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt_token');

  runApp(DietApp(initialRoute: token != null ? '/homepage' : '/'));
}

Future<void> _requestPermissions() async {
  // Request notification permission
  if (await Permission.notification.isDenied) {
    final status = await Permission.notification.request();
    debugPrint('📱 Notification permission: $status');
  }
  
  // Request exact alarm permission (Android 12+)
  if (await Permission.scheduleExactAlarm.isDenied) {
    final status = await Permission.scheduleExactAlarm.request();
    debugPrint('⏰ Exact alarm permission: $status');
  }
  
  // Request alarm permission
  if (await Permission.ignoreBatteryOptimizations.isDenied) {
    final status = await Permission.ignoreBatteryOptimizations.request();
    debugPrint('🔋 Battery optimization permission: $status');
  }
}

class DietApp extends StatelessWidget {
  final String initialRoute;
  const DietApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diet Apps',
      initialRoute: initialRoute,
      routes: {
        '/' : (context) => LoginPage(),
        '/register' : (context) => RegisterPage(),
        '/forgot-password' : (context) => ForgotPassword(),
        '/homepage' : (context) => Homepage(),
        '/chatbot' : (context) => ChatBot(),
        '/artikel' : (context) => AllArticle(),
        '/report' : (context) => Report(),
        '/history' : (context) => History(),
        '/profile' : (context) => Profile(),
        '/infoapps' : (context) => InfoApps(),
        '/feedback' : (context) => FeedbackUser(),
        '/rekomen-pola-hidup' : (context) => RePolahidup(),
        '/editprofil':(context) => Editprofile(),
        '/ubahpass':(context)=> Ubahpass(),
        '/opencamera' : (context) => OpenCamera(),
        '/previewphoto' : (context) => PreviewPage(imagePath: '', photoNumber: 0),
        '/inputbmi' : (context) => inputbmi(),
        '/result-scan' : (context) => ResultScan(),
        '/details-article' : (context) => DetailArticlePage()
      },
    );
  }
}