class LearnOffline {
  int? status;
  List<ListUser>? list;

  LearnOffline({this.status, this.list});

  LearnOffline.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['list'] != null) {
      list =<ListUser>[];
      json['list'].forEach((v) {
        list!.add(new ListUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListUser {
  int? uid;
  String? username;
  String? fullname;
  String? langnative;
  int? totalExp;
  int? heart;
  bool isInvite=false;

  ListUser(
      {this.uid,
        this.username,
        this.fullname,
        this.langnative,
        this.totalExp,
        this.heart,required this.isInvite});

  ListUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    fullname = json['fullname'];
    langnative = json['langnative'];
    totalExp = json['totalExp'];
    heart = json['heart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['username'] = this.username;
    data['fullname'] = this.fullname;
    data['langnative'] = this.langnative;
    data['totalExp'] = this.totalExp;
    data['heart'] = this.heart;
    return data;
  }
}