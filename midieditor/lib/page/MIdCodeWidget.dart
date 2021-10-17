import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midieditor/BaseConfig.dart';
import 'package:midieditor/base/StartWidget.dart';
import 'package:midieditor/tool/MidiCreate.dart';
import 'package:midieditor/util/PlayUtil.dart';
import 'package:midieditor/view/RoundButton.dart';
import 'package:midieditor/view/ToolBar.dart';
import 'package:path_provider/path_provider.dart';

class MidCodeWidget extends StartWidget {
  @override
  State<StatefulWidget> createState() {
    return _MidCodeWidgetState();
  }

}

class _MidCodeWidgetState extends StartState<MidCodeWidget> {
  TextEditingController controller_code = TextEditingController();
  String outpath = "";

  @override
  void initState() {
    
    super.initState();
    initDirs();
  }

    Future<void> initDirs() async {
    //获取各种目录
    //适配安卓11 List<Directory> dirs = await getExternalCacheDirectories();
    Directory dir = await getTemporaryDirectory();
    print("externalCacheDirectories ${dir}");
    BaseConfig.cacheDir = dir;
    if (Platform.isWindows) {
      BaseConfig.docDir = await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      BaseConfig.docDir = await getApplicationDocumentsDirectory();
    } else {
      Directory dir_doc = await getExternalStorageDirectory();

      BaseConfig.docDir = dir_doc;
    }

    if (BaseConfig.docDir == null) {
      BaseConfig.docDir = await getApplicationSupportDirectory();
    }
    print("docDir ${BaseConfig.docDir}");
    if (!BaseConfig.cacheDir.existsSync()) {
      BaseConfig.cacheDir.create();
    }
    if (!BaseConfig.docDir.existsSync()) {
      BaseConfig.docDir.create();
    }
    //解压mid到缓存
    var bytes = await rootBundle.load("assets/example.mid");

    writeToFile(bytes, BaseConfig.cacheDir.path + "/" + "example.mid");
    outpath = BaseConfig.cacheDir.path + "/" + 'output.mid';
  }

  //write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Widget itemName(String text){
    return Container(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Text(text),
    );
  }

  void win_playMidi(String filename) {

  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: ToolBar(
        backText: "代码转音乐",
        backTap: (){
          SystemNavigator.pop();
        },
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(children: [
          itemName("输入曲谱"),
          TextField(
            controller: controller_code,
            minLines: 5,
          ),
          SizedBox(width: 16,height: 16,),
          RoundButton(
            text: "转换",
            width: 300,
            height: 40,
            color: BaseConfig.colorAccent,
            onPressed: (){
              MidiCreate create = new MidiCreate();
              create.makeTextToMidi(controller_code.text, outpath);
              toast("转换成功");
            },
          ),
          SizedBox(width: 32,height: 32,),
          RoundButton(
            text: "播放",
            width: 300,
            height: 40,
            color: BaseConfig.colorAccent,
            onPressed: (){
              PlayUtil.playSoundWithPath(outpath);
            },
          ),
          SizedBox(width: 32,height: 32,),
          RoundButton(
            text: "试听当前行",
            width: 300,
            height: 40,
            color: BaseConfig.colorAccent,
            onPressed: (){

            },
          ),
          SizedBox(width: 32,height: 32,),
          Text("谱曲说明：")
        ],),
      ),
    );
    
  }
}
