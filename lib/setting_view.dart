import 'package:alarm/alarm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:office_syndrome/helper/app_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  TextEditingController _dateController = TextEditingController();
  bool isOn = false;
  List<bool> isSelected = [true, false];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryBg,
      appBar: AppBar(
        elevation: 0,
        actionsIconTheme: IconThemeData(color: colorPrimary),
        iconTheme: IconThemeData(color: color_gray_text),
        title: Text(
          'setting'.tr(),
          style: TextStyle(
            color: color_gray_text,
            fontFamily: fontMitr,
            fontSize: 18,
          ),
        ),
        backgroundColor: colorPrimary,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          cardTermView(),
          SizedBox(height: 5),
          cardNotificationView(),
        ],
      ),
    );
  }

  Future<void> _openLink() async {
    final Uri url = Uri.parse('https://www.termsfeed.com/live/77c7612f-e8c9-4c19-9d5e-c8ad0586848e');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  cardTermView() {
    return InkWell(
      onTap: () {
       _openLink();
      },
      child: Container(
        height: 60,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              width: 1,
              color: const Color.fromARGB(255, 72, 72, 72),
            ),
          ),
          margin: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'ข้อกำหนดและเงื่อนไขการใช้งาน',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: fontMitr,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.arrow_forward_ios, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  cardNotificationView() {
    return InkWell(
      onTap: () {
        Alarm.stopAll();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => CardSelectPage(1)),
        // );
      },
      child: Container(
        height: 60,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              width: 1,
              color: const Color.fromARGB(255, 72, 72, 72),
            ),
          ),
          margin: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'เปิดการแจ้งเตือน',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: fontMitr,
                    fontSize: 16,
                  ),
                ),
              ),
              Switch(
                value: isOn,
                onChanged: (value) {
                  setState(() {
                    isOn = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
