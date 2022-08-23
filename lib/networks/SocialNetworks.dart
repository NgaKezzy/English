import 'dart:convert';
import 'package:app_learn_english/extentions/constants.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataFirtAppLog.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/presentation/profile/Login/UserSocialModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import 'package:app_learn_english/utils/utils.dart';

class SocialNetworks {
  static final SocialNetworks _singleton = SocialNetworks._internal();
  factory SocialNetworks() {
    return _singleton;
  }
  SocialNetworks._internal();
  var googleSignInNow = GoogleSignIn();
  var facebookSignInNow = FacebookAuth.i;
  GoogleSignInAccount? googleSignInAccount;
  UserSocialModel? userGoogleModel;

  // Future<DataUser> googleLogin() async {
  //   var dataUser;
  //   this.googleSignInAccount = await this.googleSignInNow.signIn();
  //   this.userGoogleModel = new UserSocialModel(
  //       name: this.googleSignInAccount!.displayName,
  //       email: this.googleSignInAccount!.email,
  //       photoURL: this.googleSignInAccount!.photoUrl,
  //       id: this.googleSignInAccount!.id);
  //
  //   dataUser =
  //       await this.socialLogin(this.userGoogleModel, Constants.GOOGLE_TYPE);
  //   return dataUser;
  // }

  Future<DataUser?> googleSigin() async {
    DataUser? dataUser;
    this.googleSignInAccount = await this.googleSignInNow.signIn();
    this.userGoogleModel = UserSocialModel(
        name: this.googleSignInAccount!.displayName,
        email: this.googleSignInAccount!.email,
        photoURL: this.googleSignInAccount!.photoUrl,
        id: this.googleSignInAccount!.id);

    print("LoginGGIdSocial:${this.userGoogleModel!.id}");
    String? token = await FirebaseMessaging.instance.getToken();
    dataUser = await this
        .socialSigin(this.userGoogleModel, Constants.GOOGLE_TYPE, token);
    dataUser.avatar = this.googleSignInAccount!.photoUrl ?? "";
    return dataUser;
  }

  Future<int> googleConnect() async {
    int status = 0;
    this.googleSignInAccount = await this.googleSignInNow.signIn();
    this.userGoogleModel = new UserSocialModel(
        name: this.googleSignInAccount!.displayName,
        email: this.googleSignInAccount!.email,
        photoURL: this.googleSignInAccount!.photoUrl,
        id: this.googleSignInAccount!.id);

    status =
        await this.socialConnect(this.userGoogleModel, Constants.GOOGLE_TYPE);
    return status;
  }

  // Future<DataUser> facebookLogin() async {
  //   var dataUser;
  //   UserSocialModel? userFacebookModel;
  //   var result = await this.facebookSignInNow.login(
  //     permissions: ["public_profile", "email"],
  //   );
  //
  //   if (result.status == LoginStatus.success) {
  //     final requestData = await this.facebookSignInNow.getUserData(
  //           fields: "email,name,picture.type(large)",
  //         );
  //     userFacebookModel = new UserSocialModel(
  //       name: requestData["name"],
  //       email: requestData["email"],
  //       id: requestData["id"],
  //       photoURL: requestData["picture"]["data"]["url"] ?? "",
  //     );
  //     print("IdGoog:${userFacebookModel.id}");
  //     dataUser = await this.socialLogin(userFacebookModel, Constants.FACEBOOK_TYPE);
  //   }
  //   return dataUser;
  // }

  Future<DataUser?> facebookSigin() async {
    DataUser? dataUser;
    UserSocialModel? userFacebookModel;
    var result = await this.facebookSignInNow.login(
      permissions: ["public_profile", "email"],
    );
    print("object:${result.status}");
    if (result.status == LoginStatus.success) {
      final requestData = await this.facebookSignInNow.getUserData(
            fields: "email,name,picture.type(large)",
          );
      userFacebookModel = new UserSocialModel(
        name: requestData["name"],
        email: requestData["email"],
        id: requestData["id"],
        photoURL: requestData["picture"]["data"]["url"] ?? "",
      );
      print(requestData["picture"]["data"]["url"]);
      String? token = await FirebaseMessaging.instance.getToken();

      dataUser = await this
          .socialSigin(userFacebookModel, Constants.FACEBOOK_TYPE, token);
      dataUser.avatar = requestData["picture"]["data"]["url"] ?? "";
    }
    return dataUser;
  }

  Future<int> facebookConnect() async {
    int status = 0;
    UserSocialModel? userFacebookModel;
    var result = await this.facebookSignInNow.login(
      permissions: ["public_profile", "email"],
    );

    if (result.status == LoginStatus.success) {
      final requestData = await this.facebookSignInNow.getUserData(
            fields: "email,name,picture.type(large)",
          );
      printYellow(requestData.toString());

      userFacebookModel = new UserSocialModel(
        name: requestData["name"],
        email: requestData["email"],
        id: requestData["id"],
        photoURL: requestData["picture"]["data"]["url"] ?? "",
      );
      status = await socialConnect(userFacebookModel, Constants.FACEBOOK_TYPE);
    }
    return status;
  }

