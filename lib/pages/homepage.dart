import 'package:diet_apps/components/article.dart';
import 'package:diet_apps/components/card_iklan.dart';
import 'package:diet_apps/components/menu_button.dart';
import 'package:diet_apps/components/buttom_navigation.dart';
import 'package:diet_apps/components/alert-notif.dart';
import 'package:diet_apps/controllers/article_controller.dart';
import 'package:diet_apps/controllers/get_user_data.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ArticleController articleController = Get.find<ArticleController>();
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
        photo = data['profile_picture'];
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB), // Background abu-abu sangat muda
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue.withOpacity(0.2), width: 2),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 35,
                          backgroundImage: (photo != null)
                              ? NetworkImage(photo!, headers: const {"ngrok-skip-browser-warning": "true"})
                              : null,
                          child: (photo == null || photo!.isEmpty)
                              ? const Icon(Icons.person, color: Colors.grey)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Halo, Selamat Datang", style: TextStyle(color: Colors.grey, fontSize: 14)),
                          Text(
                            fullname,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pushNamed(context, ''),
                      icon: const Icon(Icons.notifications_active_outlined, color: Colors.blueAccent),
                    ),
                  )
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Text(
                "Rekomendasi Hari Ini",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: 210, // Sesuaikan dengan tinggi card + padding
              child: PageView(
                controller: PageController(viewportFraction: 1.0), // 1.0 artinya 1 card full layar
                children: [
                  buildModernIklan(context, "Analisis Postur AI", "Cek progres tubuhmu dengan presisi AI.", "assets/images/run_iklan.png", const Color(0xFFE3F2FD)),
                  buildModernIklan(context, "Hidrasi Tubuh", "Minum air putih bantu metabolisme.", "assets/images/sarapan.png", const Color(0xFFE8F5E9)),
                  buildModernIklan(context, "Pola Hidup", "Atur nutrisi harianmu di sini.", "assets/images/workout.png", const Color(0xFFFFF3E0)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, spreadRadius: 5)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildMenuIcon(context, Icons.camera_alt_rounded, "Scan", Colors.blue, () {
                      NotificationDialog(context, "Peringatan!", "Pastikan tubuh terlihat penuh dan gunakan baju press body.", '/opencamera');
                    }),
                    buildMenuIcon(context, Icons.monitor_heart_rounded, "Pola Hidup", Colors.redAccent, () {
                      Navigator.pushNamed(context, '/rekomen-pola-hidup');
                    }),
                    buildMenuIcon(context, Icons.forum_rounded, "Chatkuy", Colors.teal, () {
                      Navigator.pushNamed(context, '/chatbot');
                    }),
                  ],
                ),
              ),
            ),

            // --- ARTIKEL SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Artikel Terbaru", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/artikel'),
                    child: const Text("Lihat Semua", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            
            Obx(() {
              if (articleController.isLoading.value) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ));
              }

              var displayArticles = articleController.homeArticles;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayArticles.length,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                itemBuilder: (context, index) {
                  final article = displayArticles[index];
                  return ArticleCard(
                    article.img ?? '', 
                    article.title, 
                    article.date ?? '', 
                    () => Navigator.pushNamed(context, "/details-article", arguments: article.id)
                  );
                },
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 0),
    );
  }
}