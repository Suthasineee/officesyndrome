import 'dart:async';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:office_syndrome/helper/app_controller.dart';
import 'package:office_syndrome/helper/application.dart';
import 'package:office_syndrome/helper/colors.dart';
import 'package:office_syndrome/helper/notificationService.dart';
import 'package:office_syndrome/helper/preferences_helper.dart';
import 'package:office_syndrome/learn.dart';
import 'package:office_syndrome/map.dart';
import 'package:office_syndrome/model/notificationData.dart';
import 'package:office_syndrome/profile_page.dart';
import 'package:office_syndrome/setting/setting.dart';
import 'package:office_syndrome/setting_view.dart';
import 'package:office_syndrome/video/video.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:alarm/alarm.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool isWarning = false;
  NotificationData data = NotificationData();
  String name = "";
  List<NotificationData> notificationData = [];
  int id = 0;
  bool isAppInForeground = true;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isIOS) {
      NotificationService().cancelAll();
    }
    getMenu();
    getData();
    initNoti();

    notificationData.forEach((item) {
      if (item.date!.day == DateTime.now().day &&
          item.date!.hour == DateTime.now().hour &&
          item.date!.minute == DateTime.now().minute &&
          item.startAt != 3) {
        item.startAt = 3;
        print("VideoPage2");
        print(" item.startAt:" + item.startAt.toString());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VideoPage(0)),
        );
      }
    });
    super.initState();
  }

  bool isOpen = false;
  getMenu() async {
    await FirebaseFirestore.instance.collection("menu").get().then((value) {
      setState(() {
        isOpen = value.docs.first.get("one");
      });
    });
  }

  cancelID(id) {
    Alarm.stop(id);
  }

  int i = 0;
  initNoti() async {
    _ringSub?.cancel(); // กันสมัครซ้ำ

    if (await Alarm.isRinging()) {
      final alarms = await Alarm.getAlarms();
      if (alarms.isNotEmpty) {
        //  WidgetsBinding.instance.addPostFrameCallback((_) {
        // Application.navigatorKey.currentState?.push(
        //   MaterialPageRoute(builder: (_) => VideoPage(-1)),
        // );
        //  });
      }
    } else {}
    _ringSub = Alarm.ringing.listen((alarmSet) {
      print("Alarm:ringing");
      NotificationService().cancelAll();
      final ids = alarmSet.alarms.map((a) => a.id).toList();
      final currentId = ids.first;
      var data;
      notificationData.forEach((item) {
        data = item;
        if (item.id == currentId) {
          item.startAt = 3;
        }
      });
      if (!Navigator.canPop(context) && data.startAt != 3) {
        print("VideoPage1");
        Application.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => VideoPage(currentId)),
        );
      }
    });
  }

  setNoti(time, id) async {
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: time,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      allowAlarmOverlap: true,
      warningNotificationOnKill: Platform.isLinux,
      androidFullScreenIntent: false,
      volumeSettings: VolumeSettings.fade(
        volume: 0.7,
        fadeDuration: Duration(seconds: 5),
        volumeEnforced: true,
      ),
      notificationSettings: const NotificationSettings(
        title: 'ป้องกันออฟฟิศซินโดรม',
        body: 'ถึงเวลาขยับร่างกาย',
        stopButton: 'หยุดการแจ้งเตือน',
        icon: 'notification_icon',
        iconColor: colorPrimary,
      ),
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  StreamSubscription? _ringSub;

  late SharedPreferences prefs;

  getData() async {
    //await Alarm.set(alarmSettings: alarmSettings);
    notificationData = await getNotificationData();
    Timer(Duration(seconds: 1), () {
      setState(() {});
    });
    notificationData = await getNotificationData();
  }

  void _startTimer(int time, count) {
    DateTime selectedTime = DateTime.now().add(Duration(seconds: time));
    // if (selectedTime.isBefore(DateTime.now())) {
    //   selectedTime.add(Duration(days: 1));
    // }
    // For testing purposes
    if (Platform.isIOS) {
      // NotificationService().scheduleDailyNotification(selectedTime, count);
      setNoti(selectedTime, count);
    } else {
      setNoti(selectedTime, count);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //_timer?.cancel();
    _ringSub!.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("state:" + state.name);
    if (state == AppLifecycleState.paused) {
      if (Platform.isIOS) {
        NotificationService().cancelAll();
        // Alarm.stopAll();
        notificationData.forEach((item) async {
          item.id!.forEach((i) async {
            if (item.isON!) {
              NotificationService().scheduleDailyNotification(item.date!, i);
            }
          });
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      print("🟢 App in foreground");
    } else if (state == AppLifecycleState.detached) {
      print("🔴 App terminated");
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

  Widget Profileiew() {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfilePage()),
        );
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.person, color: Colors.black),
            ),
            Text(
              'โปรไฟล์',
              style: TextStyle(
                color: Colors.black,
                fontFamily: fontMitr,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Learn() {
    return InkWell(
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LearnPage()));
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.accessibility, color: Colors.black),
            ),
            Text(
              'ท่ายืดออกกำลังกาย',
              style: TextStyle(
                color: Colors.black,
                fontFamily: fontMitr,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Learn2() {
    return InkWell(
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MapPage()));
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.health_and_safety, color: Colors.black),
            ),
            Text(
              'รักษาออฟฟิศซินโดรม',
              style: TextStyle(
                color: Colors.black,
                fontFamily: fontMitr,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorPrimary,
        leading: isOpen
            ? IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SettingView()),
                  );
                },
              )
            : Container(),
        actions: [],
      ),

      backgroundColor: Colors.white,
      bottomNavigationBar: _nextButton(),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                          ],
                        ),
                        SizedBox(height: 10),
                        isOpen
                            ? Column(
                                children: [Profileiew(), Learn(), Learn2()],
                              )
                            : Container(),
                        notificationData.length < 12 ? addView() : Container(),
                        listNotificationView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: <Widget>[
          //     Container(
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(18),
          //       ),
          //       width: MediaQuery.sizeOf(context).width * 0.85,
          //       height: 120,
          //       alignment: Alignment.center,
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Text(
          //             'หยุดการแจ้งเตือน',
          //             style: TextStyle(
          //               color: Colors.black,
          //               fontFamily: fontMitr,
          //               // fontWeight: FontWeight.w600,
          //               fontSize: 18,
          //             ),
          //           ),
          //           SizedBox(height: 15),
          //           ElevatedButton(
          //             style: ElevatedButton.styleFrom(
          //               elevation: 0,
          //               backgroundColor:
          //                   Colors.white, //background color of button
          //               side: BorderSide(
          //                 width: 1,
          //                 color: Color.fromARGB(255, 203, 202, 202),
          //               ),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(10),
          //               ),
          //             ),
          //             onPressed: () async {
          //               Alarm.stopAll();
          //             },
          //             child: Container(
          //               width: MediaQuery.sizeOf(context).width * 0.6,
          //               height: 30,
          //               alignment: Alignment.center,
          //               child: Text(
          //                 'ตกลง',
          //                 style: TextStyle(
          //                   color: Colors.black,
          //                   fontFamily: fontMitr,
          //                   // fontWeight: FontWeight.w600,
          //                   fontSize: 18,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
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
            MaterialPageRoute(builder: (_) => SettingPage(0, 0, null)),
          ).then((onValue) {
            bool isSave = false;
            if (onValue.isAdd == 0) {
              data = onValue;
              List<int> id = [];
              if (data.type == 1) {
                //1-12
                data.startAt = 0;
                isSave = true;
                for (int i = 1; i <= data.time!; i++) {
                  _startTimer(60 * 60 * data.time! * i, i);
                  id.add(i);
                }
                data.id = id;
              } else if (data.type == 2) {
                //15-26
                data.startAt = 0;
                isSave = true;

                for (int i = 1; i <= data.time!; i++) {
                  _startTimer(7200 * i, i + 14);
                  id.add(i + 14);
                }

                data.id = id;
              } else if (data.type == 3) {
                //101-3000
                isSave = true;
                data.startAt = 1;
                int sum =
                    (data.clock!.inHours * 60 * 60) +
                    (data.clock!.inMinutes * 60);
                List<int> id = [];
                int num = 100;
                for (int i = 1; i <= data.time!; i++) {
                  for (int j = num; j <= 1000; j++) {
                    var check = notificationData.where((item) {
                      int typeCount = item.id!
                          .where((e) => e == (j))
                          .toList()
                          .length;
                      return typeCount > 0;
                    }).toList();
                    if (check.isEmpty) {
                      _startTimer(sum * i, j);
                      id.add(j);
                      num = j + 1;
                      j = 1002;
                    }
                  }
                }
                data.id = id;
              } else if (data.type == 4) {
                //10000
                isSave = true;
                data.startAt = 0;
                List<int> id = [];
                for (int i = 0; i <= notificationData.length!; i++) {
                  int typeCount = notificationData
                      .where((e) => e.id![0] == (i + 10000))
                      .toList()
                      .length;
                  if (typeCount == 0) {
                    id.add(i + 10000);
                    i = notificationData.length + 1;
                  }
                }
                // DateTime minus15 = data.date!.subtract(Duration(seconds: 2));
                // if (minus15.isBefore(DateTime.now())) {
                //   minus15.add(Duration(days: 1));
                // }

                final now = tz.TZDateTime.now(tz.local);
                var scheduled = tz.TZDateTime(
                  tz.local,
                  now.year,
                  now.month,
                  now.day,
                  data.date!.hour,
                  data.date!.minute,
                );

                if (Platform.isIOS) {
                  // NotificationService().scheduleDailyNotification(
                  //   scheduled,
                  //   id[0],
                  // );
                  setNoti(scheduled, id[0]);
                } else {
                  setNoti(scheduled, id[0]);
                }

                data.id = id;
              }

              if (isSave) {
                data.isON = true;
                saveNotificationData(data);
                getData();
              } else {}
            } else {
              editNotificationData(data, data.index);
              getData();
            }
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.add, color: Colors.black),
            ),
            Text(
              'เพิ่มเวลา',
              style: TextStyle(
                color: Colors.black,
                fontFamily: fontMitr,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listNotificationView() {
    return notificationData.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(bottom: 20),
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
          showAlertDeleteDialog(context, dataT.id![0], index).then((onValue) {
            setState(() {
              getData();
            });
          });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (_) => SettingPage(1, index, dataT)),
          // ).then((onValue) async {
          //   notificationData = await getNotificationData();
          //   bool isSave = false;
          //   if (onValue.isAdd == 1) {
          //     data = onValue;

          //     List<int> id = [];
          //     if (data.type == 1) {
          //       //1-12
          //       data.startAt = 0;

          //       isSave = true;

          //       for (int i = 1; i <= data.time!; i++) {
          //         _startTimer(60 * 60 * data.time! * i, i);
          //         id.add(i);
          //       }

          //       data.id = id;
          //     } else if (data.type == 2) {
          //       //15-26
          //       data.startAt = 0;
          //       int typeCount = notificationData
          //           .where((e) => e.type == 2)
          //           .toList()
          //           .length;
          //       if (typeCount < 1) {
          //         isSave = true;

          //         for (int i = 1; i <= data.time!; i++) {
          //           _startTimer(7200 * i, i + 14);
          //           id.add(i + 14);
          //         }
          //       } else {
          //         isSave = false;
          //       }
          //       data.id = id;
          //     } else if (data.type == 3) {
          //       //101-3000
          //       isSave = true;
          //       data.startAt = 1;
          //       int sum =
          //           (data.clock!.inHours * 60 * 60) +
          //           (data.clock!.inMinutes * 60);
          //       List<int> id = [];
          //       int num = 100;
          //       for (int i = 1; i <= data.time!; i++) {
          //         for (int j = num; j <= 1000; j++) {
          //           var check = notificationData.where((item) {
          //             int typeCount = item.id!
          //                 .where((e) => e == (j))
          //                 .toList()
          //                 .length;
          //             return typeCount > 0;
          //           }).toList();
          //           if (check.isEmpty) {
          //             _startTimer(sum * i, j);
          //             id.add(j);
          //             num = j + 1;
          //             j = 1002;
          //           }
          //         }
          //       }
          //       data.id = id;
          //     } else if (data.type == 4) {
          //       //10000
          //       isSave = true;
          //       data.startAt = 0;
          //       List<int> id = [];
          //       for (int i = 0; i <= notificationData.length!; i++) {
          //         int typeCount = notificationData
          //             .where((e) => e.id![0] == (i + 10000))
          //             .toList()
          //             .length;
          //         if (typeCount == 0) {
          //           id.add(i + 10000);
          //           i = notificationData.length + 1;
          //         }
          //       }
          //       DateTime minus15 = data.date!.subtract(Duration(seconds: 15));
          //       setNoti(minus15, id[0]);
          //       data.id = id;
          //     }
          //     if (isSave) {
          //       data.isON = true;
          //       saveNotificationData(data);
          //     }
          //   }
          //   getData();
          // });
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
                  fontSize: 16,
                ),
              ),
            ),
            // Icon(Icons.delete, size: 30),
            Padding(
              padding: EdgeInsets.zero,
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
                      if (value) {
                        if (dataT.type == 1) {
                          //1-12
                          for (int i = 1; i <= dataT.time!; i++) {
                            _startTimer(
                              60 * 60 * dataT.time! * i,
                              dataT.id![i - 1],
                            );
                          }
                        } else if (dataT.type == 2) {
                          //15-26
                          for (int i = 1; i <= dataT.time!; i++) {
                            _startTimer(7200 * i, dataT.id![i - 1]);
                          }
                        } else if (dataT.type == 3) {
                          //101-3000
                          int sum =
                              (dataT.clock!.inHours * 60 * 60) +
                              (dataT.clock!.inMinutes * 60);
                          for (int i = 1; i <= dataT.time!; i++) {
                            _startTimer(sum * i, dataT.id![i - 1]);
                          }
                        } else if (dataT.type == 4) {
                          //10000
                          // DateTime minus15 = dataT.date!.subtract(
                          //   Duration(seconds: 2),
                          // );
                          if (dataT.date!.isBefore(DateTime.now())) {
                            dataT.date!.add(Duration(days: 1));
                          }

                          if (Platform.isIOS) {
                            // NotificationService().scheduleDailyNotification(
                            //   dataT.date!,
                            //   dataT.id![0],
                            // );
                            setNoti(dataT.date!, dataT.id![0]);
                          } else {
                            setNoti(dataT.date!, dataT.id![0]);
                          }
                        }
                      } else {
                        cancelID(dataT.id![0]!);
                      }
                      editNotificationData(dataT, index);
                      getData();
                    });
                  },
                ),
              ),
            ),

            //SizedBox(width: 5),
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
        onPressed: () async {
          if (await Alarm.isRinging()) {
            Alarm.ringing.listen((alarmSet) {
              final ids = alarmSet.alarms.map((a) => a.id).toList();
              // ถ้าคุณไม่ได้ให้ซ้อนกัน ปกติจะมีอันเดียว:
              final currentId = ids.first;
              print("VideoPage3");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VideoPage(currentId)),
              );
            });
          } else {
            print("VideoPage4");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VideoPage(-1)),
            );
          }
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

  Future<void> showAlertDeleteDialog(BuildContext context, id, index) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: fontMitr,
          ),
        ),
        content: SizedBox(
          child: Text(
            "ต้องการลบการแจ้งเตือนหรือไม่?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: fontMitr,
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                      // await openAppSettings();

                      if (Platform.isIOS) {
                        //NotificationService().cancelID(id);
                        final alarms = await Alarm.getAlarms();
                        final ids = alarms.map((a) => id!).toList();
                        if (ids.isNotEmpty) {
                          Alarm.stop(id);
                        }
                      } else {
                        final alarms = await Alarm.getAlarms();
                        final ids = alarms.map((a) => id!).toList();
                        if (ids.isNotEmpty) {
                          Alarm.stop(id);
                        }
                      }
                      deleteNotificationData(index);
                      print("VideoPage5");
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Container(
                      width: 100,
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
                  SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      print("VideoPage6");
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
