class SoundPoolModel {
  int code;
  String message;
  int ttl;
  Data data;

  SoundPoolModel({this.code, this.message, this.ttl, this.data});

  SoundPoolModel.fromJson(Map<String, dynamic> json) {
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
  List<Categories> categories;
  int materialCategory;
  List<Materials> materials;
  Cursor cursor;

  Data({this.categories, this.materialCategory, this.materials, this.cursor});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    materialCategory = json['material_category'];
    if (json['materials'] != null) {
      materials = new List<Materials>();
      json['materials'].forEach((v) {
        materials.add(new Materials.fromJson(v));
      });
    }
    cursor =
        json['cursor'] != null ? new Cursor.fromJson(json['cursor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    data['material_category'] = this.materialCategory;
    if (this.materials != null) {
      data['materials'] = this.materials.map((v) => v.toJson()).toList();
    }
    if (this.cursor != null) {
      data['cursor'] = this.cursor.toJson();
    }
    return data;
  }
}

class Categories {
  int pid;
  int id;
  String name;
  int rank;
  int globalRank;
  String cover;
  int type;
  int catTp;
  int applyBiz;
  int ctime;
  int mtime;
  Null children;
  int resCnt;

  Categories(
      {this.pid,
      this.id,
      this.name,
      this.rank,
      this.globalRank,
      this.cover,
      this.type,
      this.catTp,
      this.applyBiz,
      this.ctime,
      this.mtime,
      this.children,
      this.resCnt});

  Categories.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    id = json['id'];
    name = json['name'];
    rank = json['rank'];
    globalRank = json['global_rank'];
    cover = json['cover'];
    type = json['type'];
    catTp = json['cat_tp'];
    applyBiz = json['apply_biz'];
    ctime = json['ctime'];
    mtime = json['mtime'];
    children = json['children'];
    resCnt = json['res_cnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pid'] = this.pid;
    data['id'] = this.id;
    data['name'] = this.name;
    data['rank'] = this.rank;
    data['global_rank'] = this.globalRank;
    data['cover'] = this.cover;
    data['type'] = this.type;
    data['cat_tp'] = this.catTp;
    data['apply_biz'] = this.applyBiz;
    data['ctime'] = this.ctime;
    data['mtime'] = this.mtime;
    data['children'] = this.children;
    data['res_cnt'] = this.resCnt;
    return data;
  }
}

class Materials {
  String appFilter;
  int applyFor;
  Author author;
  List<int> catIds;
  List<CatInfos> catInfos;
  int categoryId;
  int categoryIndex;
  String cover;
  int ctime;
  String downloadUrl;
  int duration;
  Extra extra;
  int fav;
  int hot;
  int id;
  int mtime;
  String musicians;
  String name;
  String playurl;
  String popPreviewUrl;
  int public;
  int rank;
  String staticCover;
  String tags;
  int type;
  int whiteList;

  Materials(
      {this.appFilter,
      this.applyFor,
      this.author,
      this.catIds,
      this.catInfos,
      this.categoryId,
      this.categoryIndex,
      this.cover,
      this.ctime,
      this.downloadUrl,
      this.duration,
      this.extra,
      this.fav,
      this.hot,
      this.id,
      this.mtime,
      this.musicians,
      this.name,
      this.playurl,
      this.popPreviewUrl,
      this.public,
      this.rank,
      this.staticCover,
      this.tags,
      this.type,
      this.whiteList});

