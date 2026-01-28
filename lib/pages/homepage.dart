import 'dart:async'; // Jangan lupa import ini untuk Timer
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

  // Banner configuration
  PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': '📸 Scan Postur Tubuh',
      'desc': 'Analisis postur dengan AI dalam 3 detik!',
      'icon': Icons.person_search_rounded,
      'iconSize': 100.0,
      'color': const Color(0xFFE3F2FD),
      'action': 'scan',
    },
    {
      'title': '💧 Hidrasi Hari Ini',
      'desc': 'Minum air putih bantu metabolisme optimal',
      'icon': Icons.water_drop_rounded,
      'iconSize': 100.0,
      'color': const Color(0xFFE8F5E9),
      'route': '/chatbot',
    },
    {
      'title': '📊 Lihat Progress Kamu',
      'desc': 'Pantau perkembangan berat badan & postur',
      'icon': Icons.trending_up_rounded,
      'iconSize': 100.0,
      'color': const Color(0xFFFFF3E0),
      'route': '/report',
    },
    {
      'title': '🤖 Chat dengan AI',
      'desc': 'Konsultasi diet & workout gratis 24/7',
      'icon': Icons.smart_toy_rounded,
      'iconSize': 100.0,
      'color': const Color(0xFFF3E5F5),
      'route': '/chatbot',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _bannerController = PageController();
    _startBannerAutoScroll();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
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

  Future<void> _refreshData() async {
    await Future.wait([
      _loadData(),
      articleController.fetchHomeArticles(),
    ]);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Data berhasil diperbarui'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        int nextPage = _currentBannerIndex + 1;
        if (nextPage >= _banners.length) nextPage = 0;
        
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handleBannerAction(Map<String, dynamic> banner) {
    if (banner['action'] == 'scan') {
      NotificationDialog(
        context, 
        "Peringatan!", 
        "Pastikan tubuh terlihat penuh dan gunakan baju press body.", 
        '/opencamera'
      );
    } else if (banner['route'] != null) {
      Navigator.pushNamed(context, banner['route']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: Colors.blueAccent,
          backgroundColor: Colors.white,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            children: [
              // Header Section
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

              // Banner Section dengan Auto-Scroll
              SizedBox(
                height: 210,
                child: PageView.builder(
                  controller: _bannerController,
                  itemCount: _banners.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentBannerIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final banner = _banners[index];
                    return buildModernIklan(
                      context,
                      banner['title'],
                      banner['desc'],
                      banner['icon'],
                      banner['color'],
                      onTap: () => _handleBannerAction(banner),
                    );
                  },
                ),
              ),

              // Banner Indicator Dots
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_banners.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentBannerIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentBannerIndex == index 
                            ? Colors.blueAccent 
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
              ),

              // Menu Icons
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

              // Artikel Section
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
                if (articleController.isLoadingHome.value) {
                  return Column(
                    children: List.generate(3, (index) => ArticleCardSkeleton()),
                  );
                }
                
                if (articleController.homeError.value.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                        const SizedBox(height: 12),
                        Text(
                          articleController.homeError.value,
                          style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => articleController.fetchHomeArticles(),
                          icon: const Icon(Icons.refresh),
                          label: const Text("Coba Lagi"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                if (articleController.homeArticles.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.article_outlined, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          "Belum ada artikel tersedia",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: articleController.homeArticles.length,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) {
                    final article = articleController.homeArticles[index];
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
      ),
      bottomNavigationBar: BottomNav(currentIndex: 0),
    );
  }
}