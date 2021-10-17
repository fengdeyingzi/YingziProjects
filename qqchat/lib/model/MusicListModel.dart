class MusicListModel {
  int code;
  String message;
  int ttl;
  Data data;

  MusicListModel({this.code, this.message, this.ttl, this.data});

  MusicListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    ttl = json['ttl'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['ttl'] = this.ttl;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Hotword> hotword;
  bool linkImport;
  List<Typelist> typelist;
  int version;

  Data({this.hotword, this.linkImport, this.typelist, this.version});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['hotword'] != null) {
      hotword = new List<Hotword>();
      json['hotword'].forEach((v) {
        hotword.add(new Hotword.fromJson(v));
      });
    }
    linkImport = json['link_import'];
    if (json['typelist'] != null) {
      typelist = new List<Typelist>();
      json['typelist'].forEach((v) {
        typelist.add(new Typelist.fromJson(v));
      });
    }
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hotword != null) {
      data['hotword'] = this.hotword.map((v) => v.toJson()).toList();
    }
    data['link_import'] = this.linkImport;
    if (this.typelist != null) {
      data['typelist'] = this.typelist.map((v) => v.toJson()).toList();
    }
    data['version'] = this.version;
    return data;
  }
}

class Hotword {
  int id;
  String name;
  int inSearch;
  int badge;
  String icon;

  Hotword({this.id, this.name, this.inSearch, this.badge, this.icon});

  Hotword.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    inSearch = json['in_search'];
    badge = json['badge'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['in_search'] = this.inSearch;
    data['badge'] = this.badge;
    data['icon'] = this.icon;
    return data;
  }
}

class Typelist {
  int id;
  String name;
  int index;
  int cameraIndex;
  String icon;
  Extra extra;
  int childCnt;
  

  Typelist(
      {this.id,
      this.name,
      this.index,
      this.cameraIndex,
      this.icon,
      this.extra,
      this.childCnt
      });

  Typelist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    index = json['index'];
    cameraIndex = json['camera_index'];
    icon = json['icon'];
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
    childCnt = json['child_cnt'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['index'] = this.index;
    data['camera_index'] = this.cameraIndex;
    data['icon'] = this.icon;
    if (this.extra != null) {
      data['extra'] = this.extra.toJson();
    }
    data['child_cnt'] = this.childCnt;
    
    return data;
  }
}

class Extra {
  String iconV2;

  Extra({this.iconV2});

  Extra.fromJson(Map<String, dynamic> json) {
    iconV2 = json['icon_v2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon_v2'] = this.iconV2;
    return data;
  }
}