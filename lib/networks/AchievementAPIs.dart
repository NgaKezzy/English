import 'dart:convert';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/AchievementModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';

class AchievementAPIs {
  static final AchievementAPIs _singleton = AchievementAPIs._internal();
  factory AchievementAPIs() {
    return _singleton;
  }
  AchievementAPIs._internal();

  Future<List<UserAchievement>> getDataAchievement() async {
    var dataAchievement;
    var url = DataCache().getUserData().uid == 0
        ? 'FlowerAchievement/getDataAchievementV2/297'
        : 'FlowerAchievement/getDataAchievementV2/' +
            DataCache().getUserData().uid.toString();
    printGreen(url);
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      printYellow(mapResponse.toString());
      if (mapResponse['status'] == 1) {
        dataAchievement = mapResponse['listAchi'] != null
            ? mapResponse['listAchi'].map<UserAchievement>((json) {
                return UserAchievement.fromJson(json);
              }).toList()
            : [];
      } else {
        printGreen("Khong co data");
      }
    } else {
      throw Exception('Failed to load album');
    }
    printCyan(dataAchievement.length.toString());
    return dataAchievement;
  }

  Future<bool> updateAchievement({int achiId = 0}) async {
    bool result = false;
    if (achiId != 0) {
      var url = 'FlowerAchievement/updateAchievement/';
      var formData = jsonEncode(<String, dynamic>{
        "uid": DataCache().getUserData().uid,
        "achiId": achiId,
      });
      var response = await Session().postDefault(url, formData);

      if (response.statusCode == 200) {
        Map mapResponse = json.decode(response.body.toString());
        if (mapResponse['status'] == 1) {
          result = true;
          DataCache().updateCompleteInCache(achiId);
        }
      } else {
        throw Exception('Update Failed.');
      }
    }
    return result;
  }

  Future<bool> updateExp({int uid = 0, int exp = 0}) async {
    bool result = false;
    if (uid != 0 && exp != 0) {
      var url = 'FlowerTarget/getRewardExp/';
      var formData = jsonEncode(<String, dynamic>{
        "uid": uid,
        "exp": exp,
      });
      var response = await Session().postDefault(url, formData);

      if (response.statusCode == 200) {
        Map mapResponse = json.decode(response.body.toString());
        if (mapResponse['status'] == 1) {
          if (mapResponse['totalExp'] != null) {
            result = true;
            DataCache().updateTotalExp(mapResponse['totalExp']);
          }
        }
      } else {
        throw Exception('Update Failed.');
      }
    }
    return result;
  }
}
