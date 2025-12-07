import 'package:diet_apps/components/snackbar.dart';
import 'package:flutter/material.dart';

class RekomendasiCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final String description;

  const RekomendasiCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
  });

  @override
  State<RekomendasiCard> createState() => _RekomendasiCardState();
}

class _RekomendasiCardState extends State<RekomendasiCard> {
  bool done = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: done ? Colors.green[50] : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Gambar makanan/aktivitas
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                widget.imagePath,
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(width: 12),

            // Teks rekomendasi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(widget.description,
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),

                  // Tombol “Sudah dilakukan”
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        done = !done;
                        done? ShowAlert(context, "Anda Sudah Melakukan "+widget.title, Colors.green, 2): null;
                      });
                    },
                    icon: Icon(done ? Icons.check : Icons.access_time),
                    label: Text(done ? "Sudah dilakukan" : "Belum dilakukan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: done ? Colors.green : Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
