

import 'dart:async';
import 'dart:convert';

import 'package:bubble_box/bubble_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qqchat/base/BoxStartWidget.dart';
import 'package:qqchat/util/XDialog.dart';
import 'package:qqchat/util/XHttpUtils.dart';
import 'package:qqchat/view/XImage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:io';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import '../BaseConfig.dart';

class QQChatWidget extends BoxStartWdiget {
  @override
  State<StatefulWidget> createState() {
    return _QQChatState();
  }
  
}

class ChatItem {
  String msg;
  int qq;
  String name;
  int type;
  ChatItem({this.msg,this.qq,this.name="",this.type = 1});
}

class _QQChatState extends BoxStartState {
  static int CHAT_MSG = 1;
  static int CHAT_ERR = -1;
  static int CHAT_PRO = 2;
  static int CHAT_XML = 3;
  static int CHAT_IMG = 4;

  TextEditingController controller_msg = TextEditingController();
  int qq = 0;
  bool isReg = false;
  String pass = "";
  bool doArgs = false;
  Map<int,String> map_qqname = {};
  List<ChatItem> list_chat = [];
  String addr = false?"ws://127.0.0.1:2024":"ws://websocket.yzjlb.net:2024";
  // String addr = "ws://127.0.0.1:2024";
  WebSocket _webSocket = null;
  WebSocketSink _websink = null;
  Timer time_beat = null;
  ScrollController scrollController = new ScrollController();

 void initState(){
   super.initState();
  //  list_chat.add(new ChatItem(msg: "测试",qq:2541012655,name:"影子"));
  //  list_chat.add(new ChatItem(msg: "测试336436",qq:2541012655,name:"影子"));
  //  list_chat.add(new ChatItem(msg: "测试434",qq:2541012655,name:"影子"));
    const timeout = const Duration(seconds: 15);
    time_beat=Timer.periodic(
      timeout,
      (t){
        _sendMessage("#");
        if(isDispose)
        t.cancel();
      }
    );
 }



 void onReStart(){
   refQQName(2541012655);
 }

 void dispose() {
    super.dispose();
    print("socket关闭");
    if (_webSocket != null) _webSocket.close();
    if (_websink != null) _websink.close();
    if(time_beat != null){
      if(time_beat.isActive){
      time_beat.cancel();
      }
    }
    
  }

    //加收藏
  bool showStarButton(){
    return false;
  }

  //关闭按钮
  bool showCloseButton(){
    return false;
  }

  //设置按钮
  bool showSettingButton(){
    return false;
  }

  String getTitle(){
    if (_webSocket == null && _websink == null) {
      return "Socket未连接";
    }
    return "伪QQ聊天室";
  }


  //获取qq昵称
  Future<String> getQQName(int qq) async {
    print("获取QQ昵称：${qq}");
    var bodyString = await XHttpUtils.requestBody("https://r.qzone.qq.com/fcg-bin/cgi_get_portrait.fcg?uins=${qq}",data: {
      "uins":qq
    },heads: {
      "content-type":XHttpUtils.formUrlEncodedContentType
    }, method: XHttpUtils.GET,coding: "GBK");
    print(bodyString);
    int start=0;
    int end = 0;
    int type = 0;
   
    for(int i=bodyString.length-1;i>0;i--){
      if(type == 0){
        if(bodyString[i] == "\""){
        end = i;
        type = 1;
      }
      }else{
        if(bodyString[i] == "\""){
          start = i+1;
          break;
        }
      }
      
    }
    if(start == 0 || end == 0){
      return null;
    }
    return bodyString.substring(start,end);
  }

  Future<void> refQQName(int qq) async {
    if(map_qqname[qq] == null){
      String name = await getQQName(qq);
      map_qqname[qq] = name;
      setState(() {
        
      });
    }
  }

