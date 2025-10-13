import 'package:alarm/alarm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_syndrome/firebase_options.dart';
import 'package:office_syndrome/guild/guild_view.dart';
import 'package:office_syndrome/helper/colors.dart';
import 'package:office_syndrome/helper/notificationService.dart';
import 'package:office_syndrome/home/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'helper/app_controller.dart';
import 'helper/application.dart';
import 'dart:io' show Platform;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await EasyLocalization.ensureInitialized();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Application.navigatorKey = navigatorKey;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstOpen = prefs.getBool('is_first_open') ?? true;
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));
  if (isFirstOpen) {
    await prefs.setBool('is_first_open', false);
  } // Initialize time zone
  //tz.initializeTimeZones();
  // requestNotificationPermission();
  if (Platform.isIOS) {
    NotificationService().init();
    await Alarm.init();
  } else {
    await Alarm.init();
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // บังคับแนวตั้งปกติ
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('th', 'TH')],
      path: 'assets/translations', // folder containing translation files
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(isFirstOpen: isFirstOpen),
    ),
  );
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  } else {
    // NotificationService().init(navigatorKey);
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstOpen;
  const MyApp({super.key, required this.isFirstOpen});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      navigatorKey: Application.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: colorPrimary),
      ),
      home: isFirstOpen ? GuildPage() : HomePage(),
    );
  }
}
