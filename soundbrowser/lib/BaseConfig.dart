
import 'dart:io';

import 'dart:ui';

import 'package:flutter/material.dart';

class BaseConfig{

  static String url = "http://app.yzjlb.net";
  static String yzjlbUrl = "http://www.yzjlb.net";
  static String updateUrl = "http://www.yzjlb.net/app/sharing"; //更新地址
  static String userDoc = "http://i.yzjlb.net/?p=1349"; //用户协议
  static String privateDoc = "http://i.yzjlb.net/?p=1347"; //隐私政策
  static String chongzhiUrl = "http://app.yzjlb.net/app/api.php?type=chongzhi&package=net.yzjlb.sharing";//会员充值（用卡密）
  static String changeKamiUrl = "http://app.yzjlb.net/app/api.php?type=kmchange&package=net.yzjlb.sharing";//卡密转移
  static String kamiPlayUrl = "http://app.yzjlb.net/app/api.php?type=play&package=net.yzjlb.sharing";//卡密购买链接
  static String moreAppUrl = "http://app.yzjlb.net/app/api.php?type=moreappurl&package=net.yzjlb.sharing";//更多app链接
  static String feedbackUrl = "http://app.yzjlb.net/app/api.php?type=feedback&package=net.yzjlb.sharing";//反馈
  static String analyzeUrl = "http://app.yzjlb.net/app/api.php?type=analyze&package=net.yzjlb.sharing";//app统计 只统计2部分 平台 包名 版本 识别码 时间 统计数据
  static String donateUrl = "http://app.yzjlb.net/app/api.php?type=donate&package=net.yzjlb.sharing";//获取捐赠页面
  static String playlistUrl = "http://app.yzjlb.net/app/api.php?type=playlist&package=net.yzjlb.sharing";//获取会员充值列表
  static String crackDetectionUrl = "http://app.yzjlb.net/app/api.php?type=checkapp&package=net.yzjlb.sharing";  //破解检测 将udid发送到服务器 如果返回数据为300表示不正常
  static String issueUrl = "http://app.yzjlb.net/app/api.php?type=issue&package=net.yzjlb.sharing"; //问题列表
  static String sponsorUrl = "http://app.yzjlb.net/app/api.php?type=sponsor&package=net.yzjlb.sharing"; //赞助地址
  static String appUrl = "http://www.yzjlb.net";//app官网

  static String versionName = "1.0";
  static String versionCode = "1";
  static String udid = "null";
  static String channel = "shop";

  //获取会员状态 （貌似不需要这个接口）
  
  //
  static Directory cacheDir ;
  static Directory docDir ;
  static String platform = "android";
  static bool isBiliBili = false;
  static bool isMaxScreen = false;

  static const double font_h1 = 18;
  static const double font_h2 = 17;
  static const double font_title = 17; //标题字体大小
  static const double font_h3 = 14; //正文内容
  static const double font_h4 = 13; //正文内容 2
  static const double font_h5 = 11;
  static const double font_h6 = 10;
  static const int CODE_OK = 200;
  static bool enableVIP = false;//启用会员模式
  static String vip_type = "普通用户";
  static String vip_startTime = "";//会员开始时间
  static String vip_endTime = ""; //会员结束时间

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
  static const colorPrimary = Color(0xFF60a0f0);

//元件预设颜色
  static const colorControlNormal = Color(0xff6a6a6a);

//  高亮色
  static const colorAccent = Color(0xFF60a0f0);

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