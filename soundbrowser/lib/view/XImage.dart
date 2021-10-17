import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import "../BaseConfig.dart";
import "../base/StartWidget.dart";
import 'package:flutter/material.dart';

/*
构建一个可以设置占位图以及错误图片的控件
如果不设置 默认为灰色背景框
 */
class XImage extends StatelessWidget {
  String noneImage;
  String errorImage;
  String imageUrl;
  double width;
  double height;
  BoxFit fit;
  double radius;
  Color backgroundColor;

  XImage(String imageUrl,{this.fit,this.errorImage,this. noneImage,this.width,this.height,this.radius,this.backgroundColor}){
    this.imageUrl = imageUrl;
    if(this.radius==null){
      this.radius = 0;
    }

  }

  Widget buildWebImage(){
    if(imageUrl==null || imageUrl.length==0){
      return Image.asset(errorImage??"assets/photo_error.png",width: width,height: height,fit:  fit??BoxFit.cover,);
    }
    if(imageUrl.startsWith("http://") || imageUrl.startsWith("https://")){
//      return CachedNetworkImage(
//        placeholder: (BuildContext context,String img){
//          return Image.asset(noneImage??"assets/photo.png",fit: fit??BoxFit.cover,width: width,height: height,);
//        },
//        errorWidget: (BuildContext,String img,Object error){
//          return Image.asset(errorImage??"assets/photo_error.png",width: width,height: height,fit: fit??BoxFit.cover,);
//        },
//        imageUrl: imageUrl,
//        width: width,
//        height: height,
//        fit: fit??BoxFit.cover,
//      );
      return FadeInImage.assetNetwork(
        placeholder: noneImage??"assets/photo.png",
        image: imageUrl,
        width: width,
        height: height,
        fit: fit??BoxFit.cover,
      );
    }

    else{
      if(BaseConfig.platform == "web"){
        return Image.asset(imageUrl,width: width,height: height,fit:  fit??BoxFit.cover,);
      }
      File file = new File(imageUrl);
      if(file.existsSync()){
        print("image file"+imageUrl);
        return Image.file(file,width: width,height: height,fit:  fit??BoxFit.cover,);
      }
      else{
        print("image asset"+imageUrl);
        return Image.asset(imageUrl,width: width,height: height,fit:  fit??BoxFit.cover,);
      }

    }
  }

  Widget buildImage(){
    if(imageUrl==null || imageUrl.length==0 ){
      return Image.asset(errorImage??"assets/grey.png",width: width,height: height,fit:  fit??BoxFit.cover,);
    }
    if(imageUrl.startsWith("http://") || imageUrl.startsWith("https://"))
      return CachedNetworkImage(
        placeholder: (BuildContext context,String img){
          return Image.asset(noneImage??"assets/grey.png",fit: fit??BoxFit.cover,width: width,height: height,);
        },
        errorWidget: (BuildContext,String img,dynamic error){
          return Image.asset(errorImage??"assets/grey.png",width: width,height: height,fit: fit??BoxFit.cover,);
        },
        imageUrl: imageUrl,
        width: width,
        height: height,
        fadeOutDuration:new Duration(microseconds: 200),
        fit: fit??BoxFit.cover,
      );
    else{
      File file = new File(imageUrl);
      if(file.existsSync()){
        print("image file"+imageUrl);
        return Image.file(file,width: width,height: height,fit:  fit??BoxFit.cover,);
      }
      else{
        print("image asset"+imageUrl);
        return Image.asset(imageUrl,width: width,height: height,fit:  fit??BoxFit.cover,);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
          color: backgroundColor,
          child: (BaseConfig.platform=="web")?buildWebImage(): buildImage()),
    );

  }

  //获取商家列表的logo图
  static Widget getListLogo(String url){
    return XImage(
      url ,
      width: 88,
      radius: 4,
      height: 62,
      fit: BoxFit.cover,
    );
  }

  static Widget getCompanyLogo(String url){
    return XImage(
      url ,
      radius: 4,
      width: 88,
      height: 62,
      fit: BoxFit.fill,
      noneImage: "assets/mrpic.png",
      errorImage: "assets/mrpic.png",
    );
  }

}

