import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

Future<void> scheduleNotification() async {
  tz.initializeTimeZones(); // important for zonedSchedule

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await _notificationsPlugin.zonedSchedule(
    0,
    'Hello',
    'This is a scheduled notification',
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)), // 10s later
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
      ),
    ),

    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode .exact,
  );

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
