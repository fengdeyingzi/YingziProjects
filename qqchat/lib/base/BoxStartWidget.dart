

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qqchat/BaseConfig.dart';
import 'package:qqchat/base/StartWidget.dart';


abstract class BoxStartWdiget extends StartWidget{
  
}


// 小工具统一界面，右上角显示说明 显示收藏 显示应用评价 显示设置
// 为了工具
abstract class BoxStartState <T extends BoxStartWdiget> extends StartState<T> {
  bool _showBack = true;

  //获取应用说明
  String getAppInfo(){
    return "暂无说明";
  }

  String getTitle(){
    return "title";
  }
  
  //加收藏
  bool showStarButton(){
    return true;
  }

  //关闭按钮
  bool showCloseButton(){
    return true;
  }

  //设置按钮
  bool showSettingButton(){
    return true;
  }

  void setShowBack(bool show){
    this._showBack = show;
  }

  void onBack(){
    navigationPop();
  }

  //
  Widget buildBody(BuildContext context);
var borderColor = Color(0xFF805306);
  @override
  Widget buildWidget(BuildContext context) {
    // return WindowBorder(
    //             color: borderColor,
    //             width: 1,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: BaseConfig.platform=="windows"?Container(width: double.infinity ,alignment: Alignment.centerLeft,height: 48,child: MoveWindow(child:
    //        Container(
    //          alignment: Alignment.centerLeft,
    //          child: Text(getTitle(),textAlign: TextAlign.center,)),
    //        )
    //        ): Text(getTitle()),
    //       leading: _showBack?BackButton(onPressed: (){
    //         onBack();
    //       },):null,
    //       backgroundColor: BaseConfig.colorPrimary,
    //       actions: <Widget>[
    //         showStarButton()? IconButton(onPressed: (){
    //         }, icon: Icon(Icons.star)):SizedBox(),
    //         showSettingButton()? IconButton(onPressed: (){

    //         }, icon: Icon(Icons.settings)):SizedBox(),

    //       ]..add(WindowButtons()),
    //     ),
    //     body: buildBody(context)
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
         title: Text(getTitle())
      ),
      body: buildBody(context),
      );
    
  }

}
/*
final buttonColors = WindowButtonColors(
    iconNormal: Color(0xFFFFFFFF),
    mouseOver: Color(0x10000000),
    mouseDown: Color(0xFF805306),
    iconMouseOver: Color(0xFF805306),
    iconMouseDown: Color(0x30ffffff));

final closeButtonColors = WindowButtonColors(
    mouseOver: Color(0x30D32F2F),
    mouseDown: Color(0x80B71C1C),
    iconNormal: Color(0xFFFFFFFF),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseConfig.platform != "windows"?SizedBox(): Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
*/