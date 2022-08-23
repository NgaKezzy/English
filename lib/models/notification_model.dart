class NotificationModel {
  int? error;
  String? msg;
  Datas? datas;

  NotificationModel({this.error, this.msg, this.datas});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    msg = json['msg'];
    datas = json['datas'] != null ? new Datas.fromJson(json['datas']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['msg'] = this.msg;
    if (this.datas != null) {
      data['datas'] = this.datas!.toJson();
    }
    return data;
  }
}

class Datas {
  int? isLocalNoti;
  int? isNativeAds;
  int? vAndroid;
  int? vIos;
  String? fb;
  String? linkUpdate;
  String? api;
  String? tokenMd5;

  Datas(
      {this.isLocalNoti,
        this.isNativeAds,
        this.vAndroid,
        this.vIos,
        this.fb,
        this.linkUpdate,
        this.api,
        this.tokenMd5});

  Datas.fromJson(Map<String, dynamic> json) {
    isLocalNoti = json['isLocalNoti'];
    isNativeAds = json['isNativeAds'];
    vAndroid = json['vAndroid'];
    vIos = json['vIos'];
    fb = json['fb'];
    linkUpdate = json['linkUpdate'];
    api = json['api'];
    tokenMd5 = json['tokenMd5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isLocalNoti'] = this.isLocalNoti;
    data['isNativeAds'] = this.isNativeAds;
    data['vAndroid'] = this.vAndroid;
    data['vIos'] = this.vIos;
    data['fb'] = this.fb;
    data['linkUpdate'] = this.linkUpdate;
    data['api'] = this.api;
    data['tokenMd5'] = this.tokenMd5;
    return data;
  }
}