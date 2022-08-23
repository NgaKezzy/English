class Achievement {
  int id;
  String name;
  String name_vi;
  String name_zh;
  String name_ja;
  String name_hi;
  String name_es;
  String name_ru;
  String name_tr;
  String name_pt;
  String name_id;
  String name_th;
  String name_ms;
  String name_ar;
  String name_fr;
  String name_it;
  String name_de;
  String name_ko;
  String name_zh_Hant_TW;
  String name_sk;
  String name_sl;
  String description;
  String description_vi;
  String description_zh;
  String description_ja;
  String description_hi;
  String description_es;
  String description_ru;
  String description_tr;
  String description_pt;
  String description_id;
  String description_th;
  String description_ms;
  String description_ar;
  String description_fr;
  String description_it;
  String description_de;
  String description_ko;
  String description_zh_Hant_TW;
  String description_sk;
  String description_sl;
  int count;
  int type;
  String createdtime;
  String updatedtime;
  Achievement({
    required this.id,
    required this.name,
    required this.name_vi,
    required this.name_zh,
    required this.name_ja,
    required this.name_hi,
    required this.name_es,
    required this.name_ru,
    required this.name_tr,
    required this.name_pt,
    required this.name_id,
    required this.name_th,
    required this.name_ms,
    required this.name_ar,
    required this.name_fr,
    required this.name_it,
    required this.name_de,
    required this.name_ko,
    required this.name_zh_Hant_TW,
    required this.name_sk,
    required this.name_sl,
    required this.description,
    required this.description_vi,
    required this.description_zh,
    required this.description_ja,
    required this.description_hi,
    required this.description_es,
    required this.description_ru,
    required this.description_tr,
    required this.description_pt,
    required this.description_id,
    required this.description_th,
    required this.description_ms,
    required this.description_ar,
    required this.description_fr,
    required this.description_it,
    required this.description_de,
    required this.description_ko,
    required this.description_zh_Hant_TW,
    required this.description_sk,
    required this.description_sl,
    required this.count,
    required this.type,
    required this.createdtime,
    required this.updatedtime,
  });
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] != null ? int.parse(json['id']) : 0,
      name: json['name'] != null ? json['name'].toString() : "",
      name_vi: json['name_vi'] != null ? json['name_vi'].toString() : "",
      name_zh: json['name_zh'] != null ? json['name_zh'].toString() : "",
      name_ja: json['name_ja'] != null ? json['name_ja'].toString() : "",
      name_hi: json['name_hi'] != null ? json['name_hi'].toString() : "",
      name_es: json['name_es'] != null ? json['name_es'].toString() : "",
      name_ru: json['name_ru'] != null ? json['name_ru'].toString() : "",
      name_tr: json['name_tr'] != null ? json['name_tr'].toString() : "",
      name_pt: json['name_pt'] != null ? json['name_pt'].toString() : "",
      name_id: json['name_id'] != null ? json['name_id'].toString() : "",
      name_th: json['name_th'] != null ? json['name_th'].toString() : "",
      name_ms: json['name_ms'] != null ? json['name_ms'].toString() : "",
      name_ar: json['name_ar'] != null ? json['name_ar'].toString() : "",
      name_fr: json['name_fr'] != null ? json['name_fr'].toString() : "",
      name_it: json['name_it'] != null ? json['name_it'].toString() : "",
      name_de: json['name_de'] != null ? json['name_de'].toString() : "",
      name_ko: json['name_ko'] != null ? json['name_ko'].toString() : "",
      name_zh_Hant_TW: json['name_zh_Hant_TW'] != null
          ? json['name_zh_Hant_TW'].toString()
          : "",
      name_sk: json['name_sk'] != null ? json['name_sk'].toString() : "",
      name_sl: json['name_sl'] != null ? json['name_sl'].toString() : "",
      description:
          json['description'] != null ? json['description'].toString() : "",
      description_vi: json['description_vi'] != null
          ? json['description_vi'].toString()
          : "",
      description_zh: json['description_zh'] != null
          ? json['description_zh'].toString()
          : "",
      description_ja: json['description_ja'] != null
          ? json['description_ja'].toString()
          : "",
      description_hi: json['description_hi'] != null
          ? json['description_hi'].toString()
          : "",
      description_es: json['description_es'] != null
          ? json['description_es'].toString()
          : "",
      description_ru: json['description_ru'] != null
          ? json['description_ru'].toString()
          : "",
      description_tr: json['description_tr'] != null
          ? json['description_tr'].toString()
          : "",
      description_pt: json['description_pt'] != null
          ? json['description_pt'].toString()
          : "",
      description_id: json['description_id'] != null
          ? json['description_id'].toString()
          : "",
      description_th: json['description_th'] != null
          ? json['description_th'].toString()
          : "",
      description_ms: json['description_ms'] != null
          ? json['description_ms'].toString()
          : "",
      description_ar: json['description_ar'] != null
          ? json['description_ar'].toString()
          : "",
      description_fr: json['description_fr'] != null
          ? json['description_fr'].toString()
          : "",
      description_it: json['description_it'] != null
          ? json['description_it'].toString()
          : "",
      description_de: json['description_de'] != null
          ? json['description_de'].toString()
          : "",
      description_ko: json['description_ko'] != null
          ? json['description_ko'].toString()
          : "",
      description_zh_Hant_TW: json['description_zh_Hant_TW'] != null
          ? json['description_zh_Hant_TW'].toString()
          : "",
      description_sk: json['description_sk'] != null
          ? json['description_sk'].toString()
          : "",
      description_sl: json['description_sl'] != null
          ? json['description_sl'].toString()
          : "",
      count: json['count'] != null ? int.parse(json['count']) : 0,
      type: json['type'] != null ? int.parse(json['type']) : 0,
      createdtime:
          json['createdtime'] != null ? json['createdtime'].toString() : "",
      updatedtime:
          json['updatedtime'] != null ? json['updatedtime'].toString() : "",
    );
  }
  Map toJson() => {
        'id': this.id,
        'name': this.name,
        'description': this.description,
        'count': this.count,
        'type': this.type,
        'createdtime': this.createdtime,
        'updatedtime': this.updatedtime,
      };
  String getNameByLanguage(String code) {
    String name = this.name;
    switch (code) {
      case "en":
        name = this.name;
        break;
      case "vi":
        name = this.name_vi;
        break;
      case "hi":
        name = this.name_hi;
        break;
      case "es":
        name = this.name_es;
        break;
      case "ru":
        name = this.name_ru;
        break;
      case "ja":
        name = this.name_ja;
        break;
      case "zh":
        name = this.name_zh;
        break;
      case "tr":
        name = this.name_tr;
        break;
      case "pt":
        name = this.name_pt;
        break;
      case "id":
        name = this.name_id;
        break;
      case "th":
        name = this.name_th;
        break;
      case "ms":
        name = this.name_ms;
        break;
      case "ar":
        name = this.name_ar;
        break;
      case "fr":
        name = this.name_fr;
        break;
      case "it":
        name = this.name_it;
        break;
      case "de":
        name = this.name_de;
        break;
      case "ko":
        name = this.name_ko;
        break;
      case "zh_Hant_TW":
        name = this.name_zh_Hant_TW;
        break;
      case "sk":
        name = this.name_sk;
        break;
      case "sl":
        name = this.name_sl;
        break;
      default:
    }
    return name;
  }

  String getDescriptionByLanguage(String code) {
    String des = this.description;
    switch (code) {
      case "en":
        des = this.description;
        break;
      case "vi":
        des = this.description_vi;
        break;
      case "hi":
        des = this.description_hi;
        break;
      case "es":
        des = this.description_es;
        break;
      case "ru":
        des = this.description_ru;
        break;
      case "ja":
        des = this.description_ja;
        break;
      case "zh":
        des = this.description_zh;
        break;
      case "tr":
        des = this.description_tr;
        break;
      case "pt":
        des = this.description_pt;
        break;
      case "id":
        des = this.description_id;
        break;
      case "th":
        des = this.description_th;
        break;
      case "ms":
        des = this.description_ms;
        break;
      case "ar":
        des = this.description_ar;
        break;
      case "fr":
        des = this.description_fr;
        break;
      case "it":
        des = this.description_it;
        break;
      case "de":
        des = this.description_de;
        break;
      case "ko":
        des = this.description_ko;
        break;
      case "zh_Hant_TW":
        des = this.description_zh_Hant_TW;
        break;
      case "sk":
        des = this.description_sk;
        break;
      case "sl":
        des = this.description_sl;
        break;
      default:
    }
    return des;
  }
}

