// extern crate env_logger;
/// Simple WebSocket server with error handling. It is not necessary to setup logging, but doing
/// so will allow you to see more details about the connection by using the RUST_LOG env variable.
extern crate ws;
#[macro_use]
extern crate json;
/*
formt!

客户端：
心跳包：#
注册
  {action:register,data:密码,id:738565676}
登录
  {action:login,data:这是密码,id:654657465}
发送消息
  {action:sendmsg,data:这是一条消息}
发送xml消息（暂未实现）
  {action:sendxml,data:这是消息，可以加<image url=/>}
发送图片消息
  {action:sendimg,data:这是图片消息}
退出登录
  {action:exit}

服务器：
发送消息
  {action:sendmsg,data:这是一条消息,id:用户id,name:用户名}
发送图片消息
  {action:sendimg,data:http://...,id:用户id}
发送xml消息（暂未实现）
  {action:sendxml,data:这是一条消息,id:用户id,name:用户名}
发送消息列表（暂未实现）
  {action:msgs,data:[
      {
          id:用户名id
          name:用户名
      }
  ]}
收到系统提示
  {action:prompt,data:这是一个提示}
收到成员退出信息
  {action:exit,id:758386576}
用户系统，用json保存
{
  userlist:[
    {
      qq:13738568,
      pass:34675767
    }
  ]
}


*/

use json::JsonValue;
use std::fs::File;
use std::io::Read;
use std::io::Write;
use std::path::Path;
use std::sync::mpsc;
use std::sync::Mutex;
use std::thread;
use ws::listen;
use ws::CloseCode;
use ws::Error;
use ws::Handler;
use ws::Handshake;
use ws::Message;
use ws::Result;
use ws::Sender;
// use ws::debug;

#[macro_use]
extern crate lazy_static;

struct ChatItem {
  qq: i64,
  msg: String,
  time: String,
  action:String
}

lazy_static! {
//   static ref HOSTNAME: Mutex<String> = Mutex::new(String::new());
  static ref LIST_CON: Mutex<Vec<Sender>> = Mutex::new(Vec::new());
  static ref LIST_USER: Mutex<json::JsonValue> = Mutex::new(json::JsonValue::new_array());
  static ref LIST_MSG: Mutex<Vec<ChatItem>>  = Mutex::new(Vec::new());
}

fn add_msg(action:String, msg: String, qq: i64 ) {
  let mut list_msg = LIST_MSG.lock().unwrap();
  println!("添加一条消息 {}", msg);
  let msgitem = ChatItem {
    action:action,
    msg: msg,
    qq: qq,
    time: String::from("我也不知道"),
  };

  list_msg.push(msgitem);
}



fn send_msglist(con: &ws::Sender) {
  let mut list_msg = LIST_MSG.lock().unwrap();
  println!("发送历史消息");
  for (index, value) in list_msg.iter().enumerate() {
    let students = object! {
        "action" => value.action.clone(),
        "data" => value.msg.clone(),
        "id" => value.qq
    };
    let response = students.dump();
    println!("send {}", response);
    con.send(response);
  }
}

fn add_user(qq: i64, pass: String) -> bool {
  {
    let mut list_user = LIST_USER.lock().unwrap(); //等待，阻塞线程，
                                                   // match list_user {
                                                   //   json::JsonValue::Array(list_user) => {
    let mut sub_items = json::JsonValue::new_object();
    println!("添加QQ：{} {}", qq, pass);
    sub_items["qq"] = qq.into();
    sub_items["pass"] = json::JsonValue::String(pass);

    for i in 0..list_user.len() {
      let item: &JsonValue = &(list_user[i]);
      if item["qq"] == qq {
        println!("添加qq失败：{}", qq);
        return false;
      }
    }
    list_user.push(sub_items);
  }
  save_users();
  //   }
  // }
  return true;
}

//修改用户密码
fn set_user(qq: i64, pass: String) {
  let mut list_user = LIST_USER.lock().unwrap(); //等待，阻塞线程，
                                                 // match list_user {
                                                 //   json::JsonValue::Array(list_user) => {
  let mut sub_items = json::JsonValue::new_object();
  sub_items["qq"] = qq.into();
  sub_items["pass"] = json::JsonValue::String(pass);
  for i in 0..list_user.len() {
    let item: &JsonValue = &(list_user[i]);
    if item["qq"] == qq {
      list_user.array_remove(i);
    }
  }
  list_user.push(sub_items);
  //   }
  // }
}

fn read_txt(path: &String) -> String {
  let data = read_data(path);
  return String::from(std::str::from_utf8(&data).unwrap());
}

