import 'package:diet_apps/components/category_button.dart';
import 'package:diet_apps/components/recomend_section.dart';
import 'package:flutter/material.dart';

class RePolahidup extends StatefulWidget {
  const RePolahidup({super.key});

  @override
  State<RePolahidup> createState() => _RePolahidupState();
}

class _RePolahidupState extends State<RePolahidup> {
  String selectedCategory = "Makanan";

  final Map<String, List<Map<String, String>>> recommendations = {
    "Makanan": [
      {
        "title": "Sarapan",
        "image": "assets/images/sarapan.png",
        "desc": "Konsumsi oatmeal dan buah segar",
      },
      {
        "title": "Makan Siang",
        "image": "assets/images/sarapan.png",
        "desc": "Pilih nasi merah dan lauk protein",
      },
      {
        "title": "Makan Malam",
        "image": "assets/images/sarapan.png",
        "desc": "Kurangi karbohidrat, perbanyak sayur",
      },
    ],
    "Olahraga": [
      {
        "title": "Jogging Pagi",
        "image": "assets/images/run_iklan.png",
        "desc": "Minimal 30 menit jalan cepat",
      },
      {
        "title": "Stretching",
        "image": "assets/images/run_iklan.png",
        "desc": "Peregangan otot ringan",
      },
    ],
    "Tidur": [
      {
        "title": "Waktu Tidur Ideal",
        "image": "assets/images/run_iklan.png",
        "desc": "Tidur cukup 7-8 jam per malam",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Rekomendasi Pola Hidup",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          CategoryBar(
            categories: ["Makanan", "Olahraga", "Tidur"],
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: (recommendations[selectedCategory] ?? [])
                  .map((item) => RekomendasiCard(
                        title: item["title"]!,
                        imagePath: item["image"]!,
                        description: item["desc"]!,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
