import 'package:diet_apps/components/snackbar.dart';
import 'package:diet_apps/config/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storage = const FlutterSecureStorage();
final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: ConfigApi.serverClientId,
    scopes: [
      'email',
      'profile',
      'openid',
    ],
  );

Future<void> logout(BuildContext context) async {
  try {
    // 1. Bersihkan Google Sign In dengan proteksi try-catch
    try {
      // Hanya jalankan jika library terdeteksi aktif
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (googleError) {
      print("Google Sign Out skipped/error: $googleError");
    }

    // 2. Hapus Token JWT
    await storage.deleteAll(); // Gunakan deleteAll untuk keamanan extra

    // 3. Hapus SEMUA data lokal (PENTING untuk masalah foto tertukar)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 

    // 4. Navigasi & Bersihkan History
    if (context.mounted) {
      // Gunakan pushNamedAndRemoveUntil agar user tidak bisa klik 'Back' ke profile
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      ShowAlert(context, "Anda telah keluar", Colors.blue, 2);
    }
  } catch (e) {
    print("Error Logout Utama: $e");
    // Tetap paksa pindah ke login jika error berat
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}