import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome/helper/app_controller.dart';
import 'package:office_syndrome/helper/colors.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  int id;
  VideoPage(this.id);
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool isWarningOn = false;
  bool isClockWarningOn = false;
  bool isTimeOn = false;
  bool onSelectTimeButton = false;
  bool onSelectOneTimeButton = false;
  bool onSelectTwoTimeButton = false;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/simple.mp4")
      ..initialize().then((_) {
        setState(() {});
        if (widget.id != -1) {
          // refresh หลังโหลดเสร็จ
          // _controller.play();
        } // เริ่มเล่นอัตโนมัติ
      });

    Alarm.stop(widget.id);
  }

  String _format(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size videoSize = _controller.value.size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorPrimary,
        title: Text(
          'ถึงเวลาขยับร่างกาย',
          style: TextStyle(
            color: Colors.black,
            fontFamily: fontMitr,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Colors.white,

      //bottomNavigationBar: _nextButton(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _controller.value.isPlaying
      //           ? _controller.pause()
      //           : _controller.play();
      //     });
      //   },
      //   child: Icon(
      //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //   ),
      // ),
      body: _controller.value.isInitialized
          ? Stack(
              fit: StackFit.expand,
              children: [
                ClipRect(
                  // กันล้นขอบจอ
                  child: FittedBox(
                    fit: BoxFit.cover, // <— สำคัญ: ครอปให้เต็มจอ
                    alignment: Alignment
                        .topCenter, // เปลี่ยนเป็น .topCenter / .bottomCenter ได้
                    child: SizedBox(
                      width: videoSize.width,
                      height: videoSize.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.65,
                    // ),
                    // ปุ่มเล่น/หยุด
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(46),
                          topRight: Radius.circular(46),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _controller.value.volume == 0
                                      ? Icons.volume_off
                                      : Icons.volume_up,
                                  size: 30,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_controller.value.volume == 0) {
                                      _controller.setVolume(1); // unmute
                                    } else {
                                      _controller.setVolume(0); // mute
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 30,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.replay_10, size: 30),
                                onPressed: () async {
                                  final pos =
                                      _controller.value.position -
                                      const Duration(seconds: 10);
                                  await _controller.seekTo(
                                    pos < Duration.zero ? Duration.zero : pos,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.forward_10, size: 30),
                                onPressed: () async {
                                  final d = _controller.value.duration;
                                  final pos =
                                      _controller.value.position +
                                      const Duration(seconds: 10);
                                  await _controller.seekTo(pos > d ? d : pos);
                                },
                              ),
                            ],
                          ),
                          // ใช้ AnimatedBuilder เพื่ออัปเดตเวลาบน UI ตาม controller
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) {
                              final duration = _controller.value.duration;
                              final position = _controller.value.position;
                              final remaining = duration - position;

                              // ป้องกันค่า Slider เกินช่วง
                              final max = duration.inMilliseconds
                                  .toDouble()
                                  .clamp(0, double.infinity);
                              final value = position.inMilliseconds
                                  .clamp(0, duration.inMilliseconds)
                                  .toDouble();

                              return Column(
                                children: [
                                  // Slider ที่ลากเลื่อนได้
                                  Slider(
                                    value: max == 0 ? 0 : value,
                                    min: 0,
                                    max: (max.toDouble() == 0)
                                        ? 1
                                        : max.toDouble(),
                                    onChanged: (v) {
                                      _controller.seekTo(
                                        Duration(milliseconds: v.toInt()),
                                      );
                                    },
                                  ),

                                  // แถบ progress มาตรฐาน (มี buffered สีเทา) + ลากได้
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 12),
                                  //   child: VideoProgressIndicator(
                                  //     _controller,
                                  //     allowScrubbing: true,
                                  //     padding: const EdgeInsets.symmetric(vertical: 6),
                                  //     colors: VideoProgressColors(
                                  //       playedColor: Colors.blue,
                                  //       bufferedColor: Colors.grey,
                                  //       backgroundColor: Colors.black12,
                                  //     ),
                                  //   ),
                                  // ),

                                  // แถวตัวเลขเวลา: current / total (remaining)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_format(position)), // current
                                        Text(
                                          '${_format(duration)}',
                                        ), // total + remaining
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          // const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => TellerDetailPage(),
          //   ),
          // );
        },
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            'ปิด',
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
