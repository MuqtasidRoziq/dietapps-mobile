import 'package:diet_apps/components/buttom_navigation.dart';
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(currentIndex: 3),
    );
  }
}