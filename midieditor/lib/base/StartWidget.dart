import 'dart:async';
import 'dart:convert';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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


