import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';

class TalkCacheModel {
  int? idTalk;
  List<TalkDetailModel> listSub = [];

  setIdTalk(int idTalk) {
    this.idTalk = idTalk;
  }

  getIdTalk() {
    return this.idTalk;
  }

  setListSub(List<TalkDetailModel> listSub) {
    this.listSub = listSub;
  }

  getListSub() {
    return this.listSub;
  }

  toJSON() {
    this.listSub.forEach((element) {
      printBlue(element.toJson().toString());
    });
  }

  toJSONY() {
    this.listSub.forEach((element) {
      printBlue(element.toJson().toString());
    });
  }
}
