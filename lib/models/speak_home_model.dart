class SpeakHomeModel {
  int? status;
  List<Lists>? lists;

  SpeakHomeModel({required this.status, required this.lists});

  SpeakHomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['lists'] != null) {
      lists = <Lists>[];
      json['lists'].forEach((v) {
        lists?.add(new Lists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.lists != null) {
      data['lists'] = this.lists?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lists {
  int? id;
  String? name_vi;
  String? name;
  String? name_zh;
  String? name_ja;
  String? name_hi;
  String? name_es;
  String? name_ru;
  String? name_tr;
  String? name_pt;
  String? name_id;
  String? name_th;
  String? name_ms;
  String? name_ar;
  String? name_fr;
  String? name_it;
  String? name_de;
  String? name_ko;
  String? name_zh_Hant_TW;
  String? name_sk;
  String? name_sl;
  int? catId;
  int? catId2;
  int? catId3;
  int? catId4;
  int? catId5;
  String? picture;
  String? linkOrigin;
  int? totalLike;
  int? totalSub;
  String? createdtime;
  String? updatetime;
  bool? isVip;
  bool? type;

  Lists(
      {required this.id,
      required this.name_vi,
      required this.name,
      required this.name_zh,
      required this.name_ja,
      required this.name_hi,
      required this.name_es,
      required this.name_ru,
      required this.name_tr,
      required this.name_pt,
      required this.name_id,
      required this.name_th,
      required this.name_ms,
      required this.name_ar,
      required this.name_fr,
      required this.name_it,
      required this.name_de,
      required this.name_ko,
      required this.name_zh_Hant_TW,
      required this.name_sk,
      required this.name_sl,
      required this.catId,
      required this.catId2,
      required this.catId3,
      required this.catId4,
      required this.catId5,
      required this.picture,
      required this.linkOrigin,
      required this.totalLike,
      required this.totalSub,
      required this.createdtime,
      required this.updatetime,
      required this.isVip,
      required this.type});

  Lists.fromJson(Map<String, dynamic> json) {
    id = int.parse('${json['id']}');
    name_vi = json['name_vi'];
    name = json['name'];
    name_zh = json['name_zh'];
    name_ja = json['name_ja'];
    name_hi = json['name_hi'];
    name_es = json['name_es'];
    name_ru = json['name_ru'];
    name_tr = json['name_tr'];
    name_pt = json['name_pt'];
    name_id = json['name_id'];
    name_th = json['name_th'];
    name_ms = json['name_ms'];
    name_ar = json['name_ar'];
    name_fr = json['name_fr'];
    name_it = json['name_it'];
    name_de = json['name_de'];
    name_ko = json['name_ko'];
    name_zh_Hant_TW = json['name_zh_Hant_TW'];
    name_sk = json['name_sk'];
    name_sl = json['name_sl'];
    catId = int.parse('${json['catId']}');
    catId2 = json['catId_2'];
    catId3 = json['catId_3'];
    catId4 = json['catId_4'];
    catId5 = json['catId_5'];
    picture = json['picture'];
    linkOrigin = json['link_origin'];
    totalLike = int.parse('${json['totalLike']}');
    totalSub = int.parse('${json['totalSub']}');
    createdtime = json['createdtime'];
    updatetime = json['updatetime'];
    isVip = json['isVip'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_vi'] = this.name_vi;
    data['name'] = this.name;
    data['name_zh'] = this.name_zh;
    data['name_ja'] = this.name_ja;
    data['name_hi'] = this.name_hi;
    data['name_es'] = this.name_es;
    data['name_ru'] = this.name_ru;
    data['name_tr'] = this.name_tr;
    data['name_pt'] = this.name_pt;
    data['name_id'] = this.name_id;
    data['name_th'] = this.name_th;
    data['name_ms'] = this.name_ms;
    data['name_ar'] = this.name_ar;
    data['name_fr'] = this.name_fr;
    data['name_it'] = this.name_it;
    data['name_de'] = this.name_de;
    data['name_ko'] = this.name_ko;
    data['name_sk'] = this.name_sk;
    data['name_sl'] = this.name_sl;
    data['name_zh_Hant_TW'] = this.name_zh_Hant_TW;
    data['catId'] = this.catId;
    data['catId_2'] = this.catId2;
    data['catId_3'] = this.catId3;
    data['catId_4'] = this.catId4;
    data['catId_5'] = this.catId5;
    data['picture'] = this.picture;
    data['link_origin'] = this.linkOrigin;
    data['totalLike'] = this.totalLike;
    data['totalSub'] = this.totalSub;
    data['createdtime'] = this.createdtime;
    data['updatetime'] = this.updatetime;
    data['isVip'] = this.isVip;
    data['type'] = this.type;
    return data;
  }
}
