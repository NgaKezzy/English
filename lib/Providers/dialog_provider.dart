import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/quiz/fill_text_controller_model.dart';
import 'package:app_learn_english/models/quiz/list_choose_model.dart';
import 'package:flutter/material.dart';

class DialogProvider with ChangeNotifier {
  int _index = -1;
  bool _isCheck = false;
  int _indexFill = -1;
  bool _isRight = false;
  bool _isResult = false;
  List<String> _listRandomChoose = [];
  bool _isClickItem = false;
  late Widget _widgetRecorder;
  String _titleContent = '';
  String _titleSub = '';

  int get indexFill => _indexFill;

  bool get isCheck => _isCheck;

  int get index => _index;

  bool get isRight => _isRight;

  bool get isResult => _isResult;

  bool get isClickItem => _isClickItem;

  List<String> get listRandomChoose => _listRandomChoose;

  Widget get widgetRecorder => _widgetRecorder;

  String get titleContent => _titleContent;

  String get titleSub => _titleSub;

  setListRandomChoose(List<String> listMainChoose) {
    listMainChoose.shuffle();
    this._listRandomChoose = listMainChoose;
    return this._listRandomChoose;
  }

  setClickItem(bool isClick) {
    _isClickItem = isClick;
    notifyListeners();
  }

  setWidgetRecorder(Widget newWidget) {
    _widgetRecorder = newWidget;
    notifyListeners();
  }

  setTitleContentAndSub(String newTitleContent, String newSub) {
    _titleContent = newTitleContent;
    _titleSub = newSub;
    notifyListeners();
  }

  checkLanguage(String text, List<String> listLanguage) {
    String name = text.trim();
    String textLanguage = name
        .replaceAll(",", "")
        .replaceAll("!", "")
        .replaceAll(".", "")
        .replaceAll("?", "")
        .replaceAll("''", "");
    for (var language in listLanguage) {
      String textChoose = language
          .replaceAll(" ", "")
          .replaceAll(",", "")
          .replaceAll("!", "")
          .replaceAll(".", "")
          .replaceAll("?", "")
          .replaceAll("''", "");

      if (textChoose.toLowerCase() == textLanguage.toLowerCase()) {
        this._isCheck = true;
        break;
      } else {
        this._isCheck = false;
      }
    }
  }

  setIndex(int index) {
    this._index = index;
    return this._index;
  }

  setIndexFill(int index) {
    this._indexFill = index;
    return this._indexFill;
  }

  checkResults(List<String> listEnglish, List<ChooseModel> listChoose,
      List<int> _listIndexTextChoose) {
    for (int i = 0; i < _listIndexTextChoose.length; i++) {
      String _textEnglish = listEnglish[_listIndexTextChoose[i]]
          .replaceAll(",", "")
          .replaceAll("!", "")
          .replaceAll(".", "")
          .replaceAll("?", "")
          .replaceAll("''", "")
          .replaceAll(" ", "");

      String textChoose = listChoose[_listIndexTextChoose[i]]
          .title
          .replaceAll(" ", "")
          .replaceAll(",", "")
          .replaceAll("!", "")
          .replaceAll(".", "")
          .replaceAll("?", "")
          .replaceAll("''", "")
          .toLowerCase();
      if (_textEnglish.toLowerCase() == textChoose) {
        this._isRight = true;
      } else {
        this._isRight = false;
        break;
      }
    }
    return this._isRight;
  }

  checkResultsTextFill(List<String> listEnglish, List<int> listIndexMain,
      List<FillTextControllerModer> listTextFill) {
    for (int i = 0; i < listIndexMain.length; i++) {
      String _textEnglish = listEnglish[listIndexMain[i]]
          .replaceAll(',', '')
          .replaceAll('!', '')
          .replaceAll('.', '')
          .replaceAll('?', '')
          .replaceAll('"', '');

      String textChoose = listTextFill[listIndexMain[i]]
          .tileChange
          .toLowerCase()
          .replaceAll(" ", "")
          .replaceAll(',', '')
          .replaceAll('!', '')
          .replaceAll('.', '')
          .replaceAll('?', '')
          .replaceAll('"', '')
          .toLowerCase();
      if (_textEnglish.toLowerCase() == textChoose) {
        this._isRight = true;
      } else {
        this._isRight = false;
        break;
      }
    }
    return this._isRight;
  }

  checkResultError(String text, String textMain) {
    String name = text.trim();
    String textLanguage = name
        .replaceAll(',', '')
        .replaceAll('!', '')
        .replaceAll('.', '')
        .replaceAll('?', '')
        .replaceAll('"', '');

    String main = textMain
        .trim()
        .replaceAll(",", '')
        .replaceAll("!", '')
        .replaceAll(".", '')
        .replaceAll("?", '')
        .replaceAll('"', '');

    if (textLanguage.toLowerCase() == main.toLowerCase()) {
      this._isResult = true;
    } else {
      this._isResult = false;
    }
  }
}
