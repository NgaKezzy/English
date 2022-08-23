import 'package:app_learn_english/models/CateFollowModel.dart';
import 'package:scoped_model/scoped_model.dart';

class DataUser extends Model {
  int uid;
  String username;
  String fullname;
  String email;
  int sex;
  String country;
  String langnative;
  String avatar;
  int activeEmail;
  int totalExp;
  int totalNewWord;
  int totalVideoComplete;
  int totalTalkComplete;
  int totalVideoPlus;
  String createdtime;
  String updatetime;
  String lastDateLogin;
  int isVip;
  String createVipTime;
  List<CateFollow> listCateFollow;
  int connectFacebook;
  int connectGoogle;
  int level;
  int gold;
  int heart;
  String urlImageSocial;

  DataUser({
    required this.uid,
    required this.username,
    required this.fullname,
    required this.email,
    required this.sex,
    required this.country,
    required this.langnative,
    required this.avatar,
    required this.activeEmail,
    required this.totalExp,
    required this.totalNewWord,
    required this.totalVideoComplete,
    required this.totalTalkComplete,
    required this.totalVideoPlus,
    required this.createdtime,
    required this.updatetime,
    required this.lastDateLogin,
    required this.isVip,
    required this.createVipTime,
    required this.connectFacebook,
    required this.connectGoogle,
    required this.listCateFollow,
    required this.level,
    required this.gold,
    required this.heart,
    this.urlImageSocial = '',
  });
  factory DataUser.fromJson(Map<String, dynamic> json) {
    return DataUser(
        uid: json['uid'],
        username: json['username'].toString(),
        fullname: json['fullname'].toString(),
        email: json['email'].toString(),
        sex: json['sex'],
        country: json['country'].toString(),
        langnative: json['langnative'].toString(),
        avatar: json['avatar'].toString(),
        activeEmail: json['activeEmail'],
        totalExp: json['totalExp'],
        totalNewWord: json['totalNewWord'],
        totalVideoComplete: json['totalVideoComplete'],
        totalTalkComplete: json['totalTalkComplete'],
        totalVideoPlus: json['totalVideoPlus'],
        createdtime: json['createdtime'].toString(),
        updatetime: json['updatetime'].toString(),
        lastDateLogin: json['lastDateLogin'].toString(),
        isVip: json['isVip'],
        connectFacebook:
            json['connectFacebook'] != null ? json['connectFacebook'] : 0,
        connectGoogle:
            json['connectGoogle'] != null ? json['connectGoogle'] : 0,
        createVipTime: json['createVipTime'].toString(),
        listCateFollow: json['listCateFollow'] != null
            ? json['listCateFollow'].map<CateFollow>((json) {
                return CateFollow.fromJson(json);
              }).toList()
            : [],
        urlImageSocial: '',
        level: json['level'],
        gold: json['gold'],
        heart: json['heart']);
  }
  Map<String, dynamic> toJson() => {
        'uid': this.uid,
        'username': this.username,
        'fullname': this.fullname,
        'email': this.email,
        'sex': this.sex,
        'country': this.country,
        'langnative': this.langnative,
        'avatar': this.avatar,
        'activeEmail': this.activeEmail,
        'totalExp': this.totalExp,
        'totalNewWord': this.totalNewWord,
        'totalVideoComplete': this.totalVideoComplete,
        'totalTalkComplete': this.totalTalkComplete,
        'totalVideoPlus': this.totalVideoPlus,
        'createdtime': this.createdtime,
        'updatetime': this.updatetime,
        'lastDateLogin': this.lastDateLogin,
        'isVip': this.isVip,
        'connectFacebbok': this.connectFacebook,
        'connectGoogle': this.connectGoogle,
        'createVipTime': this.createVipTime,
        'listCateFollow': this.listCateFollow,
        'level': this.level,
        'gold': this.gold,
        'heart': this.heart,
      };
  String getLangName() {
    String lang = "";
    switch (this.langnative) {
      case "en":
        lang = "Tiếng Anh";
        break;
      case "vi":
        lang = "Việt Nam";
        break;
      case "zh":
        lang = "Trung Quốc";
        break;
      case "ja":
        lang = "Nhật Bản";
        break;
      case "hi":
        lang = "Ấn Độ";
        break;
      case "es":
        lang = "Tây Ban Nha";
        break;
      case "ru":
        lang = "Nga";
        break;
    }
    return lang;
  }
}