//读取二进制文件
fn read_data(path: &String) -> Vec<u8> {
  let mut buffer = [0u8; 1024];
  let mut readlen = 0;
  let mut offset = 0;
  let mut vec_data: Vec<u8> = Vec::new();
  let mut f: File = File::open(path).unwrap();

  loop {
    readlen = f.read(&mut buffer).unwrap();
    println!("读取：{}", readlen);
    if readlen <= 0 {
      break;
    } else {
      offset += &readlen;
      for i in 0..readlen {
        vec_data.push(buffer[i]);
        // println!("index:{}",i);
      }
    }
  }
  println!("数组长度：{}", vec_data.len());

  return vec_data;
}

//将string保存为utf8编码
fn save_text(path: &String, text: &String) -> bool {
  let mut file = File::create(path).unwrap();
  file.write(text.as_bytes());
  return true;
}

//读取用户列表
fn read_users() {
  // let f = File::open("users.json").unwrap();
  // let jsons:serde_json::Value = serde_json::from_reader(f).unwrap();
  // jsons["userlist"];
  let path = Path::new("users.json");
  if path.exists() {
    let jsontext = read_txt(&String::from("users.json"));
    let parsed = json::parse(jsontext.as_str()).unwrap();
    let mut list_temp = &parsed["userlist"];
    let mut list_user = LIST_USER.lock().unwrap(); //等待，阻塞线程，
    for item in list_temp.members() {
      list_user.push(item.clone());
    }
  } else {
    println!("读取用户列表失败 文件不存在");
    save_users();
  }
  test_json();
}

//保存用户列表
fn save_users() {
  let mut list_user = LIST_USER.lock().unwrap(); //等待，阻塞线程，
  let students = object! {
      "name" => "userlist",
      // "sex" => 15,
      // "height" => 156,
      // "weight" => 45,
      // "hobby1" => "吹牛逼".to_string(),
      // "hobby2" => hobby,
      "userlist" => (*list_user).clone(),
      // "features" => array![features_0,features_1],
      // "score_main" => score,
      // "score_branch" => score_other,
      // "others"=> data
  };
  let response = students.dump();
  println!("[返回数据]：{}", response);
  save_text(&String::from("users.json"), &response);
}

//读取消息列表
fn read_msgs() {
  // let f = File::open("users.json").unwrap();
  // let jsons:serde_json::Value = serde_json::from_reader(f).unwrap();
  // jsons["userlist"];
  let path = Path::new("msgs.json");
  if path.exists() {
    let jsontext = read_txt(&String::from("msgs.json"));
    let parsed = json::parse(jsontext.as_str()).unwrap();
    let mut list_temp = &parsed["msglist"];
    let mut list_msg = LIST_MSG.lock().unwrap(); //等待，阻塞线程，
    for item in list_temp.members() {
      let chatitem = ChatItem{
        action:item["action"].as_str().unwrap().to_string(),
        msg:item["data"].as_str().unwrap().to_string(),
        qq:item["id"].as_i64().unwrap(),
        time:"".to_string()
      };
      print!("{}",item["data"].as_str().unwrap());
      list_msg.push(chatitem);
    }
  } else {
    println!("读取消息列表失败 文件不存在");
    save_msgs();
  }
  test_json();
}
//保存消息列表
fn save_msgs() {
  let mut list_msg = LIST_MSG.lock().unwrap(); //等待，阻塞线程，
  let mut subobject = JsonValue::new_array();
  for (index,value) in list_msg.iter().enumerate() {
    let mut itemobject = JsonValue::new_object();
    itemobject["action"] = value.action.clone().into();
    itemobject["data"] = value.msg.clone().into();
    itemobject["id"] = value.qq.into();
    subobject.push(itemobject);
  }
  let students = object! {
      "name" => "userlist",
      "msglist" => subobject,
  };
  let response = students.dump();
  println!("[返回数据]：{}", response);
  save_text(&String::from("msgs.json"), &response);
}

fn test_json() {
  let list_user = LIST_USER.lock().unwrap(); //等待，阻塞线程，
  let students = object! {
      "name" => "userlist",
      // "sex" => 15,
      // "height" => 156,
      // "weight" => 45,
      // "hobby1" => "吹牛逼".to_string(),
      // "hobby2" => hobby,
      "userlist" => (*list_user).clone(),
      // "features" => array![features_0,features_1],
      // "score_main" => score,
      // "score_branch" => score_other,
      // "others"=> data
  };
  let response = students.dump();
  println!("[返回数据]：{}", response)
}

fn sendproall(msg: &String) {
  println!("sendproall 1");
  let mut list_temp = LIST_CON.lock().unwrap(); //等待，阻塞线程，
  println!("sendproall 2");
  let students = object! {
      "action" => "prompt",
      "data" => msg.clone()
  };
  let response = students.dump();
  println!("sendproall {}", msg);
  for i in 0..(*list_temp).len() {
    let item = (*list_temp).get(i).unwrap();
    item.send(response.clone());
  }
}

