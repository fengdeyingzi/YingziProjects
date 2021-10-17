
import 'dart:io';

import 'dart:ui';

import 'package:flutter/material.dart';

class BaseConfig{

  static Directory cacheDir ;
  static Directory docDir ;
  static String platform = "android";
  static bool isBiliBili = false;
  static bool isMaxScreen = false;
  static String versionName = "1.1.3";

  static const double font_h1 = 18;
  static const double font_h2 = 17;
  static const double font_title = 17; //标题字体大小
  static const double font_h3 = 14; //正文内容
  static const double font_h4 = 13; //正文内容 2
  static const double font_h5 = 11;
  static const double font_h6 = 10;

  //文字颜色
  static const textColor = Color(0xff202020);

  //编辑框提示文字颜色
  static const hintTextColor = Color(0xffCBCBCB);

  static const editLineColor = Color(0xffe4e4e4);

  //编辑器文字颜色
  static const editTextColor = Color(0xff202020);

  //标题文字颜色
  static const textColorPrimary = Color(0xffffffff);

  //主色调颜色
  static const colorPrimary = Color(0xFF909090);

//元件预设颜色
  static const colorControlNormal = Color(0xff6a6a6a);

//  高亮色
  static const colorAccent = Color(0xFF909090);

  //网址颜色
  static const colorUrl = Color(0xff6098f0);

  //背景色
  static const backgroundColor = Color(0xfff2F3F7);

  //亮色背景 白色/黑色
  static const lightBackgroundColor = Colors.white;

  //对话框背景色 菜单背景色
  static const dialogBackgroundColor = Color(0x50000000);

  static const red = Color(0xffFE3333);

  static const gray = Color(0xff999999);

  static const light_gray = const Color(0xffcccccc);
  //下划线的颜色
  static const lineColor = Color(0xffe0e0e0);
}