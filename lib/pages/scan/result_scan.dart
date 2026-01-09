import 'package:flutter/material.dart';

class ResultScan extends StatelessWidget {
  const ResultScan({super.key});

  // Fungsi helper untuk menentukan warna berdasarkan status
  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'IDEAL':
        return Colors.green;
      case 'OVERWEIGHT':
        return Colors.redAccent;
      case 'UNDERWEIGHT':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Tangkap data dari Navigator arguments
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    
    // Ambil data posture dari response Flask
    // Struktur JSON Flask: {"bmi": 22.5, "posture": {"perut": "IDEAL", ...}, "rekomendasi": {...}}
    final Map<String, dynamic> posture = args['posture'] ?? {};
    final String bmi = args['bmi']?.toString() ?? "-";

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Hasil Analisis"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Prediksi Postur Tubuh",
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 24,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "BMI Anda: $bmi",
              style: const TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.w600),
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
                  // 2. Hubungkan data ke widget Row
                  buildResultRow(
                    Icons.accessibility_new, 
                    "Lengan", 
                    posture['lengan'] ?? "Tidak Terdeteksi", 
                    _getStatusColor(posture['lengan'])
                  ),
                  const Divider(height: 30),
                  buildResultRow(
                    Icons.fitness_center, 
                    "Perut", 
                    posture['perut'] ?? "Tidak Terdeteksi", 
                    _getStatusColor(posture['perut'])
                  ),
                  const Divider(height: 30),
                  buildResultRow(
                    Icons.airline_seat_legroom_extra, 
                    "Paha", 
                    posture['paha'] ?? "Tidak Terdeteksi", 
                    _getStatusColor(posture['paha'])
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Kirim data rekomendasi ke halaman berikutnya
                  Navigator.pushReplacementNamed(
                    context, 
                    '/rekomen-pola-hidup', 
                    arguments: args['rekomendasi']
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

  // Widget Row (Pastikan ini ada di bawah atau di file komponen terpisah)
  Widget buildResultRow(IconData icon, String label, String status, Color color) {
    return Row(
      children: [
        Icon(icon, size: 30, color: Colors.blueGrey),
        const SizedBox(width: 20),
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            status,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}