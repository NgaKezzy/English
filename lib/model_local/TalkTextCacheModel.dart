import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TalkTextDetailModel.dart';

class TalkTextCacheModel {
  int? idTalkText;
  List<TalkTextDetailModel> listSentence = [];

  setIdTalk(int idTalk) {
    this.idTalkText = idTalk;
  }

  getIdTalk() {
    return this.idTalkText;
  }

  setListSub(List<TalkTextDetailModel> listSub) {
    this.listSentence = listSub;
  }

  getListSub() {
    return this.listSentence;
  }

  toJSON() {
    this.listSentence.forEach((element) {
      printBlue(element.toJson().toString());
    });
  }

  toJSONY() {
    this.listSentence.forEach((element) {
      printBlue(element.toJson().toString());
    });
  }
}
