import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/TargetOffline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TargetProvider with ChangeNotifier {
  int _count = 0;
  ItemTargetModel? _itemTarget;
  int? get count => _count;
  ItemTargetModel? get itemTarget => _itemTarget;

  Future<void> updateCount() async {
    _count++;
    notifyListeners();
  }

  Future<void> setItemTarget(ItemTargetModel itemTarget) async {
    _itemTarget = itemTarget;
    notifyListeners();
  }

  Future<void> setCount(int countLocal) async {
    printRed("LOAD COUNT: " + countLocal.toString());
    _count = countLocal;
    notifyListeners();
  }
}
