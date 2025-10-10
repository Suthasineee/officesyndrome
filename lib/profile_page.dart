import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:office_syndrome/helper/app_controller.dart';
import 'package:office_syndrome/helper/colors.dart';
import 'package:office_syndrome/helper/preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? _picked;
  final picker = ImagePicker();

  Future<void> _pickFromGallery() async {
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x == null) return;

    setState(() {
      _picked = x;
      //  saveImg(file.toString());
    });

    final bytes = await x.readAsBytes();
    final b64 = base64Encode(bytes); // => string
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, b64);

    setState(() => _b64 = b64);
  }

  static const _prefsKey = 'profile_image_b64';
  String? _b64; // เก็บเป็น base64

  Future<void> _loadB64() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _b64 = prefs.getString(_prefsKey));
  }

  var name = "";
  @override
  void initState() {
    _loadB64();
    getData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getData() async {
    name = await getName();
    setState(() {});
  }

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final imgWidget = (_b64 == null)
        ? const Icon(Icons.account_circle, size: 120, color: Colors.grey)
        : ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.memory(
              base64Decode(_b64!),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          );

    return Scaffold(
      appBar: AppBar(title: Text("โปรไฟล์"), backgroundColor: colorPrimary),
      backgroundColor: colorPrimary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.sizeOf(context).width,
            color: colorPrimary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                imgWidget,
                ElevatedButton(
                  onPressed: _pickFromGallery,
                  child: Text("อัปโหลด"),
                ),
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
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: name == "" ? 'ชื่อ' : name,
                          hintText: 'ชื่อ',
                          prefixIcon: const Icon(Icons.person),
                          suffixIcon: controller.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () =>
                                      setState(() => controller.clear()),
                                  icon: const Icon(Icons.clear),
                                ),
                          border: const OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.done,
                        onChanged: (_) =>
                            setState(() {}), // เพื่อโชว์/ซ่อนปุ่มล้าง
                        onSubmitted: (v) => setState(() {
                          saveName(v);
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
