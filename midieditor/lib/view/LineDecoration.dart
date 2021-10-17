import "../BaseConfig.dart";
import "../base/StartWidget.dart";
import 'package:flutter/material.dart';

/*
自定义TabBar的指示器
使用方法：在TabBar里加入属性
indicator: LineDecoration(width: 32, height: 3),
 */
class LineDecoration extends Decoration {
  double width;
  double height;
  Color color;
  double bottom;
  LineDecoration({this.width,this.height,this.color,this.bottom});

  @override
  BoxPainter createBoxPainter([Function onChanged]) {
    //  implement createBoxPainter
    return _LinePainter(tabWidth:width,tabHeight:height,color: color,bottom: bottom);
  }



}

class _LinePainter extends BoxPainter{
  double tabWidth;
  double tabHeight;
  Color color;
  double bottom;

  _LinePainter({this.tabWidth,this.tabHeight,this.color,this.bottom}){
    if(tabWidth==null){
      tabWidth = 32;

    }
    if(tabHeight == null){
      tabHeight = 3;
    }
    if(color==null){
      color = Colors.white;
    }
    if(bottom==null){
      bottom = 0;
    }
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    //  implement paint
    double width= configuration.size.width;
    double height = configuration.size.height;
//    print("绘制 ${width} ${height} ${offset.dx}");
    Paint paint = new Paint();
    paint.style = PaintingStyle.fill;
    paint.color = color;
    Rect rect = Rect.fromLTRB(offset.dx+(width - tabWidth)/2,(height-tabHeight-bottom),offset.dx+(width-tabWidth)/2+tabWidth,height-bottom);

    canvas.drawRect(rect, paint);

  }



}
