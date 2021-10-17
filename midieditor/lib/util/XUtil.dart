import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:convert/convert.dart';
// base64库
import 'dart:convert' as convert;
//import 'dart:js' as js;

// 文件相关
import 'dart:io';
import '../BaseConfig.dart';
import 'package:crypto/crypto.dart';

class XUtil {
  /** 返回当前时间戳 */
  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  /**
   * 随机数
   */

  static int rand() {
    return Random().nextInt(30000);
  }

  /** 复制到剪粘板 */
  static copyToClipboard(final String text) {
//     if (text == null) return;
// //    Clipboard.setData(new ClipboardData(text: text));
//     if (BaseConfig.platform == "web") {
// //      var result = js.context.callMethod("copyToClipboard", [text]);
//       print(text);
//     } else
//       FlutterClipboardManager.copyToClipBoard(text).then((result) {
//         print("复制成功${result}");
//       });
  }

//  从剪切板获取文本
  static Future<ClipboardData> getClipboard() {
    return Clipboard.getData(Clipboard.kTextPlain);
  }

  static const RollupSize_Units = ["GB", "MB", "KB", "B"];

  /** 返回文件大小字符串 */
  static String getRollupSize(int size) {
    int idx = 3;
    int r1 = 0;
    String result = "";
    while (idx >= 0) {
      int s1 = size % 1024;
      size = size >> 10;
      if (size == 0 || idx == 0) {
        r1 = (r1 * 100) ~/ 1024;
        if (r1 > 0) {
          if (r1 >= 10)
            result = "$s1.$r1${RollupSize_Units[idx]}";
          else
            result = "$s1.0$r1${RollupSize_Units[idx]}";
        } else
          result = s1.toString() + RollupSize_Units[idx];
        break;
      }
      r1 = s1;
      idx--;
    }
    return result;
  }

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  /** 返回两个日期相差的天数 */
  static int daysBetween(DateTime a, DateTime b, [bool ignoreTime = false]) {
    if (ignoreTime) {
      int v = a.millisecondsSinceEpoch ~/ 86400000 -
          b.millisecondsSinceEpoch ~/ 86400000;
      if (v < 0) return -v;
      return v;
    } else {
      int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
      if (v < 0) v = -v;
      return v ~/ 86400000;
    }
  }

  /** 获取屏幕宽度 */
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /** 获取屏幕高度 */
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidget(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /** 获取系统状态栏高度 */
  static double getSysStatsHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getNavigatorBarHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /*
  * Base64加密
  */
  static String base64Encode(String data) {
    var content = convert.utf8.encode(data);
    var digest = convert.base64Encode(content);
    return digest;
  }

  /*
  * Base64解密
  */
  static String base64Decode(String data) {
    List<int> bytes = convert.base64Decode(data);
    // 网上找的很多都是String.fromCharCodes，这个中文会乱码
    //String txt1 = String.fromCharCodes(bytes);
    String result = convert.utf8.decode(bytes);
    return result;
  }

  /*
  * 通过图片路径将图片转换成Base64字符串
  */
  static Future<String> image2Base64(String path) async {
    File file = new File(path);
    Uint8List imageBytes = await file.readAsBytes();
    return convert.base64Encode(imageBytes);
  }

  /*
  * 将图片文件转换成Base64字符串
  */
  static Future<String> imageFile2Base64(File file) async {
    Uint8List imageBytes = await file.readAsBytes();
    return convert.base64Encode(imageBytes);
  }

  /*
  * 将Base64字符串的图片转换成图片
  */
  static Future<Image> base642Image(String base64Txt) async {
    Uint8List decodeTxt = convert.base64.decode(base64Txt);
    return Image.memory(
      decodeTxt,
      width: 100, fit: BoxFit.fitWidth,
      gaplessPlayback: true, //防止重绘
    );
  }

  static bool isEmpty(String text) {
    bool isEm = true;
    if (text == null || text.length == 0) return true;
    for (var i = 0; i < text.length; i++) {
      if (text[i] != " ") {
        isEm = false;
      }
    }
    return isEm;
  }

  //将数组转换为json形式
  static String arrayToJsonString(List<String> array) {
    StringBuffer buffer = new StringBuffer();
    buffer.write("{");
    for (int i = 0; i < array.length; i++) {
      buffer.write("${array[i]}");
      if (i < array.length - 1) {
        buffer.write(",");
      }
    }
    buffer.write("}");
    return buffer.toString();
  }

//将,号分隔的文字转换为数组
  static List<String> stringToArray(String text, [Pattern character]) {
    return text.split(character ?? ',');
  }

  // md5 加密
  static String MD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  static String MD516(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes).substring(8,24);
  }

  //计算文字高度
  ///value: 文本内容；fontSize : 文字的大小；fontWeight：文字权重；maxWidth：文本框的最大宽度；maxLines：文本支持最大多少行
  static double calculateTextHeight(BuildContext context,
      String value, fontSize, FontWeight fontWeight, double maxWidth, int maxLines) {
//    value = filterText(value);
    TextPainter painter = TextPainter(
      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        locale: Localizations.localeOf(context,),// nullOk: true),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);
    ///文字的宽度:painter.width
    return painter.height;
  }

  static double calculateTextWidth(BuildContext context,
      String value, fontSize, FontWeight fontWeight, double maxWidth, int maxLines) {
//    value = filterText(value);
    TextPainter painter = TextPainter(
      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        locale: Localizations.localeOf(context), //, nullOk: true),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);
    ///文字的宽度:painter.width
    return painter.width;
  }



  ///验证身份证
  static bool checkPrice(String value) {
    return RegExp(
        r"-?([0-9]+|[0-9]{1,3}(,[0-9]{3})*)(.[0-9]{1,2})?")
        .hasMatch(value);
  }

//  static double getDpr(){
//    return window.devicePixelRatio;
//  }
}

bool isNull(dynamic obj) {
  return obj == null;
}

bool isNotNull(dynamic obj) {
  return obj != null;
}

///手机号验证
bool isChinaPhoneLegal(String str) {
  return RegExp(r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$")
      .hasMatch(str);
}

///邮箱验证
bool isEmail(String str) {
  return RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$").hasMatch(str);
}