  Materials.fromJson(Map<String, dynamic> json) {
    appFilter = json['app_filter'];
    applyFor = json['apply_for'];
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
    catIds = json['cat_ids'].cast<int>();
    if (json['cat_infos'] != null) {
      catInfos = new List<CatInfos>();
      json['cat_infos'].forEach((v) {
        catInfos.add(new CatInfos.fromJson(v));
      });
    }
    categoryId = json['category_id'];
    categoryIndex = json['category_index'];
    cover = json['cover'];
    ctime = json['ctime'];
    downloadUrl = json['download_url'];
    duration = json['duration'];
    extra = json['extra_'] != null ? new Extra.fromJson(json['extra_']) : null;
    fav = json['fav'];
    hot = json['hot'];
    id = json['id'];
    mtime = json['mtime'];
    musicians = json['musicians'];
    name = json['name'];
    playurl = json['playurl'];
    popPreviewUrl = json['pop_preview_url'];
    public = json['public'];
    rank = json['rank'];
    staticCover = json['static_cover'];
    tags = json['tags'];
    type = json['type'];
    whiteList = json['white_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_filter'] = this.appFilter;
    data['apply_for'] = this.applyFor;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['cat_ids'] = this.catIds;
    if (this.catInfos != null) {
      data['cat_infos'] = this.catInfos.map((v) => v.toJson()).toList();
    }
    data['category_id'] = this.categoryId;
    data['category_index'] = this.categoryIndex;
    data['cover'] = this.cover;
    data['ctime'] = this.ctime;
    data['download_url'] = this.downloadUrl;
    data['duration'] = this.duration;
    if (this.extra != null) {
      data['extra_'] = this.extra.toJson();
    }
    data['fav'] = this.fav;
    data['hot'] = this.hot;
    data['id'] = this.id;
    data['mtime'] = this.mtime;
    data['musicians'] = this.musicians;
    data['name'] = this.name;
    data['playurl'] = this.playurl;
    data['pop_preview_url'] = this.popPreviewUrl;
    data['public'] = this.public;
    data['rank'] = this.rank;
    data['static_cover'] = this.staticCover;
    data['tags'] = this.tags;
    data['type'] = this.type;
    data['white_list'] = this.whiteList;
    return data;
  }
}

class Author {
  String face;
  int mid;
  String name;
  String notice;
  int upFrom;

  Author({this.face, this.mid, this.name, this.notice, this.upFrom});

  Author.fromJson(Map<String, dynamic> json) {
    face = json['face'];
    mid = json['mid'];
    name = json['name'];
    notice = json['notice'];
    upFrom = json['up_from'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['face'] = this.face;
    data['mid'] = this.mid;
    data['name'] = this.name;
    data['notice'] = this.notice;
    data['up_from'] = this.upFrom;
    return data;
  }
}

class CatInfos {
  String catCover;
  int catId;
  String catName;

  CatInfos({this.catCover, this.catId, this.catName});

  CatInfos.fromJson(Map<String, dynamic> json) {
    catCover = json['cat_cover'];
    catId = json['cat_id'];
    catName = json['cat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_cover'] = this.catCover;
    data['cat_id'] = this.catId;
    data['cat_name'] = this.catName;
    return data;
  }
}

class Extra {
  String appFilter;
  int applyFor;
  int categoryId;
  int categoryIndex;
  String downloadUrl;
  int duration;
  String name;
  String popPreviewUrl;
  int public;
  int whiteList;

  Extra(
      {this.appFilter,
      this.applyFor,
      this.categoryId,
      this.categoryIndex,
      this.downloadUrl,
      this.duration,
      this.name,
      this.popPreviewUrl,
      this.public,
      this.whiteList});

  Extra.fromJson(Map<String, dynamic> json) {
    appFilter = json['app_filter'];
    applyFor = json['apply_for'];
    categoryId = json['category_id'];
    categoryIndex = json['category_index'];
    downloadUrl = json['download_url'];
    duration = json['duration'];
    name = json['name'];
    popPreviewUrl = json['pop_preview_url'];
    public = json['public'];
    whiteList = json['white_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_filter'] = this.appFilter;
    data['apply_for'] = this.applyFor;
    data['category_id'] = this.categoryId;
    data['category_index'] = this.categoryIndex;
    data['download_url'] = this.downloadUrl;
    data['duration'] = this.duration;
    data['name'] = this.name;
    data['pop_preview_url'] = this.popPreviewUrl;
    data['public'] = this.public;
    data['white_list'] = this.whiteList;
    return data;
  }
}

class Cursor {
  int maxRank;
  int size;
  int version;

  Cursor({this.maxRank, this.size, this.version});

  Cursor.fromJson(Map<String, dynamic> json) {
    maxRank = json['max_rank'];
    size = json['size'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['max_rank'] = this.maxRank;
    data['size'] = this.size;
    data['version'] = this.version;
    return data;
  }
}