import 'package:flutter/material.dart';
import 'package:gbk2utf8/gbk2utf8.dart';

import '../base/StartWidget.dart';
import '../BaseConfig.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class XHttpUtils {
  //创建HttpClient
  HttpClient _httpClient = HttpClient();
  static const String GET = 'GET';
  static const String POST = 'POST';
  static const String PUT = 'PUT';
  static const String PATCH = 'PATCH';
  static const String DELETE = 'DELETE';
  static const int CONNECT_TIMEOUT = 3000; //连接时间
  static const int SEND_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 10000; //接收时间
  static const jsonContentType = 'application/json; charset=utf-8';
  static const formUrlEncodedContentType = 'application/x-www-form-urlencoded';

  //要用async关键字异步请求
  getHttpClient() async {
    _httpClient
        .get('https://abc.com', 8090, '/path1')
        .then((HttpClientRequest request) {
      //在这里可以对request请求添加headers操作，写入请求对象数据等等
      // Then call close.
      return request.close();
    }).then((HttpClientResponse response) {
      // 处理response响应
      if (response.statusCode == 200) {
        response.transform(utf8.decoder).join().then((String string) {
          print(string);
        });
      } else {
        print("error");
      }
    });
  }

  getUrlHttpClient() async {
    var url = "https://abc.com:8090/path1";
    _httpClient.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
      // Optionally set up headers...
      // Optionally write to the request object...
      // Then call close.
      return request.close();
    }).then((HttpClientResponse response) {
      // Process the response.
      if (response.statusCode == 200) {
        response.transform(utf8.decoder).join().then((String string) {
          print(string);
        });
      } else {
        print("error");
      }
    });
  }

  //进行POST请求
  postHttpClient() async {
    _httpClient
        .post('https://abc.com', 8090, '/path2')
        .then((HttpClientRequest request) {
      //这里添加POST请求Body的ContentType和内容
      //这个是application/json数据类型的传输方式
      request.headers.contentType = ContentType("application", "json");
      request.write("{\"name\":\"value1\",\"pwd\":\"value2\"}");
      return request.close();
    }).then((HttpClientResponse response) {
      // Process the response.
      if (response.statusCode == 200) {
        response.transform(utf8.decoder).join().then((String string) {
          print(string);
        });
      } else {
        print("error");
      }
    });
  }

  //获取host

  //map转post form请求
  static String mapToPostData(Map<String, dynamic> data) {
    print("data ${data}");
    StringBuffer buf_post = new StringBuffer();
    if(data!=null)
    data.forEach((key, value) {
      String urlValue = value.toString();
      if (value is String) {
        urlValue = Uri.encodeComponent(value);
      }

      buf_post.write("${key}=${urlValue}&");
    });
    String re = buf_post.toString();
    if (re.length > 0) {
      return re.substring(0, re.length - 1);
    }
    return re;
  }

  //获取get路由

  static Future<Map<String, dynamic>> request(String url,
      {Map<String,String> heads,
      Map<String, dynamic> data,
      String method,
      String contentType = formUrlEncodedContentType}) async {
    Map<String, String> map_header = {};

    int pos = 80;
    if (url.startsWith("https:")) {
      pos = 443;
    }
    Uri uri = Uri.parse(url);
    StringBuffer buffer = new StringBuffer();
    buffer.write("--> ${method} ${url} ");
    
    String postData = json.encode(data);
    if (contentType != null) {
      map_header["content-type"] = contentType;
    }
    if (heads != null) {
      map_header.addAll(heads);
    }
    if (contentType == formUrlEncodedContentType) {
      
      postData = mapToPostData(data);
      print("键值对 ${postData}");
    }
    buffer.writeln("${postData}");
    print(map_header.toString());
    if (method == POST) {
      
        Uri uri = Uri.parse(url);
        http.Response response = await http
            .post(uri, headers: map_header, body: postData)
            .timeout(Duration(milliseconds: RECEIVE_TIMEOUT));
        buffer.write("${response.body}");
        print(buffer.toString());
      try {
        return json.decode(response.body);
      } catch (e) {
        buffer.write("error : ${e}");
        print(buffer.toString());
        return getInfoRequest(404, "${response.body}");
      }
    } else if (method == GET) {
        if(!postData.isEmpty){
          url = url+"?"+postData;
        }
        Uri uri = Uri.parse(url);
        print("请求："+url);
        http.Response response = await http.get(uri, headers: map_header);
        print("接收数据：${response.statusCode} ${response.body}");
        try {
        return json.decode(response.body);
        } catch (e) {
        print("error2 : ${e}");
        return getInfoRequest(404, "${response.body}");
      }
    }
    return null;
  }

    static Future<String> requestBody (
      String url,
      {heads, Map<String,dynamic> data, String method,String coding="UTF-8"}) async {
//    HttpClient _httpClient = HttpClient();
    int pos = 80;
    if(url.startsWith("https:")){
      pos = 443;
    }
    Uri uri = Uri.parse(url);
    StringBuffer buffer = new StringBuffer();
    buffer.write("--> ${method} ${url} ");
buffer.writeln("${json.encode(data)}");
// print("uri host ${uri.scheme} ${uri.host} path ${uri.path}" );
if(method==POST){
  try{
    Uri uri = Uri.parse(url);
    http.Response response = await http.post(uri,headers: heads, body: json.encode(data)).timeout(Duration(milliseconds: RECEIVE_TIMEOUT));
    buffer.write("${response.body}");
    print(buffer.toString());
    if(coding == "GBK"){
      return gbk.decode(response.bodyBytes);
    }else
    return response.body;
  }catch(e){
    buffer.write("error : ${e}");
    print(buffer.toString());
    return "获取数据失败";
  }



//  _httpClient.post(uri.scheme+"://"+uri.host, pos, uri.path).then((HttpClientRequest request) {
//    //这里添加POST请求Body的ContentType和内容
//    //这个是application/json数据类型的传输方式
//    request.headers.contentType = ContentType("application", "json");
//    request.write(json.encode(data));
//
//    return request.close();
//  }).then((HttpClientResponse response) {
//    // Process the response.
//    if (response.statusCode == 200) {
//      response.transform(utf8.decoder).join().then((String string) {
//        return json.decode(string);
//      });
//    } else {
//
//      return getInfoRequest(404, "获取数据失败${response}");
//    }
//  });
}
else if(method==GET){
  try{
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri,headers: heads);
    print("接收数据：${response.statusCode} ${response.body}");
    if(coding == "GBK"){
      return gbk.decode(response.bodyBytes);
    }else
    return response.body;
  }catch(e){
    print("error : ${e}");
    return "获取数据失败";
  }
//  _httpClient.get(uri.host, pos, uri.path).then((HttpClientRequest request) {
//    //这里添加POST请求Body的ContentType和内容
//    //这个是application/json数据类型的传输方式
//    request.headers.contentType = ContentType("application", "json");
////    request.write(json.encode(data));
//
//    return request.close();
//  }).then((HttpClientResponse response) {
//    // Process the response.
//    if (response.statusCode == 200) {
//      response.transform(utf8.decoder).join().then((String string) {
//        return json.decode(string);
//      });
//    } else {
//
//      return getInfoRequest(404, "获取数据失败${response}");
//    }
//  });
}
return null;

  }


  //返回一个错误的数据
  static Map<String, dynamic> getInfoRequest2(int code, String msg) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = msg;
    data['time'] = "1000";
    data['Data'] = msg;
    data['StatusCode'] = code;
    return data;
  }

  static Map<String, dynamic> getInfoRequest(int code, String msg) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = msg;
    data['time'] = "1000";
    data['data'] = msg;
    data['code'] = code;
    return data;
  }

  postUrlHttpClient() async {
    var url = "https://abc.com:8090/path2";
    _httpClient.postUrl(Uri.parse(url)).then((HttpClientRequest request) {
      //这里添加POST请求Body的ContentType和内容
      //这个是application/x-www-form-urlencoded数据类型的传输方式
      request.headers.contentType =
          ContentType("application", "x-www-form-urlencoded");
      request.write("name='value1'&pwd='value2'");
      return request.close();
    }).then((HttpClientResponse response) {
      // Process the response.
      if (response.statusCode == 200) {
        response.transform(utf8.decoder).join().then((String string) {
          print(string);
        });
      } else {
        print("error");
      }
    });
  }

  ///其余的HEAD、PUT、DELETE请求用法类似，大同小异，大家可以自己试一下
  ///在Widget里请求成功数据后，使用setState来更新内容和状态即可
  ///setState(() {
  ///    ...
  ///  });

static Future<List<int>> download(String url,
      {Map<String,String> heads,
      Map<String, dynamic> data,
      String contentType = formUrlEncodedContentType}) async {
    Map<String, String> map_header = {};

    int pos = 80;
    if (url.startsWith("https:")) {
      pos = 443;
    }
    
    StringBuffer buffer = new StringBuffer();
    buffer.write("--> download ${url} ");
    
    String postData = json.encode(data);
    if (contentType != null) {
      map_header["content-type"] = contentType;
    }
    if (heads != null) {
      map_header.addAll(heads);
    }
    if (contentType == formUrlEncodedContentType) {
      
      postData = mapToPostData(data);
      print("键值对 ${postData}");
    }
    buffer.writeln("${postData}");
    print(map_header.toString());
    
        if(!postData.isEmpty){
          url = url+"?"+postData;
        }
        Uri uri = Uri.parse(url);
        print("请求："+url);
        try{
        http.Response response = await http.get(uri, headers: map_header);
        print("接收数据：${response.statusCode} ${response.bodyBytes.length}");
        
        return response.bodyBytes;
        }catch(e){
          return [];
        }
        
  }
}
