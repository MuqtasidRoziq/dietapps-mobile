import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/enums.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotifService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String alarmChannelId = 'pola_hidup_alarm_channel';
  static const String reminderChannelId = 'pola_hidup_reminder_channel';
  
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      // Initialize timezone
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      
      const settings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      await _plugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint('✅ Notification tapped: ${response.payload}');
        },
      );

      // Request permissions untuk Android 13+
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (android != null) {
        await android.requestNotificationsPermission();
        await android.requestExactAlarmsPermission();
        
        debugPrint('✅ Permissions requested');
      }

      // Create notification channels
      await _createNotificationChannels();
      
      _isInitialized = true;
      debugPrint('✅ Notification service initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing notification service: $e');
    }
  }

  static Future<void> _createNotificationChannels() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) return;

    // Channel untuk Alarm (dengan bunyi kustom)
    final alarmChannel = AndroidNotificationChannel(
      alarmChannelId,
      'Alarm Pola Hidup',
      description: 'Alarm dengan bunyi kustom untuk pengingat waktu tepat',
      importance: Importance.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('alarm'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      enableLights: true,
      ledColor: const Color(0xFFFF0000),
    );

    // Channel untuk Reminder (notifikasi biasa)
    final reminderChannel = AndroidNotificationChannel(
      reminderChannelId,
      'Reminder Pola Hidup',
      description: 'Pengingat sebelum waktu rekomendasi',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
      enableLights: true,
      ledColor: const Color(0xFF0000FF),
    );

    await android.createNotificationChannel(alarmChannel);
    await android.createNotificationChannel(reminderChannel);
    
    debugPrint('✅ Notification channels created');
  }

  static Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    try {
      await init();
      
      final tzDate = tz.TZDateTime.from(date, tz.local);
      final now = tz.TZDateTime.now(tz.local);
      
      if (tzDate.isBefore(now)) {
        debugPrint('⚠️ Alarm time is in the past, skipping...');
        return;
      }
      
      debugPrint('🔔 Scheduling ALARM at: $tzDate (ID: $id)');
      
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            alarmChannelId,
            'Alarm Pola Hidup',
            channelDescription: 'Alarm dengan bunyi kustom',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            sound: const RawResourceAndroidNotificationSound('alarm'),
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
            fullScreenIntent: true,
            autoCancel: true,
            enableLights: true,
            ledColor: const Color(0xFFFF0000),
            ledOnMs: 1000,
            ledOffMs: 500,
            color: const Color(0xFFFF0000),
            colorized: true,
            largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            styleInformation: BigTextStyleInformation(
              body,
              contentTitle: title,
              htmlFormatBigText: true,
              summaryText: 'Alarm Pola Hidup',
            ),
            category: AndroidNotificationCategory.alarm,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'alarm_$id',
      );
      
      debugPrint('✅ Alarm scheduled successfully for $tzDate');
    } catch (e) {
      debugPrint('❌ Error scheduling alarm: $e');
    }
  }

  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    try {
      await init();
      
      final tzDate = tz.TZDateTime.from(date, tz.local);
      final now = tz.TZDateTime.now(tz.local);
      
      if (tzDate.isBefore(now)) {
        debugPrint('⚠️ Reminder time is in the past, skipping...');
        return;
      }
      
      debugPrint('⏰ Scheduling REMINDER at: $tzDate (ID: $id)');
      
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            reminderChannelId,
            'Reminder Pola Hidup',
            channelDescription: 'Pengingat sebelum waktu rekomendasi',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
            fullScreenIntent: false,
            autoCancel: true,
            enableLights: true,
            ledColor: const Color(0xFF0000FF),
            ledOnMs: 800,
            ledOffMs: 400,
            color: const Color(0xFF0000FF),
            colorized: true,
            styleInformation: BigTextStyleInformation(
              body,
              contentTitle: title,
              htmlFormatBigText: true,
              summaryText: 'Reminder Pola Hidup',
            ),
            category: AndroidNotificationCategory.reminder,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'reminder_$id',
      );
      
      debugPrint('✅ Reminder scheduled successfully for $tzDate');
    } catch (e) {
      debugPrint('❌ Error scheduling reminder: $e');
    }
  }

  static Future<void> showInstantNotification() async {
    try {
      await init();
      
      debugPrint('🔔 Showing instant notification...');
      
      final Int64List vibrationPattern = Int64List.fromList([0, 500, 200, 500]);
      
      final androidDetails = AndroidNotificationDetails(
        reminderChannelId,
        'Reminder Pola Hidup',
        channelDescription: 'Pengingat sebelum waktu rekomendasi',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        vibrationPattern: vibrationPattern,
        autoCancel: true,
        enableLights: true,
        ledColor: const Color(0xFF0000FF),
        ledOnMs: 800,
        ledOffMs: 400,
        color: const Color(0xFF0000FF),
        colorized: true,
        styleInformation: const BigTextStyleInformation(
          'Ini adalah notifikasi instant untuk testing!',
          contentTitle: 'Test Notification',
          htmlFormatBigText: true,
          summaryText: 'Test',
        ),
      );

      final platformChannelSpecifics = NotificationDetails(
        android: androidDetails,
      );

      await _plugin.show(
        0,
        'Test Notification',
        'Ini adalah notifikasi instant untuk testing!',
        platformChannelSpecifics,
        payload: 'test_instant',
      );

      debugPrint('✅ Instant notification shown successfully!');
      
    } catch (e) {
      debugPrint('❌ ERROR showing instant notification: $e');
    }
  }

  static Future<void> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id);
      debugPrint('🗑️ Cancelled notification with ID: $id');
    } catch (e) {
      debugPrint('❌ Error cancelling notification: $e');
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await _plugin.cancelAll();
      debugPrint('🗑️ All notifications cancelled');
    } catch (e) {
      debugPrint('❌ Error cancelling all notifications: $e');
    }
  }

  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }

  static Future<void> showTestNotifications() async {
    await init();
    
    final now = DateTime.now();
    
    // Test Alarm (5 detik dari sekarang)
    await scheduleAlarm(
      id: 9999,
      title: 'Test Alarm',
      body: 'Ini adalah bunyi alarm kustom',
      date: now.add(const Duration(seconds: 5)),
    );
    
    // Test Reminder (10 detik dari sekarang)
    await scheduleReminder(
      id: 9998,
      title: 'Test Reminder',
      body: 'Ini adalah bunyi notifikasi default HP',
      date: now.add(const Duration(seconds: 10)),
    );
    
    debugPrint('✅ Test notifications scheduled');
  }

  // Method untuk cek status notifikasi
  static Future<Map<String, dynamic>> checkNotificationStatus() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    Map<String, dynamic> status = {
      'enabled': false,
      'canSchedule': false,
      'pendingCount': 0,
    };
    
    if (android != null) {
      final hasPermission = await android.areNotificationsEnabled();
      final canSchedule = await android.canScheduleExactNotifications();
      final pending = await getPendingNotifications();
      
      status = {
        'enabled': hasPermission ?? false,
        'canSchedule': canSchedule ?? false,
        'pendingCount': pending.length,
      };
      
      debugPrint('📱 Notifications enabled: $hasPermission');
      debugPrint('⏰ Can schedule exact alarms: $canSchedule');
      debugPrint('📋 Pending notifications: ${pending.length}');
      
      for (var notif in pending) {
        debugPrint('  - ID: ${notif.id}, Title: ${notif.title}, Body: ${notif.body}');
      }
    }
    
    return status;
  }
}