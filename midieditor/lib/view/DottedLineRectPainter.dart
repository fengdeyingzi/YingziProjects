import "../BaseConfig.dart";
import "../base/StartWidget.dart";
import 'package:flutter/material.dart';

/*
绘制虚线线框
使用方法
Container(
      child: CustomPaint(
        painter: DottedLineRectPainter(),
        size: Size.infinite,
      ),
    )
 */
class DottedLineRectPainter extends CustomPainter {
  Paint paint_line;
  Color lineColor; //线条颜色
//  线条粗细
  double line_size;
  //虚线长度
  double line_length;
  //虚线间隔
  double line_interval;



  DottedLineRectPainter({this.lineColor,this.line_size,this.line_length,this.line_interval}){
    if(lineColor==null){
      lineColor = Colors.grey;
    }
    if(line_size==null){
      line_size = 1;
    }
    if(line_length==null){
      line_length=5;
    }
    if(line_interval==null){
      line_interval=3;
    }
    paint_line= Paint()
      ..color=lineColor
      ..strokeWidth=line_size;

  }

  //绘制一条横着的虚线 注意 x2必须大于x1
  void _drawHLine(Canvas canvas,double x1,double y1,double x2,double y2){
    Path path = new Path();
    assert(x2>x1);
    double ix = x1;
    double iy = y1;
    for(ix=x1;ix<x2;ix+=(line_interval+line_length)){
      path.moveTo(ix, iy);
      path.lineTo(ix+line_length, iy);
      if(ix+line_length<x2){
        canvas.drawLine(Offset(ix,iy), Offset(ix+line_length,iy), paint_line);
      }
      else{
        canvas.drawLine(Offset(ix,iy), Offset(x2,iy), paint_line);
      }

//      print("lineTo ${ix} ${iy}");
    }
//    canvas.drawPath(path, paint_line);

  }
  //绘制一条纵向虚线 注意 y2必须大于y1
  void _drawVline(Canvas canvas, double x1,double y1, double x2, double y2){
    Path path = new Path();
    assert(y2>y1);
    double ix = x1;
    double iy = y1;
    for(iy=y1;iy<y2;iy+=(line_interval+line_length)){
      path.moveTo(ix, iy);
      path.lineTo(ix, iy+line_length);
      if(iy+line_length< y2){
        canvas.drawLine(Offset(ix,iy), Offset(ix,iy+line_length), paint_line);
      }
      else
        canvas.drawLine(Offset(ix,iy), Offset(ix,y2), paint_line);
    }
//    canvas.drawPath(path, paint_line);
  }

  @override
  void paint(Canvas canvas, Size size) {
    //  implement paint
    double width = size.width;
    double height = size.height;
    _drawHLine(canvas, 0, 0, width, 0);
    _drawHLine(canvas, 0, height, width, height);
    _drawVline(canvas, 0, 0, 0, height);
    _drawVline(canvas, width, 0, width, height);
//    canvas.drawLine(new Offset(0,0), new Offset(width,20), paint_line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}