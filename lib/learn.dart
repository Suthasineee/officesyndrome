import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:office_syndrome/helper/app_controller.dart';
import 'package:office_syndrome/helper/colors.dart';
import 'package:office_syndrome/helper/preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearnPage extends StatefulWidget {
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  List<String> text = [
    """ท่าเอียงคอ เอียงศีรษะไปด้านซ้ายพร้อมใช้มือช่วยกดเบาๆ ให้รู้สึกตึงที่ต้นคอ  ควรทำท่าละ 10-15 วินาที """,
    """ท่าเอียงคอ เอียงศีรษะไปด้านขวาพร้อมใช้มือช่วยกดเบาๆ ให้รู้สึกตึงที่ต้นคอ  ควรทำท่าละ 10-15 วินาที """,

    """ ยกแขนข้างหนึ่งขึ้นเหนือศีรษะ แล้วงอข้อศอก จนฝ่ามือแตะบริเวณหลัง.
ใช้มืออีกข้างหนึ่งเอื้อมมาจับข้อศอก แล้วค่อยๆ ดึงข้อศอกเบาๆ เพื่อเพิ่มแรงตึง.
ค้างไว้ 15-20 วินาที""",
    """ยืนหลังตรง มือทั้งสองข้างจับกันไว้ด้านหลังลำตัว
ค่อย ๆ เหยียดแขนไปด้านหลัง และเปิดหน้าอกขึ้น
รู้สึกถึงการยืดที่บริเวณหน้าอกและหัวไหล่
ค้างไว้ประมาณ 15–30 วินาที แล้วผ่อนคลาย""",

    """ ยืนหรือนั่งหลังตรง ผ่อนคลายไหล่
เหยียดแขนขวาตรงออกไปด้านหน้า
ใช้มือซ้ายจับแขนขวาแล้วดึงเข้าหาลำตัว (ให้รู้สึกตึงบริเวณหัวไหล่ขวา)
ค้างไว้ประมาณ 15–30 วินาที """,
    """
ยืนหรือนั่งหลังตรง ผ่อนคลายไหล่
เหยียดแขนซ้ายตรงออกไปด้านหน้า
ใช้มือขวาจับแขนขวาแล้วดึงเข้าหาลำตัว (ให้รู้สึกตึงบริเวณหัวไหล่ซ้าย)
ค้างไว้ประมาณ 15–30 วินาที""",
  ];
  int i = 0;
  int _seconds = 12; // เริ่มจาก 10 วินาที
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 1) {
        setState(() {
          _seconds--;
        });
      } else {
        _seconds = 12;
        if (i < text.length - 1) {
          i++;
        } else {
          timer.cancel(); // หยุดเมื่อครบ
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ท่ายืดออกกำลังกาย",
          style: TextStyle(
            color: Colors.black,
            fontFamily: fontMitr,
            fontSize: 22,
          ),
        ),
        backgroundColor: colorPrimary,
      ),
      //  backgroundColor: colorPrimary,
      body: Column(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _seconds == 12 ? start() : Container(),
                view(),
                detail(),
                SizedBox(height: 50),
                _seconds < 12
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: CircularProgressIndicator(
                              strokeWidth: 10,
                              backgroundColor: Colors.grey.shade300,
                              color: Colors.blueAccent,
                            ),
                          ),
                          Text(
                            _seconds.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: fontMitr,
                              fontSize: 60,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detail() {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
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
            margin: EdgeInsets.all(15),
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: Text(
              text[i],
              style: TextStyle(
                color: Colors.black,
                fontFamily: fontMitr,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget start() {
    return InkWell(
      onTap: () async {
        startTimer();
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.only(left: 15, right: 15, top: 40),
        decoration: BoxDecoration(
          color: colorPrimary,
          border: Border.all(
            color: Colors.black26, // สีขอบ
            width: 1.0, // ความหนาของเส้น
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'เริ่ม',
              style: TextStyle(
                color: Colors.black,
                fontFamily: fontMitr,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget view() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        i > 0
            ? InkWell(
                onTap: () async {
                  setState(() {
                    i--;
                    _seconds = 12;
                  });
                },
                child: Icon(Icons.arrow_back, color: Colors.black),
              )
            : Container(),
        Container(
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black26, // สีขอบ
                width: 1.0, // ความหนาของเส้น
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  //height: MediaQuery.sizeOf(context).height * 0.5,
                  child: Image.asset(
                    'assets/image/' + (i + 1).toString() + '.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
        i < text.length - 1
            ? InkWell(
                onTap: () async {
                  setState(() {
                    i++;
                  });
                },
                child: Icon(Icons.arrow_forward, color: Colors.black),
              )
            : Container(),
      ],
    );
  }
}
