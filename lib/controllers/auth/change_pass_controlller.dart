import 'dart:convert';
import 'package:diet_apps/config/api.dart';
import 'package:flutter/material.dart';
import 'package:diet_apps/components/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UbahPassController {
  Future<void> updatePassword(
    BuildContext context, {
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    required Function(bool) setLoading,
  }) async {
    // 1. Validasi Input
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ShowAlert(context, "Semua field harus diisi", Colors.orange, 3);
      return;
    }

    if (newPassword != confirmPassword) {
      ShowAlert(context, "Konfirmasi password baru tidak cocok", Colors.red, 3);
      return;
    }

    setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      final url = Uri.parse("${ConfigApi.baseUrl}/api/auth/change-password");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Mengirimkan JWT token
        },
        body: jsonEncode({
          "old_password": oldPassword,
          "new_password": newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        ShowAlert(context, "Berhasil merubah password", Colors.green, 2);
        Navigator.pop(context); // Kembali ke profil
      } else {
        ShowAlert(context, data["message"] ?? "Gagal mengubah password", Colors.red, 4);
      }
    } catch (e) {
      ShowAlert(context, "Kesalahan koneksi: $e", Colors.red, 4);
    } finally {
      setLoading(false);
    }
  }
}