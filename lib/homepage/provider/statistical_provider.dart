import 'dart:convert';

import 'package:app_learn_english/networks/DataCache.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticsticalProvider with ChangeNotifier {
  int _totalVideos = 0;
  int _totalVideosVip = 0;
  int _totalSpeak = 0;
  int _totalCompleteMonth = 0;
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void updateTotalVideos(int? number) async {
    if (number != null) {
      _totalVideos = number;
      DataCache().modifierUserData(totalVideo: number);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'userData', jsonEncode(DataCache().getUserData().toJson()));
    } else {
      _totalVideos = DataCache().getUserData().totalVideoComplete;
    }
    notifyListeners();
  }

  get totalVideosWatched => _totalVideos;

  void updateTotalVideosVip(int? number) async {
    if (number != null) {
      _totalVideosVip = number;
      DataCache().modifierUserData(totalVideoVip: number);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'userData', jsonEncode(DataCache().getUserData().toJson()));
    } else {
      _totalVideosVip = DataCache().getUserData().totalVideoPlus;
    }
    notifyListeners();
  }

  get totalVideosWatchedVip => _totalVideosVip;

  void updateTotalTalk(int? number) async {
    if (number != null) {
      _totalSpeak = number;
      DataCache().modifierUserData(totalTalk: number);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'userData', jsonEncode(DataCache().getUserData().toJson()));
    } else {
      _totalSpeak = DataCache().getUserData().totalTalkComplete;
    }
    notifyListeners();
  }

  get totalTalk => _totalSpeak;

  void updateTotalMonth(int number) async {
    _totalCompleteMonth = number;

    notifyListeners();
  }

  get totalTalkMonth => _totalCompleteMonth;

  void clear() {
    _totalVideosVip = 0;
    _totalSpeak = 0;
    _totalVideos = 0;
    notifyListeners();
  }
}
