


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FileUtil  {

  //读取一个文件的文本数据

  static String separatorChar(){
    if(Platform.isWindows){
      return "\\";
    }
    else{
      return "/";
    }
  }

  //获取文件后缀 包含.
  static String getEndName(String path){
    if(path == null)return null;
    for(var i=path.length-1; i>=0; i--){
      if(path[i] == "."){
        return path.substring(i);
      }
      else if(path[i]=="/" || path[i]=="\\"){
        return "";
      }
    }
    return "";
  }

  //获取上级目录
  static String getParamPath(String path){
    if(path == null)return null;
    for(var i=path.length-1; i>=0; i--){
      if(path[i]=="/" || path[i]=="\\"){
        return path.substring(0, i);
      }
    }
    return "";
  }

  //获取文件名
  static String getName(String path){
    if(path == null)return null;
    for(var i=path.length-1; i>=0; i--){
      if(path[i]=="/" || path[i]=="\\"){
        return path.substring(i+1);
      }
    }
    return path;
  }
  
  static String getNameEx(String path){
    if(path == null)return null;
    String endName = getEndName(path);
    String name = "";
    for(var i=path.length-1; i>=0; i--){
      if(path[i]=="/" || path[i]=="\\"){
        name = path.substring(i+1);
        break;
      }
    }

    return name.substring(0,name.length-endName.length);
  }

  //获取文件所在文件夹
  static String getDir(String path){
    if(path == null)return null;
    for(var i=path.length-1; i>=0; i--){
      if(path[i]=="/" || path[i]=="\\"){
        return path.substring(0, i);
      }
    }
  }

  static void rename(String path,String name){
    new File(path).rename((getDir(path)??"")+"/"+name);
  }

  static void renameEx(String path,String name){
    new File(path).rename(getDir(path)??""+"/"+name + (getEndName(path)??""));
  }

  static Uint8List readData(String path){
    return new File(path).readAsBytesSync();
  }

  //写入文件
  static Future<void> writeToFile(ByteData data, String path){
    final buffer = data.buffer;
    return new File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  static Future<void> writeToFileData(List<int> data, String path){
    
    return new File(path).writeAsBytes(data);
  }

  /// 递归缓存目录，计算缓存大小
static Future<int> getSize(final FileSystemEntity file) async {
  /// 如果是一个文件，则直接返回文件大小
  if (file is File) {
    int length = await file.length();
    return length;
  }

  /// 如果是目录，则遍历目录并累计大小
  if (file is Directory) {
    final List<FileSystemEntity> children = file.listSync();

    int total = 0;

    if (children != null && children.isNotEmpty)
      for (final FileSystemEntity child in children)
        total += await getSize(child);

    return total;
  }

  return 0;
}

/// 递归删除缓存目录和文件
static Future<void> delete(FileSystemEntity file) async {
  if (file is Directory) {
    final List<FileSystemEntity> children = file.listSync();
    for (final FileSystemEntity child in children) {
      await delete(child);
    }
  } else {
    await file.delete();
  }
}

  static String getPrintSize(int size) {
        //如果字节数少于1024，则直接以B为单位，否则先除于1024，后3位因太少无意义
        if (size < 1024) {
            return size.toString() + "B";
        } else {
            size = size ~/ 1024;
        }
        //如果原字节数除于1024之后，少于1024，则可以直接以KB作为单位
        //因为还没有到达要使用另一个单位的时候
        //接下去以此类推
        if (size < 1024) {
            return size.toString() + "KB";
        } else {
            size = size ~/ 1024;
        }
        if (size < 1024) {
            //因为如果以MB为单位的话，要保留最后1位小数，
            //因此，把此数乘以100之后再取余
            size = size * 100;
            return (size ~/ 100).toString() + "."
                    + (size % 100).toString() + "MB";
        } else {
            //否则如果要以GB为单位的，先除于1024再作同样的处理
            size = size * 100 ~/ 1024;
            return ((size ~/ 100).toString()) + "."
                    + ((size % 100).toString()) + "GB";
        }
    }

     //检测文件名是否合法，不包含：\/：*？“<>|
  static bool CheckFileName(String path){
if(path == null)return false;
    for(var i=path.length-1; i>=0; i--){
      if(path[i] == "\\" || path[i]=="/" || path[i]==":"|| path[i] == "*" || path[i]=="?"||path[i]=="\"" || path[i]=="<" || path[i]==">" || path[i]=="|"){
        return false;
      }

    }
    return true;
  }

  //去除文件名中不合法的部分
  static String HandleFileName(String path){
    if(path == null)return "";
    StringBuffer buffer = new StringBuffer();
    for(var i=0; i<path.length; i++){
      if(path[i] == "\\" || path[i]=="/" || path[i]==":"|| path[i] == "*" || path[i]=="?"||path[i]=="\"" || path[i]=="<" || path[i]==">" || path[i]=="|"){

      }else{
        buffer.write(path[i]);
      }

    }
    return buffer.toString();
  }

}


