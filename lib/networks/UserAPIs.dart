import 'dart:convert';

import 'dart:io';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/config/config_app.dart';
import 'package:app_learn_english/models/notification_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataFirtAppLog.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_learn_english/utils/utils.dart';

class UserAPIs {
  static final UserAPIs _singleton = UserAPIs._internal();

  factory UserAPIs() {
    return _singleton;
  }

  UserAPIs._internal();

  Future<DataUser> fetchDataUser(String uId) async {
    var dataUser;
    try {
      var url = 'FlowerUser/getFlowerUserById/$uId';
      final response = await Session().getDefault(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        if (mapResponse['status'] == 1) {
          dataUser = DataUser.fromJson(mapResponse["dataUser"]);
        }
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print(e);
    }
    return dataUser;
  }

  Future<int> changeUserNickName(String newUsername, DataUser userData) async {
    var status = 0;
    var url = 'FlowerUser/changeUserName/';

    var formData = jsonEncode(
        <String, dynamic>{"uid": userData.uid, "username": newUsername});
    var response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        userData.username = mapResponse["user"]['username'];
        // FlutterSession().set("userData", jsonEncode(userData));
        printYellow(jsonEncode(mapResponse));
        final prefs = await SharedPreferences.getInstance();

        DataOffline().getDataLocal(keyData: "userData").then((value) => {
              value['username'] = mapResponse["user"]['username'],
              prefs.setString('userData', jsonEncode(value)),
            });
      }
    } else {
      throw Exception('Failed to update username.');
    }
    return status;
  }

  Future<int> changeUserName(String newUsername, DataUser userData) async {
    var status = 0;
    var url = 'FlowerUser/changeFullName/';

    var formData = jsonEncode(
        <String, dynamic>{"uid": userData.uid, "fullname": newUsername});
    var response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        userData.fullname = mapResponse["user"]['fullname'];
        // FlutterSession().set("userData", jsonEncode(userData));
        printYellow(jsonEncode(mapResponse));
        final prefs = await SharedPreferences.getInstance();

        DataOffline().getDataLocal(keyData: "userData").then((value) => {
              value['fullname'] = mapResponse["user"]['fullname'],
              prefs.setString('userData', jsonEncode(value)),
            });
      }
    } else {
      throw Exception('Failed to update username.');
    }
    return status;
  }

  Future<DataUser?> userLogin(
      String username, String password, String? token) async {
    var dataUser;
    var url = 'FlowerUser/userLogin/';
    // bool emailValid = RegExp(
    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(username);
    var formData = jsonEncode(<String, dynamic>{
      'utype': Utils.getPlatfromID(),
      "username": username,
      "password": password,
    });
    var response = await Session().post(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      if (mapResponse['status'] == 1) {
        dataUser = DataUser.fromJson(mapResponse["dataUser"]);
      }
    } else {
      throw Exception('Login Failed.');
    }
    return dataUser;
  }

  Future<Map<String, dynamic>> userRegister(
      {String username = "",
      String password = "",
      String email = "",
      String deviceID = '',
      String? token}) async {
    Map<String, dynamic> result;
    var dataUser;
    var url = 'FlowerUser/userSigup/';

    var formData = jsonEncode(<String, dynamic>{
      'utype': Utils.getPlatfromID(),
      'deviceID': deviceID,
      "username": username,
      "password": password,
      "email": email,
      "topic": DataFirtAppLog().learn != null ? DataFirtAppLog().learn : "",
      "level": DataFirtAppLog().level != null ? DataFirtAppLog().level : 1,
      "target_key":
          DataFirtAppLog().target_key != null ? DataFirtAppLog().target_key : 1,
      "time_learn":
          DataFirtAppLog().hours != null ? DataFirtAppLog().hours : "08:00",
      "language":
          DataFirtAppLog().language != null ? DataFirtAppLog().language : "en",
      "token": token != null ? token : '',
    });
    var response = await Session().postDefault(url, formData);
    if (response.statusCode == 200) {
      result = json.decode(response.body);
      Map mapResponse = json.decode(response.body.toString());
      if (mapResponse['status'] == 1) {
        dataUser = DataUser.fromJson(mapResponse["dataUser"]);
        final prefs = await SharedPreferences.getInstance();

        prefs.setString('userData', jsonEncode(mapResponse["dataUser"]));
      }
    } else {
      throw Exception('Registor Failed.');
    }
    return result;
  }

  Future<DataUser> userAutoLogin() async {
    var dataUser;
    var url = 'FlowerUser/userLogin/';

    var formData =
        jsonEncode(<String, dynamic>{"username": "", "password": ""});
    var response = await Session().post(url, formData);

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse['status'] == 1) {
        printYellow("AUTO LOGIN: ");
        printYellow(mapResponse["dataUser"]);
        dataUser = DataUser.fromJson(mapResponse["dataUser"]);
      }
    } else {
      throw Exception('Auto login failed.');
    }
    return dataUser;
  }

  Future<int> changeUserPassword(
      String newPass, String oldPass, DataUser userData) async {
    var status = 0;
    var formData = jsonEncode(<String, dynamic>{
      "password": oldPass,
      "new_pass": newPass,
      "username": userData.username
    });
    var url = 'FlowerUser/changePassword/';

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      status = mapResponse['status'];
      if (status == 1) {
        // var dataResult = mapResponse["user"];
        // Chỗ này đê lưu cache sau tính sau

      }
    } else {
      throw Exception('Failed to update password.');
    }
    return status;
  }

  Future<int> confirmEmailAPI(String email) async {
    var status = 1;
    var url = 'FlowerUser/requestConfirmMail/';

    var formData = jsonEncode(<String, dynamic>{
      "uid": DataCache().getUserData().uid,
      "email": email
    });
    printRed(formData);
    var response = await Session().postDefault(url, formData);
    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      printYellow(mapResponse.toString());
      status = mapResponse['status'];
      // if (status == 1) {
      //   DataCache().updateConfirmMail();
      // }
    } else {
      throw Exception('Failed to update comfirm email.');
    }
    return status;
  }

  Future<int> forgotPassword(String email) async {
    var status = 1;
    var url = 'FlowerUser/forgotPassword/';

    var formData = jsonEncode(<String, dynamic>{"username": email});
    printRed(formData);
    var response = await Session().postDefault(url, formData);
    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      printYellow(mapResponse.toString());
      status = mapResponse['status'];
      // if (status == 1) {
      //   DataCache().updateConfirmMail();
      // }
    } else {
      throw Exception('Failed to update comfirm email.');
    }
    return status;
  }

  Map paserData(String data) {
    printCyan(data);
    Map res = new Map();
    List<String> strs = data.split(",");
    if (strs.length > 0) {
      String strStatus = strs[0];
      String strAvatar = strs[1];
      printYellow(strStatus);
      printYellow(strAvatar);
      List<String> strsStatus = strStatus.split(":");
      if (strsStatus.length > 0) {
        if (int.parse(strsStatus[1]) == 1) {
          res["status"] = int.parse(strsStatus[1]);
          List<String> strsVavatar = strAvatar.split(":");
          if (strsVavatar.length > 0) {
            res["avatar"] = strsVavatar[1].replaceAll(new RegExp('}|"'), "");
            printGreen(strsVavatar[1].replaceAll(new RegExp('}|"'), ""));
          }
        }
      }
    }

    return res;
  }

  Future<http.StreamedResponse?> uploadAvatar(File imageFile) async {
    var url = "FlowerUser/changeAvatar/";
    try {
      http.StreamedResponse response = await Session().postMedia(
        url,
        imageFile,
      );
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<DataUser> getListVip() async {
    var listVip;
    var url = "FlowerUser/getisVip";
    final response = await Session().getDefault(url);
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      if (mapResponse['listLanguage'] != null) {
        listVip = DataUser.fromJson(mapResponse);
      }
    } else {
      throw Exception('Load Vip faile');
    }
    return listVip;
  }

  Future<NotificationModel> getNotificationModel() async {
    var notificationModel;
    var url = " ";
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      notificationModel = NotificationModel.fromJson(mapResponse);
      var status = mapResponse['status'];
      if (status == 1) {}
    } else {
      throw Exception('Failed to load new word');
    }
    return notificationModel;
  }

  Future<bool> forgotPassword2(String email) async {
    var url = 'FlowerUser/forgotPassword';
    Map<String, String> dataForgot = {
      'email': email,
    };
    final response = await http.post(
      Uri.https(Session().BASE_URL, url),
      body: dataForgot,
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> saveTokenFCM(
      {required String token,
      String? username,
      String? uid,
      required String lang}) async {
    var url = 'ApiConfig/index';
    Map<String, String> dataContainToken = {
      'token': '$token',
      if (username != null) 'username': '$username',
      if (uid != null) 'uid': '$uid',
      'lang': '$lang',
    };
    final response = await http.post(
      Uri.https(Session().BASE_URL, url),
      body: dataContainToken,
    );
    if (response.statusCode == 200) {
      if (json.decode(response.body)['error'] == 1) {
        return false;
      }
      return false;
    }
    return false;
  }

  Future<int> getHeart({required String username, required int uid}) async {
    var url = 'User/lastDateLogin';
    Map<String, String> dataBody = {
      'username': '$username',
      'uid': '$uid',
    };
    final response = await http.post(
      Uri.https(Session().BASE_URL, url),
      body: dataBody,
    );
    if (response.statusCode == 200) {
      var dataDecode = json.decode(response.body);
      if (dataDecode['error'] == 1) {
        DataCache().setIsVipByLastLogin(dataDecode!['isVip']);
        return int.parse('${dataDecode["heart"]}');
      }
      return 0;
    }
    return 0;
  }

  Future<int> addAndDivHeart({
    required String username,
    required int uid,
    int? type,
    required int typeAction,
    int? vid,
    int? timequiz,
    String sign = '',
    String? package_inapp,
  }) async {
    var url = 'User/useHeart';
    Map<String, String> dataBody;

    dataBody = {
      'username': '$username',
      'uid': '$uid',
      'typeAction': '$typeAction',
      'sign': sign,
      if (vid != null) 'timequiz': '$timequiz',
      if (timequiz != null) 'vid': '$vid',
      if (package_inapp != null) 'package_inapp': '$package_inapp',
    };

    final response = await http.post(
      Uri.https(Session().BASE_URL, url),
      body: dataBody,
    );
    if (response.statusCode == 200) {
      var dataDecode = json.decode(response.body);
      if (dataDecode['error'] == 1) {
        return int.parse('${dataDecode["heart"]}');
      }
      return 0;
    }
    return 0;
  }

  Future<ConfigApp?> configApp() async {
    var url = 'ApiConfig';
    ConfigApp? config;
    try {
      final response = await http.get(
        Uri.https(Session().BASE_URL, url),
      );
      if (response.statusCode == 200) {
        var dataDecode = json.decode(response.body);
        config = ConfigApp.fromJson(dataDecode['datas']);
      }
      return config;
    } catch (e) {
      print(e);
      return config;
    }
  }

  Future<DataUser?> getInfoData() async {
    var url = 'FlowerUser/getUserInfo/${DataCache().getUserData().uid}';
    DataUser? userData;
    try {
      final response = await http.get(
        Uri.https(Session().BASE_URL, url),
      );
      if (response.statusCode == 200) {
        var dataDecode = json.decode(response.body);
        userData = DataUser.fromJson(dataDecode['dataUser']);
        print(userData.toJson());
      }
      return userData;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
