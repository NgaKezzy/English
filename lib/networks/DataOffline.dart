import 'dart:convert';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/SettingModel.dart';
import 'package:app_learn_english/models/CountryAll.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataFirtAppLog.dart';
import 'package:app_learn_english/model_local/TargetOffline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataOffline {
  static final DataOffline _singleton = DataOffline._internal();
  factory DataOffline() {
    return _singleton;
  }
  DataOffline._internal();

  Future<Map<String, dynamic>> getDataLocal({keyData: ""}) async {
    printGreen("Get Data Local: " + keyData);
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};
    if (prefs.containsKey(keyData)) {
      data = jsonDecode(prefs.getString(keyData)!);
    }
    return data;
  }

  removeData({keyData: ""}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(keyData);
  }

  void saveDataOffline(key, object) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(object));
  }

  void saveLangeCodeSub(langCodeSub) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('codeLangSub',langCodeSub);
  }

  void saveLangeCode(String langCode)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lange_code',langCode);
  }

  Future<Map<String, dynamic>> getDataOffline({keyData: ""}) async {
    final prefs = await SharedPreferences.getInstance();
    var dataLocal = prefs.getString(keyData);
    final data = dataLocal != null ? jsonDecode(dataLocal) : null;
    return data;
  }

  void saveDataFirtUse(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
    DataFirtAppLog().isFirt = false;
  }

  Future<int> getDataFirtUse(key) async {
    final prefs = await SharedPreferences.getInstance();
    var dataLocal = prefs.getInt(key);
    final data = dataLocal != null ? dataLocal : 0;
    return data;
  }

  void saveIDDataTalk(key, value) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setInt(key, value);
  }

  Future<int> getIDDataTalk(key) async {
    final _prefs = await SharedPreferences.getInstance();
    var dataLocal = _prefs.getInt(key);
    final data = dataLocal != null ? dataLocal : 1;
    return data;
  }

  Future<SettingOffline> getDataSetting(
      {keyData: "", CountryModel? countryModel}) async {
    final prefs = await SharedPreferences.getInstance();
    var dataLocal = prefs.getString(keyData);
    SettingOffline data;
    if (dataLocal != null) {
      data = SettingOffline.fromJson(jsonDecode(dataLocal));
      print(data);
    } else {
      data = new SettingOffline(
        switchMCHD: true,
        switchHDOT: false,
        switchTTGD: true,
        switchTBH: false,
        switchTTSK: false,
        switchCBHGR: false,
        switchNDMTKDK: false,
        language: countryModel!,
      );
      DataOffline().saveDataOffline("MainSetting", data);
    }
    return data;
  }

  Future<ItemTargetModel> getDataTarget(key) async {
    final prefs = await SharedPreferences.getInstance();
    printGreen(key);
    var dataLocal = prefs.getString(key);
    ItemTargetModel? itemTarget;
    if (dataLocal != null) {
      printCyan("CO ROI---------------------------");
      itemTarget = ItemTargetModel.fromJson(json.decode(dataLocal));
    } else {
      printCyan("CHUA CO .................");

      itemTarget = new ItemTargetModel(key: 1, name: "Thong thả", timeM: 10);
      this.saveDataTargetOffline("dataTarget", itemTarget);
    }
    return itemTarget;
  }

  void saveDataTargetOffline(String key, ItemTargetModel object) async {
    printRed("VAO LUU LOCAL");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(object).toString());
    // prefs.setString(key, object.toJson().toString());
  }

  void savePasswordMd5({required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('passwordUser', password);
  }

  void clearCache() {
    this.removeData(keyData: "userData");
    this.removeData(keyData: "dataTarget");
    this.removeData(keyData: "video_setting");
    this.removeData(keyData: "MainSetting");
    this.removeData(keyData: "uidDataTalk");
    DataCache().clearGlobal();
  }
}
