import 'package:app_learn_english/logError/LogCustom.dart';

class RoutersManager {
  static final RoutersManager _singleton = RoutersManager._internal();
  factory RoutersManager() {
    return _singleton;
  }
  RoutersManager._internal();
  String routeFAB = "";

  clearRoute() {
    printYellow("CLEAR");
    this.routeFAB = "";
  }

  setRoute(checkRouter) {
    this.routeFAB = checkRouter;
    printBlue('check FAB' + checkRouter);
  }
}
