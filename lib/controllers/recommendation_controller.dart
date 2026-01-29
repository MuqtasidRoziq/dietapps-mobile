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
  static const String _keyScheduledReminders = 'scheduled_reminders';

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
  
  static Future<Map<String, String>> getAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyAlarms);
    if (data != null) {
      Map<String, dynamic> decoded = jsonDecode(data);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    }
    return {};
  }

  static Future<void> saveAlarmTime(
    String id,
    String title,
    String time,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan ke map alarm
    Map<String, String> alarms = await getAlarms();
    alarms[id] = time;
    await prefs.setString(_keyAlarms, jsonEncode(alarms));

    final now = DateTime.now();
    final parts = time.split(':');

    if (parts.length != 2) {
      debugPrint('❌ Invalid time format: $time');
      return;
    }

    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    
    // Buat DateTime untuk alarm
    DateTime scheduleDate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      0,
    );

    // Jika waktu sudah lewat, jadwalkan untuk besok
    if (scheduleDate.isBefore(now) || scheduleDate.difference(now).inSeconds < 30) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
      debugPrint('⏭️ Time is in the past, scheduling for tomorrow: $scheduleDate');
    }
    
    debugPrint('''
📅 Alarm Time Details:
  • User selected time: $time
  • Parsed hour: $hour, minute: $minute
  • Now: $now
  • Schedule date: $scheduleDate
  • Difference: ${scheduleDate.difference(now).inMinutes} minutes
  • Is schedule in future? ${scheduleDate.isAfter(now)}
''');
    
    // Generate unique IDs
    int alarmId = id.hashCode.abs();
    int reminderId = ('${id}_reminder').hashCode.abs();

    // Cancel existing notifications
    await NotifService.cancelNotification(alarmId);
    await NotifService.cancelNotification(reminderId);

    // Jadwalkan alarm (waktu tepat)
    await NotifService.scheduleAlarm(
      id: alarmId,
      title: "⏰ Waktunya $title!",
      body: "Ayo jalankan pola hidup sehatmu 💪",
      date: scheduleDate,
    );

    // Jadwalkan reminder (10 menit sebelum)
    DateTime reminderDate = scheduleDate.subtract(const Duration(minutes: 10));
    
    if (reminderDate.isAfter(now)) {
      await NotifService.scheduleReminder(
        id: reminderId,
        title: "🔔 10 Menit Lagi!",
        body: "Bersiap untuk: $title",
        date: reminderDate,
      );
      
      await _saveReminderId(id, reminderId);
      debugPrint('✅ Reminder scheduled at $reminderDate');
    } else {
      debugPrint('⚠️ Reminder time is in the past, skipping...');
    }

    // Verify scheduled notifications
    final pending = await NotifService.getPendingNotifications();
    debugPrint('📋 Total pending notifications: ${pending.length}');
    for (var notif in pending) {
      debugPrint('  - ID: ${notif.id}, Title: ${notif.title}');
    }

    debugPrint('✅ Alarm & Reminder scheduled for $title at $time');
  }

  static Future<void> deleteAlarmTime(String id) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> alarms = await getAlarms();
    alarms.remove(id);
    await prefs.setString(_keyAlarms, jsonEncode(alarms));
    
    int alarmId = id.hashCode.abs();
    int reminderId = ('${id}_reminder').hashCode.abs();
    
    await NotifService.cancelNotification(alarmId);
    await NotifService.cancelNotification(reminderId);
    await _removeReminderId(id);
    
    debugPrint('🗑️ Alarm & Reminder deleted for ID: $id');
  }

  // --- 3. LOGIKA REMINDER OTOMATIS (untuk item yang belum dichecklist) ---
  static Future<void> scheduleAutomaticReminders(
    String id,
    String title,
    String rawTime,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final autoKey = "auto_reminder_$id";

    
    if (prefs.getBool(autoKey) == true) {
      debugPrint('⏭️ Auto reminder already scheduled for $id');
      return;
    }

    // Cek apakah item sudah dichecklist
    Map<String, bool> checklist = await getChecklist();
    if (checklist[id] == true) {
      debugPrint('✅ Item $id already checked, skipping auto reminder');
      return;
    }

    try {
      // Parse waktu rekomendasi
      String timeStr = rawTime;
      
      // Jika format range (contoh: "07:00 - 08:00"), ambil waktu awal
      if (timeStr.contains(' - ')) {
        timeStr = timeStr.split(' - ')[0].trim();
      }
      
      // Bersihkan dari karakter non-angka dan ":"
      timeStr = timeStr.replaceAll(RegExp(r'[^0-9:]'), '').trim();
      
      if (!timeStr.contains(':')) {
        debugPrint('⚠️ Invalid time format for auto reminder: $rawTime');
        return;
      }

      final now = DateTime.now();
      final parts = timeStr.split(':');

      DateTime scheduleDate = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      // Jika waktu sudah lewat, jadwalkan untuk besok
      if (scheduleDate.isBefore(now)) {
        scheduleDate = scheduleDate.add(const Duration(days: 1));
      }

      // Reminder 15 menit sebelum waktu rekomendasi
      DateTime reminderDate = scheduleDate.subtract(const Duration(minutes: 15));
      
      if (reminderDate.isAfter(now)) {
        int reminderId = "AUTO_REMINDER_$id".hashCode.abs();
        
        await NotifService.scheduleReminder(
          id: reminderId,
          title: "⏳ Waktu Rekomendasi Mendekati",
          body: "15 menit lagi: $title",
          date: reminderDate,
        );

        await prefs.setBool(autoKey, true);
        debugPrint('✅ Auto reminder scheduled for $title at $reminderDate');
      } else {
        debugPrint('⚠️ Auto reminder time is in the past for $id');
      }
    } catch (e) {
      debugPrint("❌ Gagal auto reminder: $e");
    }
  }

  // --- 4. SIMPAN KE LOKAL ---
  static Future<void> saveToLocal(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = await storage.read(key: 'jwt_token');
    
    Map<String, dynamic> securedData = {
      'jwt_signature': token?.hashCode ?? 0,
      'payload': data,
    };
    await prefs.setString(_keyLocalData, jsonEncode(securedData));

    // Jadwalkan automatic reminder untuk item yang belum dichecklist
    Map<String, bool> currentChecklist = await getChecklist();
    
    data.forEach((category, items) {
      if (items is List) {
        for (int i = 0; i < items.length; i++) {
          var item = items[i];
          String itemName = item['nama'] ?? item['gerakan'] ?? '';
          String id = "${category}_${itemName}_$i";
          
          // Hanya jadwalkan jika belum dichecklist dan ada waktu
          if (currentChecklist[id] != true && item['jam'] != null) {
            scheduleAutomaticReminders(
              id, 
              itemName, 
              item['jam'].toString()
            );
          }
        }
      }
    });

    debugPrint('✅ Data saved to local storage');
  }

  // --- 5. HELPER FUNCTIONS ---
  static Future<void> _saveReminderId(String itemId, int reminderId) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> reminders = await _getRemindersMap();
    reminders[itemId] = reminderId;
    await prefs.setString(_keyScheduledReminders, jsonEncode(reminders));
  }

  static Future<void> _removeReminderId(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> reminders = await _getRemindersMap();
    reminders.remove(itemId);
    await prefs.setString(_keyScheduledReminders, jsonEncode(reminders));
  }

  static Future<Map<String, dynamic>> _getRemindersMap() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyScheduledReminders);
    if (data != null) {
      return Map<String, dynamic>.from(jsonDecode(data));
    }
    return {};
  }

  // --- 6. FUNGSI DATA ---
  static Future<Map<String, dynamic>?> getData(BuildContext context) async {
    Map<String, dynamic>? local = await getFromLocal();
    if (local != null && (local['makanan'] as List).isNotEmpty) {
      return local;
    }
    return await fetchLatestData(context);
  }

  static Future<Map<String, dynamic>?> fetchLatestData(BuildContext context, {http.Client? client}) async {
    final httpClient = client ?? http.Client();
    try {
      String? token = await storage.read(key: 'jwt_token');
      final response = await httpClient.get(
        Uri.parse("${ConfigApi.baseUrl}/api/latest_recommendation"),
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        await saveToLocal(result['data']); 
        return result['data'];
      }
    } catch (e) {
      debugPrint("Error API Recommendation: $e");
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    String? rawJson = prefs.getString(_keyLocalData);
    if (rawJson == null) return null;

    Map<String, dynamic> decoded = jsonDecode(rawJson);
    String? currentToken = await storage.read(key: 'jwt_token');

    if (decoded['jwt_signature'] != currentToken?.hashCode) {
      debugPrint("Security: Token mismatch, menghapus cache lama.");
      await prefs.remove(_keyLocalData);
      return null;
    }

    return decoded['payload'];
  }

  static Future<bool> checkAutoLogin() async {
    String? token = await storage.read(key: 'jwt_token');
    if (token == null) return false;

    final prefs = await SharedPreferences.getInstance();
    String? lastRecom = prefs.getString('last_recom');
    
    return lastRecom != null;
  }

  // --- 7. TESTING ---
  static Future<void> testAllNotifications() async {
    debugPrint('🧪 Testing all notification types...');
    
    final now = DateTime.now();
    
    await NotifService.scheduleAlarm(
      id: 8888,
      title: 'Test Alarm',
      body: 'Ini bunyi alarm kustom untuk testing',
      date: now.add(const Duration(seconds: 5)),
    );
    
    await NotifService.scheduleReminder(
      id: 8887,
      title: 'Test Reminder',
      body: 'Ini bunyi notifikasi default HP',
      date: now.add(const Duration(seconds: 8)),
    );
    
    debugPrint('✅ Test notifications scheduled!');
  }

  static Future<void> testQuickAlarm() async {
    final testTime = DateTime.now().add(const Duration(seconds: 10));
    
    debugPrint('🧪 Quick Test: Alarm will ring at ${testTime.hour}:${testTime.minute}:${testTime.second}');
    
    await NotifService.scheduleAlarm(
      id: 7777,
      title: '⏰ TEST ALARM - Harusnya Bunyi!',
      body: 'Jika bunyi berarti sistem notifikasi sudah bekerja!',
      date: testTime,
    );
    
    await NotifService.scheduleReminder(
      id: 7776,
      title: '🔔 TEST REMINDER',
      body: 'Ini reminder 5 detik sebelumnya',
      date: DateTime.now().add(const Duration(seconds: 5)),
    );
    
    debugPrint('✅ Quick alarm scheduled! Wait 10 seconds...');
  }
}