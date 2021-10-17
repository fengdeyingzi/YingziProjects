
/*
一个只有状态栏高度的AppBar 可以自定义颜色
 */

import 'package:flutter/material.dart';

/*
只有状态栏高度的appBar
 */
class SmallAppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  Color barColor;
  SmallAppBarWidget({this.barColor}){
  }
  @override
  Widget build(BuildContext context) {
    //  implement build
    return Container(
        color: barColor??Colors.transparent,
        child: SafeArea(
          top: true, child: SizedBox(height: 0,),
        ));
  }
  @override
  //  implement preferredSize
  Size get preferredSize => Size.fromHeight(0);
}