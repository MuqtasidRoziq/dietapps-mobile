import 'package:diet_apps/config/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackController extends GetxController {
  var isLoading = false.obs;

  Future<bool> sendFeedback(int rating, String message) async {
    try {
      isLoading(true);
      
      final response = await http.post(
        Uri.parse('${ConfigApi.baseUrl}/api/feedback'),
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true", // Penting untuk Mobile/Web via Ngrok
        },
        body: jsonEncode({
          "rating": rating,
          "message": message,
        }),
      );

      if (response.statusCode == 201) {
        Get.snackbar("Sukses", "Terima kasih atas masukan Anda!");
        return true;
      } else {
        Get.snackbar("Gagal", "Terjadi kesalahan pada server");
        return false;
      }
    } catch (e) {
      print("Error feedback: $e");
      Get.snackbar("Error", "Gagal terhubung ke server");
      return false;
    } finally {
      isLoading(false);
    }
  }
}