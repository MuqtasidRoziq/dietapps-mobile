import 'package:diet_apps/pages/auth/login_page.dart';
import 'package:diet_apps/pages/auth/register_page.dart';
import 'package:diet_apps/pages/get_started.dart';
import 'package:diet_apps/pages/homepage.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(DietApps());
}

class DietApps extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (context) => GetStarted(),
        '/register' : (context) => RegisterPage(),
        '/login' : (context) => LoginPage(),
        '/homepage' : (context) => Homepage()
      },
    );
  }
}