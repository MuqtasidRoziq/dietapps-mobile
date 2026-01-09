import 'package:diet_apps/components/buttom_navigation.dart';
import 'package:diet_apps/components/card_settings.dart';
import 'package:diet_apps/controllers/auth/logout.dart';
import 'package:diet_apps/controllers/get_user_data.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GetUserData getUserDataController = GetUserData();
  final logoutController = logout;

  String? photo;
  String fullname = "Guest";

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
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Positioned(
                  top: 130,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 65,
                      backgroundImage: (photo != null && photo!.isNotEmpty)
                          ? NetworkImage(
                              photo!,
                              headers: const {"ngrok-skip-browser-warning": "true"},
                            )
                          : null,
                      child: (photo == null || photo!.isEmpty)
                          ? const Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 65),

            Text(
              fullname,
              style: const TextStyle(
                fontSize: 28,
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 30),

            // --- MENU CARD ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    buildFancyMenu(Icons.edit_note_rounded, "Edit Profil", Colors.orange, () async {
                      final result = await Navigator.pushNamed(context, '/editprofil');
                      if (result == true) _loadData();
                    }),
                    divider(),
                    buildFancyMenu(Icons.lock_reset_rounded, "Ubah Password", Colors.blue, () {
                      Navigator.pushNamed(context, '/ubahpass');
                    }),
                    divider(),
                    buildFancyMenu(Icons.history_rounded, "Riwayat Aktivitas", Colors.green, () {
                      Navigator.pushNamed(context, '/history');
                    }),
                    divider(),
                    buildFancyMenu(Icons.info_outlined, "Info Aplikasi", Colors.purple, () {
                      Navigator.pushNamed(context, '/infoapps');
                    }),
                    divider(),
                    buildFancyMenu(Icons.feedback_outlined, "Feedback", Colors.purple, () {
                      Navigator.pushNamed(context, '/feedback');
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- SIGN OUT BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await logoutController(context);
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: const Text(
                    "Keluar",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 3),
    );
  }

  // Widget Pembantu untuk Item Menu agar lebih rapi
  // Widget _buildFancyMenu(IconData icon, String title, Color color, VoidCallback onTap) {
  //   return ListTile(
  //     onTap: onTap,
  //     leading: Container(
  //       padding: const EdgeInsets.all(8),
  //       decoration: BoxDecoration(
  //         color: color.withOpacity(0.1),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Icon(icon, color: color),
  //     ),
  //     title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
  //     trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
  //   );
  // }

}