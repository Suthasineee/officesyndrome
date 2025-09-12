import 'package:flutter/material.dart';
import 'package:office_syndrome/guild/guild_view.dart';
import 'package:office_syndrome/helper/colors.dart';
import 'package:office_syndrome/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstOpen = prefs.getBool('is_first_open') ?? true;

  if (isFirstOpen) {
    await prefs.setBool('is_first_open', false);
  }

  runApp(MyApp(isFirstOpen: isFirstOpen));
}

class MyApp extends StatelessWidget {
  final bool isFirstOpen;

  const MyApp({super.key, required this.isFirstOpen});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
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
