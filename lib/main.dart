import 'package:diet_apps/pages/all_article.dart';
import 'package:diet_apps/pages/auth/login_page.dart';
import 'package:diet_apps/pages/auth/register_page.dart';
import 'package:diet_apps/pages/cekpostur.dart';
import 'package:diet_apps/pages/chatbot.dart';
import 'package:diet_apps/pages/details-article.dart';
import 'package:diet_apps/pages/editprofile.dart';
import 'package:diet_apps/pages/get_started.dart';
import 'package:diet_apps/pages/history.dart';
import 'package:diet_apps/pages/homepage.dart';
import 'package:diet_apps/pages/polahidup.dart';
import 'package:diet_apps/pages/profile.dart';
import 'package:diet_apps/pages/scan/open_camera.dart';
import 'package:diet_apps/pages/scan/result_scan.dart';
import 'package:diet_apps/pages/ubahpass.dart';
import 'package:flutter/material.dart';

void main(){
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
        '/homepage' : (context) => Homepage(),
        '/cek-postur' : (context) => CekPostur(),
        '/chatbot' : (context) => ChatBot(),
        '/artikel' : (context) => AllArticle(),
        '/riwayat' : (context) => History(),
        '/profile' : (context) => Profile(),
        '/rekomen-pola-hidup' : (context) => RePolahidup(),
        '/editprofil':(context) => Editprofile(),
        '/ubahpass':(context)=> Ubahpass(),
        '/opencamera' : (context) => OpenCamera(),
        '/result-scan' : (context) => ResultScan(),
        '/details-article' : (context) => DetailsArtikel()
      },
    );
  }
}