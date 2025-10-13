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
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response);
      },
      // (optional) secondary callback for action buttons:
    //  onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      // สำคัญสำหรับ Android เมื่อแอปไม่อยู่ foreground/terminated
      // onDidReceiveBackgroundNotificationResponse:
      //     onDidReceiveBackgroundNotificationResponse,
    );
    // Android 13+ runtime permission
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // @pragma('vm:entry-point')
  // void notificationTapBackground(NotificationResponse response) {
  //   // You can persist the payload somewhere if needed; navigation must happen when app is resumed.
  //   _handleNotificationTap(response);
  // }

  void _handleNotificationTap(payload) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    Application.navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => VideoPage(payload.id)),
    );
  }

  // @pragma('vm:entry-point')
  // void onDidReceiveBackgroundNotificationResponse(
  //   NotificationResponse response,
  // ) {
  //   Application.navigatorKey.currentState?.push(
  //     MaterialPageRoute(builder: (_) => VideoPage()),
  //   );
  // }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> cancelID(id) async {
    await _notificationsPlugin.cancel(id);
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
    try {
      await _notificationsPlugin.zonedSchedule(
        count,
        'ป้องกันออฟฟิศซินโดรม', // title
        'ถึงเวลาขยับร่างกาย', // body
        scheduledTime,
        _notificationDetails(count),
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exact,
      );

      debugPrint('Notification scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  NotificationDetails _notificationDetails(count) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        count.toString(),
        'officesyndrome',
        channelDescription: 'description here',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(
        sound: 'alarm.mp3',
        presentAlert: true,
        presentSound: true,
      ),
    );
  }
}
