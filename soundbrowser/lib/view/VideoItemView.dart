

import 'package:flutter/cupertino.dart';
import 'package:soundbrowser/view/XImage.dart';

class VideoItemView extends StatelessWidget{
  Alignment alignment; //图片显示位置
  Color backgroundColor; //背景色
  Color textColor;
  String img;
  String text;
  double itemwidth;
  double itemheight;
  BoxFit fit;

  VideoItemView(this.img,this.text,this.itemwidth,this.itemheight, {this.textColor,this.backgroundColor,this.alignment,this.fit});

  Widget getCenterWidget(){
    TextStyle textStyle = TextStyle(fontSize: 20,fontFamily: "黑体",color: textColor);
    if(alignment == null || alignment == Alignment.centerLeft){
      return Row(
  children: [
Padding(
  padding: const EdgeInsets.all(64),
  child:   XImage(img,width: itemwidth, height: itemheight,fit: fit,),
),
Expanded(child: Text(text,style: textStyle,))
  ],
);
    }else if(alignment == Alignment.centerRight){
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
  children: [

Expanded(child: Text(text,style: textStyle,textAlign: TextAlign.right,)),
Padding(
  padding: const EdgeInsets.all(64),
  child:   XImage(img,width: itemwidth, height: itemheight,fit: fit,),
),
  ],
);
    }else if(alignment == Alignment.topCenter){
      return Column(
  children: [
Padding(
  padding: const EdgeInsets.all(64),
  child:   XImage(img,width: itemwidth, height: itemheight,fit: fit,),
),
Expanded(child: Text(text,style: textStyle,))
  ],
);
    } else if(alignment == Alignment.bottomCenter){
      return Column(
  children: [

Expanded(child: Container(),),
Text(text,style: textStyle,textAlign: TextAlign.end,),
Padding(
  padding: const EdgeInsets.all(64),
  child:   XImage(img,width: itemwidth, height: itemheight,fit: fit,),
)
  ],
);
    } else if(alignment == Alignment.topLeft){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
  children: [
Padding(
  padding: const EdgeInsets.all(64),
  child:   XImage(img,width: itemwidth, height: itemheight,fit: fit,),
),
Expanded(child: Text(text,style: textStyle,))
  ],
);
    } else if(alignment == Alignment.topRight){
      return  Row(
        crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(child: Text(text,style: textStyle,textAlign: TextAlign.right,)),
Padding(
  padding: const EdgeInsets.all(64),
  child:   XImage(img,width: itemwidth, height: itemheight,fit: fit,),
),

  ],
);
    }else if(alignment == Alignment.bottomLeft){
      return  Row(
        crossAxisAlignment: CrossAxisAlignment.end,
  children: [
Padding(
  padding: const EdgeInsets.all(64),
  child:   XImage(img,width: itemwidth, height: itemheight,fit: fit,),
),
Text(text,style: TextStyle(fontSize: 32,),)
  ],
);
    }else {
      return  Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    Text(text,style: TextStyle(fontSize: 32,),),
Padding(
  padding: const EdgeInsets.all(64),
  child:   XImage(img,width: itemwidth, height: itemheight,fit: fit,),
),

  ],
);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width:double.infinity,
      height: double.infinity,
      color: backgroundColor,
      child:
getCenterWidget(),
    );
  }

}