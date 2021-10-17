
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../base/StartWidget.dart';
import '../BaseConfig.dart';


import 'package:flutter/material.dart';
import '../BaseConfig.dart';

/*
不知到为什么 自带的NavigationBar CupertinoNavigationBar 会修改掉状态栏的颜色
为了让状态栏保持白色 以及实现更好的自定义效果，自己实现一个状态栏
 */




class ToolBar extends StatelessWidget implements PreferredSizeWidget {
  BuildContext parentContext;
  Widget leading;
  Widget middle;
  Widget trailing;
  bool showBack;
  String backText;
  String backImage;
  Color backgroundColor;
  bool isLight;
  Function() backTap;

  //获取标题
  static getTitle(String title){
    return Container(
      constraints: BoxConstraints(
          maxWidth: 280
      ),
      child: Text(title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: BaseConfig.font_title,
          color: BaseConfig.textColor,
        ),),
    );
  }

  ToolBar({
    this.leading,
    this.middle,
    this.backImage,
    this.parentContext,
    this.showBack=true,
    this.backText,
    this.backgroundColor,
    this.backTap,
    this.trailing,
    this.isLight
  });

//  @override
//  State<StatefulWidget> createState() {
//    //  implement createState
//    return _NavigationBar();
//  }

  @override
  Widget build(BuildContext context) {
    if(isLight == null) isLight = true;
//    double top = XUtil.getSysStatsHeight(context);
    //  implement build
    // AnnotatedRegion<SystemUiOverlayStyle>(
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isLight ?SystemUiOverlayStyle.dark.copyWith(systemNavigationBarColor: BaseConfig.colorAccent):SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor:BaseConfig.colorAccent),
      child: Container(
//        alignment: Alignment.topCenter,
        color: (backgroundColor == null) ? Colors.transparent: backgroundColor,
//        height: 48,
//        height: double.infinity,
        child: SafeArea(
          top: true,
          child: Container(
//            height: 48,
//            alignment: Alignment.topCenter,
            child: Stack(fit: StackFit.loose, children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  
                    Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        showBack?InkResponse(
                    onTap:backTap?? () {
//                  if(parentContext!=null){
//                    Navigator.of(parentContext).pop();
//                  }
//                  else
                      Navigator.of(context).pop();
                      // SystemNavigator.pop();
                    },
                    child:
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          child: (leading == null)
                            ? Image.asset(
                          backImage??"assets/toolbar_back.png",
                          width: 40,
                          height: 24,
                          color: isLight ?BaseConfig.textColor:BaseConfig.lightBackgroundColor,
                        )
                            : leading,
                        ),
                    ):SizedBox(),

                        (backText != null)
                            ? Text(
                          backText,
                          style: TextStyle(
                              color: isLight ?BaseConfig.textColor:BaseConfig.lightBackgroundColor,
                              fontWeight: isLight ?FontWeight.bold:FontWeight.normal,
                              fontSize: BaseConfig.font_h3),
                        )
                            : SizedBox(
                          width: 8,
                        )
                      ],
                    ),
                  
                  Expanded(
                    flex: 1,
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          child: (trailing != null)
                              ? trailing
                              : SizedBox(
                            width: 20,
                            height: 20,
                          ),
                        )),
                  ),
                ],
              ),
              Center(child: middle),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  //  implement preferredSize
  Size get preferredSize => Size.fromHeight(48);
}


Widget getNavigationText(String text){
  return Text(text,
    style: TextStyle(
      fontSize: BaseConfig.font_h2,
      color: BaseConfig.textColorPrimary,
    ),
  );
}

//class _NavigationBar extends State<NavigationBar>{
//  @override
//  Widget build(BuildContext context) {
//    //  implement build
//    return Row(
//      children: <Widget>[
//     Image.asset("assets/ic_back.png",width: 16,height: 16,),
//        Expanded(
//          flex: 1,
//          child: ,
//        )
//      ],
//    );
//  }
//
//}
