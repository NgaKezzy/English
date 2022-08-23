import 'package:app_learn_english/models/CateFollowModel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:scoped_model/scoped_model.dart';

class SubChannelData {
  List<Category> listCatgoryFollow;
  List<DataTalk> listTalk;
  SubChannelData({
    required this.listCatgoryFollow,
    required this.listTalk,
  });
  factory SubChannelData.fromJson(Map<String, dynamic> json) {
    return SubChannelData(
      listCatgoryFollow: json['dataChannelFollow'].map<Category>((json) {
        return Category.fromJson(json);
      }).toList(),
      listTalk: json['listTalk'].map<DataTalk>((json) {
        return DataTalk.fromJson(json);
      }).toList(),
    );
  }
}
