import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:office_syndrome/helper/app_controller.dart';
import 'package:office_syndrome/helper/colors.dart';
import 'package:office_syndrome/helper/preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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
      appBar: AppBar(
        title: Text(
          "รักษาออฟฟิตซินโดรม",
          style: TextStyle(
            color: Colors.black,
            fontFamily: fontMitr,
            fontSize: 22,
          ),
        ),
        backgroundColor: colorPrimary,
      ),
      //  backgroundColor: colorPrimary,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: <Widget>[
              SizedBox(height: 20),
              Row(children: [button4(), button2()]),
              Row(children: [button3(), button()]),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openLink(String u) async {
    final Uri url = Uri.parse(u);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Widget button() {
    return InkWell(
      onTap: () async {
        _openLink(
          'https://www.google.com/maps/place/%E0%B8%A2%E0%B8%B9%E0%B8%99%E0%B8%B4%E0%B8%84%E0%B9%81%E0%B8%84%E0%B8%A3%E0%B9%8C%E0%B8%AA%E0%B9%80%E0%B8%95%E0%B8%8A%E0%B8%B1%E0%B8%99+%E0%B8%AA%E0%B8%B2%E0%B8%82%E0%B8%B2%E0%B8%97%E0%B9%88%E0%B8%B2%E0%B8%9E%E0%B8%A3%E0%B8%B0+%E0%B8%84%E0%B8%A5%E0%B8%B4%E0%B8%99%E0%B8%B4%E0%B8%81%E0%B8%81%E0%B8%B2%E0%B8%A2%E0%B8%A0%E0%B8%B2%E0%B8%9E%E0%B8%9A%E0%B8%B3%E0%B8%9A%E0%B8%B1%E0%B8%94/@13.723751,100.4451326,15z/data=!4m9!1m2!2m1!1z4Lij4Lix4LiB4Lip4LiyIOC4reC4reC4n-C4n-C4tOC4qOC4i-C4tOC4meC5guC4lOC4o-C4oQ!3m5!1s0x30e299d913c7c74d:0xc013946811115b4b!8m2!3d13.7237512!4d100.4631566!16s%2Fg%2F11vxm5vljl?entry=ttu&g_ep=EgoyMDI1MTAwNC4wIKXMDSoASAFQAw%3D%3D',
        );
      },
      child: Container(
        height: 180,
        width: 180,
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black26, // สีขอบ
            width: 1.0, // ความหนาของเส้น
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.pin_drop, color: Colors.grey, size: 50),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  margin: EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ยูนิคแคร์สเตชัน สาขาท่าพระ คลินิกกายภาพบำบัด',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: fontMitr,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget button4() {
    return InkWell(
      onTap: () async {
        _openLink(
          'https://www.google.com/maps/search/%E0%B8%A3%E0%B8%B1%E0%B8%81%E0%B8%A9%E0%B8%B2+%E0%B8%AD%E0%B8%AD%E0%B8%9F%E0%B8%9F%E0%B8%B4%E0%B8%A8%E0%B8%8B%E0%B8%B4%E0%B8%99%E0%B9%82%E0%B8%94%E0%B8%A3%E0%B8%A1/@13.778672,100.4579826,15z?entry=ttu&g_ep=EgoyMDI1MTAwNC4wIKXMDSoASAFQAw%3D%3D',
        );
      },
      child: Container(
        height: 180,
        width: 180,
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black26, // สีขอบ
            width: 1.0, // ความหนาของเส้น
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.pin_drop, color: Colors.grey, size: 50),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  margin: EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'รัชตกายา คลินิกกายภาพบำบัด สาขาเซ็นทรัลปิ่นเกล้า',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: fontMitr,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget button3() {
    return InkWell(
      onTap: () async {
        _openLink(
          'https://www.google.com/maps/place/InterRehab+Brain%26Pain+Total+Office+Syndrome+Solution+%E0%B8%AA%E0%B8%B2%E0%B8%82%E0%B8%B2%E0%B8%AD%E0%B9%82%E0%B8%A8%E0%B8%81+-+%E0%B8%84%E0%B8%A5%E0%B8%B4%E0%B8%99%E0%B8%B4%E0%B8%81%E0%B9%80%E0%B8%89%E0%B8%9E%E0%B8%B2%E0%B8%B0%E0%B8%97%E0%B8%B2%E0%B8%87%E0%B8%A3%E0%B8%B1%E0%B8%81%E0%B8%A9%E0%B8%B2%E0%B8%AD%E0%B8%AD%E0%B8%9F%E0%B8%9F%E0%B8%B4%E0%B8%A8%E0%B8%8B%E0%B8%B4%E0%B8%99%E0%B9%82%E0%B8%94%E0%B8%A3%E0%B8%A1+%E0%B9%80%E0%B8%84%E0%B8%A3%E0%B8%B5%E0%B8%A2%E0%B8%94%E0%B8%AA%E0%B8%B0%E0%B8%AA%E0%B8%A1+%E0%B8%99%E0%B8%AD%E0%B8%99%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%AB%E0%B8%A5%E0%B8%B1%E0%B8%9A/@13.7312905,100.5421188,15z/data=!4m10!1m2!2m1!1z4Lij4Lix4LiB4Lip4LiyIOC4reC4reC4n-C4n-C4tOC4qOC4i-C4tOC4meC5guC4lOC4o-C4oQ!3m6!1s0x30e29f8d492df527:0x2bb68ca240c336b2!8m2!3d13.7312905!4d100.5601432!15sCjfguKPguLHguIHguKnguLIg4Lit4Lit4Lif4Lif4Li04Lio4LiL4Li04LiZ4LmC4LiU4Lij4LihWj0iO-C4o-C4seC4geC4qeC4siDguK3guK3guJ_guJ_guLTguKgg4LiL4Li0IOC4mSDguYLguJTguKMg4LihkgESc3BlY2lhbGl6ZWRfY2xpbmljmgEgQ2hSRFNVaE5NRzluUzBWSlEwRm5TVVExWjNZNGVCQUKqAaUBEAEqPyI74Lij4Lix4LiB4Lip4LiyIOC4reC4reC4n-C4n-C4tOC4qCDguIvguLQg4LiZIOC5guC4lOC4oyDguKEoNTIfEAEiG2rtsoCGnp3DuaDAb0TpIU3GWCR0vxwu6J-MlDI_EAIiO-C4o-C4seC4geC4qeC4siDguK3guK3guJ_guJ_guLTguKgg4LiL4Li0IOC4mSDguYLguJTguKMg4Lih4AEA-gEECEwQTw!16s%2Fg%2F11t833yzxq?entry=ttu&g_ep=EgoyMDI1MTAwNC4wIKXMDSoASAFQAw%3D%3D',
        );
      },
      child: Container(
        height: 180,
        width: 180,
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black26, // สีขอบ
            width: 1.0, // ความหนาของเส้น
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
               child: Icon(Icons.pin_drop, color: Colors.grey, size: 50),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  margin: EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'คลินิกเฉพาะทางรักษาออฟฟิศซินโดรม เครียดสะสม นอนไม่หลับ',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: fontMitr,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget button2() {
    return InkWell(
      onTap: () async {
        _openLink(
          'https://www.google.com/maps/place/%E0%B9%80%E0%B8%A7%E0%B8%8A%E0%B8%81%E0%B8%B2%E0%B8%A2%E0%B8%B2%E0%B8%84%E0%B8%A5%E0%B8%B4%E0%B8%99%E0%B8%B4%E0%B8%81+%E0%B8%88%E0%B8%A3%E0%B8%B1%E0%B8%8D%E0%B8%AA%E0%B8%99%E0%B8%B4%E0%B8%97%E0%B8%A7%E0%B8%87%E0%B8%A8%E0%B9%8C+(%E0%B8%84%E0%B8%A5%E0%B8%B4%E0%B8%99%E0%B8%B4%E0%B8%81%E0%B8%A3%E0%B8%B1%E0%B8%81%E0%B8%A9%E0%B8%B2%E0%B8%AD%E0%B8%AD%E0%B8%9F%E0%B8%9F%E0%B8%B4%E0%B8%A8%E0%B8%8B%E0%B8%B4%E0%B8%99%E0%B9%82%E0%B8%94%E0%B8%A3%E0%B8%A1+%E0%B8%9B%E0%B8%A7%E0%B8%94+%E0%B8%95%E0%B8%B6%E0%B8%87+%E0%B8%8A%E0%B8%B2+%E0%B9%84%E0%B8%A1%E0%B9%80%E0%B8%81%E0%B8%A3%E0%B8%99+%E0%B8%81%E0%B8%A3%E0%B8%B0%E0%B8%94%E0%B8%B9%E0%B8%81%E0%B8%97%E0%B8%B1%E0%B8%9A%E0%B9%80%E0%B8%AA%E0%B9%89%E0%B8%99)/@13.7470132,100.4522488,15z/data=!4m10!1m2!2m1!1z4Lij4Lix4LiB4Lip4LiyIOC4reC4reC4n-C4n-C4tOC4qOC4i-C4tOC4meC5guC4lOC4o-C4oQ!3m6!1s0x30e299ec87d2a35f:0x35d5a0fdfb743e38!8m2!3d13.7470132!4d100.4702732!15sCjfguKPguLHguIHguKnguLIg4Lit4Lit4Lif4Lif4Li04Lio4LiL4Li04LiZ4LmC4LiU4Lij4LihWj0iO-C4o-C4seC4geC4qeC4siDguK3guK3guJ_guJ_guLTguKgg4LiL4Li0IOC4mSDguYLguJTguKMg4LihkgEObWVkaWNhbF9jbGluaWOaAURDaTlEUVVsUlFVTnZaRU5vZEhsalJqbHZUMnhHY1dRelVqRmFhM2d5VmtWNFJrMHdjRVppYTNCUVlteEZOVk5IWXhBQqoBpQEQASo_IjvguKPguLHguIHguKnguLIg4Lit4Lit4Lif4Lif4Li04LioIOC4i-C4tCDguJkg4LmC4LiU4LijIOC4oSg1Mh8QASIbau2ygIaencO5oMBvROkhTcZYJHS_HC7on4yUMj8QAiI74Lij4Lix4LiB4Lip4LiyIOC4reC4reC4n-C4n-C4tOC4qCDguIvguLQg4LiZIOC5guC4lOC4oyDguKHgAQD6AQQIABAg!16s%2Fg%2F11ygg910mx?entry=ttu&g_ep=EgoyMDI1MTAwNC4wIKXMDSoASAFQAw%3D%3D',
        );
      },
      child: Container(
        height: 180,
        width: 180,
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black26, // สีขอบ
            width: 1.0, // ความหนาของเส้น
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.pin_drop, color: Colors.grey, size: 50),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  margin: EdgeInsets.only(right: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'เวชกายาคลินิก จรัญสนิทวงศ์ (คลินิกรักษาออฟฟิศซินโดรม',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: fontMitr,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
