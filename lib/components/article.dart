import 'package:flutter/material.dart';

Widget ArticleCard(String? img, String title, String date, VoidCallback onPressed) {
  // 1. Pastikan string img tidak null dan tidak kosong/spasi saja
  final String imageUrl = (img == null || img.trim().isEmpty) ? "" : img.trim();

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
        backgroundColor: Colors.white,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImageWidget(imageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(date,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Fungsi pembantu agar kode lebih rapi dan aman
Widget _buildImageWidget(String url) {
  if (url.isEmpty) {
    return Image.asset('assets/images/google_logo.png', width: 60, height: 60, fit: BoxFit.cover);
  }

  // Jika link adalah SVG (seperti data Kompas di DB Anda)
  if (url.contains('.svg')) {
    return Container(
      width: 60, height: 60, color: Colors.grey[200],
      child: const Icon(Icons.article, color: Colors.grey), // Tampilkan icon saja jika SVG
    );
  }

  // Jika link adalah gambar standar (Detik/HelloSehat)
  return Image.network(
    url,
    width: 60, height: 60, fit: BoxFit.cover,
    headers: const {"ngrok-skip-browser-warning": "true"},
    errorBuilder: (context, error, stackTrace) => Image.asset(
      'assets/images/google_logo.png',
      width: 60, height: 60, fit: BoxFit.cover,
    ),
  );
}