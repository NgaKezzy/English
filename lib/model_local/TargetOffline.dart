import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemTargetModel extends Model {
  int key = 0;
  String name = "";
  int timeM = 0;

  ItemTargetModel({
    required this.key,
    required this.name,
    required this.timeM,
  });

  factory ItemTargetModel.fromJson(Map<String, dynamic> json) {
    printYellow(json.toString());
    return ItemTargetModel(
      key: json['key'],
      name: json['name'].toString(),
      timeM: json['timeM'],
    );
  }
  Map toJson() => {
        'key': this.key,
        'name': this.name,
        'timeM': this.timeM,
      };
}

class TargetOffline {
  static final TargetOffline _singleton = TargetOffline._internal();
  factory TargetOffline() {
    return _singleton;
  }
  TargetOffline._internal();
  List<ItemTargetModel> listTarget = [];

  List<ItemTargetModel> getListTarget(BuildContext context) {
    if (_singleton.listTarget.length <= 0) {
      ItemTargetModel item1 = new ItemTargetModel(
          key: 1, name: S.of(context).Deliberately, timeM: 10);
      ItemTargetModel item2 =
          new ItemTargetModel(key: 2, name: S.of(context).basic, timeM: 15);
      ItemTargetModel item3 =
          new ItemTargetModel(key: 3, name: S.of(context).medium, timeM: 20);
      ItemTargetModel item4 =
          new ItemTargetModel(key: 4, name: S.of(context).hardWork, timeM: 30);
      ItemTargetModel item5 =
          new ItemTargetModel(key: 5, name: S.of(context).Passion, timeM: 60);
      _singleton.listTarget.add(item1);
      _singleton.listTarget.add(item2);
      _singleton.listTarget.add(item3);
      _singleton.listTarget.add(item4);
      _singleton.listTarget.add(item5);
    }
    return listTarget;
  }

  ItemTargetModel geTargetByKey(int key) {
    ItemTargetModel? res;
    if (_singleton.listTarget.length <= 0) {
      ItemTargetModel item1 =
          new ItemTargetModel(key: 1, name: "Deliberately", timeM: 10);
      ItemTargetModel item2 =
          new ItemTargetModel(key: 2, name: "basic", timeM: 15);
      ItemTargetModel item3 =
          new ItemTargetModel(key: 3, name: "medium", timeM: 20);
      ItemTargetModel item4 =
          new ItemTargetModel(key: 4, name: "hardWork", timeM: 30);
      ItemTargetModel item5 =
          new ItemTargetModel(key: 5, name: "Passion", timeM: 60);
      _singleton.listTarget.add(item1);
      _singleton.listTarget.add(item2);
      _singleton.listTarget.add(item3);
      _singleton.listTarget.add(item4);
      _singleton.listTarget.add(item5);
    }
    listTarget.forEach((element) {
      if (element.key == key) {
        res = element;
      }
    });

    return res!;
  }
}
