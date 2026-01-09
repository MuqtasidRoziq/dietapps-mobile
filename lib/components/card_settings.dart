import 'dart:ui';
import 'package:flutter/material.dart';

Widget buildFancyMenu(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
    );
  }

Widget divider() {
  return Divider(height: 1, indent: 70, endIndent: 20, color: Colors.grey[100]);
}