fn sendmsgall(msg: String, qq: i64) {
  let mut list_temp = LIST_CON.lock().unwrap(); //等待，阻塞线程，
  let students = object! {
      "action" => "sendmsg",
      "data" => msg.clone(),
      "id" => qq
  };
  let response = students.dump();
  println!("sendmsgall {} {}", response, qq);
  for i in 0..(*list_temp).len() {
    let item = (*list_temp).get(i).unwrap();
    item.send(response.clone());
    println!("sendmsg {} ", i);
  }
}

fn sendall(action:String, data:String, qq:i64){
  let mut list_temp = LIST_CON.lock().unwrap(); //等待，阻塞线程，
  let students = object! {
      "action" => action,
      "data" => data,
      "id" => qq
  };
  let response = students.dump();
  println!("sendall {} {}", response, qq);
  for i in 0..(*list_temp).len() {
    let item = (*list_temp).get(i).unwrap();
    item.send(response.clone());
    println!("sendmsg {} ", i);
  }
}

fn senderr(msg: String, con: &ws::Sender) {
  let mut list_temp = LIST_CON.lock().unwrap(); //等待，阻塞线程，
  let students = object! {
      "action" => "err",
      "data" => msg.clone()
  };
  let response = students.dump();

  con.send(response.clone());
}

fn sendpro(msg: String, con: &ws::Sender) {
  let mut list_temp = LIST_CON.lock().unwrap(); //等待，阻塞线程，
  let students = object! {
      "action" => "prompt",
      "data" => msg.clone()
  };
  let response = students.dump();

  con.send(response.clone());
}

fn user_size() -> usize {
  let mut list_con = LIST_CON.lock().unwrap(); //等待，阻塞线程，
  return list_con.len();
}

fn add_con(ws: &Sender) {
  let mut list_con = LIST_CON.lock().unwrap(); //等待，阻塞线程，
  list_con.push(ws.clone());
}

