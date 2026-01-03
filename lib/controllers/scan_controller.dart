import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:diet_apps/config/api.dart';

class ScanController {
  // Ganti dengan URL server Flask kamu
  static const String baseUrl = ConfigApi.baseUrl + "/api/detect/scan";
  Future<Map<String, dynamic>?> uploadScanData({
    required String userId,
    required String gender, // "Laki-laki" atau "Perempuan"
    required double tinggi,
    required double berat,
    required List<String> alergi,
    required List<String> imagePaths, // [0]depan, [1]kanan, [2]kiri
  }) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(baseUrl));

      // 1. Mapping Gender sesuai kebutuhan Flask (pria/wanita)
      String genderMapped = (gender.toLowerCase() == "laki-laki") ? "pria" : "wanita";

      // 2. Tambahkan Field Teks
      request.fields['id'] = userId;
      request.fields['gender'] = genderMapped;
      request.fields['tinggi'] = tinggi.toString();
      request.fields['berat'] = berat.toString();

      // 3. Tambahkan List Alergi (Flask menggunakan getlist)
      for (String item in alergi) {
        request.files.add(http.MultipartFile.fromString('alergi', item));
      }

      // 4. Tambahkan 3 File Gambar sesuai Key di Flask
      request.files.add(await http.MultipartFile.fromPath('foto_depan', imagePaths[0]));
      request.files.add(await http.MultipartFile.fromPath('foto_kanan', imagePaths[1]));
      request.files.add(await http.MultipartFile.fromPath('foto_kiri', imagePaths[2]));

      // 5. Kirim data
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? "Gagal memproses scan");
      }
    } catch (e) {
      print("Error di ScanController: $e");
      rethrow;
    }
  }
}