import 'package:flutter/material.dart';

Widget MenuButton({
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onPressed,
}) {
  return Container(
    margin: EdgeInsets.all(10),
    height: 100,
    width: 200,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 40,),
      label: Text(title, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  );
}
