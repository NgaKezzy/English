import 'package:app_learn_english/models/TalkModel.dart';

class VideoReview {
  int vrid;
  int uid;
  int tid;
  int status;
  int id;
  int catId;
  int catId_2;
  int catId_3;
  int catId_4;
  int catId_5;
  String createdtime;
  String updatetime;
  String hourNoti;
  int totalReview;
  String picture;
  String link_origin;
  int totalLike;
  int totalSub;
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
  String author;
  bool isVip;
  bool type;
  int catelog_id;
  String yt_id;
  String description;
  bool? isSubmit;
  String picLink;

  VideoReview({
    required this.vrid,
    required this.uid,
    required this.tid,
    required this.status,
    required this.totalReview,
    required this.id,
    required this.catId,
    required this.catId_2,
    required this.catId_3,
    required this.catId_4,
    required this.catId_5,
    required this.picture,
    required this.link_origin,
    required this.totalLike,
    required this.totalSub,
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
    required this.author,
    required this.createdtime,
    required this.updatetime,
    required this.hourNoti,
    required this.isVip,
    required this.type,
    required this.catelog_id,
    required this.yt_id,
    required this.description,
    required this.isSubmit,
    required this.picLink,
  });
  factory VideoReview.fromJson(Map<String, dynamic> json) {
    return VideoReview(
      vrid: int.parse(json['vrid']),
      uid: int.parse(json['uid']),
      tid: int.parse(json['tid']),
      status: json['status'] != null ? int.parse(json['status']) : 0,
      totalReview: int.parse(json['totalReview']),
      id: json['id'] != null ? int.parse(json['id']) : 0,
      catId: json['catId'] != null ? int.parse(json['catId']) : 0,
      catId_2: json['catId_2'] != null ? int.parse(json['catId_2']) : 0,
      catId_3: json['catId_3'] != null ? int.parse(json['catId_3']) : 0,
      catId_4: json['catId_4'] != null ? int.parse(json['catId_4']) : 0,
      catId_5: json['catId_5'] != null ? int.parse(json['catId_5']) : 0,
      picture: json['picture'].toString(),
      link_origin: json['link_origin'].toString(),
      totalLike: json['totalLike'] != null ? int.parse(json['totalLike']) : 0,
      totalSub: json['totalSub'] != null ? int.parse(json['totalSub']) : 0,
      picLink: json['picLink'] != null ? json['picLink'].toString() : "",
      name: json['name'].toString(),
      name_vi: json['name_vi'].toString(),
      name_zh: json['name_zh'].toString(),
      name_ja: json['name_ja'].toString(),
      name_hi: json['name_hi'].toString(),
      name_es: json['name_es'].toString(),
      name_ru: json['name_ru'].toString(),
      name_tr: json['name_tr'].toString(),
      name_pt: json['name_pt'].toString(),
      name_id: json['name_id'].toString(),
      name_th: json['name_th'].toString(),
      name_ms: json['name_ms'].toString(),
      name_ar: json['name_ar'].toString(),
      name_fr: json['name_fr'].toString(),
      name_it: json['name_it'].toString(),
      name_de: json['name_de'].toString(),
      name_ko: json['name_ko'].toString(),
      name_zh_Hant_TW: json['name_zh_Hant_TW'].toString(),
      name_sk: json['name_sk'].toString(),
      name_sl: json['name_sl'].toString(),
      author: json['author'],
      createdtime: json['createdtime'].toString(),
      updatetime: json['updatetime'].toString(),
      hourNoti: json['hourNoti'].toString(),
      isVip: json['isVip'] != null
          ? (int.parse(json['isVip']) == 1 ? true : false)
          : false,
      type: json['type'] != null
          ? (int.parse(json['type']) == 1 ? true : false)
          : false,
      yt_id: json['yt_id'].toString(),
      catelog_id:
          json['catelog_id'] != null ? int.parse(json['catelog_id']) : 0,
      description:
          json['description'] != null ? json['description'].toString() : "",
      isSubmit: json['isSubmit'] ?? null,
    );
  }

  DataTalk convertToTalkData() {
    DataTalk res = new DataTalk(
      id: this.tid,
      catId: this.catId,
      catId_2: this.catId_2,
      catId_3: this.catId_3,
      catId_4: this.catId_4,
      catId_5: this.catId_5,
      picture: this.picture,
      link_origin: this.link_origin,
      totalLike: this.totalLike,
      totalSub: this.totalSub,
      name: this.name,
      name_vi: this.name_vi,
      name_zh: this.name_zh,
      name_ja: this.name_ja,
      name_hi: this.name_hi,
      name_es: this.name_es,
      name_ru: this.name_ru,
      name_tr: this.name_tr,
      name_pt: this.name_pt,
      name_id: this.name_id,
      name_th: this.name_th,
      name_ms: this.name_ms,
      name_ar: this.name_ar,
      name_fr: this.name_fr,
      name_it: this.name_it,
      name_de: this.name_de,
      name_ko: this.name_ko,
      name_zh_Hant_TW: this.name_zh_Hant_TW,
      name_sk: this.name_sk,
      name_sl: this.name_sl,
      author: this.author,
      createdtime: this.createdtime,
      updatetime: this.updatetime,
      isVip: this.isVip,
      type: this.type,
      catelog_id: this.catelog_id,
      yt_id: this.yt_id,
      description: this.description,
      isSubmit: this.isSubmit,
      picLink: this.picLink,
      hourNoti: this.hourNoti,
      name_lv: '',
      name_bs: '',
      name_bg: '',
      name_ht: '',
      name_kk: '',
      name_az: '',
      name_da: '',
      name_ur: '',
      name_cs: '',
      name_hu: '',
      name_nl: '',
      name_el: '',
      name_fl: '',
      name_uz: '',
      name_pl: '',
      name_hr: '',
      name_sr: '',
      name_no: '',
      name_ro: '',
      name_cre: '',
      name_he: '',
      name_af: '',
      name_bn: '',
      name_uk: '',
    );
    return res;
  }
}
