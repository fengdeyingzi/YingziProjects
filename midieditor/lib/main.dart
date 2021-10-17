import 'dart:async';
import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midieditor/page/CodeEditWidget.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:midieditor/page/LogoWidget.dart';



import 'BaseConfig.dart';
import 'obj/Pieces.dart';

void main() {
  try {
    BaseConfig.platform = Platform.operatingSystem;
    if (BaseConfig.platform == null) BaseConfig.platform = "web";
    print("当前平台 ${BaseConfig.platform}");
  } catch (error) {
    print("平台检测失败 web");
    BaseConfig.platform = "web";
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '代码转音乐',
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [
        BotToastNavigatorObserver()
      ], //2. registered route observer
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        "LogoWidget":(BuildContext context) => LogoWidget(),
        "CodeEditWidget": (BuildContext context) => CodeEditWidget(),

      },
      home: LogoWidget(),
    );
  }
}