class UserAchievement {
  int uid;
  int complete;
  int status;
  int recieved;
  int achiId;
  String createdtime;
  String updatedtime;
  int achiLogId;
  Achievement? achiData;
  UserAchievement({
    required this.uid,
    required this.complete,
    required this.status,
    required this.recieved,
    required this.achiId,
    required this.createdtime,
    required this.updatedtime,
    required this.achiLogId,
    required this.achiData,
  });
  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
        uid: json['uid'] != null ? int.parse(json['uid']) : 0,
        complete: json['complete'] != null ? int.parse(json['complete']) : 0,
        status: json['status'] != null ? int.parse(json['status']) : 0,
        recieved: json['recieved'] != null ? int.parse(json['recieved']) : 0,
        achiId: json['achiId'] != null ? int.parse(json['achiId']) : 0,
        createdtime:
            json['createdtime'] != null ? json['createdtime'].toString() : "",
        updatedtime:
            json['updatedtime'] != null ? json['updatedtime'].toString() : "",
        achiLogId: json['achiLogId'] != null ? int.parse(json['achiLogId']) : 0,
        achiData: json['achiData'] != null
            ? Achievement.fromJson(json['achiData'])
            : null);
  }
  Map toJson() => {
        'uid': this.uid,
        'complete': this.complete,
        'status': this.status,
        'recieved': this.recieved,
        'achiId': this.achiId,
        'createdtime': this.createdtime,
        'updatedtime': this.updatedtime,
        'achiLogId': this.achiLogId,
        'achiData': this.achiData,
      };
}
