import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:office_syndrome/helper/app_controller.dart';
import 'package:office_syndrome/helper/colors.dart';
import 'package:office_syndrome/helper/notificationService.dart';
import 'package:office_syndrome/helper/preferences_helper.dart';
import 'package:office_syndrome/model/notificationData.dart';
import 'package:office_syndrome/setting/setting.dart';
import 'package:office_syndrome/video/video.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isWarning = false;
  NotificationData data = NotificationData();
  String name = "";
  List<NotificationData> notificationData = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  late SharedPreferences prefs;
  getData() async {
    notificationData = await getNotificationData();
    setState(() {});
  }

  void _startTimer(int time, count) {
    DateTime selectedTime = DateTime.now().add(
      Duration(seconds: time),
    ); // For testing purposes
    NotificationService().scheduleDailyNotification(selectedTime, count);
  }

  @override
  void dispose() {
    //_timer?.cancel();
    super.dispose();
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied && !isWarning) {
      isWarning = true;
      await Permission.notification.request();
      // await openAppSettings();
    }
  }

  Future<bool> checkNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      showAlertDialog(context);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: colorPrimary),
      backgroundColor: Colors.white,
      bottomNavigationBar: _nextButton(),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.sizeOf(context).width,
              color: colorPrimary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 70),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          'ป้องกันออฟฟิศ',
                          style: TextStyle(
                            //  color: colorPrimaryDark,
                            fontSize: 35,
                            fontFamily: fontMitr,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 48, left: 20),
                        child: Text(
                          'ซินโดรม',
                          style: TextStyle(
                            //  color: colorPrimaryDark,
                            fontSize: 35,
                            fontFamily: fontMitr,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              color: colorPrimary,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(46),
                    topRight: Radius.circular(46),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 25),
                          child: Text(
                            'ตั้งเวลาการแจ้งเตือน',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: fontMitr,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        addView(),
                      ],
                    ),
                    SizedBox(height: 10),
                    listNotificationView(),
                    // Container(
                    //   height: 50,
                    //   margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Container(
                    //         padding: EdgeInsets.only(left: 15),
                    //         child: Text(
                    //           'แจ้งเตือน',
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontFamily: fontMitr,
                    //             fontWeight: FontWeight.w500,
                    //             fontSize: 20,
                    //           ),
                    //         ),
                    //       ),
                    //       Switch(
                    //         activeColor: Colors.white,
                    //         activeTrackColor: colorAccent,
                    //         value: isOn,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             isOn = value;
                    //             if (!isOn) {
                    //               NotificationService().cancelAll();
                    //               print("cancelAll");
                    //             } else {
                    //               int type = prefs.getInt('type') ?? 0;
                    //               if (type == 1) {
                    //                 for (int i = 1; i <= data.time!; i++) {
                    //                   _startTimer(3600 * i, i);
                    //                 }
                    //               } else if (type == 2) {
                    //                 for (int i = 1; i <= data.time!; i++) {
                    //                   _startTimer(7200 * i, i);
                    //                 }
                    //               } else if (type == 3) {
                    //                 int clock = prefs.getInt('clock') ?? 0;
                    //                 DateTime date =
                    //                     DateTime.fromMillisecondsSinceEpoch(
                    //                       clock,
                    //                     );
                    //                 int sum = prefs.getInt('sum') ?? 0;
                    //                 int time = prefs.getInt('time') ?? 0;
                    //                 for (int i = 1; i <= time; i++) {
                    //                   DateTime selectedfTime = date.add(
                    //                     Duration(seconds: sum * i),
                    //                   );
                    //                   NotificationService()
                    //                       .scheduleDailyNotification(
                    //                         selectedfTime,
                    //                         i,
                    //                       );
                    //                   print(
                    //                     "selectedfTime:" +
                    //                         selectedfTime.second.toString(),
                    //                   );
                    //                 }
                    //               } else if (type == 4) {
                    //                 int clock = prefs.getInt('clock') ?? 0;
                    //                 int time = prefs.getInt('time') ?? 0;
                    //                 DateTime date;
                    //                 if (clock != 0) {
                    //                   date = DateTime.fromMillisecondsSinceEpoch(
                    //                     clock,
                    //                   );
                    //                   for (int i = 1; i <= time; i++) {
                    //                     print("scheduleDailyNotification");
                    //                     NotificationService()
                    //                         .scheduleDailyNotification(date, i);
                    //                   }
                    //                 }
                    //               }
                    //             }
                    //             setData();
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addView() {
    return InkWell(
      onTap: () async {
        if (await Permission.notification.isDenied && Platform.isAndroid) {
          showAlertDialog(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SettingPage(0, 0)),
          ).then((onValue) {
            bool isSave = false;
            if (onValue.isAdd == 0) {
              setState(() {
                NotificationService().cancelAll();
                data = onValue;
                List<int> id = [];
                if (data.type == 1) {
                  //1-12
                  int typeCount = notificationData
                      .where((e) => e.type == 1)
                      .toList()
                      .length;
                  if (typeCount <= 1) {
                    isSave = true;
                    onValue.startAt = 0;
                    for (int i = 1; i <= data.time!; i++) {
                      _startTimer(3600 * i, i);
                      id.add(i);
                    }
                  }
                } else if (data.type == 2) {
                  //15-26
                  int typeCount = notificationData
                      .where((e) => e.type == 2)
                      .toList()
                      .length;
                  if (typeCount <= 1) {
                    isSave = true;
                    onValue.startAt = 0;
                    for (int i = 1; i <= data.time!; i++) {
                      _startTimer(7200 * i, i + 14);
                      id.add(i + 14);
                    }
                  }
                } else if (data.type == 3) {
                  //101-3000
                  isSave = true;
                  int typeCount = notificationData
                      .where((e) => e.type == 3)
                      .toList()
                      .length;
                  int typeId = 0;
                  if (notificationData.isEmpty || typeCount == 0) {
                    onValue.startAt = 1;
                    typeId = 1;
                  } else {
                    for (int i = 0; i <= 12; i++) {
                      int typeCount = notificationData
                          .where((e) => e.startAt == (i + 1))
                          .toList()
                          .length;

                      if (typeCount == 0) {
                        typeId = (i + 1);
                        i = 13;
                      }
                    }
                  }
                  int sum =
                      (data.clock!.inHours * 60 * 60) +
                      (data.clock!.inMinutes * 60);

                  for (int i = 1; i <= data.time!; i++) {
                    _startTimer(sum * i, i + (typeId + 100));
                    data.id!.add(i + (typeId + 100));
                  }
                } else if (data.type == 4) {
                  //10000
                  isSave = true;
                  onValue.startAt = 0;
                  int id = 0;
                  for (int i = 0; i <= notificationData.length!; i++) {
                    int typeCount = notificationData
                        .where((e) => e.id == i + 10000)
                        .toList()
                        .length;
                    if (typeCount == 0) {
                      id = i + 10000;
                      i = notificationData.length + 1;
                    }
                  }

                  NotificationService().scheduleDailyNotification(
                    data.date!,
                    1,
                  );
                  data.id!.add(id);
                }
              });
              if (isSave) {
                data.isON = true;
                saveNotificationData(data);
                getData();
              }
            } else {
              editNotificationData(data, data.index);
              getData();
            }
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 25),
        decoration: BoxDecoration(
          color: colorAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget listNotificationView() {
    return notificationData.isNotEmpty
        ? Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                ...List.generate(notificationData.length, (index) {
                  return notificationView(notificationData[index], index);
                }),
              ],
            ),
          )
        : Container(
            // child: Text(
            //   'ไม่มีข้อมูล',
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontFamily: fontMitr,
            //     fontSize: 18,
            //   ),
            // ),
          );
  }

  Widget notificationView(NotificationData dataT, index) {
    return InkWell(
      onTap: () async {
        if (await Permission.notification.isDenied && Platform.isAndroid) {
          showAlertDialog(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SettingPage(1, index)),
          ).then((onValue) {
            if (onValue.isAdd == 0) {
              setState(() {
                NotificationService().cancelAll();
                data = onValue;
                // prefs.setString('text', data.text.toString());
                if (data.type == 1) {
                  for (int i = 1; i <= data.time!; i++) {
                    _startTimer(3600 * i, i);
                  }
                  //   prefs.setInt('type', 1);
                } else if (data.type == 2) {
                  for (int i = 1; i <= data.time!; i++) {
                    _startTimer(7200 * i, i);
                  }
                  // prefs.setInt('type', 2);
                } else if (data.type == 3) {
                  int sum =
                      (data.clock!.inHours * 60 * 60) +
                      (data.clock!.inMinutes * 60);

                  for (int i = 1; i <= data.time!; i++) {
                    _startTimer(sum * i, i);
                  }
                } else if (data.type == 4) {
                  NotificationService().scheduleDailyNotification(
                    data.date!,
                    1,
                  );
                }
              });
              saveNotificationData(data);
              getData();
            } else if (onValue.isAdd == 1) {
              editNotificationData(onValue, onValue.index);
              getData();
            }
            setState(() {
              getData();
            });
          });
        }
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black26, // สีขอบ
            width: 1.0, // ความหนาของเส้น
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                dataT.text.toString().isEmpty
                    ? 'เลือกเวลาการแจ้งเตือน'
                    : dataT.text.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: fontMitr,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Transform.scale(
                scale:
                    0.8, // ปรับขนาด (1.0 = ปกติ, มากกว่าคือใหญ่ขึ้น, น้อยกว่าคือเล็กลง)
                child: Switch(
                  activeColor: Colors.white,
                  activeTrackColor: colorAccent,
                  value: dataT.isON!,
                  onChanged: (value) {
                    setState(() {
                      dataT.isON = value;
                      editNotificationData(dataT, index);
                      getData();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 25, left: 30, right: 30),
      height: 48,
      width: MediaQuery.of(context).size.width * 0.5,
      // margin: EdgeInsets.only(top: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorAccent, //background color of button
          side: BorderSide(width: 1, color: Color.fromARGB(255, 203, 202, 202)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VideoPage()),
          );
        },
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            'เล่นตอนนี้',
            style: TextStyle(
              color: Colors.white,
              fontFamily: fontMitr,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showAlertDialog(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          "เปิดการแจ้งเตือน",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: fontMitr,
          ),
        ),
        content: Text(
          "ไปที่ตั้งค่าการแจ้งเตือน",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: fontMitr,
            fontSize: 18,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(
                      color: colorAccent,
                      fontFamily: fontMitr,
                      // fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: colorAccent, //background color of button
                  side: BorderSide(
                    width: 1,
                    color: Color.fromARGB(255, 203, 202, 202),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  await openAppSettings();
                },
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    'ตกลง',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: fontMitr,
                      // fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
