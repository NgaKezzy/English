import 'package:app_learn_english/models/video_history/talk_video_history_model.dart';

import '../TalkModel.dart';

class History {
  int id;
  int uid;
  int vid;
  String createdtime;
  TalkVideoHistory Talk;

  History({
    required this.id,
    required this.uid,
    required this.vid,
    required this.createdtime,
    required this.Talk,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'].runtimeType == int ? json['id'] : int.parse(json['id']),
      uid: json['uid'] != null
          ? (json['uid'].runtimeType == int
              ? json['uid']
              : int.parse(json['uid']))
          : 0,
      vid: json['vid'] != null
          ? (json['vid'].runtimeType == int
              ? json['vid']
              : int.parse(json['vid']))
          : 0,
      createdtime: json['createdtime'].toString(),
      Talk: TalkVideoHistory.fromJson(json['Talk']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'uid': this.uid,
        'vid': this.vid,
        'createdtime': this.createdtime,
        'Talk': this.Talk,
      };

  DataTalk convertToTalkData() {
    DataTalk res = new DataTalk(
      id: this.vid,
      catId: this.Talk.catId,
      catId_2: this.Talk.catId2,
      catId_3: this.Talk.catId3,
      catId_4: this.Talk.catId4,
      catId_5: this.Talk.catId5,
      picture: this.Talk.picture,
      link_origin: this.Talk.linkOrigin,
      totalLike: this.Talk.totalLike,
      totalSub: this.Talk.totalSub,
      name: this.Talk.name,
      name_vi: this.Talk.nameVi,
      name_zh: this.Talk.nameZh,
      name_ja: this.Talk.nameJa,
      name_hi: this.Talk.nameHi,
      name_es: this.Talk.nameEs,
      name_ru: this.Talk.nameRu,
      name_tr: this.Talk.nameTr,
      name_pt: this.Talk.namePt,
      name_id: this.Talk.nameId,
      name_th: this.Talk.nameTh,
      name_ms: this.Talk.nameMs,
      name_ar: this.Talk.nameAr,
      name_fr: this.Talk.nameFr,
      name_it: this.Talk.nameIt,
      name_de: this.Talk.nameDe,
      name_ko: this.Talk.nameKo,
      name_zh_Hant_TW: this.Talk.nameZhHantTw,
      name_sk: this.Talk.nameSk,
      name_sl: this.Talk.nameSl,
      author: this.Talk.author,
      createdtime: this.Talk.createdtime,
      updatetime: this.Talk.updatetime,
      isVip: this.Talk.isVip,
      type: this.Talk.type,
      catelog_id: this.Talk.catelogId,
      yt_id: this.vid.toString(),
      description: "",
      isSubmit: true,
      picLink: "",
      hourNoti: "",
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
