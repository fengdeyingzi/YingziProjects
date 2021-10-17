


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
      else if(path[i]=="/"){
        return "";
      }
    }
    return "";
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

  //获取文件名
  static String getName(String path){
    if(path == null)return null;
    for(var i=path.length-1; i>=0; i--){
      if(path[i]=="/" || path[i]=="\\"){
        return path.substring(i+1);
      }
    }
    return "";
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

}


