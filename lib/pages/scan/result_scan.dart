import 'package:flutter/material.dart';
import 'package:diet_apps/components/result-predict.dart';

class ResultScan extends StatelessWidget {
  const ResultScan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Prediksi Postur Tubuh",
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 24,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 20),
            
            // Card Hasil Analisis
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  buildResultRow(Icons.accessibility_new, "Lengan", "Overweight", Colors.orange),
                  const Divider(height: 30),
                  buildResultRow(Icons.fitness_center, "Perut", "Overweight", Colors.redAccent),
                  const Divider(height: 30),
                  buildResultRow(Icons.airline_seat_legroom_extra, "Paha", "Overweight", Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/rekomen-pola-hidup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Lihat Rekomendasi Pola Hidup",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}