import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen_adaptation/screen_adaptation.dart';
import 'package:soundbrowser/BaseConfig.dart';
import 'package:soundbrowser/base/BoxStartWidget.dart';
import 'package:soundbrowser/util/XUtil.dart';
import 'package:soundbrowser/view/StackText.dart';
import 'package:soundbrowser/view/VideoItemView.dart';

class VideoWidght extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoState();
  }
}
/*
包含的类型
图片（设置大小，填充类型，可放大，透明，移动，移入移出，翻转，弹跳，缩放弹跳动画，震动，杂色，可添加多图，变亮变暗）
动图（设置图片序列，设置帧率）
粒子 （方向，速度，生命，每秒生成数量）
标题 （设置背景，背景图，背景圆角，淡入淡出，打字效果，移入移出，跳跃，流光字，轮廓）
伪弹幕 （控制弹幕上，中，下 弹幕文字，控制弹幕大小）
播放视频（阻塞）
图片平铺 


设置界面切换效果（移动，淡入淡出，黑屏白屏）

全局显示：
图片
进度条
红框


*/
class _VideoState extends State<VideoWidght> {
  String text = "测试";
  TextStyle textStyle = TextStyle();
  double strokeWidth = 2.0;
  Color strokeColor = Colors.grey;

  Color textColor = Colors.white;
  String img = "I:\\Pictures\\吾爱破解logo.png";
  Color backgroundColor = Colors.white;
  Alignment alignment = Alignment.centerLeft;
  String showType = "video_item";
  Matrix4 mzoom;
  Size video_size = Size(640, 360);
  double opacity = 1.0;
  Duration opacity_duration = Duration(microseconds: 1000);
  

  @override
  void initState() {
    super.initState();
    mzoom = Matrix4.identity();
    onReStart();
  }

  Future<void> showImageText(String img, String text, Alignment alignment, {Duration duration}) async {
    print("showImageText " + text);
    this.showType = "video_item";
    this.img = img;
    this.text = text;
    this.alignment = alignment;
    setState(() {});
    await Future.delayed(duration?? Duration(milliseconds: 1500));
  }

//一个简单的标题
  Future<void> showTitle(String title,{Color color=Colors.white,TextStyle style, double strokeWidth=3.0,Color strokeColor=Colors.grey,Duration duration,bool sleep=true}) async {
    this.showType = "title";
    this.text = title;
    this.textStyle = style;
    this.textColor = color;
    this.strokeColor = strokeColor;
    this.strokeWidth = strokeWidth;
    setState(() {
      
    });
    if(sleep){
      await Future.delayed(duration?? Duration(milliseconds: 1500));
    }
  }

  Future<void> setOpacity(double opacity,{Duration duration,bool sleep=true}) async {
    this.opacity = opacity;
    if(duration!=null)
    this.opacity_duration = duration;
    setState(() {
      
    });
    if(sleep){
      await Future.delayed(this.opacity_duration?? Duration(milliseconds: 1500));
    }
  }

  //关闭视频画面
  void closeVideo() {
    this.showType = "close";
    setState(() {});
  }

//屏幕显示动画 持续1.5秒
  Future<void> screenShow() async {
    await setOpacity(1.0, duration: Duration(microseconds: 500,seconds: 1));
  }

//屏幕隐藏动画 持续1.5秒
  Future<void> screenHide() async {
    await setOpacity(0, duration: Duration(microseconds: 500,seconds: 1));
  }

//实现简单屏幕转场效果
  Future<void> screenTransition() async {
    await screenHide();
    screenShow();
  }

