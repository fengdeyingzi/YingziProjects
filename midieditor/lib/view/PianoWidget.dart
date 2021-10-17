import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:midieditor/base/BaseWidget.dart';
import 'package:midieditor/view/ToolBar.dart';

import '../base/StartWidget.dart';

class PianoWidget extends StatefulWidget{
  
  int note;
  double width;
  double height;
 
  PianoWidget(this.note,this.width,this.height);

  @override
  State<StatefulWidget> createState() {
    return _PianoState();
  }

}


class _PianoState extends State<PianoWidget>{
bool isDown = false;
 Color color_none;
  Color color_down;
  void initState(){
  color_none = isSemitone(widget.note)?Color(0xff3090f0):Color(0xffffffff);
  color_down = isSemitone(widget.note)?Color(0xff202020):Color(0xff808080);
  }

  //通过node计算出是否为半音
  bool isSemitone(int node){
    var temp = node%12;
    if(temp==1 || temp==3 || temp==6 || temp==8 || temp==10){
      return true;
    }
    return false;
  }

  //通过node计算出音阶
  int getLeve(int node){
    return node~/12 -1 ;
  }

  //通过node计算出音符1-7
  int getNode(int node){
    int temp = node%12;
    if(temp>=11){
      return 7;
    }else if(temp>=9){
      return 6;
    }else if(temp>=7){
      return 5;
    }else if(temp>=5){
      return 4;
    }else if(temp>=4){
      return 3;
    }else if(temp>=2){
      return 2;
    }else if(temp>=0){
      return 1;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTapDown: (event){
setState(() {
  isDown = true;
});
      },
      onTapUp: (event){
setState(() {
  isDown = false;
});
      },
      child: Container(
        width:widget.width,
        height:widget.height,
      decoration: BoxDecoration(
        color: isDown?color_down:color_none,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4),bottomRight: Radius.circular(4.0))
      ),
      
    ),
    );
  }

}