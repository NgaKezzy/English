import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/NewWord.dart';

class NewWordCacheModel {
  int? idSub;
  List<NewWord> listNewWordSub = [];

  setIdSub(int idSub) {
    this.idSub = idSub;
  }

  getIdSub() {
    return this.idSub;
  }

  setListNewWord(List<NewWord> listNewWordSub) {
    this.listNewWordSub = listNewWordSub;
  }

  getListNewWord() {
    return this.listNewWordSub != null ? this.listNewWordSub : [];
  }

  toJSON() {
    this.listNewWordSub.forEach((element) {
      printBlue(element.toJson().toString());
    });
  }

  toJSONY() {
    this.listNewWordSub.forEach((element) {
      printYellow(element.toJson().toString());
    });
  }
}
