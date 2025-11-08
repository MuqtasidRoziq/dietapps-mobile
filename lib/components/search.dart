import 'package:flutter/material.dart';

Widget Searching(
  String title,
  VoidCallback onPressed,
) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: title,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.search_sharp, color: Colors.black, size: 30,),
          ),
        ],
      ),
    ),
  );
}
