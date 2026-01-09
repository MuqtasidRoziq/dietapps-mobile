import 'package:flutter/material.dart';

Widget Searching(String hint, Function(String) onChanged) {
  return TextField(
    onChanged: onChanged, // Ini yang mengirim data ke controller
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}