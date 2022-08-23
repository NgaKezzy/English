class TalkQuizModel{
  int? id;
  String? nameVi;
  String? name;
  int? catId;
  Null? catId2;
  Null? catId3;
  Null? catId4;
  Null? catId5;
  String? picture;
  String? linkOrigin;
  int? totalLike;
  int? totalSub;
  String? createdtime;
  String? updatetime;
  bool? isVip;
  bool? type;

  TalkQuizModel(
      {this.id,
        this.nameVi,
        this.name,
        this.catId,
        this.catId2,
        this.catId3,
        this.catId4,
        this.catId5,
        this.picture,
        this.linkOrigin,
        this.totalLike,
        this.totalSub,
        this.createdtime,
        this.updatetime,
        this.isVip,
        this.type});

  TalkQuizModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameVi = json['name_vi'];
    name = json['name'];
    catId = json['catId'];
    catId2 = json['catId_2'];
    catId3 = json['catId_3'];
    catId4 = json['catId_4'];
    catId5 = json['catId_5'];
    picture = json['picture'];
    linkOrigin = json['link_origin'];
    totalLike = json['totalLike'];
    totalSub = json['totalSub'];
    createdtime = json['createdtime'];
    updatetime = json['updatetime'];
    isVip = json['isVip'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_vi'] = this.nameVi;
    data['name'] = this.name;
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