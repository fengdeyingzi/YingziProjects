

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_cursor/flutter_cursor.dart';
import 'package:soundbrowser/base/BoxStartWidget.dart';
import 'package:soundbrowser/view/SplitWidget.dart';

class DemoSplitWidget extends BoxStartWdiget {
  @override
  State<StatefulWidget> createState() {
    return _DemoSplitWidgetState();
  }
  
}

class  _DemoSplitWidgetState extends BoxStartState<DemoSplitWidget> {
  @override
  Widget buildBody(BuildContext context) {
    return Container(width: double.infinity,height: double.infinity,
    alignment: Alignment.topLeft,
    child: SplitWidget(
      minWidth: 65,
      children: [
      Container(
        width: 128,
        height: 128,
        child: Scrollable(
          dragStartBehavior: DragStartBehavior.start,
        axisDirection:  AxisDirection.up,
        controller: new ScrollController(),
        // physics: ScrollPhysics.,
        restorationId: "restorationId",
          viewportBuilder: (BuildContext context, ViewportOffset offset) {
          return Container(width: 32,height: 32, color: Colors.green,child: Text("控件1 ${offset.pixels}"),);
        },
           ),
      ),
      Container(width:32,height:32,color: Colors.grey,child: Text("控件2"),),
      Container(width: 64,height: 32,child: Text("控件3"),),
      
      Container(width: 64,height: 32,color: Colors.orange,child: Text("控件4"),)
    ],),);
  }
  
}