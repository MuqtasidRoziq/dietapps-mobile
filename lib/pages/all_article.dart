import 'package:diet_apps/components/article.dart';
import 'package:diet_apps/components/buttom_navigation.dart';
import 'package:flutter/material.dart';

class AllArticle extends StatelessWidget {
  const AllArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Artikel", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),)
            ),
          ),

          Article('assets/images/google_logo.png', "google telah mendapatkan anugerahnya dalam menciptakan ai", "12 Juny 2025", (){

          }),
          Article('assets/images/google_logo.png', "google telah mendapatkan anugerahnya dalam menciptakan ai", "12 Juny 2025", (){

          }),
          Article('assets/images/google_logo.png', "google telah mendapatkan anugerahnya dalam menciptakan ai", "12 Juny 2025", (){

          }),
          Article('assets/images/google_logo.png', "google telah mendapatkan anugerahnya dalam menciptakan ai", "12 Juny 2025", (){

          }),
          Article('assets/images/google_logo.png', "google telah mendapatkan anugerahnya dalam menciptakan ai", "12 Juny 2025", (){

          }),
          Article('assets/images/google_logo.png', "google telah mendapatkan anugerahnya dalam menciptakan ai", "12 Juny 2025", (){

          }),
          Article('assets/images/google_logo.png', "google telah mendapatkan anugerahnya dalam menciptakan ai", "12 Juny 2025", (){

          }),
          Article('assets/images/google_logo.png', "google telah mendapatkan anugerahnya dalam menciptakan ai", "12 Juny 2025", (){

          }),
          Article('assets/images/google_logo.png', "google telah mendapatkan anugerahnya dalam menciptakan ai", "12 Juny 2025", (){

          }),
          Article('assets/images/google_logo.png', "google telah mendapatkan anugerahnya dalam menciptakan ai", "12 Juny 2025", (){

          }),
          Article('assets/images/google_logo.png', "google telah mendapatkan anugerahnya dalam menciptakan ai", "12 Juny 2025", (){

          }),
        ],
      ),
      bottomNavigationBar: BottomNav(currentIndex: 1),
    );
  }
}