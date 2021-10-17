
import 'dart:math';

import 'package:flutter/cupertino.dart';

class XObject {
  String type; //类型 cir rect img text
  Point position; //位置
  double scalex; //缩放x
  double scaley; //缩放y
  double opacity; //不透明度
}

class ObjectView extends StatefulWidget{
  XObject params;
  ObjectView(this.params);

  @override
  State<StatefulWidget> createState() {
    return _ObjectViewState();
  }
  
}

class  _ObjectViewState extends State<ObjectView> {

  @override
  Widget build(BuildContext context) {
    
  }

  @override
  void didUpdateWidget(covariant ObjectView oldWidget) {
    
    super.didUpdateWidget(oldWidget);
  }
  
}