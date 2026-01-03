import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diet_apps/config/api.dart';
import 'package:diet_apps/components/snackbar.dart';

class LoginController {

  final storage = const FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: ConfigApi.serverClientId,
    scopes: [
      'email',
      'profile',
      'openid',
    ],
  );

  Future<void> login(
    BuildContext context,
    String email, 
    String password,
    Function(bool) isLoading
    ) async {
       isLoading(true);

    try {
      final url = Uri.parse("${ConfigApi.baseUrl}/api/auth/login");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      print("Status Code: ${response.statusCode}");
      print("Data Raw: ${response.body}");

      if (response.statusCode == 200 && data["success"] == true) {
        await storage.write(key: 'jwt_token', value: data["access_token"]);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', data["users"]["email"]);
        await prefs.setString('fullname', data["users"]["fullname"]);
        await prefs.setString('photo', data["users"]["photo"] ?? "");
        
        ShowAlert(context, data["message"], Colors.green, 2);
        Navigator.pushReplacementNamed(context, '/homepage');
      } else {
        ShowAlert(context, data["message"] ?? "Login Gagal", Colors.red, 5);
      }
    } catch (e) {
      ShowAlert(context, "Terjadi kesalahan koneksi", Colors.red, 5);
      print("Error during login: $e");
    } finally {
      isLoading(false);
    }
  }


  Future<void> signInWithGoogle(BuildContext context, Function(bool) isLoading) async {
    isLoading(true);
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        isLoading(false);
        return; // User membatalkan login
      }

      // 2. Ambil Auth
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      

      // 3. Kirim ke Backend
      final response = await http.post(
        Uri.parse("${ConfigApi.baseUrl}/api/auth/login/google"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': googleAuth.idToken}),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        // Simpan token
        await storage.write(key: 'jwt_token', value: data["access_token"]);

        // Simpan data user ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('id', data["users"]["id"].toString());
        await prefs.setString('fullname', data["users"]["fullname"]);
        await prefs.setString('gender', data["users"]["jenis_kelamin"] ?? "");
        await prefs.setString('email', data["users"]["email"]);
        await prefs.setString('photo', data["users"]["photo"] ?? "");

        ShowAlert(context, "Login Google Berhasil", Colors.green, 2);
        Navigator.pushReplacementNamed(context, '/homepage');
      } else {
        ShowAlert(context, data["message"] ?? "Gagal Login Google", Colors.red, 5);
      }
    } catch (error) {
      print("Error Google Login: $error");
      ShowAlert(context, "Terjadi kesalahan koneksi Google", Colors.red, 5);
    } finally {
      isLoading(false);
    }
  }
}