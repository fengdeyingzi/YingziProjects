import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soundbrowser/base/BoxStartWidget.dart';
import 'package:soundbrowser/model/MusicListModel.dart';
import 'package:soundbrowser/model/SoundPoolModel.dart';
import 'package:soundbrowser/util/BiliUtil.dart';
import 'package:soundbrowser/util/FileUtil.dart';
import 'package:soundbrowser/util/PlayUtil.dart';
import 'package:soundbrowser/util/XHttpUtils.dart';
import 'package:soundbrowser/util/XUtil.dart';
import 'package:soundbrowser/view/XImage.dart';

import '../BaseConfig.dart';

class SoundPoolWidget extends BoxStartWdiget {
  @override
  State<StatefulWidget> createState() {
    return _SoundPoolState();
  }
}

class _SoundPoolState extends BoxStartState<SoundPoolWidget> {
  String url = "https://member.bilibili.com";
  List<Categories> categories = null;
  List<Materials> materials = null;
  List<Hotword> hotword;
  List<Typelist> typelist;
  int load_state = 0;
  int load_type = null; //0音效 1音乐

  //音效下载 head
  // User-Agent:okhttp/3.12.12.9
  // APP-KEY:bilistudio
  // env:prod
  // Range: bytes=0-

  @override
  void initState() {
    super.initState();
    

    initDirs();
  }

  void refreshData(){
    if (load_type == 0) {
      getSoundTabs();
    } else {
      getMusicTabs();
      toast("音乐列表有签名校验\n所以暂不支持下载");
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

  Future<void> initDirs() async {
    //获取各种目录
    //适配安卓11 List<Directory> dirs = await getExternalCacheDirectories();
    Directory dir = await getTemporaryDirectory();
    print("externalCacheDirectories ${dir}");
    BaseConfig.cacheDir = dir;
    if (Platform.isWindows) {
      BaseConfig.docDir = await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      BaseConfig.docDir = await getApplicationDocumentsDirectory();
    } else {
      Directory dir_doc = await getExternalStorageDirectory();

      BaseConfig.docDir = dir_doc;
    }

    if (BaseConfig.docDir == null) {
      BaseConfig.docDir = await getApplicationSupportDirectory();
    }
    print("docDir ${BaseConfig.docDir}");
    if (!BaseConfig.cacheDir.existsSync()) {
      BaseConfig.cacheDir.create();
    }
    if (!BaseConfig.docDir.existsSync()) {
      BaseConfig.docDir.create();
    }
  }

  void onReStart() {
    super.onReStart();
    if (load_type == 0) {
      getSoundTabs();
    } else {
      getMusicTabs();
    }
  }

  

  //取文字生成图片
  Widget getImageText(String text) {
    if (text.length > 0) {
      text = text.substring(0, 1);
    }
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: BaseConfig.colorAccent,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            color: BaseConfig.lightBackgroundColor,
            fontSize: BaseConfig.font_h2,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> download(String url, String name) async {
    Map<String, String> data = {"APP-KEY": "bilistudio", "env": "prod"};
    String endName = ".wav";
    if (url.indexOf(".mp3") > 0) {
      endName = ".mp3";
    }
    var result = await XHttpUtils.download(url, heads: data);
    print("length" + result.length.toString());
    String path =
        BaseConfig.docDir.path + FileUtil.separatorChar() + name + endName;
    FileUtil.writeToFileData(result,
        BaseConfig.docDir.path + FileUtil.separatorChar() + name + endName);
    await PlayUtil.closeAll();
    PlayUtil.playSound(path);
  }

  Widget getTabItem(Categories item) {
    return GestureDetector(
      onTap: () {
        toast(item.name);
        navigationNameTo("SoundPoolList2Widget",
            arguments: {"id": item.id, "name": item.name, "type": load_type});
      },
      child: Container(
        width: 80,
        height: 80,
        child: Column(
          children: [
            getImageText(item.name),
            SizedBox(
              width: 8,
              height: 8,
            ),
            Text(item.name ?? "")
          ],
        ),
      ),
    );
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
        String path = getItemPath(item);
        if (load_type == 1) {
          toast("暂不支持");
        } else {
          if (File(path).existsSync()) {
            PlayUtil.playSound(path);
          } else {
            if (await BiliUtil.download(item.downloadUrl, item.name)) {
              setState(() {});
              toast("下载成功");
            } else {
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
            isFile
                ? Image.asset(
                    "assets/play.png",
                    width: 24,
                    height: 24,
                  )
                : Image.asset(
                    "assets/falling.png",
                    width: 24,
                    height: 24,
                  )
          ],
        ),
      ),
    );
  }

//获取音乐
  void getMusicTabs() async {
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
      "sign": "bf3f00adcd631c9be2128a393e470326"
    };
    var result = await XHttpUtils.request(url + "/x/material/bgm/bcut/pre",
        data: data, method: XHttpUtils.GET);
    print(result);

    MusicListModel model = MusicListModel.fromJson(result);
    if (model.code == 0) {
      setState(() {
        hotword = model.data.hotword;
        typelist = model.data.typelist;
        categories = [];
        materials = [];
        typelist.forEach((element) {
          categories.add(new Categories(id: element.id, name: element.name));
        });
        hotword.forEach((element) {
          materials.add(
              Materials(id: element.id, name: element.name, downloadUrl: ""));
        });
        load_state = STATE_SUCCESS;
      });

      // toast("加载完成");
    } else {
      toast("加载失败");
      setState(() {
        load_state = STATE_ERROR;
      });
    }
  }

  //获取音效列表
  Future<void> getSoundTabs() async {
    //&apply_for=0&build=1180030&c_locale=&channel=xiaomi&mobi_app=android_bbs&need_category=1&platform=android&s_locale=&tp=20&ts=1632540528&sign=bf3f00adcd631c9be2128a393e470326"
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
      "sign": "bf3f00adcd631c9be2128a393e470326"
    };
    var result = await XHttpUtils.request(url + "/x/material/bcut/v2/pre",
        data: data, method: XHttpUtils.GET);
    print(result);
    SoundPoolModel model = SoundPoolModel.fromJson(result);
    if (model.code == 0) {
      setState(() {
        categories = model.data.categories;
        materials = model.data.materials;
        load_state = STATE_SUCCESS;
      });

      // toast("加载完成");
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
          Wrap(
            children: categories.map((item) {
              return getTabItem(item);
            }).toList(),
          ),
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
        if (load_type == 0) {
          getSoundTabs();
        } else {
          getMusicTabs();
        }
      });
    } else {
      return getEmptyLoad();
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    var args = getArgs(context);
    if(load_type == null){
      load_type = args["type"];
      print("load_type ${load_type}");
      refreshData();
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: getContent(),
    );
  }
}
