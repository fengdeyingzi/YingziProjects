


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer_plugin/musicplayer_plugin.dart';
import 'package:process_run/cmd/process_cmd.dart';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/shell.dart';
import 'package:soundbrowser/base/BoxStartWidget.dart';
import 'package:soundbrowser/util/FileUtil.dart';
import 'package:soundbrowser/view/XImage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../BaseConfig.dart';

class FileListWidget extends BoxStartWdiget {
  @override
  State<StatefulWidget> createState() {
    return _FileListState();
  }
}

class _FileListState extends BoxStartState<FileListWidget> {
  TextEditingController controller = new TextEditingController();
  int musicid = 0;
  String play_cur = "";
  List<Map<String,String>> list_file=[];
  //当前目录
  String path_cur = "D:\\";
  //当前播放音乐
  String path_play = "";

  @override
  void initState() {
    super.initState();
    controller.text = "D:\\";
  }

  String getTitle(){
    return "音效浏览器";
  }

  bool showSettingButton(){
    return false;
  }

  bool showStarButton(){
    return false;
  }

  void onBack(){
    if(FileUtil.getParamPath(path_cur) != ""){
      path_cur = FileUtil.getParamPath(path_cur);
                  controller.text = path_cur;
                  refreshList();
    }
    
  }

  Future<void> playMusic(String path) async {
    await MusicplayerPlugin.closeAll();
    if(path!=path_play){
      path_play = path;
      MusicplayerPlugin.playMusic(path);
    }
    
  }

  Future<int> win_copyFile(String filename) async {
    bool runInShell = Platform.isWindows;
    try {
      ProcessCmd cmd = processCmd('clipboard.exe', ['-setfile', filename],
          runInShell: runInShell);
      await runCmd(cmd); //, stdin: stdin, stdout: stdout);
    } on ShellException catch (e) {
      print(e.toString());
    }

    return 0;
  }

  Future<void> refreshList() async {
    try {
      var directory = Directory(path_cur);
      List<FileSystemEntity> files = await directory.listSync();
      files.sort((a,b){
        return -(b.path).compareTo(a.path);
      });
     
         
      list_file.clear();
      for (var f in files) {
        print(f.path);
        if(f.statSync().type == FileSystemEntityType.directory){
list_file.insert(0,{
          "path":f.path,
          "endname":FileUtil.getEndName(f.path),
          "name":FileUtil.getName(f.path)
        });
        }
        else
        list_file.add({
          "path":f.path,
          "endname":FileUtil.getEndName(f.path),
          "name":FileUtil.getName(f.path)
        });
        
      }
    } catch (e) {
      print("获取相册失败：${e.toString()}");
      toast(e.toString());
    }
    
    setState(() {
      
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                        fontSize: BaseConfig.font_h3, color: BaseConfig.textColor),
                  ),
                ),
TextButton(
                onPressed: () {
                  path_cur = controller.text;
                  refreshList();
                },
                child: Text("前往")),

            TextButton(
                onPressed: () async {
                  path_cur = FileUtil.getParamPath(path_cur);
                  controller.text = path_cur;
                  refreshList();
                },
                child: Text("上级目录")),
              ],
            ),
          ),
          
          Expanded(child: Scrollbar(
            key: UniqueKey(),
            isAlwaysShown: true,
            child: ListView.builder(itemBuilder: (context,index){
              var item = list_file[index]["path"];
              File itemfile = new File(item);
              String img = "assets/ex_doc.png";
              String endName = FileUtil.getEndName(item);
              endName = endName.toLowerCase();
              if(itemfile.statSync().type == FileSystemEntityType.directory){
                img = "assets/ex_folder.png";
              }
              if(endName == ".png" || endName == ".PNG" || endName== ".jpg" || endName == ".JPG" || endName == ".gif" || endName == ".GIF" || endName == ".bmp" || endName == ".BMP"){
                img = item;
              }else if(endName == ".mp3" || endName == ".wav" || endName == ".m4a" || endName == ".amr"){
                img = "assets/file_mp3.png";
              }
              return InkWell(
                onTap: () async {
                  if((await itemfile.stat()).type == FileSystemEntityType.directory){
                    path_cur = itemfile.path;
                    controller.text = path_cur;
                    refreshList();
                  }else{
                    if(endName == ".mp3" || endName == ".wav" || endName == ".m4a" || endName == ".amr"){
                      playMusic(item);
                    }else{
                      launch(item);
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      XImage(img,width: 32,height: 32,),
                      SizedBox(width: 8,height: 8,),
                      Expanded(child: Text(FileUtil.getName(item))),
                      GestureDetector(
                        onTap: (){
                          toast("添加收藏成功");
                        },
                        child: Image.asset("assets/star.png",width: 20,height: 20,)),
                        SizedBox(width: 8,height: 8,),
                      GestureDetector(
                        onTap: (){
                          win_copyFile(item);
                          toast("复制文件成功");
                        },
                        child: Icon(Icons.copy,size: 20,)
                      )
                    ],
                  ),
                ),
              );
            },itemCount: list_file.length,itemExtent: 48,),
          ), )
        ],
      ),
    );
  }
}
