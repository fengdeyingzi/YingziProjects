

/*
url显示的文字
*/

import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../BaseConfig.dart';

class UrlTextWidget extends StatefulWidget{
  String text;
  String title;
  UrlTextWidget(this.text,{this.title});

  @override
  State<StatefulWidget> createState() {
    return _UrlTextWidgetState();
  }
}

class _UrlTextWidgetState extends State<UrlTextWidget>{
  bool isEnter = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
            onHover: (details){
              print("onHover");
              isEnter = true;
              setState(() {
                
              });
            },
            onEnter: (details){
              isEnter = true;
              setState(() {
                
              });
print("onEnter");
            },
            onExit: (details){
              print("onExit");
              isEnter = false;
              setState(() {
                
              });
            },
            child: GestureDetector(
              onTap: (){
                launch(widget.text);
              },
              
              child: Text(
              widget.title??widget.text,
              
              style: TextStyle(
                  fontSize: BaseConfig.font_h3, color: BaseConfig.colorUrl,
                  decoration: isEnter?TextDecoration.underline:TextDecoration.none),
            ),
            ),
          );
  }
}