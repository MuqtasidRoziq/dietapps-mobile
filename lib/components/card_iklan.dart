import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildModernIklan(BuildContext context, String title, String desc, String img, Color bgColor) {
  double screenWidth = MediaQuery.of(context).size.width;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Memberi jarak agar card tidak nempel pinggir
    child: Container(
      width: screenWidth, // Otomatis memenuhi lebar layar
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  width: (screenWidth - 80) * 0.5, // Menyesuaikan lebar teks agar tidak nabrak gambar
                  child: Text(desc, style: const TextStyle(fontSize: 13, color: Colors.black54), maxLines: 3),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Detail", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Image.asset(img, height: 140),
          )
        ],
      ),
    ),
  );
}