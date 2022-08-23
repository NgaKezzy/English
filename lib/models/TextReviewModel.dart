import 'package:scoped_model/scoped_model.dart';

class TextReview extends Model {
  int ttrid;
  int uid;
  int ttdid;
  int status;
  int totalReview;
  int id;
  int ttid;
  int stepLevel;
  int type;
  int roles;
  int isMainSentence;
  String createdtime;
  String updatetime;
  String content;
  String content_vi;
  String content_zh;
  String content_ja;
  String content_hi;
  String content_es;
  String content_ru;
  String content_tr;
  String content_pt;
  String content_id;
  String content_th;
  String content_ms;
  String content_ar;
  String content_fr;
  String content_it;
  String content_de;
  String content_ko;
  String content_zh_Hant_TW;
  String content_sk;
  String content_sl;
  String author;

  TextReview({
    required this.ttrid,
    required this.uid,
    required this.ttdid,
    required this.status,
    required this.totalReview,
    required this.id,
    required this.ttid,
    required this.type,
    required this.stepLevel,
    required this.createdtime,
    required this.updatetime,
    required this.content,
    required this.content_vi,
    required this.content_zh,
    required this.content_ja,
    required this.content_hi,
    required this.content_es,
    required this.content_ru,
    required this.content_tr,
    required this.content_pt,
    required this.content_id,
    required this.content_th,
    required this.content_ms,
    required this.content_ar,
    required this.content_fr,
    required this.content_it,
    required this.content_de,
    required this.content_ko,
    required this.content_zh_Hant_TW,
    required this.content_sk,
    required this.content_sl,
    required this.author,
    required this.roles,
    required this.isMainSentence,
  });
  factory TextReview.fromJson(Map<String, dynamic> json) {
    return TextReview(
      ttrid: int.parse(json['ttrid']),
      uid: int.parse(json['uid']),
      ttdid: int.parse(json['ttdid']),
      status: int.parse(json['status']),
      totalReview: int.parse(json['totalReview']),
      id: int.parse(json['id']),
      ttid: json['ttid'] != null ? int.parse(json['ttid']) : 0,
      type: int.parse(json['type']),
      stepLevel: int.parse(json['stepLevel']),
      roles: json['roles'] != null ? int.parse(json['roles']) : 0,
      isMainSentence: json['isMainSentence'] != null
          ? int.parse(json['isMainSentence'])
          : 0,
      createdtime: json['createdtime'].toString(),
      updatetime: json['updatetime'].toString(),
      content: json['content'].toString(),
      content_vi: json['content_vi'].toString(),
      content_zh: json['content_zh'].toString(),
      content_ja: json['content_ja'].toString(),
      content_hi: json['content_hi'].toString(),
      content_es: json['content_es'].toString(),
      content_ru: json['content_ru'].toString(),
      content_tr: json['content_tr'] ?? '',
      content_pt: json['content_pt'] ?? '',
      content_id: json['content_id'] ?? '',
      content_th: json['content_th'] ?? '',
      content_ms: json['content_ms'] ?? '',
      content_ar: json['content_ar'] ?? '',
      content_fr: json['content_fr'] ?? '',
      content_it: json['content_it'] ?? '',
      content_de: json['content_de'] ?? '',
      content_ko: json['content_ko'] ?? '',
      content_zh_Hant_TW: json['content_zh_Hant_TW'] ?? '',
      content_sk: json['content_sk'] ?? '',
      content_sl: json['content_sl'] ?? '',
      author: json['author'].toString(),
    );
  }
  Map toJson() => {
        'ttrid': this.ttrid,
        'uid': this.uid,
        'ttdid': this.ttdid,
        'status': this.status,
        'totalReview': this.totalReview,
        'id': this.id,
        'ttid': this.ttid,
        'type': this.type,
        'stepLevel': this.stepLevel,
        'createdtime': this.createdtime,
        'updatetime': this.updatetime,
        'content': this.content,
        'content_vi': this.content_vi,
        'content_zh': this.content_zh,
        'content_ja': this.content_ja,
        'content_hi': this.content_hi,
        'content_es': this.content_es,
        'content_ru': this.content_ru,
        'content_tr': this.content_tr,
        'content_pt': this.content_pt,
        'content_id': this.content_id,
        'content_th': this.content_th,
        'content_ms': this.content_ms,
        'content_ar': this.content_ar,
        'content_fr': this.content_fr,
        'content_it': this.content_it,
        'content_de': this.content_de,
        'content_ko': this.content_ko,
        'content_zh_Hant_TW': this.content_zh_Hant_TW,
        'content_sk': this.content_sk,
        'content_sl': this.content_sl,
        'author': this.author,
        'roles': this.roles,
        'isMainSentence': this.isMainSentence,
      };

  String getContentByLanguage(String code) {
    String des = this.content;
    switch (code) {
      case "en":
        des = this.content;
        break;
      case "vi":
        des = this.content_vi;
        break;
      case "hi":
        des = this.content_hi;
        break;
      case "es":
        des = this.content_es;
        break;
      case "ru":
        des = this.content_ru;
        break;
      case "ja":
        des = this.content_ja;
        break;
      case "zh":
        des = this.content_zh;
        break;
      case "tr":
        des = this.content_tr;
        break;
      case "pt":
        des = this.content_pt;
        break;
      case "id":
        des = this.content_id;
        break;
      case "th":
        des = this.content_th;
        break;
      case "ms":
        des = this.content_ms;
        break;
      case "ar":
        des = this.content_ar;
        break;
      case "fr":
        des = this.content_fr;
        break;
      case "it":
        des = this.content_it;
        break;
      case "de":
        des = this.content_de;
        break;
      case "ko":
        des = this.content_ko;
        break;
      case "zh_Hant_TW":
        des = this.content_zh_Hant_TW;
        break;
      case "sk":
        des = this.content_sk;
        break;
      case "sl":
        des = this.content_sl;
        break;
      default:
    }
    return des;
  }
}
