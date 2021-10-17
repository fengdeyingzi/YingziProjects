import "../BaseConfig.dart";
import "../base/StartWidget.dart";
import 'package:flutter/material.dart';


class CircleCheckbox extends StatefulWidget {
  ValueChanged<bool> onChanged;
  bool value;
  double width;
  double height;

  CircleCheckbox({this.onChanged,Key key,this.value,this.width,this.height}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _CircleCheckbox();
  }
}

class _CircleCheckbox extends State<CircleCheckbox> {
  bool isCheck;
  double width;
  double height;

  @override
  void initState() {
    super.initState();
    isCheck = widget.value;
    width = widget.width;
    height = widget.height;
    if(isCheck==null)isCheck = false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          isCheck = !isCheck;
          if(widget.onChanged!=null){
            widget.onChanged(isCheck);
          }
        });

      },
      child: Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Container(
          width: widget.width??12,
          height: widget.height??12,
          child: Image.asset(widget.value ? "assets/cir_check_yes.png":"assets/cir_check_none.png",width: widget.width??12,height: widget.height??12,),
        ),
      ),
    );
  }


}