import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
  }

  static Future<void> scheduleReminder(Duration delay) async {
    final scheduled = tz.TZDateTime.now(tz.local).add(delay);

    await _plugin.zonedSchedule(
      0,
      'Recordatorio de gastos',
      'No olvides registrar tus gastos',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Recordatorios',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }
}