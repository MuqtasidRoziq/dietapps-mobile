import 'package:diet_apps/components/article.dart';
import 'package:diet_apps/components/card_iklan.dart';
import 'package:diet_apps/components/menu_button.dart';
import 'package:diet_apps/components/search.dart';
import 'package:flutter/material.dart';
import 'package:diet_apps/components/buttom_navigation.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //(0xFFD5ECF4),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 30,
                      ),
                      SizedBox(width: 10,),
                      Text("Username")
                    ],
                  ),
                  IconButton(onPressed: (){
                    Navigator.pushNamed(context, '');
                  }, icon: Icon(Icons.notifications_none_outlined, size: 25,))
                ],
              ),
            ),
            Text("Rekomendasi Hari Ini",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IklanCard("Lari Pagi", "ayo semangat sangan lupa lari jaga tubuhmu", "assets/images/run_iklan.png", Colors.white, "lihat detail"),
                  IklanCard("Lari Pagi", "ayo semangat sangan lupa lari jaga tubuhmu", "assets/images/run_iklan.png", Colors.white, "lihat detail"),
                  IklanCard("Lari Pagi", "ayo semangat sangan lupa lari jaga tubuhmu", "assets/images/run_iklan.png", Colors.white, "lihat detail"),
                  IklanCard("Lari Pagi", "ayo semangat sangan lupa lari jaga tubuhmu", "assets/images/run_iklan.png", Colors.white, "lihat detail"),
                  IklanCard("Lari Pagi", "ayo semangat sangan lupa lari jaga tubuhmu", "assets/images/run_iklan.png", Colors.white, "lihat detail"),
                  IklanCard("Lari Pagi", "ayo semangat sangan lupa lari jaga tubuhmu", "assets/images/run_iklan.png", Colors.white, "lihat detail"),
                ],
              ),
          ),
          Searching("Search"),
          SizedBox(height: 20,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MenuButton(title: "Cek Postur", icon: Icons.accessibility_new, color: Colors.deepOrangeAccent, onPressed: (){
                  Navigator.pushNamed(context, '/');
                }),
                MenuButton(title: "Pola Hidup", icon: Icons.monitor_heart, color: Colors.deepOrangeAccent, onPressed: (){
                  Navigator.pushNamed(context, '/');
                }),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Text("Artikel",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

          ),
          SizedBox(height: 10,),
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
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
      ),
    );
  }
}
