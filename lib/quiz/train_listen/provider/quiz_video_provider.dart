import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuizVideoProvider with ChangeNotifier {
  CountdownController _countdownController = CountdownController(
    autoStart: true,
  );
  late YoutubePlayerController _youtubePlayerController;
  int _timeSecond = 150;
  List<TalkDetailModel> _listSub = [];
  List<String> _filterArray = [];
  List<String> _randomString = [];
  List<Widget> _randomStringConvert = [];
  List<Widget> _elementConvert = [];
  int _index = 0;
  int _indexMatched = 0;
  bool _initialize = false;
  bool _isPlayerReady = false;
  double _second = 0;
  double _point = 150;
  int _gesture = 0;
  int _preGesture = -1;
  double _secondCheck = 0;
  double _timeEnd = 0;
  int _type = 0;
  DataTalk? _dataTalk;

  DataTalk? get dataTalk => _dataTalk;

  void setDataTalk(DataTalk data) {
    _dataTalk = data;
    notifyListeners();
  }

  int get type => _type;

  void setType(int type) {
    _type = type;
    notifyListeners();
  }

  double get timeEnd => _timeEnd;

  void setTimeEnd(double timeEnd) {
    _timeEnd = timeEnd;
    notifyListeners();
  }

  double get secondCheck => _secondCheck;

  void setSecondCheck(double secondCheck) {
    _secondCheck = secondCheck;
    notifyListeners();
  }

  List<bool> _randomStringBool = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  List<bool> get randomStringBool => _randomStringBool;

  void setRandomStringBool(List<bool> randomStringBool) {
    _randomStringBool = randomStringBool;
    notifyListeners();
  }

  void setElementRandomStringBool(bool value, int index) {
    _randomStringBool[index] = value;
    notifyListeners();
  }

  void removeElementRandomStringBool(int index) {
    _randomStringBool.removeAt(index);
    notifyListeners();
  }

  int get preGesture => _preGesture;

  void setPreGesture(int preGesture) {
    _preGesture = preGesture;
    notifyListeners();
  }

  double get point => _point;

  void setPoint(double point) {
    _point = point;
    notifyListeners();
  }

  double get second => _second;

  void setSecond(double second) {
    _second = second;
    notifyListeners();
  }

  int get gesture => _gesture;

  void setGesture(int gesture) {
    _gesture = gesture;
    notifyListeners();
  }

  YoutubePlayerController get youtubePlayerController =>
      _youtubePlayerController;

  void setControllerYoutube(YoutubePlayerController controller) {
    _youtubePlayerController = controller;
    notifyListeners();
  }

  bool get isPlayerReady => _isPlayerReady;

  void setIsPlayerReady(bool value) {
    _isPlayerReady = value;
    notifyListeners();
  }

  bool get initialize => _initialize;

  void reset() {
    _index = 0;
    _indexMatched = 0;
    _listSub = [];
    _initialize = false;
    _filterArray = [];
    _randomString = [];
    _isPlayerReady = false;
    _randomStringBool = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];
    _second = 0;
    _point = 150;
    _gesture = -1;
    _preGesture = -1;
    notifyListeners();
  }

  void setRandomStringConvert(List<Widget> list) {
    _randomStringConvert = list;
    notifyListeners();
  }

  void setRandomStringConvertIndex(Widget wid) {
    _randomStringConvert[indexMatched] = wid;
    notifyListeners();
  }

  List<Widget> get randomStringConvert => _randomStringConvert;

  void setElementConvert(List<Widget> list) {
    _elementConvert = list;
    notifyListeners();
  }

  void setElementConvertE(Widget widget, int index) {
    _elementConvert[index] = widget;
    notifyListeners();
  }

  List<Widget> get elementConvert => _elementConvert;

  void setInitialize(bool boolean) {
    _initialize = boolean;
    notifyListeners();
  }

  int get currentTime => _timeSecond;

  CountdownController get controller => _countdownController;

  void setListSub(List<TalkDetailModel> listSub) {
    _listSub = listSub;
    notifyListeners();
  }

  List<TalkDetailModel> get listSub => _listSub;

  void setFilterArray(List<String> filterArray) {
    _filterArray = filterArray;
    notifyListeners();
  }

  void removeElementFilterArray(int index) {
    _filterArray.removeAt(index);
    notifyListeners();
  }

  List<String> get filterArray => _filterArray;

  void setRandomString(List<String> randomString) {
    _randomString = randomString;
    notifyListeners();
  }

  void setRandomStringRemove(String element) {
    _randomString.remove(element);
    notifyListeners();
  }

  List<String> get randomString => _randomString;

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }

  int get index => _index;

  void setIndexMatched(int indexMatched) {
    _indexMatched = indexMatched;
    notifyListeners();
  }

  int get indexMatched => _indexMatched;
}
