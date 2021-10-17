import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:midieditor/base/StartWidget.dart';
import 'package:midieditor/tool/MidiCreate.dart';
import 'package:midieditor/util/FileUtil.dart';
import 'package:midieditor/util/PlayUtil.dart';
import 'package:midieditor/view/RoundButton.dart';
import 'package:midieditor/view/ToolBar.dart';
import 'package:musicplayer_plugin/musicplayer_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/cmd/process_cmd.dart';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/shell_run.dart';
import 'package:share_extend/share_extend.dart';
import 'package:process_run/which.dart';
import '../BaseConfig.dart';

class CodeEditWidget extends StartWidget {
  @override
  State<StatefulWidget> createState() {
    return _CodeEditState();
  }
}

class _CodeEditState extends StartState<CodeEditWidget> {
  TextEditingController controller_code = TextEditingController();
  TextEditingController controller_user = TextEditingController();
  String outpath;
  String musicid = "music";

  void initState() {
    super.initState();

    controller_code.text = """[p:1]
1155665 4433221
5544332 5544332
1155665 4433221
""";
    initDirs();
    // MusicplayerPlugin.doPrint();
  }

  void onReStart() {
    // String outpath = BaseConfig.cacheDir.path + "/" + 'output.mid';
    // MidiCreate.makeSimpleMidi();
    // MusicplayerPlugin.getGUID();
    // MusicplayerPlugin.getMainArgs();
    print("热加载");
    print(""+FileUtil.HandleFileName("测试影子<>:?\\/哈哈【"));
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

  Widget itemName(String text) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Text(text),
    );
  }

   Future<int> win_shareFile(String filename) async {
    bool runInShell = Platform.isWindows;
    filename = filename.replaceAll("/", "\\");
    try {
      ProcessCmd cmd = processCmd('explorer.exe', ['/select,'+filename],
          runInShell: runInShell);
      await runCmd(cmd); //, stdin: stdin, stdout: stdout);
    } on ShellException catch (e) {
      print(e.toString());
    }

    return 0;
  }

  Future<int> win_playMidi(String filename) async {
    bool runInShell = Platform.isWindows;
    filename = filename.replaceAll("/", "\\");
    try {
      ProcessCmd cmd = processCmd('ctplay.exe', [filename],
          runInShell: runInShell);
      await runCmd(cmd); //, stdin: stdin, stdout: stdout);
    } on ShellException catch (e) {
      print(e.toString());
    }

    return 0;
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: ToolBar(
        backText: "代码转音乐 ${BaseConfig.versionName} - 风的影子 制作",
        backTap: () {
          SystemNavigator.pop();
        },
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          children: [
            itemName("输入曲谱:"),
            TextField(
              controller: controller_code,
              minLines: 5,
              maxLines: 5,
              style: TextStyle(
                  fontSize: BaseConfig.font_h3, color: BaseConfig.textColor),
            ),
            SizedBox(width: 16, height: 16),
            RoundButton(
              text: "转换",
              width: 300,
              height: 40,
              color: BaseConfig.colorAccent,
              onPressed: () {
                MidiCreate create = new MidiCreate();
                MusicplayerPlugin.stopMusic(musicid);
                create.makeTextToMidi(controller_code.text, outpath);

                toast("转换成功，保存在缓存目录下");
              },
            ),
            SizedBox(width: 32, height: 16),
            RoundButton(
              text: "播放",
              width: 300,
              height: 40,
              color: BaseConfig.colorAccent,
              onPressed: () async {
                MusicplayerPlugin.stopMusic(musicid);
                // if(BaseConfig.platform == "windows"){
                //   win_playMidi(outpath);
                // }else{
                  if(BaseConfig.platform == "windows"){
                    outpath = outpath.replaceAll("/", "\\");
                    musicid = await MusicplayerPlugin.playMusic(outpath);
                  }else
                  PlayUtil.playSoundWithPath(outpath);
                // }
                
              },
            ),
            SizedBox(width: 32, height: 16),
            RoundButton(
              text: "试听当前行",
              width: 300,
              height: 40,
              color: BaseConfig.colorAccent,
              onPressed: () {
                MusicplayerPlugin.stopMusic(musicid);
                MidiCreate create = new MidiCreate();
                String edit_text = controller_code.text;
                int offset = controller_code.selection.baseOffset;
                int start = 0;
                int end = edit_text.length;
                for(int i=offset-1;i>=0;i--){
                  if(edit_text[i]=='\n'){
                    start = i;
                    break;
                  }
                }
                for(int i=offset;i<end;i++){
                  if(edit_text[i] == '\n'){
                      end = i;
                  }
                }
                print("start = ${start} end=${end}");
                create.makeTextToMidi(edit_text.substring(start,end), outpath);
                if(BaseConfig.platform == "windows"){
                  win_playMidi(outpath);
                }else{
                  PlayUtil.playSoundWithPath(outpath);
                }
                
              },
            ),
            SizedBox(width: 32, height: 16),
            RoundButton(
              text: "分享",
              width: 300,
              height: 40,
              color: BaseConfig.colorAccent,
              onPressed: () {
                MusicplayerPlugin.stopMusic(musicid);
                print("分享 ${outpath}");
                if(BaseConfig.platform == "windows"){
                  win_shareFile(outpath);
                }else
                ShareExtend.share(outpath, "file");
              },
            ),
            SizedBox(width: 32, height: 32),
            Text(
              "谱曲说明：\n1~7 曲调\n# 升半调\n+ 高音\n- 低音\n\/ 音长减半\n_ 音长加倍\n. 音长加1/2\n, 音长加1/4",
            )
          ],
        ),
      ),
    );
  }
}
