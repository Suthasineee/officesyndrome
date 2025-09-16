import 'dart:convert';

import 'package:office_syndrome/model/notificationData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

const String dataNotification = "dataNotification";

saveNotificationData(NotificationData data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Map<String, String>> list = [];
  Map<String, String> dataf = {
    "clock": data.clock!.inMilliseconds.toString() == 'null'
        ? ''
        : data.clock!.inMilliseconds.toString(),
    "date": data.date!.millisecondsSinceEpoch.toString(),
    "text": data.text.toString(),
    "type": data.type.toString(),
    "time": data.time.toString(),
  };
  list.add(dataf);
  List<NotificationData> dataN = await getNotificationData();
  dataN.forEach((item) {
    Map<String, String> s = {
      "clock": item.clock!.inMilliseconds.toString() == 'null'
          ? ''
          : item.clock!.inMilliseconds.toString(),
      "date": item.date!.millisecondsSinceEpoch.toString(),
      "text": item.text.toString(),
      "type": item.type.toString(),
      "time": item.time.toString(),
    };
    list.add(s);
  });
  String jsonString = jsonEncode(list);
  prefs.setString(dataNotification, jsonString);
}

Future<List<NotificationData>> getNotificationData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(dataNotification);
  List<NotificationData> notificationData = [];
  if (jsonString != null) {
    List<dynamic> jsonData = jsonDecode(jsonString);
    List<Map<String, String>> myList = [];
    List<Map<String, dynamic>> list = jsonData
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    for (int i = 0; i < list.length; i++) {
      NotificationData data = NotificationData();
      data.text = list[i]['text'];
      data.type = int.parse(list[i]['type']);
      data.time = int.parse(list[i]['time']);
      data.date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(list[i]['date'].toString()),
      );
      data.clock = list[i]['clock'].toString() == ''
          ? null
          : Duration(milliseconds: int.parse(list[i]['clock'].toString()));
      notificationData.add(data);
    }
  }

  return notificationData;
}
