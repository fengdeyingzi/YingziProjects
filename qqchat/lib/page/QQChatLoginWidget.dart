

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qqchat/base/BoxStartWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BaseConfig.dart';

class QQChatMainWidget extends BoxStartWdiget {
  @override
  State<StatefulWidget> createState() {
    return _QQChatMainState();
  }
  
}


class _QQChatMainState  extends BoxStartState{
  TextEditingController controller_qq = TextEditingController();
  TextEditingController controller_pass = TextEditingController();

  String getTitle(){
    return "伪QQ聊天室";
  }

  void initState(){
    super.initState();
    readUser();
  }

  //
  Future<void> saveUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  print('Pressed $counter times.');
  String qq = controller_qq.text;
  String pass = controller_pass.text;
  await prefs.setString('input_qq', qq);
  await prefs.setString("input_pass",pass);
}

Future<void> readUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  print('Pressed $counter times.');
  controller_qq.text = prefs.getString("input_qq");
  controller_pass.text = prefs.getString("input_pass");
  
}


  @override
  Widget buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("请输入QQ号："),
          TextField(
                                      controller: controller_qq,
                                      style: TextStyle(
                                        fontSize: BaseConfig.font_h3,
                                        color: BaseConfig.textColor
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                    SizedBox(width: 4,height: 4,),
          Text("注：QQ号将用于获取头像昵称，并非真的登录QQ",style: TextStyle(
            color: Color(0xfff06565)
          ),),
                                    SizedBox(width: 16,height: 16,),
          Text("请输入密码："),
          TextField(
                                      controller: controller_pass,
                                      keyboardType: TextInputType.visiblePassword,
                                      obscureText: true,
                                      
                                      style: TextStyle(
                                        fontSize: BaseConfig.font_h3,
                                        color: BaseConfig.textColor
                                      ),
                                    ),
                                    SizedBox(width: 4,height: 4,),
                                    Text("注：并非是QQ密码",style: TextStyle(
            color: Color(0xfff06565)
          ),),
          SizedBox(width: 16,height: 16,),
          TextButton(onPressed: (){
            if(controller_qq.text.length==0){
              toast("请输入QQ号");
            }
            else if(controller_qq.text.length<4){
              toast("请输入正确的QQ号");
            }else if(controller_pass.text.length<6){
              toast("请输入密码，或密码长度少于6位");
            }else{
              saveUser();
              navigationNameTo("QQChatWidget",arguments: {
                "qq":int.parse(controller_qq.text) ,
                "pass":controller_pass.text,
                "isreg":false
              });
            }
              
          }, 
          style: ButtonStyle(
             backgroundColor: MaterialStateProperty.all(BaseConfig.colorAccent),
          overlayColor: MaterialStateProperty.all(Color(0xff7abefe)),
          foregroundColor: MaterialStateProperty.all(BaseConfig.lightBackgroundColor)
          ),
          child: Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            child: Text("登录")),
            
            
            ),
            SizedBox(width: 8,height: 8,),
            TextButton(onPressed: (){
            if(controller_qq.text.length==0){
              toast("请输入QQ号");
            }
            else if(controller_qq.text.length<4){
              toast("请输入正确的QQ号");
            }else if(controller_pass.text.length<6){
              toast("请输入密码，或密码长度少于6位");
            }else{
              saveUser();
              navigationNameTo("QQChatWidget",arguments: {
                "qq":int.parse(controller_qq.text) ,
                "pass":controller_pass.text,
                "isreg":true
              });
            }
              
          }, 
          style: ButtonStyle(
             backgroundColor: MaterialStateProperty.all(BaseConfig.colorAccent),
          overlayColor: MaterialStateProperty.all(Color(0xff7abefe)),
          foregroundColor: MaterialStateProperty.all(BaseConfig.lightBackgroundColor)
          ),
          child: Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            child: Text("注册")),
            
            
            ),
        ],
      ),
    );
  }
  
}