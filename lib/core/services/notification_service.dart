import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  Future<void> scheduleAll() async {
    await init();
    await _plugin.cancelAll();
    await _schedule(id: 1, hour: 8,  title: ' Breakfast Time!', body: 'Start your day with a delicious breakfast recipe.');
    await _schedule(id: 2, hour: 14, title: ' Lunch Time!',     body: 'Check out some amazing lunch ideas for today.');
    await _schedule(id: 3, hour: 20, title: ' Dinner Time!',  body: 'Explore dinner recipes to end your day right.');
  }

  Future<void> _schedule({
    required int id,
    required int hour,
    required String title,
    required String body,
  }) async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        id, title, body, scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'meal_reminder_channel',
            'Meal Reminders',
            channelDescription: 'Daily meal time recipe suggestions',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {

    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