  Future<DataUser?> appleLogin({
    required AuthorizationCredentialAppleID credential,
  }) async {
    var url = "FlowerUserSocial/loginAppleById";
    var dataUser;

    if (credential.state == 'success') {
      var formData = jsonEncode(<String, dynamic>{
        "social_id": credential.userIdentifier,
        "typeSpcial": Constants.APPLE_TYPE,
      });

      try {
        var response = await Session().postDefault(url, formData);
        if (response.statusCode == 200) {
          Map mapResponse = json.decode(response.body.toString());
          if (mapResponse['status'] == 1) {
            dataUser = DataUser.fromJson(mapResponse["dataUser"]);
            DataCache().setUserData(dataUser);
            // Call API laays data target về lưu cache
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('userData', jsonEncode(mapResponse["dataUser"]));
            TargetAPIs().getDataTarget(mapResponse["dataUser"]['uid']).then(
                  (value) => {
                    printBlue("Load target OK"),
                    DataCache().setUserTargetLogModel(value),
                  },
                );
          }
        }
      } catch (e) {}
    }
    return dataUser;
  }

  Future<DataUser?> appleSignIn({
    required AuthorizationCredentialAppleID credential,
  }) async {
    var dataUser;
    UserSocialModel? userAppleModel;

    printRed('Trạng thái: $credential');

    if (credential.state == 'success') {
      userAppleModel = UserSocialModel(
        name: credential.givenName,
        email: credential.email,
        id: credential.userIdentifier,
        photoURL: "",
      );
      String? token = await FirebaseMessaging.instance.getToken();

      dataUser =
          await this.socialSigin(userAppleModel, Constants.APPLE_TYPE, token);
    }
    return dataUser;
  }

  Future<int> socialConnect(dataSocial, type) async {
    var url = 'FlowerUserSocial/socialConnect/';
    DataUser dataUser = DataCache().getUserData();
    int status = 0;
    var formData = jsonEncode(<String, dynamic>{
      "social_id": dataSocial.id,
      "email": dataSocial.email,
      "displayName": dataSocial.name,
      "uid": dataUser.uid,
      "typeSpcial": type,
    });
    var response = await Session().postDefault(url, formData);
    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        if (type == Constants.FACEBOOK_TYPE) {
          dataUser.connectFacebook = 1;
        } else if (type == Constants.GOOGLE_TYPE) {
          dataUser.connectGoogle = 1;
        }
        DataCache().updateSocial(dataUser);
      }
    } else {
      throw Exception('Login Failed.');
    }
    return status;
  }

  Future<DataUser> socialLogin(dataSocial, type) async {
    var url = 'FlowerUserSocial/socialLogin/';
    var dataUser;
    var formData = jsonEncode(<String, dynamic>{
      "social_id": dataSocial.id,
      "email": dataSocial.email,
      "displayName": dataSocial.name,
      "typeSpcial": type,
      "utype": Utils.getPlatfromID(),
    });
    printRed(formData.toString());
    try {
      var response = await Session().postDefault(url, formData);

      if (response.statusCode == 200) {
        Map mapResponse = json.decode(response.body.toString());
        if (mapResponse['status'] == 1) {
          dataUser = DataUser.fromJson(mapResponse["dataUser"]);
          DataCache().setUserData(dataUser);
          // Call API laays data target về lưu cache
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userData', jsonEncode(mapResponse["dataUser"]));
          TargetAPIs()
              .getDataTarget(mapResponse["dataUser"]['uid'])
              .then((value) => {
                    printBlue("Load target OK"),
                    DataCache().setUserTargetLogModel(value),
                  });
        }
      }
    } catch (error) {
      print('Xảy ra lỗi trong quá trình đăng nhập Facebook');
    }

    return dataUser;
  }

  Future<DataUser> socialSigin(dataSocial, type, String? token) async {
    var url = 'FlowerUserSocial/socialSignin/';
    var dataUser;
    String? deviceId = await PlatformDeviceId.getDeviceId;
    var formData = jsonEncode(<String, dynamic>{
      "social_id": dataSocial.id,
      "email": dataSocial.email,
      "displayName": dataSocial.name,
      "typeSpcial": type,
      "deviceID": deviceId,
      "avatar": dataSocial.photoURL,
      "utype": Utils.getPlatfromID(),
      "language":
          DataFirtAppLog().language != null ? DataFirtAppLog().language : "vi",
      if (token != null) "token": token,
    });
    try {
      http.Response response = await http.post(
        Uri.https(Session().BASE_URL, url),
        body: formData,
      );
      if (response.statusCode == 200) {
        Map mapResponse = json.decode(response.body.toString());
        if (mapResponse['status'] == 1) {
          dataUser = DataUser.fromJson(mapResponse["dataUser"]);
          DataCache().setUserData(dataUser);
          // Call API laays data target về lưu cache
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userData', jsonEncode(mapResponse["dataUser"]));
          prefs.setString('login', "${dataSocial.id}");
          print('LoginGGFB:${dataSocial.id}');
          TargetAPIs()
              .getDataTarget(mapResponse["dataUser"]['uid'])
              .then((value) => {
                    printBlue("Load target OK"),
                    DataCache().setUserTargetLogModel(value),
                  });
        }
      }
      return dataUser;
    } catch (error) {
      print(error);
      return dataUser;
    }
  }

  googleLogout() async {
    printYellow("GOOGLE LOGOUT");
    this.googleSignInAccount = await this.googleSignInNow.signOut();
    this.userGoogleModel = null;
  }

  facebookLogout() async {
    await this.facebookSignInNow.logOut();
  }
}
