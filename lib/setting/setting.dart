import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome/helper/app_controller.dart';
import 'package:office_syndrome/helper/colors.dart';
import 'package:office_syndrome/helper/notificationService.dart';
import 'package:office_syndrome/helper/preferences_helper.dart';
import 'package:office_syndrome/model/notificationData.dart';

class SettingPage extends StatefulWidget {
  int type;
  int index;
  dynamic data;
  SettingPage(this.type, this.index, this.data, {super.key});
  createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isWarningOn = false;
  bool isClockWarningOn = false;
  bool onSelectTimeButton = false;
  bool onSelectOneTimeButton = false;
  bool onSelectTwoTimeButton = false;
  int _value = 1;
  NotificationData data = NotificationData();

  @override
  void initState() {
    data.isAdd = widget.type;
    data.index = widget.index;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorPrimary,
        actions: [
          widget.type == 1
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    NotificationService().cancelID(widget.data.id!);
                    deleteNotificationData(widget.index);
                    getNotificationData();
                    data.isAdd = 3;
                    Navigator.pop(context, data);
                  },
                )
              : Container(),
        ],
      ),
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
                          'ตั้งเวลา',
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
                          'การแจ้งเตือน',
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
                  children: [_warningButton(), _timeButton()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _twoHourButton() {
    return InkWell(
      onTap: () {
        setState(() {
          onSelectTwoTimeButton = true;
          onSelectOneTimeButton = false;
          onSelectTimeButton = false;
          data.text = 'ทุก 2 ชั่วโมง';
          data.type = 2;
          data.time = 12;
          data.clock = Duration(seconds: 7200);
          data.date = DateTime.now();
        });
      },
      child: Container(
        color: onSelectTwoTimeButton ? colorPrimaryBg : Colors.white,
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.6,
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'ทุก 2 ชั่วโมง',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: fontMitr,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.black12,
              margin: EdgeInsets.only(top: 5),
            ),
          ],
        ),
      ),
    );
  }

  void _increment() {
    setState(() {
      if (_value <= 29) {
        _value++;
      }
      data.time = _value;
      data.text =
          "แจ้งเตือน :  " +
          "${selectedTime.inHours.toString().padLeft(2, '0')}:"
              "${(selectedTime.inMinutes % 60).toString().padLeft(2, '0')}"
              " นาที  " +
          data.time.toString() +
          " ครั้ง";
    });
  }

  void _decrement() {
    setState(() {
      if (_value > 1) _value--; // กันไม่ให้ติดลบ.
      data.time = _value;
      data.text =
          "แจ้งเตือน :  " +
          "${selectedTime.inHours.toString().padLeft(2, '0')}:"
              "${(selectedTime.inMinutes % 60).toString().padLeft(2, '0')}"
              " นาที  " +
          data.time.toString() +
          " ครั้ง";
    });
  }

  Widget _CountNumber() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline, size: 30),
          onPressed: _decrement,
        ),
        SizedBox(width: 10),
        Text('$_value', style: TextStyle(fontSize: 18)),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.add_circle_outline, size: 30),
          onPressed: _increment,
        ),
      ],
    );
  }

  DateTime selectedClock = DateTime.now();
  Widget _selectClockButton() {
    return InkWell(
      onTap: () {
        setState(() {
          onSelectTwoTimeButton = false;
          onSelectOneTimeButton = true;
          onSelectTimeButton = false;
        });
      },
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: CupertinoDatePicker(
              key: UniqueKey(),
              mode: CupertinoDatePickerMode.time,
              use24hFormat: true,
              initialDateTime: DateTime.now(),
              backgroundColor: Colors.transparent,
              onDateTimeChanged: (DateTime date) {
                // setState(() {
                selectedClock = date;
                data.text =
                    "แจ้งเตือนเวลา " +
                    "${selectedClock.hour.toString().padLeft(2, '0')}:"
                        "${(selectedClock.minute % 60).toString().padLeft(2, '0')}"
                        "  น. ";
                data.type = 4;
                data.time = 0;
                data.date = selectedClock;
                //   });
              },
            ),
          ),
          SizedBox(height: 20),
          // Text(
          //   "แจ้งเตือนเวลา : " +
          //       "${selectedClock.hour.toString().padLeft(2, '0')}:"
          //           "${(selectedClock.minute % 60).toString().padLeft(2, '0')}:"
          //       "  น. ",
          //   style: TextStyle(
          //     color: Colors.black,
          //     fontFamily: fontMitr,
          //     fontSize: 22,
          //   ),
          // ),
        ],
      ),
    );
  }

  Duration selectedTime = Duration(hours: 0, minutes: 0, seconds: 0);
  Widget _selectTimeButton() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                onSelectTwoTimeButton = false;
                onSelectOneTimeButton = false;
                onSelectTimeButton = !onSelectTimeButton;
              });
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 50),
                    child: Text(
                      'กำหนดเวลา',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: fontMitr,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(
                      !onSelectTimeButton
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),

          onSelectTimeButton
              ? Column(
                  children: [
                    Text(
                      "แจ้งเตือนทุก :  " +
                          "${selectedTime.inHours.toString().padLeft(2, '0')}:"
                              "${(selectedTime.inMinutes % 60).toString().padLeft(2, '0')}"
                              " นาที",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: fontMitr,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 150,
                      child: CupertinoTimerPicker(
                        mode:
                            CupertinoTimerPickerMode.hm, // hour, minute, second
                        initialTimerDuration: selectedTime,
                        onTimerDurationChanged: (Duration newTime) {
                          setState(() {
                            selectedTime = newTime;
                            data.time = _value;
                            data.text =
                                "แจ้งเตือน :  " +
                                "${selectedTime.inHours.toString().padLeft(2, '0')}:"
                                    "${(selectedTime.inMinutes % 60).toString().padLeft(2, '0')}"
                                    " นาที  " +
                                data.time.toString() +
                                " ครั้ง";

                            data.type = 3;
                            data.clock = newTime;
                            data.date = DateTime.now();
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'จำนวน',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: fontMitr,
                            fontSize: 18,
                          ),
                        ),
                        _CountNumber(),
                        Text(
                          'ครั้ง',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: fontMitr,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Container(),

          Container(
            height: 1,
            color: Colors.black12,
            margin: EdgeInsets.only(top: 5),
          ),
        ],
      ),
    );
  }

  Widget _oneHourButton() {
    return InkWell(
      onTap: () {
        setState(() {
          onSelectTwoTimeButton = false;
          onSelectOneTimeButton = true;
          onSelectTimeButton = false;
          data.text = 'ทุก 1 ชั่วโมง';
          data.type = 1;
          data.time = 12;
          data.clock = Duration(seconds: 3600);
          data.date = DateTime.now();
        });
      },
      child: Container(
        color: onSelectOneTimeButton ? colorPrimaryBg : Colors.white,
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.6,
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'ทุก 1 ชั่วโมง',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: fontMitr,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.black12,
              margin: EdgeInsets.only(top: 5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _warningButton() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isWarningOn = !isWarningOn;
              isClockWarningOn = false;
            });
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'แจ้งเตือนซ้ำ',
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
                    !isWarningOn
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: Colors.black12,
          margin: EdgeInsets.only(top: 5),
        ),
        isWarningOn
            ? Column(
                children: [
                  _oneHourButton(),
                  _twoHourButton(),
                  //_selectTimeButton(),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget _timeButton() {
    return InkWell(
      onTap: () {
        setState(() {
          isClockWarningOn = !isClockWarningOn;
          isWarningOn = false;
          onSelectTwoTimeButton = false;
          onSelectOneTimeButton = false;
          onSelectTimeButton = false;

          data.text =
              "แจ้งเตือนเวลา " +
              "${selectedClock.hour.toString().padLeft(2, '0')}:"
                  "${(selectedClock.minute % 60).toString().padLeft(2, '0')}"
                  "  น. ";
          data.type = 4;
          data.time = 0;
          data.clock = Duration(seconds: 7200);

          data.date = selectedClock;
        });
      },
      child: Column(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'แจ้งเตือนตามเวลา',
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
                    !isClockWarningOn
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.black12,
            margin: EdgeInsets.only(top: 5),
          ),
          SizedBox(height: 20),
          isClockWarningOn ? _selectClockButton() : Container(),
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
          backgroundColor:
              isClockWarningOn ||
                  ((selectedTime.inHours > 0 || selectedTime.inMinutes > 0)) ||
                  onSelectOneTimeButton ||
                  onSelectTwoTimeButton
              ? colorAccent
              : Colors.black12, //background color of button
          side: BorderSide(width: 1, color: Color.fromARGB(255, 203, 202, 202)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          if (widget.type == 1) {
            NotificationService().cancelID(widget.data.id!);
            deleteNotificationData(widget.index);
          }
          Navigator.pop(context, data);
        },
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            'บันทึก',
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
