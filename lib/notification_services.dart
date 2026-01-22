import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotifService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    final String timeZoneName = "Asia/Jakarta"; 
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(initializationSettings);

    final android = _notificationsPlugin
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        'pola_hidup_channel',
        'Pola Hidup',
        description: 'Notifikasi pola hidup sehat',
        importance: Importance.max,
      ),
    );
  }

  static Future<void> requestNotificationPermission() async {
    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      await android.requestNotificationsPermission();
    }
  }

  // Fungsi untuk langsung memunculkan notifikasi
  static Future<void> showInstantNotif(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'pola_hidup_channel', 'Pola Hidup',
      importance: Importance.max, priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, details);
  }
  
  static Future<void> requestExactAlarmPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      try {
        // Meminta izin untuk menjadwalkan alarm yang tepat waktu
        await androidImplementation.requestExactAlarmsPermission();
      } catch (e) {
        print("Gagal meminta izin exact alarm: $e");
      }
    }
  }
  // Fungsi untuk JADWAL (Misal: Ingatkan minum air setiap jam)
  static Future<void> scheduleNotif(int id, String title, String body, DateTime scheduledTime) async {
    // Minta izin dulu jika belum ada
    await requestExactAlarmPermission();

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'pola_hidup_channel', 
            'Pola Hidup Channel',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print("Gagal menjadwalkan: $e");
      // Jika masih gagal, gunakan mode inexact sebagai cadangan
      await _notificationsPlugin.zonedSchedule(
        id, title, body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(android: AndroidNotificationDetails('pola_hidup_channel', 'Pola Hidup')),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, // Lebih toleran
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    print("Notifikasi dengan ID $id telah dibatalkan.");
  }

  // 4. Batalkan semua notifikasi (Bermanfaat saat Logout)
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}