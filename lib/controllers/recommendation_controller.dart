import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:diet_apps/config/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecommendationController {

  static final storage = const FlutterSecureStorage();
  static const String _keyChecklist = 'checklist_status'; 
  static const String _keyAlarms = 'alarm_times';
  // Fungsi untuk menyimpan Map checklist ke Shared Preferences
  static Future<void> saveChecklist(Map<String, bool> status) async {
    final prefs = await SharedPreferences.getInstance();
    // Konversi Map ke String JSON agar bisa disimpan
    await prefs.setString(_keyChecklist, jsonEncode(status));
  }

  // Fungsi untuk mengambil Map checklist yang tersimpan
  static Future<Map<String, bool>> getChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyChecklist);
    if (data != null) {
      Map<String, dynamic> decoded = jsonDecode(data);
      // Casting kembali dari dynamic ke bool
      return decoded.map((key, value) => MapEntry(key, value as bool));
    }
    return {}; // Return map kosong jika belum ada data
  }

  static Future<Map<String, dynamic>?> getData(BuildContext context) async {
    // 1. Cek Lokal dulu biar cepat (User Experience)
    Map<String, dynamic>? local = await getFromLocal();
    if (local != null && (local['makanan'] as List).isNotEmpty) {
      print("Controller: Pakai data lokal");
      return local;
    }

    print("Controller: Lokal kosong, panggil endpoint API...");
    return await fetchLatestData(context);
  }

  static Future<void> saveAlarmTime(String id, String time) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> alarms = await getAlarms();
    alarms[id] = time;
    await prefs.setString(_keyAlarms, jsonEncode(alarms));
  }

  static Future<Map<String, String>> getAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyAlarms);
    if (data != null) {
      return Map<String, String>.from(jsonDecode(data));
    }
    return {};
  }
  // Tambahkan di dalam class RecommendationController
  static Future<void> deleteAlarmTime(String id) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> alarms = await getAlarms();
    alarms.remove(id); // Menghapus ID alarm tertentu
    await prefs.setString(_keyAlarms, jsonEncode(alarms));
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
        // result['data'] adalah hasil dari fungsi get_latest_recommendation() di Flask
        await saveToLocal(result['data']); 
        return result['data'];
      }
    } catch (e) {
      print("Error memanggil endpoint: $e");
    }
    return null;
  }

  static Future<void> saveToLocal(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_recom', jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    String? localData = prefs.getString('last_recom');
    if (localData != null) return jsonDecode(localData);
    return null;
  }
}