import 'package:flutter/material.dart';

class CheckLogin with ChangeNotifier {
  bool checkInternet = true;
  bool _checkIp = false;
  int isFirstUse = 0;
  bool _checkIpRegister = false;
  Map<String, dynamic> userData = {};

  void setCheckInternet(bool check) {
    checkInternet = check;
    notifyListeners();
  }

  bool get checkIp => _checkIp;
  void setCheckIp(bool checkNew) {
    _checkIp = checkNew;
    notifyListeners();
  }

  bool get checkIpRegister => _checkIpRegister;
  void setCheckIpRGT(bool checkNewRGT) {
    _checkIpRegister = checkNewRGT;
    notifyListeners();
  }

  get checkInternetCurrent => checkInternet;

  void setIsFirstUse(int isFirst) {
    isFirstUse = isFirst;
    notifyListeners();
  }

  get getIsFirstUse => isFirstUse;

  void setUserData(Map<String, dynamic> data) {
    userData = data;
    notifyListeners();
  }

  get getUserData => userData;
}
