import 'package:diet_apps/pages/all_article.dart';
import 'package:diet_apps/pages/auth/forgot/input_email.dart';
import 'package:diet_apps/pages/auth/login_page.dart';
import 'package:diet_apps/pages/auth/register_page.dart';
import 'package:diet_apps/pages/scan/inputbmi.dart';
import 'package:diet_apps/pages/chatbot.dart';
import 'package:diet_apps/pages/details-article.dart';
import 'package:diet_apps/pages/editprofile.dart';
import 'package:diet_apps/pages/get_started.dart';
import 'package:diet_apps/pages/history.dart';
import 'package:diet_apps/pages/homepage.dart';
import 'package:diet_apps/pages/polahidup.dart';
import 'package:diet_apps/pages/profile.dart';
import 'package:diet_apps/pages/scan/camera/open_camera.dart';
import 'package:diet_apps/pages/scan/preview_page.dart';
import 'package:diet_apps/pages/scan/result_scan.dart';
import 'package:diet_apps/pages/ubahpass.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


late List<CameraDescription> cameras; // Menyimpan daftar kamera yang tersedia
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(DietApps());
}

class DietApps extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => GetStarted(),
        '/register' : (context) => RegisterPage(),
        '/login' : (context) => LoginPage(),
        '/forgot-password' : (context) => ForgotPassword(),
        '/homepage' : (context) => Homepage(),
        '/chatbot' : (context) => ChatBot(),
        '/artikel' : (context) => AllArticle(),
        '/riwayat' : (context) => History(),
        '/profile' : (context) => Profile(),
        '/rekomen-pola-hidup' : (context) => RePolahidup(),
        '/editprofil':(context) => Editprofile(),
        '/ubahpass':(context)=> Ubahpass(),
        '/opencamera' : (context) => OpenCamera(),
        '/previewphoto' : (context) => PreviewPage(imagePath: '', photoNumber: 0),
        '/inputbmi' : (context) => inputbmi(),
        '/result-scan' : (context) => ResultScan(),
        '/details-article' : (context) => DetailsArtikel()
      },
    );
  }
}