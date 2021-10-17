import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer_plugin/musicplayer_plugin.dart';
import 'package:soundbrowser/base/BoxStartWidget.dart';
import 'package:soundbrowser/util/FileUtil.dart';

import '../BaseConfig.dart';

class MusicPlayerWidget extends BoxStartWdiget {
  @override
  State<StatefulWidget> createState() {
    return _MusicPlayerState();
  }
}

class _MusicPlayerState extends BoxStartState<MusicPlayerWidget> {
  TextEditingController controller = new TextEditingController();
  int musicid = 0;
  String play_cur = "";

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          TextField(
            controller: controller,
            style: TextStyle(
                fontSize: BaseConfig.font_h3, color: BaseConfig.textColor),
          ),
          TextButton(
              onPressed: () {
                MusicplayerPlugin.mciSendString(controller.text).then((value) {
                  print(value);
                  toast(value);
                });
              },
              child: Text("send")),
          TextButton(
              onPressed: () async {
                String filename = controller.text;
                if (filename.startsWith("assets/")) {
                  var bytes = await rootBundle.load(filename);
                  filename = "D:\\"+FileUtil.getName(filename);
                  await FileUtil.writeToFile(bytes, filename);
                }
                MusicplayerPlugin.playMusic(filename).then((value) {
                  print(value);
                  toast(value);
                  play_cur = value;
                });
              },
              child: Text("play")),
          TextButton(
              onPressed: () {
                MusicplayerPlugin.stopMusic(play_cur);
              },
              child: Text("stop")),
          TextButton(
              onPressed: () async {
                await MusicplayerPlugin.stopMusic(play_cur);
                MusicplayerPlugin.playMusic(controller.text).then((value) {
                  print(value);
                  toast(value);
                  play_cur = value;
                });
              },
              child: Text("replay")),
          TextButton(
              onPressed: () async {
                toast("录音");
                await MusicplayerPlugin.recvBit("16");
                await MusicplayerPlugin.recvStart("D:\\test.wav");
              },
              child: Text("录音")),
          TextButton(
              onPressed: () async {
                toast("停止录音");
                await MusicplayerPlugin.recvStop();
              },
              child: Text("停止录音")),
        ],
      ),
    );
  }
}
