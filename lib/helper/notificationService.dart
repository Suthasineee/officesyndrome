import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:office_syndrome/helper/application.dart';
import 'package:office_syndrome/video/video.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> init() async {
    tz.initializeTimeZones();
    final String currentTimeZone = DateTime.now().timeZoneName;
    tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // เมื่อกด Notification จะเข้ามาที่นี่
        //if (response.payload == "openPage") {
        Application.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => VideoPage()),
        );
        // }
      },
    );
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> scheduleDailyNotification(
    DateTime selectedTime,
    int count,
  ) async {
    if (selectedTime.isBefore(DateTime.now())) {
      selectedTime = selectedTime.add(const Duration(days: 1));
    }
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
      selectedTime,
      tz.local,
    );
    print("count:" + count.toString());
    print("selectedTime:" + selectedTime.toString());
    try {
      await _notificationsPlugin.zonedSchedule(
        count,
        'ป้องกันออฟฟิศซินโดรม', // title
        'ถึงเวลาขยับร่างกาย', // body
        scheduledTime,
        _notificationDetails(count),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Notification scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  NotificationDetails _notificationDetails(count) {
    print("count2:" + count.toString());
    return NotificationDetails(
      android: AndroidNotificationDetails(
        count.toString(),
        'your_channel_name',
        channelDescription: 'description here',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}
