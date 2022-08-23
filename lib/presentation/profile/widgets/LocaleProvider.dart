import 'dart:io';

import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/SettingModel.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  bool _updateView = false;
  String? _preLanguageCode;
  bool _updateApi = false;
  bool _isFirstApp=false;
  bool _isFirstOpen=false;

  bool get isFirstApp=>_isFirstApp;
  bool get isFirstOpen=>_isFirstOpen;

  bool get updateView => _updateView;

  bool get updateApi => _updateApi;

  Locale? get locale => _locale;

  String? get preLanguageCode => _preLanguageCode;
  String? _codeLange;
  String? _codeLangeSub;

  SettingOffline? _settingData;

  SettingOffline? get settingData => _settingData;

  String? get codeLange => _codeLange;
  String? get codeLangeSub => _codeLangeSub;

  void initData() {
    if (_settingData == null) {
      getDataLanguageSetting().then((value) => {
        _settingData = value,
        _locale = Locale((_codeLange==null)?_settingData!.language.sortname.toLowerCase():_codeLange!),
      });
    }else{
      _locale = Locale((_codeLange==null)?_settingData!.language.sortname.toLowerCase():_codeLange!);
    }
  }

  Future<SettingOffline> getDataLanguageSetting() async {
    SettingOffline data =
    await DataOffline().getDataSetting(keyData: "MainSetting");
    return data;
  }

  Future<String> getDataSaveOffline() async {
    final prefs = await SharedPreferences.getInstance();
    var lange = prefs.getString('lange_code');
    return lange.toString();
  }


  void setUpdateApi(bool set) {
    _updateApi = set;
    notifyListeners();
  }

  void setCodeLange(String newCodeLange) {
    _codeLange = newCodeLange;
    notifyListeners();
  }

  void setCodeLangeSub(String newCodeLange) {
    _codeLangeSub = newCodeLange;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!PlyrVideoPlayer.all.contains(locale)) return;
    _preLanguageCode = _locale == null ? null : _locale!.languageCode;
    _updateApi = false;
    _locale = locale;
    notifyListeners();
  }

  Future<void> reloadWithLogin() async {
    if (_updateView == false) {
      _updateView = true;
      notifyListeners();
    }
  }

  Future<void> reloadWithLogout() async {
    if (_updateView == true) {
      _updateView = false;
    }
  }

  void setIsFirstApp(bool isFirst){
    _isFirstApp=isFirst;
    notifyListeners();
  }

  void setIsFirstOpen(bool isOpen){
    _isFirstOpen=isOpen;
    notifyListeners();
  }
}
