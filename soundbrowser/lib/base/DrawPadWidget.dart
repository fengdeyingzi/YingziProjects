import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_save/image_save.dart';
import 'package:kolor_picker/kolor_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/cmd/process_cmd.dart';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/shell_run.dart';
import 'package:share_extend/share_extend.dart';
import 'package:soundbrowser/base/BoxStartWidget.dart';
import 'package:soundbrowser/page/DrawWidget.dart';
import 'package:soundbrowser/util/FileUtil.dart';


import '../BaseConfig.dart';

class DrawPadWidget extends BoxStartWdiget {
  @override
  State<StatefulWidget> createState() {
    return _DrawPadState();
  }
}

class _DrawPadState extends BoxStartState<DrawPadWidget> {
  List<DrawItem> list_points = [];
  int color = 0xff202020;
  int backgroundColor = 0xffffffff;
  double width = 2;
  DrawItem drawItem_cur;
  GlobalKey rootWidgetKey = GlobalKey();

  @override
  void initState() {
    drawItem_cur = new DrawItem();
    initDirs();
    super.initState();
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
  }

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          rootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }



  Future<bool> saveImage(Uint8List data, String path) async {
//    File file = new File(path);
    // Save to album.
    if (data == null) toast("截图失败");
    await new File(path).writeAsBytes(data);

    return true;
  }

  Future<int> win_shareFile(String filename) async {
    bool runInShell = Platform.isWindows;
    filename = filename.replaceAll("/", "\\");
    try {
      ProcessCmd cmd = processCmd('explorer.exe', ['/select,' + filename],
          runInShell: runInShell);
      await runCmd(cmd); //, stdin: stdin, stdout: stdout);
    } on ShellException catch (e) {
      print(e.toString());
    }

    return 0;
  }

///........
  void showPanSizeDialog() {
    // raise the [showDialog] widget
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a size!'),
          content: Row(children: [
            getPanSizeDialog(4, onPressed: (){
              width = 4;
              Navigator.of(context).pop();
            }),
            getPanSizeDialog(6, onPressed: (){
              width = 6;
              Navigator.of(context).pop();
            }),
            getPanSizeDialog(8, onPressed: (){
              width = 8;
              Navigator.of(context).pop();
            }),
            getPanSizeDialog(12, onPressed: (){
              width = 12;
              Navigator.of(context).pop();
            }),
            getPanSizeDialog(16, onPressed: (){
              width = 16;
              Navigator.of(context).pop();
            })
          ],),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                // setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //获取一个指定大小的圆
  Widget getPanSizeDialog(double size,{VoidCallback onPressed}){
    return Container(width: 32,height: 32,alignment: Alignment.center, child: 
    IconButton(
      
      icon: Container(width: size,height: size,
      decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(size/2))),
      ), onPressed: () {
if(onPressed!=null){
  onPressed();
}
        },
    ),);
  }

  void showColorPicker() {
    // raise the [showDialog] widget
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Color(color),
              onColorChanged: (changeColor) {
                color  = changeColor.value;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                // setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showColorPickerBackground() {
    // raise the [showDialog] widget
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Color(backgroundColor),
              onColorChanged: (changeColor) {
backgroundColor  = changeColor.value;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                // setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
              child: GestureDetector(
                  onPanDown: (event) {
                    print("onPanDown");
                    drawItem_cur = DrawItem();
                    drawItem_cur.draw_type = 1;
                    drawItem_cur.color = color;
                    drawItem_cur.size = width;
                    drawItem_cur.list = [];
                    drawItem_cur.list.add(
                        Point(event.localPosition.dx, event.localPosition.dy));
                    list_points.add(drawItem_cur);
                  },
                  onPanCancel: () {},
                  onPanStart: (event) {
                    print("onPanStart");
                  },
                  onPanUpdate: (event) {
                    print("onPanUpdate" + event.localPosition.dx.toString());
                    drawItem_cur.list.add(
                        Point(event.localPosition.dx, event.localPosition.dy));
                    setState(() {});
                  },
                  onPanEnd: (event) {},
                  child: RepaintBoundary(
                      key: rootWidgetKey,
                      child: DrawWidget(list_points, Color(backgroundColor))))),
          
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    list_points = [];
                    setState(() {});
                  },
                  child: Text("清除")),
              TextButton(
                  onPressed: () {
                    showColorPicker();
                  },
                  child: Text("画笔颜色")),
                  TextButton(
                  onPressed: () {
                    showPanSizeDialog();
                  },
                  child: Text("画笔大小")),
                  TextButton(
                  onPressed: () {
                    showColorPickerBackground();
                  },
                  child: Text("背景色")),
              TextButton(
                  onPressed: () async {
                    String sharePath = BaseConfig.cacheDir.path +
                        FileUtil.separatorChar() +
                        "temp.png";
                    saveImage(await _capturePng(), sharePath);
                    if (BaseConfig.platform == "windows") {
                      win_shareFile(sharePath);
                    } else
                      ShareExtend.share(sharePath, "image");
                  },
                  child: Text("分享"))
            ],
          )
        ],
      ),
    );
  }
}
