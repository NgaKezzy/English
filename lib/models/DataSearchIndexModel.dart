import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:scoped_model/scoped_model.dart';

class DataSearchIndex extends Model {
  List<DataTalk> dataTalkSugges;
  List<Category> dataCatgory;
  List<Category> dataChannel;
  DataSearchIndex({
    required this.dataTalkSugges,
    required this.dataCatgory,
    required this.dataChannel,
  });
  factory DataSearchIndex.fromJson(Map<String, dynamic> json) {
    return DataSearchIndex(
        dataTalkSugges: json['listTalkSugges'].map<DataTalk>((json) {
          return DataTalk.fromJson(json);
        }).toList(),
        dataCatgory: json['listCategory'].map<Category>((json) {
          return Category.fromJson(json);
        }).toList(),
        dataChannel: json['listChannel'].map<Category>((json) {
          return Category.fromJson(json);
        }).toList());
  }
  Map toJson() => {
        'dataTalk': this.dataTalkSugges,
        'dataCatgory': this.dataCatgory,
        'dataChannel': this.dataChannel,
      };
}
