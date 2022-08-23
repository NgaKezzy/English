import 'dart:convert';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserTargetLogModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:http/http.dart' as http;

class TargetAPIs {
  static final TargetAPIs _singleton = TargetAPIs._internal();
  factory TargetAPIs() {
    return _singleton;
  }
  TargetAPIs._internal();

  Future<UserTargetLogModel> getDataTarget(int uid) async {
    var dataTarget;
    var url = 'FlowerTarget/getDataTargetByUserId/' + uid.toString();
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse['status'] == 1) {
        dataTarget = UserTargetLogModel.fromJson(mapResponse['dataTarget']);
      } else {
        printGreen("Khong co data");
      }
    } else {
      throw Exception('Failed to load album');
    }
    return dataTarget;
  }

  Future<bool> updateTarget({int uid = 0, int targetKey = 0}) async {
    bool result = false;
    if (uid != 0 && targetKey != 0) {
      var url = 'FlowerTarget/settingTarget/';
      var formData = jsonEncode(<String, dynamic>{
        "uid": uid,
        "target_key": targetKey,
      });
      var response = await Session().postDefault(url, formData);

      if (response.statusCode == 200) {
        Map mapResponse = json.decode(response.body.toString());
        if (mapResponse['status'] == 1) {
          result = true;
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

  Future<List<int>> updateWatchedVideo({
    required int uid,
    required int videoId,
    required String username,
    required int isVip,
  }) async {
    var url = 'UsersLogVideo/add/';
    Map data = {
      'uid': '$uid',
      'vid': '$videoId',
      'username': '$username',
      'isvvip': '$isVip',
    };
    try {
      var response = await http.post(
        Uri.https(Session().BASE_URL, url),
        body: data,
      );
      print(response);
      if (response.statusCode == 200) {
        var mapping = json.decode(response.body);
        return [
          int.parse('${mapping['totalVideoComplete']}'),
          int.parse('${mapping['totalVideoPlus']}')
        ];
      } else {
        return [];
      }
    } catch (e) {
      print('Xảy ra lỗi trong quá trình xử lý $e');
      return [];
    }
  }

  Future<int> updateWatchedSpeak({
    required int uid,
    required int speakId,
    required String username,
  }) async {
    var url = 'UsersLogSpeak/add/';
    Map data = {
      'uid': '$uid',
      'sid': '$speakId',
      'username': '$username',
    };
    try {
      var response = await http.post(
        Uri.https(Session().BASE_URL, url),
        body: data,
      );
      print(response);
      if (response.statusCode == 200) {
        var mapping = json.decode(response.body);
        return int.parse('${mapping['totalTalkComplete']}');
      } else {
        return 0;
      }
    } catch (e) {
      print('Xảy ra lỗi trong quá trình xử lý $e');
      return 0;
    }
  }

  Future<int> updateCompleteTarget({
    required int uid,
    required int target,
    required String username,
    required int isCompleted,
  }) async {
    var url = 'UsersLogTarget/add';
    Map data = {
      'uid': '$uid',
      'target': '$target',
      'username': '$username',
      'iscomplete': '$isCompleted',
    };
    try {
      var response = await http.post(
        Uri.https(Session().BASE_URL, url),
        body: data,
      );
      print(response);
      if (response.statusCode == 200) {
        var mapping = json.decode(response.body);
        return int.parse('${mapping['totalCompleteMonth']}');
      } else {
        return 0;
      }
    } catch (e) {
      print('Xảy ra lỗi trong quá trình xử lý $e');
      return 0;
    }
  }
}
