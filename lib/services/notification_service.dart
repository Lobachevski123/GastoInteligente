import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;
  static int _nextId = 1;

  static Future<void> init() async {
    if (_initialized) return;

    // Inicializar notificaciones
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

    // Timezone base (suficiente para "delay")
    tzdata.initializeTimeZones();

    // Pedir permiso en Android 13+ usando permission_handler
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }

    // Crear canal (Android 8+)
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(const AndroidNotificationChannel(
      'reminder_channel',
      'Recordatorios',
      description: 'Notificaciones de recordatorio de gastos',
      importance: Importance.defaultImportance,
    ));

    _initialized = true;
  }

  static Future<int> scheduleReminder(Duration delay) async {
    final when = tz.TZDateTime.now(tz.local).add(delay);
    final id = _nextId++;

    await _plugin.zonedSchedule(
      id,
      'Recordatorio de gastos',
      'No olvides registrar tus gastos',
      when,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Recordatorios',
          channelDescription: 'Notificaciones de recordatorio de gastos',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
    return id;
  }

  static Future<void> cancel(int id) => _plugin.cancel(id);
  static Future<void> cancelAll() => _plugin.cancelAll();
}
