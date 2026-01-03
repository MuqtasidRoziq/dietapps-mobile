import 'package:diet_apps/components/buttom_navigation.dart';
import 'package:diet_apps/components/card_settings.dart';
import 'package:diet_apps/components/snackbar.dart';
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
        photo = data['photo'];
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        radius: 55,
                        backgroundImage: (photo != null && photo!.isNotEmpty) 
                            ? NetworkImage(photo!) 
                            : null,
                          child: (photo == null || photo!.isEmpty) 
                            ? const Icon(Icons.person, color: Colors.white) 
                            : null,
                      ),
                      SizedBox(height: 10),
                      Text(
                        fullname,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            menuCard([
              menuItem(context, Icons.edit, "Edit Profil", (){ Navigator.pushNamed(context, '/editprofil'); }),
              menuItem(context, Icons.password, "change password", (){ Navigator.pushNamed(context, '/ubahpass');}),
            ]),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async{
                await logoutController;
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/login');
                ShowAlert(context, "berhasi logout", Colors.green, 2);
              },
              icon: Icon(Icons.logout, color: Colors.white),
              label: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF4EAAA7,
                ), // warna hijau kebiruan
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10,)
          ],
          
        ),

      bottomNavigationBar: BottomNav(currentIndex: 3),
    );
  }
}