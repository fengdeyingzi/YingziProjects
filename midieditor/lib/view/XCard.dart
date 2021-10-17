import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class XCard extends StatelessWidget{

  Widget child;
  Color shadowColor; //阴影颜色
  double radius; //圆角大小
  double elevation; //阴影高度
  EdgeInsetsGeometry padding;
  EdgeInsetsGeometry margin;

  XCard({this.child,this.shadowColor,this.radius,this.elevation,this.padding,this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
//            color: Colors.white,
      padding: EdgeInsets.fromLTRB(4, 4, 4, 1),
      margin: margin??EdgeInsets.fromLTRB(6, 6, 6, 6),
//            elevation: 1,
//            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),  //设置圆角
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius??4)),
//              color: Colors.blue,
//             border: new Border.all(color: Color(0xFFFF0000), width: 8,),
        // 边色与边宽度
        boxShadow: [
          BoxShadow(
              color: shadowColor??Color(0x20000000),
              offset: Offset(0, elevation??4),
              blurRadius: 1,
              spreadRadius: -4),
        ],
      ),
      child:  Container(
//          padding: EdgeInsets.all(radius??2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius??4)),
            color: Colors.white,
          ),
          child: Container(
              padding: padding??EdgeInsets.all(0.1),
              child: child)),
    );
  }



}