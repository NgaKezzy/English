import 'dart:math';

import 'package:app_learn_english/logError/LogCustom.dart';

class QuizVideoUtils {
  static RegExp regExp = new RegExp(
    r"[^\w\s\']",
    caseSensitive: false,
    multiLine: false,
  );

  static Random random = Random();

  static int randomNumb(List<String> arr, List<int> randomIndexArray) {
    int randomInt;

    randomInt = random.nextInt(arr.length);
    bool flag = false;
    if (randomIndexArray.length == 0) {
      return randomInt;
    }
    for (var i = 0; i < randomIndexArray.length; i++) {
      if (randomInt == randomIndexArray[i]) {
        flag = true;
      }
    }
    if (flag) {
      return randomNumb(arr, randomIndexArray);
    } else {
      return randomInt;
    }
  }

  static List<String> renderFilterArray(
    String sub,
  ) {
    print('Đây là sub:' + sub);
    List<String> stringToArray = sub.replaceAll(regExp, '').trim().split(' ');
    printYellow('Array chưa lọc: ' + stringToArray.toString());
    var filterArray = stringToArray;
    // .where((element) => regExp.hasMatch(element) == false)
    // .toList();
    return filterArray;
  }

  static List<String> renderRandomString(List<String> filterArray) {
    List<String> randomString = [];
    List<int> randomIndex = [];
    printRed(filterArray.toString());
    for (var i = 0; i < filterArray.length; i++) {
      randomIndex.add(randomNumb(filterArray, randomIndex));
    }
    for (var i = 0; i < filterArray.length; i++) {
      randomString.add(filterArray[randomIndex[i]]);
    }
    printRed(randomString.toString());

    return randomString;
  }
}
