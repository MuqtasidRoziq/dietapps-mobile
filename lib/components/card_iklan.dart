import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildModernIklan(
  BuildContext context, 
  String title, 
  String desc, 
  IconData icon, 
  Color bgColor,
  {String? route, VoidCallback? onTap}
) {
  double screenWidth = MediaQuery.of(context).size.width;
  
  // Tentukan warna icon berdasarkan warna background
  Color iconColor;
  if (bgColor == const Color(0xFFE3F2FD)) {
    // Biru muda -> icon biru tua
    iconColor = Colors.blue.shade300.withOpacity(0.4);
  } else if (bgColor == const Color(0xFFE8F5E9)) {
    // Hijau muda -> icon hijau tua
    iconColor = Colors.green.shade300.withOpacity(0.4);
  } else if (bgColor == const Color(0xFFFFF3E0)) {
    // Orange muda -> icon orange tua
    iconColor = Colors.orange.shade300.withOpacity(0.4);
  } else if (bgColor == const Color(0xFFF3E5F5)) {
    // Ungu muda -> icon ungu tua
    iconColor = Colors.purple.shade300.withOpacity(0.4);
  } else {
    iconColor = Colors.grey.shade300;
  }
  
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Container(
      width: screenWidth,
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
                Text(
                  title, 
                  style: const TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: (screenWidth - 80) * 0.5,
                  child: Text(
                    desc, 
                    style: const TextStyle(
                      fontSize: 13, 
                      color: Colors.black54
                    ), 
                    maxLines: 3
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (onTap != null) {
                      onTap();
                    } else if (route != null && route.isNotEmpty) {
                      Navigator.pushNamed(context, route);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  child: const Text(
                    "Detail", 
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Icon(
              icon,
              size: 110,
              color: iconColor, // Warna yang sudah disesuaikan
            ),
          )
        ],
      ),
    ),
  );
}