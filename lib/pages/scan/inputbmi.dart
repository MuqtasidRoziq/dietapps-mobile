import 'package:camera/camera.dart';
import 'package:diet_apps/components/snackbar.dart';
import 'package:diet_apps/controllers/scan_controller.dart';
import 'package:diet_apps/controllers/get_user_data.dart'; // Import class GetUserData kamu
import 'package:flutter/material.dart';

class inputbmi extends StatefulWidget {
  const inputbmi({super.key});

  @override
  State<inputbmi> createState() => _inputbmiState();
}

class _inputbmiState extends State<inputbmi> {
  TextEditingController tinggiController = TextEditingController();
  TextEditingController beratController = TextEditingController();
  TextEditingController alergiController = TextEditingController();
  
  final ScanController _scanController = ScanController();
  final GetUserData _userDataService = GetUserData(); // Instance service kamu

  Future<void> _processSubmit(List<XFile> imagePaths) async {
    // 1. Validasi awal
    if (tinggiController.text.isEmpty || beratController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tinggi dan Berat harus diisi!")),
      );
      return;
    }

    // 2. Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 3. AMBIL DATA USER ASLI DARI SERVICE KAMU
      final userData = await _userDataService.getUserData();
      String? userId = userData['id'];
      String? gender = userData['gender'];

      if (userId == null || gender == null) {
        throw Exception("Data User (ID/Gender) tidak ditemukan di Session.");
      }

      // 4. Mapping Alergi (Input teks ke List String)
      List<String> alergiList = alergiController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // 5. KIRIM KE CONTROLLER (Koneksi ke Flask)
      final result = await _scanController.uploadScanData(
        context,
        userId: userId,
        gender: gender, // Akan di-map di controller (Laki-laki -> pria)
        tinggi: double.parse(tinggiController.text),
        berat: double.parse(beratController.text),
        alergi: alergiList,
        images: imagePaths,
      );

      if (!mounted) return;
      Navigator.pop(context); 

      if (result != null && result['status'] == 'success') {
        ShowAlert(context, "Analisis Berhasil!", Colors.green, 2);
        Navigator.pushReplacementNamed(
          context, 
          '/result-scan', 
          arguments: result['data']
        );
      } else {
        print("Proses gagal atau terjadi kesalahan di server");
      }

    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tangkap file dari halaman kamera
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    final List<XFile> capturedImages = args is List<XFile> ? args : [];

    return Scaffold(
      appBar: AppBar(title: const Text("Analisis Postur & BMI")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _label("Tinggi Badan (cm)"),
                    TextField(
                      controller: tinggiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Masukan Tinggi Badan (Cm)",
                        border: OutlineInputBorder()
                        ),
                    ),
                    const SizedBox(height: 15),
                    _label("Berat Badan (kg)"),
                    TextField(
                      controller: beratController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Masukan Berat Badan (Kg)",
                        border: OutlineInputBorder()
                        ),
                    ),
                    const SizedBox(height: 15),
                    _label("Alergi Makanan (opsional)"),
                    TextField(
                      controller: alergiController,
                      decoration: const InputDecoration(
                        hintText: "Contoh: Udang, Telur",
                        border: OutlineInputBorder()
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      // PANGGIL FUNGSI SUBMIT ASLI
                      onPressed: () => _processSubmit(capturedImages),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Kirim & Analisis", style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _label(String txt) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(txt, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}