fn main() {
  // let mut list_con:Vec<Sender> = Vec::new();
  // let  (tx, rx) = mpsc::channel<String>();
  struct Server {
    ws: Sender,
    username: String,
    qq: i64,
  }

  read_users();
  read_msgs();
  // add_user(2541012655, String::from("666666"));
  // save_users();

  impl Handler for Server {
    fn on_open(&mut self, shake: Handshake) -> Result<()> {
      println!("on_open {}", self.ws.connection_id());
      let mut list_temp = LIST_CON.lock().unwrap(); //等待，阻塞线程，
                                                    // (*list_temp).push(self.ws.clone());
                                                    // let list_temp = *list_con.clone();
      for i in 0..(*list_temp).len() {
        (*list_temp)
          .get(i)
          .unwrap()
          .send("hello, this is rust server");
      }
      println!("当前用户数量：{}", list_temp.len());
      if let Some(addr) = shake.remote_addr()? {
        println!("Connection with {} now open", addr);
      }
      Ok(())
    }

    fn on_message(&mut self, msg: Message) -> Result<()> {
      if msg.to_string().as_str() == "#" {
        return Ok(());
      }
      println!("Server got message '{}'. ", msg);
      let jsonmap = json::parse(msg.to_string().as_str()).unwrap();
      if jsonmap["action"] == "register" {
        let pass = jsonmap["data"].as_str().unwrap();
        let temp_qq = jsonmap["id"].as_i64().unwrap();
        println!("注册");
        if add_user(temp_qq, pass.to_string()) {
          {
            let mut list_con = LIST_CON.lock().unwrap(); //等待，阻塞线程，
            list_con.push(self.ws.clone());
          }
          let promsg = &(String::from("用户")
            + &temp_qq.to_string()
            + &"进入房间,当前有"
            + &user_size().to_string()
            + &"人在线");
          send_msglist(&self.ws);
          sendproall(promsg);
          self.qq = temp_qq;
        } else {
          senderr("注册失败 用户已存在".to_string(), &self.ws);
        }
      } else if jsonmap["action"] == "login" {
        let pass = jsonmap["data"].as_str().unwrap();
        let temp_qq = jsonmap["id"].as_i64().unwrap();
        let mut isLogin = false;
        println!("开始登录 {}", temp_qq);
        let mut list_user = LIST_USER.lock().unwrap(); //等待，阻塞线程，
        for i in 0..list_user.len() {
          let item: &JsonValue = &(list_user[i]);
          println!("for {} {} {}", i, item["qq"].as_i64().unwrap(), temp_qq);
          if item["qq"].as_i64().unwrap() == temp_qq {
            
            if (item["pass"].as_str().unwrap() == pass) {
              add_con(&self.ws);
              let promsg = &(String::from("用户")
                + &temp_qq.to_string()
                + &"进入房间,当前有"
                + &user_size().to_string()
                + &"人在线");
              send_msglist(&self.ws);
              sendproall(promsg);
              
              isLogin = true;
              self.qq = temp_qq;
            } else {
              // senderr(&"密码错误".to_string(), &self.ws);
            }
          }
        }
        if !isLogin {
          senderr("登录失败".to_string(), &self.ws);
        } else {
          sendpro("登录成功".to_string(), &self.ws);
          println!("登录成功");
        }
      } else if jsonmap["action"] == "sendmsg" {
        if self.qq != 0 {
          sendmsgall(jsonmap["data"].as_str().unwrap().to_string(), self.qq);
          add_msg("sendmsg".to_string(), jsonmap["data"].as_str().unwrap().to_string(),self.qq);
        } else {
          senderr("消息发送失败".to_string(), &self.ws);
        }
      } else if jsonmap["action"] == "sendimg" {
        if self.qq != 0 {
          sendall("sendimg".to_string(),jsonmap["data"].as_str().unwrap().to_string(), self.qq);
          add_msg("sendimg".to_string(), jsonmap["data"].as_str().unwrap().to_string(),self.qq);
        } else {
          senderr("图片消息发送失败".to_string(), &self.ws);
        }
      } else if jsonmap["action"] == "exit" {
        let mut list_con = LIST_CON.lock().unwrap(); //等待，阻塞线程，
        for i in 0..(*list_con).len() {
          let item = (*list_con).get(i).unwrap();
          if item.connection_id() == self.ws.connection_id() {
            list_con.remove(i);
          }
        }
        sendproall(
          &((String::from("用户：") + &(self.qq.to_string()) + &"退出了房间".to_string())
            .to_string()),
        );
        // sendmsgall(&String::from(""));
      }
      // log it
      // self.log.send(msg.to_string()).unwrap();
      // Handle messages received on this connection
      println!("Server got message '{}'. ", &msg);
      // for i in 0..(*list_con).len() {
      //   let item = (*list_con).get(i).unwrap();
      //   item.send(msg.to_string());
      // }
      // echo it back
      // self.ws.send(msg)
      return Ok(());
    }

    fn on_close(&mut self, _: CloseCode, _: &str) {
      // self.ws.shutdown().unwrap();
      let mut list_temp = LIST_CON.lock().unwrap(); //等待，阻塞线程，
      for i in 0..(*list_temp).len() {
        // let item = (*list_temp).get(i).unwrap(); //xldebug
        match (*list_temp).get(i) {
          Some(item) => {
            if item.connection_id() == self.ws.connection_id() {
              (*list_temp).remove(i);
              println!("on_close 删除：id:{} index:{}", self.ws.connection_id(), i);
            }
          }
          None => {}
        }
      }
    }

    fn on_error(&mut self, err: Error) {
      let mut list_temp = LIST_CON.lock().unwrap(); //等待，阻塞线程
      for i in 0..(*list_temp).len() {
        // let item = (*list_temp).get(i).unwrap();
        match (*list_temp).get(i) {
          Some(item) => {
            if item.connection_id() == self.ws.connection_id() {
              (*list_temp).remove(i);
              println!("on_error 删除：id:{} index:{}", self.ws.connection_id(), i);
            }
          }
          None => {}
        }
      }
      // Ignore connection reset errors by default, but allow library clients to see them by
      // overriding this method if they want
      // if let Result::Kind::Io(ref err) = err.kind {
      //     if let Some(104) = err.raw_os_error() {
      //         return;
      //     }
      // }

      // error!("{:?}", err);
      // if !log_enabled!(ErrorLevel) {
      //     println!(
      //         "Encountered an error: {}\nEnable a logger to see more information.",
      //         err
      //     );
      // }
    }
  }

  // Setup logging
  //   env_logger::init();
  println!("hello server ws://127.0.0.1:2024");
  let useServer = false;
  // thread::spawn(move || {
  //     let received = rx.recv().unwrap();
  //     println!("Got: {}", received);
  // });
  // Listen on an address and call the closure for each connection
  if let Err(error) = listen(
    if useServer {
      "ws://119.29.215.145:2024"
    } else {
      "0.0.0.0:2024"
    },
    move |out| {
      println!("一个新连接：{}", out.connection_id());

      Server {
        ws: out,
        username: String::from(""),
        qq: 0,
      }
      // return |msg:Message| {

      //     // Handle messages received on this connection
      //     println!("Server got message '{}'. ", &msg);
      //     let mut list_temp = LIST_CON.lock().unwrap();  //等待，阻塞线程，
      //     for i in 0 .. (*list_temp).len() {
      //         let item = (*list_temp).get(i).unwrap();
      //         item.send(msg.to_string());
      //     }

      //     // Use the out channel to send messages back
      //     // out.send(msg);
      //     return Ok(());
      // };
    },
  ) {
    // Inform the user of failure
    println!("Failed to create WebSocket due to {:?}", error);
  }
  println!("执行结束");
}
