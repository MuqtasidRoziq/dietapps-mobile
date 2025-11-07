import 'package:flutter/material.dart';

Searching(String title){
  return TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50)
      ),
      prefixIcon: Icon(Icons.search_outlined),
      label: Text(title),
    ),
  );
}