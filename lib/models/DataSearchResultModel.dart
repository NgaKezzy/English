import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/TalkTextDetailModel.dart';
import 'package:app_learn_english/models/TalkTextModel.dart';
import 'package:scoped_model/scoped_model.dart';

class DataSearchModel extends Model {
  List<Category> dataCategory;
  List<DataTalk> dataTalk;
  List<TalkDetailModel> dataTalkDetail;
  List<Category> dataChannel;
  List<DataTalkText> dataTextTalk;
  List<TalkTextDetailModel> dataTextTalkDetail;
  DataSearchModel({
    required this.dataCategory,
    required this.dataTalk,
    required this.dataTalkDetail,
    required this.dataChannel,
    required this.dataTextTalk,
    required this.dataTextTalkDetail,
  });
  factory DataSearchModel.fromJson(Map<String, dynamic> json) {
    return DataSearchModel(
        dataCategory: json['dataCategory'].map<Category>((json) {
          return Category.fromJson(json);
        }).toList(),
        dataTalk: json['dataTalk'].map<DataTalk>((json) {
          return DataTalk.fromJson(json);
        }).toList(),
        dataTalkDetail: json['dataTalkDetail'].map<TalkDetailModel>((json) {
          return TalkDetailModel.fromJson(json);
        }).toList(),
        dataChannel: json['dataChannel'].map<Category>((json) {
          return Category.fromJson(json);
        }).toList(),
        dataTextTalk: json['dataTextTalk'].map<DataTalkText>((json) {
          return DataTalkText.fromJson(json);
        }).toList(),
        dataTextTalkDetail:
            json['dataTextTalkDetail'].map<TalkTextDetailModel>((json) {
          return TalkTextDetailModel.fromJson(json);
        }).toList());
  }
  Map toJson() => {
        'dataCatgory': this.dataCategory,
        'dataTalk': this.dataTalk,
        'dataTalkDetail': this.dataTalkDetail,
        'dataChannel': this.dataChannel,
        'dataTextTalk': this.dataTextTalk,
        'dataTextTalkDetail': this.dataTextTalkDetail,
      };
}
