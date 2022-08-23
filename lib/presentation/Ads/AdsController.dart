import 'dart:async';

import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/screens/play_video_screen.dart';
import 'package:flutter/cupertino.dart';

class AdsController {
  static final AdsController _singleton = AdsController._internal();
  factory AdsController() {
    return _singleton;
  }
  AdsController._internal();
  String route = "";
  AdmobHelper admobHelper = AdmobHelper();

  clearRoute() {
    printYellow("CLEAR");
    this.route = "";
  }

  checkTime() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if ((route.toString() == PlayVideo.routeName.toString()) ||
          (route.toString() == MainSpeakScreen.routeName.toString())) {
        printBlue('Ko hiện ads');
      } else {
        printBlue("SHOW ADS");
        admobHelper.showRewaredAd();
      }
    });
  }

// callback cộng tim cho trò chơi

  setRoute(checkRouter) {
    this.route = checkRouter;
    printBlue('check ads' + checkRouter);
  }

  showAdsCallback(Function callback, BuildContext context) {
    admobHelper.showRewaredGameHasCallback(callback, context);
  }
}
