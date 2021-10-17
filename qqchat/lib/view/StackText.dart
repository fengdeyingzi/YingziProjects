

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StackText extends StatelessWidget {
 TextStyle style;
String text;
double strokeWidth;
Color strokeColor;
 StackText(this.text,{this.style,this.strokeWidth = 2,this.strokeColor=Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Stack(
  children: <Widget>[
    // Stroked text as border.
    Text(
      text??"",
      style: style!=null? TextStyle(
        fontSize: style.fontSize,
        // color: style.color,
        fontWeight: style.fontWeight,
        foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = strokeColor,
      ):TextStyle(foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = strokeColor,),
    ),
    // Solid text as fill.
    Text(
      text??"",
      style: style??TextStyle(),
    ),
  ],
);
  }
  
}