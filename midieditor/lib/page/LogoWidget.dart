import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:midieditor/BaseConfig.dart';
import 'package:midieditor/page/CodeEditWidget.dart';
import 'package:midieditor/util/XUtil.dart';

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
    _controller = new AnimationController(vsync: this, duration: Duration(seconds: 3));
    _controller.forward();
    _onLoading();
  }


  Future _onLoading() async {
    await Future.delayed(new Duration(milliseconds: 3000));
    navigationNameTo("CodeEditWidget",isPopAll: true);
//    navigationTo(GameMenuWidget());

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }


}