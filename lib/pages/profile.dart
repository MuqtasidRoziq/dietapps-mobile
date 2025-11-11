import 'package:diet_apps/components/buttom_navigation.dart';
import 'package:diet_apps/components/card_settings.dart';
import 'package:diet_apps/components/snackbar.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
                        radius: 50,
                        backgroundImage: AssetImage(
                          'assets/images/profile_picture.png',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Muqtasid Roziq",
                        style: TextStyle(
                          fontSize: 20,
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
              onPressed: () {
                Navigator.pushNamed(context, '/');
                ShowAlert(context, "berhasi logout", Colors.green);
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