import '../BaseConfig.dart';
import 'FileUtil.dart';
import 'PlayUtil.dart';
import 'XHttpUtils.dart';

class BiliUtil {
  static Future<bool> download(String url, String name) async {
    Map<String, String> data = {"APP-KEY": "bilistudio", "env": "prod"};
    String endName = ".wav";
    name = FileUtil.HandleFileName(name);
    if (url.indexOf(".mp3") > 0) {
      endName = ".mp3";
    }
    print("下载文件：$url");
    var result = await XHttpUtils.download(url, heads: data);
    if (result.length == 0) {
      return false;
    }
    print("length" + result.length.toString());
    String path =
        BaseConfig.docDir.path + FileUtil.separatorChar() + name + endName;
    FileUtil.writeToFileData(result,
        BaseConfig.docDir.path + FileUtil.separatorChar() + name + endName);
    await PlayUtil.closeAll();
    PlayUtil.playSound(path);
    return true;
  }
}
