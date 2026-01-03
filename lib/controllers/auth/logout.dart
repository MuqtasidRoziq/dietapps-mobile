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
    // 1. Cek apakah ada sesi Google yang aktif, jika ada keluarkan
    // Ini tidak akan error meskipun user login dengan metode biasa
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
      // Opsional: Jika ingin benar-benar memutus koneksi akun dari aplikasi
      // await _googleSignIn.disconnect(); 
    }

    // 2. Hapus Token JWT (Kunci utama akses ke Backend Flask)
    // Baik login biasa maupun google, keduanya menyimpan token di sini
    await storage.delete(key: 'jwt_token');

    // 3. Hapus data profil user di SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('fullname');
    await prefs.remove('photo');
    // Atau gunakan await prefs.clear(); untuk menghapus semuanya

    // 4. Reset navigasi ke halaman Login
    // (route) => false artinya user tidak bisa menekan tombol 'back' untuk kembali ke aplikasi
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

    ShowAlert(context, "Anda telah keluar", Colors.blue, 2);
  } catch (e) {
    print("Error Logout: $e");
    ShowAlert(context, "Terjadi kesalahan saat logout", Colors.red, 3);
  }
}