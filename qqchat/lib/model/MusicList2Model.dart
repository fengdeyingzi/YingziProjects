class MusicList2Model {
	int code;
	String message;
	int ttl;
	Data data;

	MusicList2Model({this.code, this.message, this.ttl, this.data});

	MusicList2Model.fromJson(Map<String, dynamic> json) {
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
	List<ListData> list;
	Pager pager;

	Data({this.list, this.pager});

	Data.fromJson(Map<String, dynamic> json) {
		if (json['list'] != null) {
			list = new List<ListData>();
			json['list'].forEach((v) { list.add(new ListData.fromJson(v)); });
		}
		pager = json['pager'] != null ? new Pager.fromJson(json['pager']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
		if (this.pager != null) {
      data['pager'] = this.pager.toJson();
    }
		return data;
	}
}

class ListData {
	int id;
	int tid;
	int index;
	int sid;
	String name;
	String musicians;
	int mid;
	String cover;
	String stat;
	String playurl;
	int state;
	int duration;
	int filesize;
	int ctime;
	int pubtime;
	int mtime;
	List<String> mvpTags;
	List<String> tags;
	List<String> colors;
	List<String> fontColors;
	String categorys;
	// List<Null> timeline;
	int recommendPoint;
	int cooperate;
	String cooperateUrl;
	int New;
	int hotval;
	int fav;
	int playerView;
	String src;
	String wavesUrl;
	String bossKey;
	String markersDownloadUrl;
	int mkWhiteList;
	String vuperDownloadUrl;
	int upFrom;
	String downloadUrl;
	int type;
	// List<Null> catIds;
	// List<Null> catInfos;

	ListData({this.id, this.tid, this.index, this.sid, this.name, this.musicians, this.mid, this.cover, this.stat, this.playurl, this.state, this.duration, this.filesize, this.ctime, this.pubtime, this.mtime, this.mvpTags, this.tags, this.colors, this.fontColors, this.categorys, this.recommendPoint, this.cooperate, this.cooperateUrl, this.New, this.hotval, this.fav, this.playerView, this.src, this.wavesUrl, this.bossKey, this.markersDownloadUrl, this.mkWhiteList, this.vuperDownloadUrl, this.upFrom, this.downloadUrl, this.type});

	ListData.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		tid = json['tid'];
		index = json['index'];
		sid = json['sid'];
		name = json['name'];
		musicians = json['musicians'];
		mid = json['mid'];
		cover = json['cover'];
		stat = json['stat'];
		playurl = json['playurl'];
		state = json['state'];
		duration = json['duration'];
		filesize = json['filesize'];
		ctime = json['ctime'];
		pubtime = json['pubtime'];
		mtime = json['mtime'];
		mvpTags = json['mvp_tags'].cast<String>();
		tags = json['tags'].cast<String>();
		colors = json['colors'].cast<String>();
		fontColors = json['font_colors'].cast<String>();
		categorys = json['categorys'];
		// if (json['timeline'] != null) {
		// 	timeline = new List<Null>();
		// 	json['timeline'].forEach((v) { timeline.add(new Null.fromJson(v)); });
		// }
		recommendPoint = json['recommend_point'];
		cooperate = json['cooperate'];
		cooperateUrl = json['cooperate_url'];
		New = json['new'];
		hotval = json['hotval'];
		fav = json['fav'];
		playerView = json['player_view'];
		src = json['src'];
		wavesUrl = json['waves_url'];
		bossKey = json['boss_key'];
		markersDownloadUrl = json['markers_download_url'];
		mkWhiteList = json['mk_white_list'];
		vuperDownloadUrl = json['vuper_download_url'];
		upFrom = json['up_from'];
		downloadUrl = json['download_url'];
		type = json['type'];
		// if (json['cat_ids'] != null) {
		// 	catIds = new List<Null>();
		// 	json['cat_ids'].forEach((v) { catIds.add(new Null.fromJson(v)); });
		// }
		// if (json['cat_infos'] != null) {
		// 	catInfos = new List<Null>();
		// 	json['cat_infos'].forEach((v) { catInfos.add(new Null.fromJson(v)); });
		// }
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['tid'] = this.tid;
		data['index'] = this.index;
		data['sid'] = this.sid;
		data['name'] = this.name;
		data['musicians'] = this.musicians;
		data['mid'] = this.mid;
		data['cover'] = this.cover;
		data['stat'] = this.stat;
		data['playurl'] = this.playurl;
		data['state'] = this.state;
		data['duration'] = this.duration;
		data['filesize'] = this.filesize;
		data['ctime'] = this.ctime;
		data['pubtime'] = this.pubtime;
		data['mtime'] = this.mtime;
		data['mvp_tags'] = this.mvpTags;
		data['tags'] = this.tags;
		data['colors'] = this.colors;
		data['font_colors'] = this.fontColors;
		data['categorys'] = this.categorys;
		// if (this.timeline != null) {
    //   data['timeline'] = this.timeline.map((v) => v.toJson()).toList();
    // }
		data['recommend_point'] = this.recommendPoint;
		data['cooperate'] = this.cooperate;
		data['cooperate_url'] = this.cooperateUrl;
		data['new'] = this.New;
		data['hotval'] = this.hotval;
		data['fav'] = this.fav;
		data['player_view'] = this.playerView;
		data['src'] = this.src;
		data['waves_url'] = this.wavesUrl;
		data['boss_key'] = this.bossKey;
		data['markers_download_url'] = this.markersDownloadUrl;
		data['mk_white_list'] = this.mkWhiteList;
		data['vuper_download_url'] = this.vuperDownloadUrl;
		data['up_from'] = this.upFrom;
		data['download_url'] = this.downloadUrl;
		data['type'] = this.type;
		// if (this.catIds != null) {
    //   data['cat_ids'] = this.catIds.map((v) => v.toJson()).toList();
    // }
		// if (this.catInfos != null) {
    //   data['cat_infos'] = this.catInfos.map((v) => v.toJson()).toList();
    // }
		return data;
	}
}

class Pager {
	int total;
	int pn;
	int ps;

	Pager({this.total, this.pn, this.ps});

	Pager.fromJson(Map<String, dynamic> json) {
		total = json['total'];
		pn = json['pn'];
		ps = json['ps'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['total'] = this.total;
		data['pn'] = this.pn;
		data['ps'] = this.ps;
		return data;
	}
}