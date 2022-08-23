import 'package:app_learn_english/models/TalkTextModel.dart';

class HistorySpeakModel {
  int id;
  int uid;
  int sid;
  String createdtime;
  DataTalkText textTalk;

  HistorySpeakModel({
    required this.id,
    required this.uid,
    required this.sid,
    required this.createdtime,
    required this.textTalk,
  });

  factory HistorySpeakModel.fromJson(Map<String, dynamic> json) {
    return HistorySpeakModel(
        id: json['id'].runtimeType == int ? json['id'] : int.parse(json['id']),
        uid: json['uid'] != null
          ? (json['uid'].runtimeType == int
              ? json['uid']
              : int.parse(json['uid']))
          : 0,
        sid: json['sid'] != null
          ? (json['sid'].runtimeType == int
              ? json['sid']
              : int.parse(json['sid']))
          : 0,
        createdtime: json['createdtime'].toString(),
        textTalk: DataTalkText.fromJson(json['textTalk']),);
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'uid': this.uid,
        'sid': this.sid,
        'createdtime': this.createdtime,
        'listTextTalk': this.textTalk,
      };
}
