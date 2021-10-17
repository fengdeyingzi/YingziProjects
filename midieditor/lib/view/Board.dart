


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midieditor/obj/Pieces.dart';
import 'package:sprintf/sprintf.dart';
import 'dart:ui' as ui;

import '../BaseConfig.dart';


class BoardPainter extends CustomPainter {
  var piece_size = 0; //棋格大小
  var board_num = 15; //横向 纵向 棋子数
  int highlight;
  var shownum = false;
  //棋子数组
  List<Pieces> list_pieces = [];

  BoardPainter(List<Pieces> list_pieces,this.highlight,{this.shownum = false}){
    this.list_pieces = list_pieces;
  }

  void drawText(Canvas canvas, String text, double x, double y, double width) {
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: 24,
    ))
      ..pushStyle(ui.TextStyle(color: Color(0xff65a0f0)))
      ..addText('${text}');
    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: width);
    ui.Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, Offset(x, y));
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    // print("绘制:${size.width},${size.height}");
    piece_size = (size.width/board_num).toInt();
    
    Paint paint = Paint();
    paint.color= Colors.grey;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;

    Paint paint_cir = Paint();
    paint_cir.color= Colors.grey;
    paint_cir.strokeWidth = 2;
    paint_cir.style = PaintingStyle.stroke;

    Paint paint_white = Paint();
    paint_white.style = PaintingStyle.fill;
    paint_white.color = Colors.white;

    Paint paint_black = Paint();
    paint_black.color= Colors.black;
    paint_black.style = PaintingStyle.fill;

    Paint paint_light = Paint();
    paint_light.style = PaintingStyle.stroke;
    paint_light.strokeWidth = 3;
    paint_light.color = Colors.orange[300];

    var paint_shownum = Paint();
    paint_shownum.style = PaintingStyle.fill;
    paint_shownum.color = Color(0xffd0d0d0);

    double width = size.width;
    double height = size.height;
    
    //画棋盘
    if(!shownum){
    for(var ix=0;ix<board_num;ix++){
      canvas.drawLine(Offset(piece_size/2 + ix*piece_size, piece_size/2), Offset(piece_size/2 + ix*piece_size, piece_size/2+piece_size*(board_num-1)), paint);
    }

    for(var iy=0;iy<board_num;iy++){
        canvas.drawLine(Offset(piece_size/2, piece_size/2 + iy*piece_size), Offset(piece_size/2 + piece_size*(board_num-1), piece_size/2+iy*piece_size), paint);
    }
    }

    //画棋子
    for(var ix=0;ix<board_num;ix++){
      for(var iy=0;iy<board_num;iy++){
        //显示棋盘index
        if(shownum){
          // canvas.drawCircle(Offset(piece_size/2 + ix*piece_size, piece_size/2 + iy*piece_size) , piece_size/2, paint_shownum);
          var text = sprintf("%02x",[iy*board_num+ix]);
          drawText(canvas, "${text}", piece_size/2 + ix*piece_size-20, piece_size/2 + iy*piece_size-20, 40);
        }
        var index = iy*board_num + ix;
        Pieces item = list_pieces[index];
        if(index == highlight){
          canvas.drawCircle(Offset(piece_size/2 + ix*piece_size, piece_size/2 + iy*piece_size) , piece_size/3 + 3, paint_light);
        }
        if(item.type == 1){
          canvas.drawCircle(Offset(piece_size/2 + ix*piece_size, piece_size/2 + iy*piece_size) , piece_size/3, paint_white);
            canvas.drawCircle(Offset(piece_size/2 + ix*piece_size, piece_size/2 + iy*piece_size) , piece_size/3, paint_cir);
        }
        else if(item.type == 2){
            canvas.drawCircle(Offset(piece_size/2 + ix*piece_size, piece_size/2 + iy*piece_size) , piece_size/3, paint_black);
        }

      }
    }
  

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


class Board extends StatefulWidget{
  //棋子数组
  List<Pieces> list_pieces = [];
  double width;
  double height;
  bool shownum;
  int highlight;
  Board(this.list_pieces,this.width,this.height,this.highlight,{this.shownum = false});

  @override
  State<StatefulWidget> createState() {
    return _Board();
  }

  

}

class _Board extends State<Board>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height:widget.height,
      child: CustomPaint(
        painter: BoardPainter(widget.list_pieces,widget.highlight,shownum: widget.shownum),
        size: Size.infinite,
      ),
    );
    
  }

}