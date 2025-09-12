import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:office_syndrome/helper/app_controller.dart';
import 'package:office_syndrome/helper/colors.dart';
import 'package:office_syndrome/helper/notificationService.dart';
import 'package:office_syndrome/model/notificationData.dart';
import 'package:office_syndrome/setting/setting.dart';
import 'package:office_syndrome/video/video.dart';
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isOn = true;
  NotificationData data = NotificationData();
  @override
  void initState() {
    // _initNotification();
    NotificationService().init();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: colorPrimary),
      backgroundColor: Colors.white,
      bottomNavigationBar: _nextButton(),
      body: Column(
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
                  Container(
                    padding: EdgeInsets.only(left: 25, top: 25),
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SettingPage()),
                      ).then((onValue) {
                        setState(() {
                          data = onValue;
                          if (data.type == 1) {
                            //  _startTimer(3600);
                          } else if (data.type == 2) {
                            //  _startTimer(7200);
                          } else if (data.type == 3) {
                            NotificationService().cancelAll;
                            int sum =
                                (data.clock!.inHours * 60 * 60) +
                                (data.clock!.inMinutes * 60);
                            for (int i = 1; i <= data.time!; i++) {
                              _startTimer(sum * i, i);
                            }
                          } else if (data.type == 4) {
                            NotificationService().cancelAll;
                            NotificationService().scheduleDailyNotification(
                              data.date!,
                              1,
                            );
                          }
                        });
                      });
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
                              data.type != null
                                  ? data.text.toString()
                                  : 'เลือกเวลาการแจ้งเตือน',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: fontMitr,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 15, right: 15, top: 20),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'แจ้งเตือน',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: fontMitr,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Switch(
                          activeColor: Colors.white,
                          activeTrackColor: colorAccent,
                          value: isOn,
                          onChanged: (value) {
                            setState(() {
                              isOn = value;
                              if (!isOn) {
                                NotificationService().cancelAll;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 50, left: 30, right: 30),
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
}
