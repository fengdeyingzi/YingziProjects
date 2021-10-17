import 'dart:async';
import 'dart:convert';
import 'dart:ui';



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:soundbrowser/util/XHttpUtils.dart';
import '../view/XCard.dart';
import '../BaseConfig.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'BaseWidget.dart';


/*
550 行 添加路由
 */
abstract class StartWidget extends BaseWidget {
  State _state;

  StartWidget({Key key}) : super(key:key);

  setUpperState(State state) {
    this._state = state;
  }

  State getUpperState() {
    return _state;
  }
}

abstract class StartState<T extends StartWidget> extends BaseState<T> {

  @override
  List<String> getHttpData() {
    return [];
  }

  Map<dynamic, dynamic> getArgs(BuildContext context){
    return   ModalRoute.of(context).settings.arguments as Map<dynamic, dynamic>;
  }

    //处理网络请求的返回数据 如果返回的是CODE_OK执行success 如果返回的不是CODE_OK 执行error
    //接口协议
/*
200 正常获取
400 获取失败/错误

*/
  void parseJosn(
      Map<dynamic, dynamic> jsonMap, OnParseSuccess success, OnParseError error,
      {bool isCheckCode = true}) {
    
    if (jsonMap['code'] == null) {
//      toast("请求出错");
      if (!isDispose)
        error("请求出错");
    } else if (isCheckCode != null && !isCheckCode) {
      if (!isDispose) success(jsonMap);
    } else var CODE_OK;
 if (jsonMap['code'] == BaseConfig.CODE_OK) {
      if (!isDispose) success(jsonMap);
    } else {
      if (!isDispose) {
        error("(${jsonMap['code']})${jsonMap['msg']}");
        if (jsonMap['code'] == 401) { //登录失效

        }
      }
    }
  }

  void parseJosn2(
      Map<dynamic, dynamic> jsonMap, OnParseSuccess success, OnParseError error,
      {bool isCheckCode = true}) {
    
    if (jsonMap['StatusCode'] == null) {
//      toast("请求出错");
      if (!isDispose)
        error("请求出错");
    } else if (isCheckCode != null && !isCheckCode) {
      if (!isDispose) success(jsonMap);
    } else var CODE_OK;
 if (jsonMap['StatusCode'] == BaseConfig.CODE_OK) {
      if (!isDispose) success(jsonMap);
    } else {
      if (!isDispose) {
        error("(${jsonMap['StatusCode']})${jsonMap['Data']}");
        if (jsonMap['StatusCode'] == 401) {

        }
      }
    }
  }


  Map<String,String> getHeader(){
    return {

    };
  }



  //请求数据
  Future<Map<String,dynamic>> postData(String url, {Map<String,dynamic> data}) async {
    Map<String,dynamic> re_data = null;
    if(data == null){
      data = {};
    }
      data["lang"] = "zh";
      data["plat"] = BaseConfig.platform;
      data["versionName"] = BaseConfig.versionName;
      data["versionCode"] = BaseConfig.versionCode;
      data["area"] = "中国";
      data["udid"] = BaseConfig.udid;
      data["time_zone"] = "+8:00";
      data["channel"] = BaseConfig.channel;
      re_data = await XHttpUtils.request(url, method: XHttpUtils.POST, data:
      data
      
          , heads: getHeader(),contentType: XHttpUtils.formUrlEncodedContentType);
    
    
    

    return re_data;
  }

    //显示一个输入框 并监听输入文字
  void showInputDialog(
      {String title,
      String text,
      ValueChanged confirmCallback,
      VoidCallback cancelCallback}) {
    TextEditingController controller = TextEditingController();
    if(text!=null)
    controller.text = text;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 260,
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
//      color: Colors.white,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ConstrainedBox(
                            child: SingleChildScrollView(
                              child: TextField(
                                controller: controller,
                                style: TextStyle(
                                  fontSize: BaseConfig.font_h3,
                                  color: BaseConfig.textColor
                                ),
                              ),
                            ),
                            constraints: BoxConstraints(
//                    minWidth: double.infinity, //宽度尽可能大
                                maxHeight: 320 //最小高度为50像素
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[

                          Expanded(
                            flex: 1,
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  cancelCallback();
                                },
                                child: Text("取消", style: TextStyle(
                                        color: Color(0xffcccccc),
                                        fontSize: BaseConfig.font_h3))),
                          ),
                          Expanded(
                            flex: 1,
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  confirmCallback(controller.text);
                                },
                                child: Text(
                                  "确定",
                                  style: TextStyle(
                                      color: Color(0xFF1363DB),
                                      fontSize: BaseConfig.font_h3),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

}


