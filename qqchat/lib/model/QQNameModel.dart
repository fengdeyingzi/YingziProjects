class QQNameModel {
  List<String> l1679026015;

  QQNameModel({this.l1679026015});

  QQNameModel.fromJson(Map<String, dynamic> json) {
    l1679026015 = json['1679026015'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1679026015'] = this.l1679026015;
    return data;
  }
}