class TalkFollowLogModel {
  int idTalkLog;
  int uid;
  int talkId;
  int status;
  String createdtime;
  String updatetime;
  int type;
  int isFollow;
  int isLike;

  TalkFollowLogModel(
      {required this.idTalkLog,
      required this.uid,
      required this.talkId,
      required this.status,
      required this.createdtime,
      required this.updatetime,
      required this.isFollow,
      required this.isLike,
      required this.type});
  factory TalkFollowLogModel.fromJson(Map<String, dynamic> json) {
    return TalkFollowLogModel(
      idTalkLog: json['idTalkLog'],
      uid: json['uid'],
      talkId: json['talkId'],
      status: json['status'],
      createdtime: json['createdtime'].toString(),
      updatetime: json['updatetime'].toString(),
      type: json['type'],
      isFollow: json['isFollow'],
      isLike: json['isLike'],
    );
  }
  Map toJson() => {
        'idTalkLog': this.idTalkLog,
        'uid': this.uid,
        'talkId': this.talkId,
        'status': this.status,
        'createdtime': this.createdtime,
        'updatetime': this.updatetime,
        'type': this.type,
        'isFollow': this.isFollow,
        'isLike': this.isLike,
      };

  void setSatus(int status) {
    this.isFollow = status;
  }

  void setSatusLike(int status) {
    this.isLike = status;
  }
}