  void doMessage(String onData) {
    if(onData[0] == "{"){
      Map<String, dynamic> map_data = json.decode(onData);
     String action = map_data["action"];
     if(action == "sendmsg"){
       refQQName(map_data["id"]);
       list_chat.add(ChatItem(msg: map_data["data"],qq: map_data["id"],type: CHAT_MSG)) ;
       
          Timer(Duration(milliseconds: 100), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
      toast("收到新消息");
        
     }else if(action == "prompt"){
       list_chat.add(ChatItem(msg: map_data["data"],qq: 0,type: CHAT_PRO));
     } 
     else if(action == "err"){
       showCupertinoDialog(context: context,
    barrierDismissible: true,
    builder:(BuildContext ctx){

      return XDialog.buildWeChatDialog(context, "错误", map_data["data"],confirmText: "确定",confirmCallback: (){

      });
    });
     }
     else if(action == "exit"){
        list_chat.add(ChatItem(msg: map_data["data"],qq: 0,type: CHAT_PRO));
     }
     setState(() {
       
     });
    }
     
  }

    //启动服务器连接
  Future<void> startSocket() async {
    if (addr == "") {
      return;
    }
    try {
//      channel = new IOWebSocketChannel.connect('ws://192.168.0.175:2020');
      if (BaseConfig.platform == "web") {
        var channel = WebSocketChannel.connect(Uri.parse("${addr}"));
        _websink = channel.sink;
        channel.stream.listen((onData) {
          showLogToast("onData:" + onData);
          if (onData is String) {
            print("message string");
            String message = onData as String;
            if (message[0] != "{") {
              print("message error");
              return;
            }
            doMessage(message);
          }

          // channel.sink.close(status.goingAway);
        }, onError: (err) {
          _websink = null;
          showLogToast("onError:" + err.toString());
          // playMsgSound();
        }, onDone: () {
          showLogToast("onDone");
          if (_websink != null) {
            _websink = null;
            update(() {});
          }
          // playLoginSound();
        });
        if(isReg){
          _sendMap({
          "action":"register",
          "data":pass,
          "id":qq
        });
        }
        else
        _sendMap({
          "action":"login",
          "data":pass,
          "id":qq
        });
      } else {
        _webSocket = await WebSocket.connect("${addr}");

        update(() {});
        _webSocket.listen((onData) {
          showLogToast("onData:" + onData);
          if (onData[0] != "{") {
            return;
          }
          doMessage(onData);
        }, onError: (err) {
          showLogToast("onError:" + err);
          // playMsgSound();
        }, onDone: () {
          showLogToast("onDone");
          if (_webSocket != null) {
            print("----> onDone " + _webSocket.readyState.toString());
            // if (_webSocket!.readyState == 1) {
              _webSocket = null;
              update(() {});
            // }
            
          }

          // playLoginSound();
        }, cancelOnError: true);
        if(isReg){
          _sendMap({
          "action":"register",
          "data":pass,
          "id":qq
        });
        }
        else
        _sendMap({
          "action":"login",
          "data":pass,
          "id":qq
        });
        // _sendMap({
        //   "action":"userlist"
        // });
      }

//      channel = IOWebSocketChannel.connect('ws://127.0.0.1:2020',pingInterval: Duration(milliseconds: 5000));
    } catch (e) {
      print("onError:" + e.toString());
      toast("socket连接失败:" + e.toString());
      // playMsgSound();
      update(() {
        _webSocket = null;
      });
    }
  }

  void _sendMap(Map<String, dynamic> map_obj) {
    if(map_obj!=null){
      _sendMessage(json.encode(map_obj));
    }
    
  }

  void _sendMessage(String text) {
    if (_webSocket != null)
      _webSocket.add(text);
    else if (_websink != null) {
      _websink.add(text);
    } else {
      toast("socket未连接");
      update(() {});
    }
    print("sendMessage ${text}");
  }

  Widget getChatMsg(ChatItem item){
    Widget layout_con  = Container();
   if(item.type == CHAT_MSG){
     layout_con =  Text(item.msg??"");
   } else if(item.type == CHAT_XML){
     
String htmlData = item.msg;
dom.Document document = htmlparser.parse(htmlData);
/// sanitize or query document here
Widget html = Html(
  document: document,
);
    layout_con = html;
   }

    if(item.qq == qq){
return Container(
  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
  child:   Row(
  
            mainAxisAlignment: MainAxisAlignment.end,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children: [
  
             
  
              Column(
  crossAxisAlignment: CrossAxisAlignment.end,
                children: [
  
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Text(map_qqname[item.qq]?? item.name),
                  ),
  
                  BubbleBox(
  
                    maxWidth: 200,
  
                    shape: BubbleShapeBorder(
  
                      direction: BubbleDirection.right,
  
                      arrowQuadraticBezierLength: 2,
  
                    ),
  
                    backgroundColor: Colors.white,
  
                    margin: EdgeInsets.all(4),
  
                    child: Text(
  
                      item.msg??"",
  
                    ),
  
                  ),
  
                ],
  
              ),
  
               XImage("http://q2.qlogo.cn/headimg_dl?dst_uin=${item.qq}&spec=640",width: 40,height: 40,radius: 20,),
  
            ],
  
          ),
);
    }else
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
            mainAxisAlignment: item.qq == qq ?MainAxisAlignment.end: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              XImage("http://q2.qlogo.cn/headimg_dl?dst_uin=${item.qq}&spec=640",width: 40,height: 40,radius: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Text(map_qqname[item.qq]??item.name),
                  ),
                  BubbleBox(
                    maxWidth: 200,
                    shape: BubbleShapeBorder(
                      direction: BubbleDirection.left,
                      arrowQuadraticBezierLength: 2,
                    ),
                    backgroundColor: Colors.white,
                    margin: EdgeInsets.all(4),
                    child: Text(
                      item.msg??"",
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }


  Widget getProMsg(ChatItem item){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color(0x30202020),
            borderRadius: BorderRadius.all(Radius.circular(3))
          ),
          child: Text(item.msg, style: TextStyle(
            color: BaseConfig.lightBackgroundColor,
            fontSize: BaseConfig.font_h5
          ),),
        ),
      ],
    );
  }


  @override
  Widget buildBody(BuildContext context) {
    var args = getArgs(context);
    if(!doArgs){
      doArgs = true;
      qq = args["qq"];
      pass = args["pass"];
      isReg = args["isreg"];
      startSocket();
    }
    return Container(
      color: Color(0xfff2f2f2),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(itemBuilder: (BuildContext context, int index){
              var item = list_chat[index];
              if(item.type == CHAT_PRO){
return getProMsg(item);
              }
              else
return getChatMsg(item);
            },itemCount: list_chat.length,
            controller: scrollController,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
        //           constraints: BoxConstraints(
        //   maxHeight: 50,
        //   minHeight: 20
        // ),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: BaseConfig.lightBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(24))
                  ),
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    
                    controller: controller_msg,
                    scrollPadding: EdgeInsets.zero,
                    style: TextStyle(
                      fontSize: BaseConfig.font_h3,
                      color: BaseConfig.textColor,
                      textBaseline: TextBaseline.alphabetic, //用于提示文字对齐
                    ),
                    // keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      isCollapsed: true,
                    border: InputBorder.none,
                    contentPadding:EdgeInsets.fromLTRB(8, 8, 8, 8),
                    hintStyle: TextStyle(
                      fontSize: BaseConfig.font_h3,
                      textBaseline: TextBaseline.alphabetic,
                      //用于提示文字对齐
                      color: BaseConfig.hintTextColor
                      ),
                    ),            
                  ),
                ),
              ),
              TextButton(onPressed: (){
                if(controller_msg.text.length == 0){
                  toast("请输入文字");
                  return;
                }
                _sendMap({
                  "action":"sendmsg",
                  "data":controller_msg.text,
                });
                controller_msg.text = "";
              }, 
            
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(BaseConfig.colorAccent),
                foregroundColor: MaterialStateProperty.all(BaseConfig.lightBackgroundColor),
                  shape:MaterialStateProperty.all( RoundedRectangleBorder(
        side: BorderSide(
          color: BaseConfig.colorAccent,
          width:3.0,
          style: BorderStyle.none
        ),
        borderRadius: BorderRadius.circular(20)
      ),),
              ),
              child: Text("发送")),
              SizedBox(width: 8,height: 8,)
            ],
          )
        ],
      ),
    );
  }
  
}