import 'package:flutter/material.dart';
import 'package:office_syndrome/helper/app_controller.dart';
import 'package:office_syndrome/helper/colors.dart';
import 'package:office_syndrome/home/home.dart';

class GuildPage extends StatefulWidget {
  @override
  _GuildPageState createState() => _GuildPageState();
}

class _GuildPageState extends State<GuildPage> {
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
        elevation: 0,
        backgroundColor: colorPrimary,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20, top: 20),
              child: Text(
                'ถัดไป',
                style: TextStyle(
                  color: colorPrimaryDark,
                  fontFamily: fontMitr,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 10),
                color: colorPrimary,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.5,
                child: Image.asset(
                  'assets/image/guild.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 0),
                child: Text(
                  'OFFICE',
                  style: TextStyle(
                    color: colorPrimaryDark,
                    fontSize: 45,
                    fontFamily: fontMitr,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 45),
                child: Text(
                  'SYNDROME',
                  style: TextStyle(
                    color: colorPrimaryDark,
                    fontSize: 45,
                    fontFamily: fontMitr,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 0),
                child: Text(
                  'ป้องกัน',
                  style: TextStyle(
                    color: colorPrimaryDark,
                    fontSize: 30,
                    fontFamily: fontMitr,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 35),
                child: Text(
                  'ออฟฟิตซินโดรม',
                  style: TextStyle(
                    color: colorPrimaryDark,
                    fontSize: 30,
                    fontFamily: fontMitr,
                    fontWeight: FontWeight.w300,
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
