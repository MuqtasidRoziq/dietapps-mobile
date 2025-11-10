import 'dart:math';

import 'package:flutter/material.dart';

class RePolahidup extends StatefulWidget {
  const RePolahidup({super.key});

  @override
  State<RePolahidup> createState() => _RePolahidupState();
}

class _RePolahidupState extends State<RePolahidup> {
    String selectedCategory = "Makanan";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Rekomendasi pola hidup",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),   
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
              
                  ],
            ),
            ),
            Expanded(child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                
                ),
            ))
        ],
      ),
    );
  }
  Widget buildCategoryButton(String title) {
    bool isSelected = selectedCategory == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.green[800] : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}