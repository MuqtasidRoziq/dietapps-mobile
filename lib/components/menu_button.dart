import 'package:flutter/material.dart';

Widget MenuButton({
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onPressed,
}) {
  return Container(
    padding: EdgeInsets.all(20),
    child: Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white, size: 40,),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(20),
            shadowColor: Colors.grey,
            elevation: 5
          ),
        ),
        SizedBox(height: 5,),
        Text(title, style: TextStyle(fontSize: 15),)
      ],
    ),
  );
}
