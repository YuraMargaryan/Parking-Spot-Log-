// notification_service_ios.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationServiceIOS {
  NotificationServiceIOS._();
  static final NotificationServiceIOS _instance = NotificationServiceIOS._();
  factory NotificationServiceIOS() => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzdata.initializeTimeZones();

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(iOS: iosInit);

    await _plugin.initialize(settings);

    // Запрашиваем разрешение на уведомления
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Показ мгновенного уведомления
  Future<void> showInstant(int id, String title, String body) async {
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(iOS: iosDetails);

    await _plugin.show(id, title, body, details);
  }

  /// Запланированное уведомление
  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    // Проверяем, что время в будущем
    if (dateTime.isBefore(DateTime.now())) {
      throw Exception('The notification time should be in the future.');
    }

    final tz.TZDateTime scheduled = tz.TZDateTime.from(dateTime, tz.local);

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(iOS: iosDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }


  Future<void> cancel(int id) async => _plugin.cancel(id);
  Future<void> cancelAll() async => _plugin.cancelAll();
}
