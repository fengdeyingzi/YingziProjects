

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/**
 * 带分隔线效果的Column
*/

class DividerColumn extends Column{
   final Color lineColor;
   final double indent;
   final double endIndent;
//   final double line_padding_right;
  static List<Widget> _doDivider(List<Widget> list,Color lineColor,double indent,double endIndent){
    List<Widget> list_new = [];
    for(var i=0;i<list.length;i++){
      var item = list[i];
      list_new.add(item);
      if(i<list.length-1){
        list_new.add(Divider(
          height: 1,
          indent: indent,
          endIndent: endIndent,
          color: lineColor,
        ));
      }
    }
    return list_new;
  }
  
  DividerColumn({
    Key key,
    this.indent=0,
    this.endIndent = 0,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    this.lineColor=Colors.grey,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline textBaseline,
    List<Widget> children = const <Widget>[],
  }) : super(
    children: _doDivider(children,lineColor,indent,endIndent),
    key: key,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
  );
  
}