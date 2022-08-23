import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoProvider with ChangeNotifier {
  DataTalk? videoDataTalk;
  DataTalk? _dataTalk;
  MiniplayerController miniplayerController = MiniplayerController();
  YoutubePlayerController? controller;
  Function? listener;
  bool setValue = true;
  DataUser? _userData;
  bool _postReport = false;

  void setVal(bool value) {
    setValue = value;
    notifyListeners();
  }

  MiniplayerController get miniplayer => miniplayerController;

  bool get postReport => _postReport;

  set postReport(newValue) {
    _postReport = newValue;
    notifyListeners();
  }

  get val => setValue;

  DataUser? get userData => _userData;

  set userData(DataUser? newData) {
    _userData = newData;
    notifyListeners();
  }

  void setdataTalk(DataTalk? dataTalk) {
    videoDataTalk = dataTalk;
    notifyListeners();
  }

  DataTalk? getdataTalk() {
    return videoDataTalk;
  }

  void setTalkData(DataTalk? dataTalk) {
    _dataTalk = dataTalk;

    notifyListeners();
  }

  DataTalk? getTalkData() {
    return _dataTalk;
  }

  void setControllerYoutube(YoutubePlayerController? controll) {
    controller = controll;
    notifyListeners();
  }

  YoutubePlayerController? getControllerYoutube() {
    return controller;
  }

  void setListener(Function listenerFnc) {
    listener = listenerFnc;
    notifyListeners();
  }

  Function? getListener() {
    return listener;
  }
}
