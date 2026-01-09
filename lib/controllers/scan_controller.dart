import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:diet_apps/config/api.dart';
import 'package:http_parser/http_parser.dart';
import 'package:diet_apps/components/snackbar.dart';

class ScanController {
  static const String baseUrl = "${ConfigApi.baseUrl}/api/detect/scan";

  Future<Map<String, dynamic>?> uploadScanData(
    BuildContext context, {
    required String userId,
    required String gender,
    required double tinggi,
    required double berat,
    required List<String> alergi,
    required List<XFile> images,
  }) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(baseUrl));

      // Header wajib untuk Ngrok dan JSON response
      request.headers.addAll({
        'ngrok-skip-browser-warning': 'true',
        'Accept': 'application/json',
      });

      String genderMapped = gender;

      request.fields['id'] = userId;
      request.fields['gender'] = genderMapped;
      request.fields['tinggi'] = tinggi.toString();
      request.fields['berat'] = berat.toString();

      for (String item in alergi) {
        request.fields['alergi'] = item; 
      }

      // 4. Tambahkan 3 File Gambar sesuai Key di Flask
      // Pastikan urutan images di UI sesuai: [0]Depan, [1]Kanan, [2]Kiri
      List<String> keys = ['foto_depan', 'foto_kanan', 'foto_kiri'];
      for (int i = 0; i < images.length; i++) {
        if (i >= keys.length) break; // Safety check
        
        Uint8List bytes = await images[i].readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            keys[i],
            bytes,
            filename: '${keys[i]}_${userId}.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      // 5. Kirim data dengan timeout (karena proses AI MediaPipe butuh waktu)
      var streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      var response = await http.Response.fromStream(streamedResponse);

      // Print untuk debug, lihat apa yang dikirim server
      print("Response Body: ${response.body}");

      final decodedResponse = jsonDecode(response.body);

      // PERBAIKAN: Cek status code 200 ATAU status == 'success'
      if (response.statusCode == 200 || decodedResponse['status'] == 'success') {
        return decodedResponse;
      } else {
        String msg = decodedResponse['message'] ?? "Gagal memproses data";
        ShowAlert(context, msg, Colors.red, 3);
        return null;
      }
    } catch (e) {
      print("Error di ScanController: $e");
      ShowAlert(context, "Terjadi kesalahan koneksi ke server", Colors.red, 3);
      return null;
    }
  }
}