  Future<void> onReStart() async {
    backgroundColor = Colors.black;
    showTitle("影子的动画测试", style: TextStyle(fontSize: 24,color: Colors.white),strokeWidth:4,strokeColor: Colors.green  );
    await Future.delayed(new Duration(milliseconds: 3000));
    
    await screenTransition();
    await showImageText("https://image.dbbqb.com/202109070824/eef56bf7dd9e11ed52eba470d23f9e15/2jZJ3", "今天我走在大街上", 
      Alignment.centerLeft,duration: Duration(milliseconds: 3));
    
    await screenTransition();
    await showImageText("https://image.dbbqb.com/202109070825/fedae3f08526a3917bd26cee89da42b6/0xn2r", "遇到了小蟀", 
      Alignment.centerRight,duration: Duration(seconds: 3,milliseconds: 500));
    await screenTransition();
    await showImageText("https://image.dbbqb.com/202109070825/43127f7da75f9c02fd5bbb2f92aeb756/zbDo", "我一不小心踩死了他", 
      Alignment.centerLeft,duration: Duration(milliseconds: 500,seconds: 1));
    await screenTransition();

    await showImageText("https://image.dbbqb.com/202109070826/c101d0223afbd6ca239a2bc0a5182415/QZzd", "然后小蟀对我说\n影子伞兵！", 
      Alignment.centerLeft,duration: Duration(milliseconds: 500,seconds: 1));
    
    await showImageText("https://image.dbbqb.com/202109070825/3d247582e44dbc31089e9919da0c3834/rE5q", "然后小蟀对我说\n影子伞兵！", 
      Alignment.centerLeft,duration: Duration(milliseconds: 500,seconds: 2));
    await screenTransition();
    

    closeVideo();

    // await Future.delayed(new Duration(milliseconds: 3000));
    // showImageText("I:\\Pictures\\吾爱破解logo.png", "左上", Alignment.topLeft);
    // await Future.delayed(new Duration(milliseconds: 3000));
    // showImageText("I:\\Pictures\\吾爱破解logo.png", "左下", Alignment.bottomLeft);
    // await Future.delayed(new Duration(milliseconds: 3000));
    // showImageText("I:\\Pictures\\吾爱破解logo.png", "右上", Alignment.topRight);
    // await Future.delayed(new Duration(milliseconds: 3000));
    // showImageText("I:\\Pictures\\吾爱破解logo.png", "右下", Alignment.bottomRight);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (ModalRoute.of(context).isCurrent) {
      onReStart();
    }
  }

  Widget getVideoItem() {
    Widget layout = null;
    if (showType == "video_item") {
      layout =  Container(
        width: video_size.width,
        height: video_size.height, //xldebug
        padding: const EdgeInsets.all(32.0),
        color: backgroundColor,
        child: VideoItemView(img, text, 160, 160,
            backgroundColor: backgroundColor,
            textColor: textColor,
            alignment: alignment),
      );
    } else if(showType == "title"){
      layout = Container(width: video_size.width,height: video_size.height,
      alignment: Alignment.center,
      color: backgroundColor,
      child: StackText(text??"",style: textStyle,strokeWidth: strokeWidth,strokeColor: strokeColor,),
      );
    }else {
      layout = Container(
      width: video_size.width,
      height: video_size.height, //xldebug
      child: SizedBox(),
      color: backgroundColor,
    );
    }
    return AnimatedContainer(duration: opacity_duration,
    color: backgroundColor,
    child: 
     AnimatedOpacity(opacity: opacity, duration: opacity_duration,
      curve: Curves.fastOutSlowIn,
      child: layout,),
    );
  }

  Widget buildViewZoom(Widget child){
    
    double zoom = XUtil.getScreenWidget(context)/ video_size.width;
    double zoomy = XUtil.getScreenHeight(context) / video_size.height;
    print("zoom ${zoom} ${XUtil.getScreenWidget(context)}/${video_size.width}");
    if(zoom<1)zoom = 1;
    if(zoomy<1)zoomy = 1;
    mzoom = Matrix4.diagonal3Values(zoom, zoomy, 1);
    return Transform(transform: mzoom,child: Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topLeft,
      child: child),);
  }

bool onEnter = false;
  @override
  Widget build(BuildContext context) {
    
    return Material(
        child: Center(
          child: GestureDetector(
              onDoubleTap: () {
                onReStart();
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  buildViewZoom(getVideoItem()),
                  Column(
                    children: [
                      MouseRegion(
                        onEnter: (event){
onEnter = true;
setState(() {
  
});
                        },
                        onExit: (event){
onEnter = false;
setState(() {
  
});
                        },
                        child: Container(width: double.infinity,height: 48,child: Row(
                          children: [
                            Expanded(child: MoveWindow(
                              child: Container(
                                height: 48,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(16, 4, 4, 4),
                                child: Text(onEnter?"xmovie":"",style: TextStyle(color: Colors.grey,fontSize: BaseConfig.font_h2),textAlign: TextAlign.center,)),
                            )),
                            
                          ]..add(onEnter?WindowButtons():SizedBox()),
                        )
                        ,),
                      )
                    ],
                  )
                ],
              )),
        ));
  }
}
