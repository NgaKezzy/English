import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/TalkTextModel.dart';

class Notifications {
  final int nuid;
  final int nid;
  final int uid;
  final String? createdTime;
  final String? updatedTime;
  final int type;
  final int parentId;
  final int catId;
  final bool status;
  final DataTalk? listTalk;
  final DataTalkText? listTalkText;

  Notifications({
    this.listTalkText,
    this.listTalk,
    required this.status,
    required this.nuid,
    required this.nid,
    required this.uid,
    required this.createdTime,
    required this.updatedTime,
    required this.type,
    required this.parentId,
    required this.catId,
  });
}
