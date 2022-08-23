import 'package:app_learn_english/logError/LogCustom.dart';

class UserSocialModel {
  String? name;
  String? email;
  String? photoURL;
  String? id;

  UserSocialModel({this.name, this.email, this.photoURL, this.id});
  UserSocialModel.fromJson(Map<String, dynamic> json) {
    name = json["name"] ? json["name"] : "";
    photoURL =
        json["photoURL"]["data"]["url"] ? json["photoURL"]["data"]["url"] : "";
    email = json["email"] ? json["email"] : "";
    id = json["id"] ? json["id"] : "";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data['email'] = this.email;
    data['photoUrl'] = this.photoURL;
    data['id'] = this.id;
    printCyan("DATA: " + data.toString());
    return data;
  }
}
