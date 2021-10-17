import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../base/StartWidget.dart';
import '../BaseConfig.dart';

class XDialog {
  static Widget buildIOSDialog(
      BuildContext context,
      String title,
      String info, {
        VoidCallback confirmCallback,
        VoidCallback cancelCallback,
      }) {
    List<CupertinoButton> list_actions = [CupertinoButton(
      child: Text("确定"),
      onPressed: confirmCallback ?? () {},
    ),];
    if(cancelCallback!=null){
      list_actions.insert(0,CupertinoButton(
        child: Text("取消"),
        onPressed: cancelCallback,
      ));
    }
    return CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Column(children: [
            Text(
              info,
            )
          ]),
        ),
        actions: list_actions
    );
  }

  static Widget buildWeChatDialog(
      BuildContext context,
      String title,
      String info,

      {String confirmText,
        Widget child,
        String cancelText,VoidCallback confirmCallback, VoidCallback cancelCallback}) {
    return new Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 280,
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
//      color: Colors.white,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              height: 42,
                              alignment: Alignment.center,
                              child: Text(title,
                                style: TextStyle(
                                    fontSize: BaseConfig.font_h3,
                                    color: BaseConfig.textColor,
                                    fontWeight: FontWeight.bold
                                ),),
                            ),
                            child??
                        //     Expanded(child: SingleChildScrollView(
                        // child: 
                        Text(
                              info ,
                              style: TextStyle(
                                fontSize: BaseConfig.font_h3,
                                color: BaseConfig.textColor,
                              ),
                            ),
                            // ),)
                          ],
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
                Divider(indent: 0,endIndent: 0,height: 1,color: BaseConfig.lineColor,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Row(
                    children: <Widget>[
                      (cancelCallback != null)
                          ? Expanded(
                        flex: 1,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              cancelCallback();
                            },
                            child: Text(cancelText??"取消",
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: BaseConfig.font_h3))),
                      )
                          : SizedBox(),
                      (cancelCallback != null)?Container(width:1/window.devicePixelRatio,height: 32,color: BaseConfig.lineColor,):SizedBox(),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              if(confirmCallback!=null)
                                confirmCallback();
                            },
                            child: Text(
                              confirmText??"确定",
                              style: TextStyle(
                                  color: BaseConfig.colorAccent,
                                  fontSize: BaseConfig.font_h3),
                            )),
                      ),


                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }






}
