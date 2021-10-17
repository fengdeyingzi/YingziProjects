
import 'package:flutter/material.dart';
import '../base/StartWidget.dart';
import '../BaseConfig.dart';


class RoundButton extends StatelessWidget {
  VoidCallback onPressed;
  double radius;
  String text;
  Color color;
  double width;
  double height;
  bool isBold;
  RoundButton({
  this.onPressed,
    this.radius,
    this.text,
    this.color,
    this.width,
    this.height,
    this.isBold=false
});

  @override
  Widget build(BuildContext context) {
    Widget layout = RaisedButton(
      onPressed: onPressed,
      elevation: 0,
      color: color??BaseConfig.colorAccent,
      disabledColor: Color(0xffF3F4F8),
      disabledTextColor: BaseConfig.gray,
      textColor: BaseConfig.lightBackgroundColor,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color??BaseConfig.colorAccent,
          width:3.0,
          style: BorderStyle.none
        ),
        borderRadius: BorderRadius.circular(radius??4)
      ),
      animationDuration: const Duration(milliseconds: 200),
      child: Text(text??"",style: TextStyle(
        fontWeight: isBold?FontWeight.bold:FontWeight.normal
      ),),
    );
    if(width != null || height!=null){
      layout = Container(
        width: width,
        height: height,
        child: layout,
      );
    }
    return layout;
  }


}


