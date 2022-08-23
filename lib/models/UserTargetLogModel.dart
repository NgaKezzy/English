import 'package:app_learn_english/model_local/TargetOffline.dart';

class UserTargetLogModel {
  int tgid;
  int uid;
  String topic;
  int level;
  ItemTargetModel targetData;
  String timeLearn;
  String createdtime;
  String updatetime;

  UserTargetLogModel({
    required this.tgid,
    required this.uid,
    required this.topic,
    required this.level,
    required this.targetData,
    required this.timeLearn,
    required this.createdtime,
    required this.updatetime,
  });
  factory UserTargetLogModel.fromJson(Map<String, dynamic> json) {
    return UserTargetLogModel(
        tgid:json['tgid'],
        uid: json['uid'],
        topic: json['topic'].toString(),
        level:json['level'],
        targetData: TargetOffline().geTargetByKey(json['target_key']),
        timeLearn: json['time_learn'].toString(),
        createdtime: json['createdtime'].toString(),
        updatetime: json['updatedtime'].toString());
  }
  Map<String, dynamic> toJson() => {
        'tgid': this.tgid,
        'uid': this.uid,
        'topic': this.topic,
        'level': this.level,
        'targetData': this.targetData,
        'timeLearn': this.timeLearn,
        'createdtime': this.createdtime,
        'updatetime': this.updatetime,
      };
}
