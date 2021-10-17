import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:soundbrowser/base/BoxStartWidget.dart';

class DrawItem {
  int draw_type; //绘制类型
  //线条粗细
  double size; //线条粗细、圆形半径
  //线条颜色
  int color;
  List<Point> list; //线条列表

}

class DrawPainter extends CustomPainter {
  List<DrawItem> list_points;

  DrawPainter(this.list_points) {}

  // void drawText(Canvas canvas, String text, double x, double y, double width) {
  //   ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
  //     textAlign: TextAlign.center,
  //     fontWeight: FontWeight.w600,
  //     fontStyle: FontStyle.normal,
  //     fontSize: 24,
  //   ))
  //     ..pushStyle(ui.TextStyle(color: Color(0xff65a0f0)))
  //     ..addText('${text}');
  //   ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: width);
  //   ui.Paragraph paragraph = pb.build()..layout(pc);
  //   canvas.drawParagraph(paragraph, Offset(x, y));
  // }

  //画线
  void drawLines(Canvas canvas, List<Point> lines, Paint paint) {
    Path path = new Path();
print("drawLines"+lines.length.toString());
    for (var i = 0; i < lines.length; i++) {
      if (i == 0) {
        path.moveTo(lines[0].x, lines[0].y);
      } else if (i == lines.length - 1) {
        path.lineTo(lines[i].x, lines[i].y);
      } else {
        path.lineTo(lines[i].x, lines[i].y);
      }
    }
    canvas.drawPath(path, paint);
  }

  //画背景
  void drawBackground(Canvas canvas, Paint paint) {
    canvas.drawColor(paint.color, BlendMode.color);
  }

  //画圆
  void drawCir(Canvas canvas, Point point, double r, Paint paint) {
    canvas.drawCircle(new Offset(point.x, point.y), r, paint);
  }

  //画图片(base64)
  void drawImg(Canvas canvas, String base64img, Rect rect) {}
  //撤销
  void revoke() {
    list_points.removeLast();
  }

  //清空
  void clear() {
    list_points.clear();
  }

  //获取list （保存）
  List<Map<String, dynamic>> getListDraw() {
    List<Map<String, dynamic>> list = [];
    for (int i = 0; i < list_points.length; i++) {
      Map<String, dynamic> map_item = {};
      DrawItem drawItem = list_points[i];
      map_item["size"] = drawItem.size;
      map_item["color"] = drawItem.color;
      map_item["draw_type"] = drawItem.draw_type;
      StringBuffer buffer = new StringBuffer();
      for (int j = 0; j < drawItem.list.length; j++) {
        Point point = drawItem.list[j];
        buffer.write("${point.x},${point.y},");
      }
      map_item["list"] = buffer.toString();
      list.add(map_item);
    }
    return list;
  }

  //设置list
  void setListDraw(List<Map<String, dynamic>> list) {
    for (int i = 0; i < list.length; i++) {
      Map<String, dynamic> map_item = list[i];
      DrawItem drawItem = new DrawItem();
      drawItem.color = map_item["color"];
      drawItem.size = map_item["size"];
      drawItem.draw_type = map_item["draw_type"];
      String linestr = map_item["list"];
      List<Point> list_point = [];
      List<String> liststr = linestr.split(",");
      for (int j = 0; j < liststr.length; j++) {
        if (j % 2 == 0 && j < liststr.length - 1) {
          list_point
              .add(new Point(int.parse(liststr[j]), int.parse(liststr[j + 1])));
        }
      }
    }
    list_points = list_points;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for(var i=0;i<list_points.length;i++){
      DrawItem drawItem = list_points[i];
      Paint paint = new Paint();
      paint.strokeWidth = drawItem.size;
      paint.isAntiAlias = true;
      paint.strokeCap = StrokeCap.round;
      paint.strokeJoin=StrokeJoin.round;
      paint.maskFilter = MaskFilter.blur(BlurStyle.inner, 2.0); //模糊遮罩效果，flutter中只有这个
      paint.style = PaintingStyle.stroke;
      paint.color = Color(drawItem.color);
      if(drawItem.draw_type == 1){
        drawLines(canvas, drawItem.list, paint);
      }else if(drawItem.draw_type == 0){
        drawBackground(canvas, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DrawWidget extends StatefulWidget {
   List<DrawItem> list_points;
   Color backgroundColor;
  
  DrawWidget(this.list_points,this.backgroundColor);

  @override
  State<StatefulWidget> createState() {
    return _DrawState();
  }
}

class _DrawState extends State<DrawWidget> {
 
  

  @override
  void initState() {
    
    
    super.initState();
  }
//  @override
//   Widget build(BuildContext context) {
//     return Container(width: double.infinity,height: double.infinity,);
//   }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color:widget.backgroundColor,
        child: CustomPaint(
          painter: DrawPainter(widget.list_points),
          size: Size.infinite,
        ),
      ),
    );
  }
}
