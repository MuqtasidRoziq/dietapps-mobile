import 'package:diet_apps/config/api.dart';
import 'package:flutter/material.dart'; // Tambahkan ini untuk SnackBar
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diet_apps/components/snackbar.dart';

class FeedbackController extends GetxController {
  var isLoading = false.obs;
  final storage = const FlutterSecureStorage();
  Future<bool> sendFeedback(BuildContext context, String comment) async {
    isLoading.value = true;
    try {
      String? token = await storage.read(key: 'jwt_token');
      final url = Uri.parse('${ConfigApi.baseUrl}/api/feedback');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'comment': comment}),
      );

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        ShowAlert(context, responseData['message'] ?? "Ulasan berhasil dikirim", Colors.green, 2);
        Navigator.pop(context);
        return true;
      } else {
        ShowAlert(context, responseData['message'] ?? "Gagal mengirim", Colors.red, 2);
        return false;
      }
    } catch (e) {
      ShowAlert(context, "Koneksi gagal: $e", Colors.orange, 2);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}