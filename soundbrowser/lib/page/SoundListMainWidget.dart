

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:soundbrowser/base/BoxStartWidget.dart';
import 'package:soundbrowser/view/UrlTextWidget.dart';

import '../BaseConfig.dart';

class SoundListMainWidget extends BoxStartWdiget {
  @override
  State<StatefulWidget> createState() {
    return SoundListMainState();
  }
  
}


class SoundListMainState extends BoxStartState<SoundListMainWidget> {

  void initState(){
    super.initState();
    setShowBack(false);
  }

  String getTitle(){
    return "必剪音效 - 风的影子 制作";
  }

  //加收藏
  bool showStarButton(){
    return false;
  }

  //设置按钮
  bool showSettingButton(){
    return false;
  }
  

  Widget getItemButton(String text,{VoidCallback onPressed}){
    return Container(
      width: 320,
      height: 50,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(BaseConfig.colorAccent),
          overlayColor: MaterialStateProperty.all(Color(0xff7abefe)),
          foregroundColor: MaterialStateProperty.all(BaseConfig.lightBackgroundColor)
        ),
        onPressed: onPressed??(){

      }, child: Text(text,style:TextStyle(color: BaseConfig.lightBackgroundColor))),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
getItemButton("必剪音效", onPressed: (){
  navigationNameTo("SoundPoolWidget",arguments: {
    "type":0
  });
}),
SizedBox(width: 32,height: 32,),
getItemButton("必剪音乐", onPressed: (){
  navigationNameTo("SoundPoolWidget", arguments: {
    "type":1
  });
}),
SizedBox(width: 32,height: 32,),
Text("音乐获取有签名校验，暂时还无法下载"),
Text("音乐文件默认下载到电脑”我的文档“目录下"),
Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text("B站主页："),
    UrlTextWidget("https://b23.tv/NTzirB",title: "https://b23.tv/NTzirB",),
  ],
)


        ],
      ),
    );
  }
  

}