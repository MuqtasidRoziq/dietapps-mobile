import 'dart:convert';
import 'package:diet_apps/config/api.dart';
import 'package:flutter/material.dart';
import 'package:diet_apps/components/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController {
  Future<void> register(
    BuildContext context, {
    required String fullname,
    required String email,
    required String password,
    required String confirmPassword,
    required String jenisKelamin,
    required Function(bool) setLoading,
  }) async {
    // 1. Validasi Input
    if (fullname.isEmpty || email.isEmpty || jenisKelamin.isEmpty) {
      ShowAlert(context, "Semua field harus diisi", Colors.orange, 3);
      return;
    }

    if (password != confirmPassword) {
      ShowAlert(context, "Password tidak sama", Colors.red, 3);
      return;
    }

    setLoading(true);

    try {
      final url = Uri.parse("${ConfigApi.baseUrl}/api/auth/register");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullname": fullname,
          "jenis_kelamin": jenisKelamin,
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        // --- SIMPAN JWT TOKEN KE SHARED PREFERENCES ---
        if (data["token"] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', data["token"]);
        }

        ShowAlert(context, data["message"], Colors.green, 2);
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ShowAlert(context, data["message"] ?? "Gagal Registrasi", Colors.red, 5);
      }
    } catch (e) {
      ShowAlert(context, "Kesalahan Server: $e", Colors.red, 5);
    } finally {
      setLoading(false);
    }
  }
}