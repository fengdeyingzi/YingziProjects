import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import '../BaseConfig.dart';
import '../util/XUtil.dart';

import '../base/StartWidget.dart';

class LogoWidget extends StartWidget{
  @override
  State<StatefulWidget> createState() {
    return _LogoState();
  }

}


class _LogoState extends StartState<LogoWidget> with SingleTickerProviderStateMixin{
  AnimationController _controller = null;
  @override
  Widget buildWidget(BuildContext context) {
    double width = XUtil.getScreenWidget(context);
    print("屏幕宽度${width}");
    if(width>500){
      BaseConfig.isMaxScreen = true;
    }
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _controller,
          alwaysIncludeSemantics: false,
          child: Image.asset("assets/logo.png",width: 160,height: 160,),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.forward();
    _onLoading();
  }


  Future _onLoading() async {
    if(!isDebug()){
      await Future.delayed(new Duration(milliseconds: 1000));
    }
    else{
      await Future.delayed(new Duration(milliseconds: 1000));
    }
    navigationNameTo("DrawWidget",isPopAll: true);
//    navigationTo(GameMenuWidget());

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }


}