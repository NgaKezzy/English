import 'package:flutter/material.dart';

class CountHeartProvider with ChangeNotifier {
  int count = 0;
  int countSecond = 0;
  bool setFirstTime = true;
  int countSecondAds = 0;
  bool checkOpenAds = true;
  bool buttonAds = false;

  void setCountHeart(int number) {
    count = number;
    notifyListeners();
  }

  int get countHeart => count;

  void setCountSecond(int number) {
    countSecond = number;
    notifyListeners();
  }

  int get countSec => countSecond;

  void setFirstTimeStart(bool val) {
    setFirstTime = val;
    notifyListeners();
  }

  bool get firstTimeStart => setFirstTime;

  //Check Ads

  void setCountSecondAds(int number) {
    countSecondAds = number;
    notifyListeners();
  }

  int get countSecAds => countSecondAds;

  void setCheckOpenAds(bool val) {
    checkOpenAds = val;
    notifyListeners();
  }

  bool get checkOpenAdsBtn => checkOpenAds;

  void setButtonAds(bool val) {
    buttonAds = val;
    notifyListeners();
  }

  bool get btnAds => buttonAds;
}
