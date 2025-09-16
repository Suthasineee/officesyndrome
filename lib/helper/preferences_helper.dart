import 'dart:convert';

import 'package:office_syndrome/model/notificationData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

const String dataNotification = "dataNotification";

editNotificationData(NotificationData data, index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<NotificationData> dataN = await getNotificationData();
  dataN[index].clock = data.clock;
  dataN[index].date = data.date;
  dataN[index].text = data.text;
  dataN[index].type = data.type;
  dataN[index].time = data.time;
  dataN[index].isON = data.isON;
  dataN[index].id = data.id;
  dataN[index].index = data.index;
  dataN[index].isAdd = data.isAdd;
  dataN[index].startAt = data.startAt;
  List<Map<String, String>> list = [];
  dataN.forEach((item) {
    List<String> stringList = item.id!.map((e) => e.toString()).toList();

    Map<String, String> s = {
      "clock": item.clock!.inMilliseconds.toString() == 'null'
          ? ''
          : item.clock!.inMilliseconds.toString(),
      "date": item.date!.millisecondsSinceEpoch.toString(),
      "text": item.text.toString(),
      "type": item.type.toString(),
      "time": item.time.toString(),
      "id": stringList.toString(),
      "isON": item.isON.toString(),
      "isAdd": item.isAdd.toString(),
      "index": item.index.toString(),
      "startAt": item.startAt.toString(),
    };
    list.add(s);
  });
  String jsonString = jsonEncode(list);
  prefs.setString(dataNotification, jsonString);
}

deleteNotificationData(index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<NotificationData> dataN = await getNotificationData();
  dataN.removeAt(index);
  List<Map<String, String>> list = [];
  dataN.forEach((item) {
    List<String> stringList = item.id!.map((e) => e.toString()).toList();
    Map<String, String> s = {
      "clock": item.clock!.inMilliseconds.toString() == 'null'
          ? ''
          : item.clock!.inMilliseconds.toString(),
      "date": item.date!.millisecondsSinceEpoch.toString(),
      "text": item.text.toString(),
      "type": item.type.toString(),
      "time": item.time.toString(),
      "id": stringList.toString(),
      "isON": item.isON.toString(),
      "isAdd": item.isAdd.toString(),
      "index": item.index.toString(),
      "startAt": item.startAt.toString(),
    };
    list.add(s);
  });
  String jsonString = jsonEncode(list);
  prefs.setString(dataNotification, jsonString);
}

saveNotificationData(NotificationData data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Map<String, String>> list = [];

  List<String> stringList = data.id!.map((e) => e.toString()).toList();
  Map<String, String> dataf = {
    "clock": data.clock!.inMilliseconds.toString() == 'null'
        ? ''
        : data.clock!.inMilliseconds.toString(),
    "date": data.date!.millisecondsSinceEpoch.toString(),
    "text": data.text.toString(),
    "type": data.type.toString(),
    "time": data.time.toString(),
    "id": stringList.toString(),
    "isON": data.isON.toString(),
    "isAdd": data.isAdd.toString(),
    "index": data.index.toString(),
    "startAt": data.startAt.toString(),
  };
  list.add(dataf);
  List<NotificationData> dataN = await getNotificationData();
  dataN.forEach((item) {
    List<String> stringList = item.id!.map((e) => e.toString()).toList();
    Map<String, String> s = {
      "clock": item.clock!.inMilliseconds.toString() == 'null'
          ? ''
          : item.clock!.inMilliseconds.toString(),
      "date": item.date!.millisecondsSinceEpoch.toString(),
      "text": item.text.toString(),
      "type": item.type.toString(),
      "time": item.time.toString(),
      "id": stringList.toString(),
      "isON": item.isON.toString(),
      "isAdd": item.isAdd.toString(),
      "index": item.index.toString(),
      "startAt": item.startAt.toString(),
    };
    list.add(s);
  });
  String jsonString = jsonEncode(list);
  print(jsonString);
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
      List<dynamic> decoded = jsonDecode(list[i]['id']);
      List<int> f = decoded.map((e) => e as int).toList();

      NotificationData data = NotificationData();
      data.id = f;
      data.isAdd = int.parse(list[i]['isAdd']);
      data.index = int.parse(list[i]['index']);
      data.isON = list[i]['isON'].toLowerCase() == "true";
      data.text = list[i]['text'];
      data.type = int.parse(list[i]['type']);
      data.time = int.parse(list[i]['time']);
      data.startAt = int.parse(list[i]['startAt']);
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
