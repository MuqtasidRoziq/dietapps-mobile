import 'package:diet_apps/components/article.dart';
import 'package:diet_apps/components/card_iklan.dart';
import 'package:diet_apps/components/menu_button.dart';
import 'package:diet_apps/components/search.dart';
import 'package:diet_apps/components/buttom_navigation.dart';
import 'package:diet_apps/components/alert-notif.dart';
import 'package:diet_apps/controllers/get_user_data.dart';
import 'package:flutter/material.dart' hide Notification;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final GetUserData getUserDataController = GetUserData();

  String fullname = "guest";
  String? photo;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await getUserDataController.getUserData();
      setState(() {
        fullname = data['fullname'] ?? "Guest"; 
        photo = data['photo'];
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 35,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            radius: 33,
                            backgroundImage: (photo != null && photo!.isNotEmpty) 
                                ? NetworkImage(photo!) 
                                : null,
                            child: (photo == null || photo!.isEmpty) 
                                ? const Icon(Icons.person, color: Colors.white) 
                                : null,
                          )
                        ],
                      ),
                      SizedBox(width: 10,),
                      Text(fullname)
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
                  IklanCard("Sarapan", "jangan lupa sarapan biar hari hari mu tidak lemas", "assets/images/sarapan.png", Colors.white, "lihat detail"),
                  IklanCard("Workout", "ayo workout bentuk tubuh mu agar menjadi kekar dan bagus", "assets/images/workout.png", Colors.white, "lihat detail"),
                ],
              ),
          ),
          Searching("Search...", (){
            
          }),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MenuButton(
                title: "Scan Postur",
                icon: Icons.camera_alt,
                color: Colors.blueAccent,
                onPressed: () {
                  Notification(context, "Peringatan!", "Pastikan postur tubuh anda terlihat secara penuh dan jelas pada kamera sebelum melanjutkan. gunakan baju yang press body", '/opencamera');
                },
              ),
              MenuButton(
                title: "Pola Hidup",
                icon: Icons.monitor_heart,
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, '/rekomen-pola-hidup');
                },
              ),
              MenuButton(
                title: "Chatkuy",
                icon: Icons.forum_rounded,
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, '/chatbot');
                },
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Artikel",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: (){
                Navigator.pushNamed(context, '/artikel');
              }, child: Text("lihat semua"))
            ],
          ),
          SizedBox(height: 10,),
          Article('assets/images/google_logo.png', "ini judul artikel", "12 Juny 2025", (){
            Navigator.pushNamed(context, "/details-article");
          }),
          Article('assets/images/google_logo.png', "ini judul artikel", "12 Juny 2025", (){
            Navigator.pushNamed(context, "/details-article");
          }),
          Article('assets/images/google_logo.png', "ini judul artikel", "12 Juny 2025", (){
            Navigator.pushNamed(context, "/details-article");
          }),
          Article('assets/images/google_logo.png', "ini judul artikel", "12 Juny 2025", (){
            Navigator.pushNamed(context, "/details-article");
          }),
          Article('assets/images/google_logo.png', "ini judul artikel", "12 Juny 2025", (){
            Navigator.pushNamed(context, "/details-article");
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
