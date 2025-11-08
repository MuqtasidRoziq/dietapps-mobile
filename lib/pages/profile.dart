import 'package:diet_apps/components/buttom_navigation.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNav(
        currentIndex: 3
      ),
    );
  }
}