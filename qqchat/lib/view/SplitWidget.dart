import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qqchat/util/XUtil.dart';

class SplitWidget extends StatefulWidget {
  List<Widget> children;
  double minWidth = 30;
  SplitWidget({this.children,this.minWidth});
  @override
  State<StatefulWidget> createState() {
    return _SplitWidgetState();
  }
}



class _SplitWidgetState extends State<SplitWidget> {
  List<Widget> list_child; //控件
  List<double> list_width; //控件宽度
  double line_width = 4; //分割线宽度
  double upx = 0;
  double upy = 0;
  List<bool> list_isLight = [];
  List<bool> list_isEnter = [];
  double minwidth = 30;

  @override
  void initState() {
    if(widget.minWidth != null){
      this.minwidth = widget.minWidth;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double max_width = XUtil.getScreenWidth(context);
    if (list_width == null) {
      if (widget.children != null && widget.children.length > 0) {
        list_child = widget.children;
        list_width = [];
        list_isLight = [];
        list_isEnter = [];
        double item_w =
            (max_width - line_width * (widget.children.length - 1)) /
                widget.children.length-2;
        for (int i = 0; i < list_child.length; i++) {
          list_width.add(item_w);
          list_isLight.add(false);
          list_isEnter.add(false);
        }
      } else {
        list_child = [];
        list_width = [];
        list_isLight = [];
        list_isEnter = [];
      }
    }

    List<Widget> list_temp = [];
    for (int j = 0; j < list_child.length; j++) {
      
        if(j<list_child.length-1){
          list_temp.add(Container(
        width: list_width[j],
        child: list_child[j]));
          list_temp.add(MouseRegion(
        onEnter: (event) {
          
          list_isEnter[j] = true;
          setState(() {
            
          });
        },
        onExit: (event) {
          list_isEnter[j] = false;
          setState(() {
            
          });
        },
        child: GestureDetector(
            onPanDown: (event) {
              upx = event.localPosition.dx;
              upy = event.localPosition.dy;
              list_isLight[j] = true;
              
          setState(() {
            
          });
            },
            
            onPanUpdate: (event) {
              
              double movex = event.localPosition.dx - upx;
              if(list_width[j] + movex > minwidth && list_width[j+1] - movex > minwidth){
                list_width[j] += movex;
                if(list_width[j+1] - movex > minwidth){
                  list_width[j + 1] -= movex;
                }
              }
              
              
                
              

              upx = event.localPosition.dx;
              upy = event.localPosition.dy;
              list_isLight[j] = true;
             
          
              setState(() {});
            },
            onPanCancel: (){
              list_isLight[j] = false;
              
          setState(() {
            
          });
            },
            onPanEnd: (event){
list_isLight[j] = false;

          setState(() {
            
          });
            },
            child: MouseRegion(
    cursor: SystemMouseCursors.resizeColumn,
              child: Container(
                width: line_width,
                height: double.infinity,
                color: (list_isLight[j] || list_isEnter[j])?Colors.blue:Colors.transparent,
              ),
            )),
      ));
        } else {
          list_temp.add(Expanded(
        
        child: list_child[j]));
        }
      
    }
    return  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list_temp,
      )
    ;
  }

  @override
  void didUpdateWidget(covariant SplitWidget oldWidget) {
    double max_width = XUtil.getScreenWidth(context);
    if (widget.children != null && widget.children.length > 0) {
      list_child = widget.children;
      list_width = [];
      double item_w = (max_width - line_width * (widget.children.length - 1)) /
          widget.children.length;
      for (int i = 0; i < list_child.length; i++) {
        list_width.add(item_w);
      }
    } else {
      list_child = [];
      list_width = [];
    }
    if(widget.minWidth != null){
      this.minwidth = widget.minWidth;
    }
    super.didUpdateWidget(oldWidget);
  }
}
