import 'dart:convert';
import 'package:diet_apps/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:diet_apps/config/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecommendationController {
  static final storage = const FlutterSecureStorage();
  
  // Keys untuk SharedPreferences
  static const String _keyChecklist = 'checklist_status';
  static const String _keyAlarms = 'alarm_times';
  static const String _keyLocalData = 'last_recom';

  // --- 1. MANAJEMEN CHECKLIST ---
  static Future<void> saveChecklist(Map<String, bool> status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyChecklist, jsonEncode(status));
  }

  static Future<Map<String, bool>> getChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyChecklist);
    if (data != null) {
      Map<String, dynamic> decoded = jsonDecode(data);
      return decoded.map((key, value) => MapEntry(key, value as bool));
    }
    return {};
  }

  // --- 2. MANAJEMEN ALARM & NOTIFIKASI ---
  static Future<void> saveAlarmTime(String id, String title, String time) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Simpan jam ke SharedPreferences
    Map<String, String> alarms = await getAlarms();
    alarms[id] = time;
    await prefs.setString(_keyAlarms, jsonEncode(alarms));

    // 2. Buat objek scheduleDate agar bisa diakses oleh proses berikutnya
    final now = DateTime.now();
    final parts = time.split(':');
    var scheduleDate = DateTime(
      now.year, now.month, now.day, 
      int.parse(parts[0]), int.parse(parts[1])
    );

    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    await NotifService.requestExactAlarmPermission(); 
  
    Future.delayed(const Duration(milliseconds: 800), () async {
      try {
        int notifId = id.hashCode.abs();
        
        await NotifService.scheduleNotif(
          notifId, 
          "Waktunya $title!", 
          "Ayo jalankan pola hidup sehatmu sekarang.", 
          scheduleDate
        );
        print("Alarm berhasil dijadwalkan untuk: $scheduleDate");
      } catch (e) {
        print("Gagal menjadwalkan notifikasi dalam delay: $e");
      }
    });
  }

  static Future<Map<String, String>> getAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyAlarms);
    if (data != null) {
      return Map<String, String>.from(jsonDecode(data));
    }
    return {};
  }

  /// Menghapus jam alarm dan membatalkan notifikasi yang sudah terjadwal
  static Future<void> deleteAlarmTime(String id) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> alarms = await getAlarms();
    alarms.remove(id);
    await prefs.setString(_keyAlarms, jsonEncode(alarms));

    // Batalkan notifikasi di sistem menggunakan ID yang sama (hash)
    await NotifService.cancelNotification(id.hashCode.abs());
  }

  // --- 3. MANAJEMEN DATA API & LOKAL (DENGAN SECURITY JWT) ---

  static Future<Map<String, dynamic>?> getData(BuildContext context) async {
    // Cek data di lokal yang sudah diamankan JWT
    Map<String, dynamic>? local = await getFromLocal();
    if (local != null && (local['makanan'] as List).isNotEmpty) {
      return local;
    }
    // Jika lokal kosong atau tidak valid, ambil dari server
    return await fetchLatestData(context);
  }

  static Future<Map<String, dynamic>?> fetchLatestData(BuildContext context) async {
    try {
      String? token = await storage.read(key: 'jwt_token');
      final response = await http.get(
        Uri.parse("${ConfigApi.baseUrl}/api/latest_recommendation"),
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        // Simpan ke lokal dengan pengaman JWT
        await saveToLocal(result['data']); 
        return result['data'];
      }
    } catch (e) {
      print("Error API Recommendation: $e");
    }
    return null;
  }

  /// Menyimpan data dengan mengikatnya ke hash JWT Token saat ini
  static Future<void> saveToLocal(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = await storage.read(key: 'jwt_token');
    
    // 1. Simpan data seperti biasa (Sesuai instruksi JWT Lock kamu)
    Map<String, dynamic> securedData = {
      'jwt_signature': token.hashCode, 
      'payload': data,
    };
    await prefs.setString(_keyLocalData, jsonEncode(securedData));

    // 2. LOGIKA OTOMATIS: Jadwalkan notifikasi untuk item yang belum diceklist
    Map<String, bool> currentChecklist = await getChecklist();
    
    // Loop data makanan/olahraga dari API
    data.forEach((category, items) {
      if (items is List) {
        for (var item in items) {
          String id = "${category}_${item['nama'] ?? item['gerakan']}";
          
          // JIKA BELUM DICEKLIST, buatkan notifikasi otomatis pada jam rekomendasi
          if (currentChecklist[id] != true) {
            _scheduleAutomaticNotif(id, item['nama'] ?? item['gerakan'], item['jam']);
          }
        }
      }
    });
  }

  // Fungsi pembantu untuk parsing jam dari API (misal "08:00 - 09:00")
  static Future<void> _scheduleAutomaticNotif(
    String id,
    String title,
    String rawTime,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final autoKey = "auto_notif_$id";

    // ❌ Jangan jadwalkan ulang jika sudah pernah
    if (prefs.getBool(autoKey) == true) return;

    try {
      String startTime = rawTime.split(' - ')[0];
      final now = DateTime.now();
      final parts = startTime.split(':');

      DateTime scheduleDate = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      if (scheduleDate.isBefore(now)) {
        scheduleDate = scheduleDate.add(const Duration(days: 1));
      }

      await NotifService.scheduleNotif(
        ("AUTO_$id").hashCode.abs(),
        "Rekomendasi: $title",
        "Kamu belum melakukan ini, yuk mulai!",
        scheduleDate,
      );

      await prefs.setBool(autoKey, true);
    } catch (e) {
      print("Gagal auto notif: $e");
    }
  }

  /// Mengambil data lokal dan memverifikasi apakah masih milik user yang sama (JWT check)
  static Future<Map<String, dynamic>?> getFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    String? rawJson = prefs.getString(_keyLocalData);
    if (rawJson == null) return null;

    Map<String, dynamic> decoded = jsonDecode(rawJson);
    String? currentToken = await storage.read(key: 'jwt_token');

    // Jika hash token berubah (misal logout lalu login akun lain), anggap data expired
    if (decoded['jwt_signature'] != currentToken.hashCode) {
      print("Security: Token mismatch, menghapus cache lama.");
      await prefs.remove(_keyLocalData);
      return null;
    }

    return decoded['payload'];
  }

  static Future<bool> checkAutoLogin() async {
    String? token = await storage.read(key: 'jwt_token');
    if (token == null) return false;

    // Sesuai permintaanmu: Pastikan shared_preferences punya record yang valid
    final prefs = await SharedPreferences.getInstance();
    String? lastRecom = prefs.getString('last_recom');
    
    return lastRecom != null;
  }
}