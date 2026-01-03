import 'dart:io';
import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  final String imagePath;
  final int photoNumber; // Untuk tahu ini foto ke-1, 2, atau 3

  const PreviewPage({super.key, required this.imagePath, required this.photoNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hasil Foto Ke-$photoNumber")),
      body: Column(
        children: [
          Expanded(
            child: Image.file(File(imagePath), fit: BoxFit.contain),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol Ulangi
                ElevatedButton(
                  onPressed: () => Navigator.pop(context), 
                  child: const Text("Ulangi"),
                ),
                // Tombol Lanjut
                ElevatedButton(
                  onPressed: () {
                    if (photoNumber < 3) {
                      // Kembali ke kamera untuk foto berikutnya
                      Navigator.pushReplacementNamed(context, '/camera');
                    } else {
                      // Sudah 3 foto, lanjut ke proses BMI/Analisis
                      Navigator.pushReplacementNamed(context, '/inputbmi');
                    }
                  },
                  child: Text(photoNumber < 3 ? "Lanjut Foto Berikutnya" : "Selesai & Analisis"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}