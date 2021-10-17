import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:soundbrowser/base/BoxStartWidget.dart';
import 'package:soundbrowser/model/MusicList2Model.dart';
import 'package:soundbrowser/model/SoundPoolListModel.dart';
import 'package:soundbrowser/util/BiliUtil.dart';
import 'package:soundbrowser/util/FileUtil.dart';
import 'package:soundbrowser/util/PlayUtil.dart';
import 'package:soundbrowser/util/XHttpUtils.dart';
import 'package:soundbrowser/util/XUtil.dart';
import 'package:soundbrowser/view/XImage.dart';

import '../BaseConfig.dart';

class SoundPoolList2Widget extends BoxStartWdiget {
  @override
  State<StatefulWidget> createState() {
    return _SoundPoolList2State();
  }
}

class _SoundPoolList2State extends BoxStartState<SoundPoolList2Widget> {
  String url = "https://member.bilibili.com";
  // List<Categories> categories = null;
  List<Materials> materials = null;
  int load_state = 0;
  int id = null;
  int load_type = 0;

  @override
  void initState() {
    super.initState();
    // if(load_type == 0)
    // getSoundList();
    // else{
    //   getMusicList();
    // }
  }

  void onReStart() {
    super.onReStart();
    if(load_type == 0)
    getSoundList();
    else{
      getMusicList();
    }
  }

  String getTitle(){
    return load_type==0?"音效列表":"音乐列表";
  }

  //加收藏
  bool showStarButton(){
    return false;
  }

  //设置按钮
  bool showSettingButton(){
    return false;
  }

  String getItemPath(Materials item) {
    String endName = ".wav";
    String url = item.downloadUrl;
    if (url.indexOf(".mp3") > 0) {
      endName = ".mp3";
    }
    String name = FileUtil.HandleFileName(item.name);
    String path =
        BaseConfig.docDir.path + FileUtil.separatorChar() + name + endName;
    return path;
  }

  Widget getListItem(Materials item) {
    File file = File(getItemPath(item));
    bool isFile = file.existsSync();
    return InkWell(
      onTap: () async {
        toast(item.name ?? "");
        print(item.downloadUrl);
        if(load_type == 1){
          showInfoDialog("由于必剪APP音乐下载有签名校验，所以暂不支持下载QAQ");
        }else{
          String path = getItemPath(item);
        if (File(path).existsSync()) {
          PlayUtil.playSound(path);
        } else {
        if(await BiliUtil.download(item.downloadUrl,item.name)){
          setState(() {
            
          });
          toast("下载成功");
        }else{
          toast("下载失败");
        }
        }
        }
        
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        width: double.infinity,
        height: 40,
        child: Row(
          children: [
            Expanded(child: Text(item.name ?? "")),
          isFile? Image.asset("assets/play.png",width: 24,height: 24,):Image.asset("assets/falling.png",width: 24,height: 24,)],
        ),
      ),
    );
  }

  //获取音效列表
  Future<void> getSoundList() async {
    Map<String, dynamic> data = {
      "appkey": "5dce947fe22167f9",
      "apply_for": 0,
      "build": 1180030,
      "c_locale": "",
      "channel": "xiaomi",
      "mobi_app": "android_bbs",
      "need_category": 1,
      "platform": "android",
      "s_locale": "",
      "tp": 20,
      "ts": XUtil.currentTimeMillis() ~/ 1000,
      "sign": "bf3f00adcd631c9be2128a393e470326",
      "cat_id": 89,
      "max_rank": 0,
      "ps": 40,
      "version": 0,
    };
    var result = await XHttpUtils.request(url + "/x/material/bcut/v2/list",
        data: data, method: XHttpUtils.GET);

    SoundPoolListModel model = SoundPoolListModel.fromJson(result);
    if (model.code == 0) {
      setState(() {
        // categories = model.data.categories;
        materials = model.data.materials;
        load_state = STATE_SUCCESS;
      });

      toast("加载完成");
    } else {
      toast("加载失败");
      setState(() {
        load_state = STATE_ERROR;
      });
    }
  }

  //获取音乐列表
  Future<void> getMusicList() async {

    Map<String, dynamic> data = {
      "appkey": "5dce947fe22167f9",
      "apply_for": 0,
      "build": 1180030,
      "c_locale": "",
      "channel": "xiaomi",
      "mobi_app": "android_bbs",
      "need_category": 1,
      "platform": "android",
      "s_locale": "",
      "ts": XUtil.currentTimeMillis() ~/ 1000,
      "sign": "6219bfbb806bc86917e0d4838b36f7d9",
      "ps": 40,
      "version": 1632539772,
      "tid":id,

    };
    var result = await XHttpUtils.request(url + "/x/material/bgm/bcut/list",
        data: data, method: XHttpUtils.GET);

    MusicList2Model model = MusicList2Model.fromJson(result);
    if (model.code == 0) {
      setState(() {
        // categories = model.data.categories;
        List<Materials> list = [];
        model.data.list.forEach((element) {
          Materials item = new Materials(id: element.id,name: element.name,downloadUrl: element.downloadUrl);
          if(item.downloadUrl == ""){
            item.downloadUrl = element.wavesUrl;
          }
          item.downloadUrl = item.downloadUrl.replaceAll("-leftchannel.data", ".m4a");
          list.add(item);
        });
        materials = list;
        load_state = STATE_SUCCESS;
      });

      toast("加载完成");
    } else {
      toast("加载失败");
      setState(() {
        load_state = STATE_ERROR;
      });
    }
  }

  Widget getContent() {
    if (load_state == 0) {
      return getLoading(text: "加载中");
    } else if (load_state == STATE_SUCCESS) {
      return Column(
        children: [
          SizedBox(
            width: 16,
            height: 16,
          ),
          // Wrap(
          //   children: categories.map((item) {
          //     return getTabItem(item);
          //   }).toList(),
          // ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                var item = materials[index];
                return getListItem(item);
              },
              itemCount: materials != null ? materials.length : 0,
            ),
          )
        ],
      );
    } else if (load_state == STATE_ERROR) {
      return getErrorLoad(() {
        if(load_type == 0)
        getSoundList();
        else{
          getMusicList();
        }
      });
    } else {
      return getEmptyLoad();
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    if (id == null) {
      Map<String, dynamic> args = getArgs(context);
      id = args["id"];
      load_type = args["type"];
      if(load_type == 0)
      getSoundList();
      else{
        getMusicList();
      }
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: getContent(),
    );
  }
}
