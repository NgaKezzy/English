import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:scoped_model/scoped_model.dart';

class DataHome extends Model {
  List<DataTalk> dataSugges;
  List<Category> listCatgory;
  List<DataTalk> listTalkNew;

  DataHome({
    required this.dataSugges,
    required this.listCatgory,
    required this.listTalkNew,
  });
  factory DataHome.fromJson(Map<String, dynamic> json) {
    return DataHome(
        dataSugges: json['dataSugges'].map<DataTalk>((json) {
          return DataTalk.fromJson(json);
        }).toList(),
        listCatgory: json['listCategory'].map<Category>((json) {
          return Category.fromJson(json);
        }).toList(),
        listTalkNew: json['dataNew'].map<DataTalk>((json) {
          return DataTalk.fromJson(json);
        }).toList());
  }
}
