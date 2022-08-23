class TalkTextDetailModel {
  int id;
  int ttid;
  int stepLevel;
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
  String content_gr;
  String content_br;
  String content_sa;
  String content_el;
  String content_nl;
  String content_kk;
  String content_pl;
  String content_bn;
  String content_ur;
  String content_ro;
  String content_uk;
  String content_uz;
  String content_af;
  String content_az;
  String content_bs;
  String content_bg;
  String content_hr;
  String content_cs;
  String content_da;
  String content_fi;
  String content_ht;
  String content_cre;
  String content_he;
  String content_hu;
  String content_lv;
  String content_no;
  String content_sr;

  String author;
  String createdtime;
  String updatetime;
  int roles;
  bool isMainSentence;

  TalkTextDetailModel({
    required this.id,
    required this.ttid,
    required this.stepLevel,
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
    required this.createdtime,
    required this.updatetime,
    required this.roles,
    required this.isMainSentence,
    required this.content_gr,
    required this.content_br,
    required this.content_sa,
    required this.content_el,
    required this.content_nl,
    required this.content_kk,
    required this.content_pl,
    required this.content_bn,
    required this.content_ur,
    required this.content_ro,
    required this.content_uk,
    required this.content_uz,
    required this.content_af,
    required this.content_az,
    required this.content_bs,
    required this.content_bg,
    required this.content_hr,
    required this.content_cs,
    required this.content_da,
    required this.content_fi,
    required this.content_ht,
    required this.content_cre,
    required this.content_he,
    required this.content_hu,
    required this.content_lv,
    required this.content_no,
    required this.content_sr,
  });
  factory TalkTextDetailModel.fromJson(Map<String, dynamic> json) {
    return TalkTextDetailModel(
      id: int.parse(json['id']),
      ttid: int.parse(json['ttid']),
      stepLevel: int.parse(json['stepLevel']),
      content: json['content'].toString(),
      content_vi: json['content_vi'].toString(),
      content_zh: json['content_zh'].toString(),
      content_ja: json['content_ja'].toString(),
      content_hi: json['content_hi'].toString(),
      content_es: json['content_es'].toString(),
      content_ru: json['content_ru'].toString(),
      content_tr: json['content_tr'].toString(),
      content_pt: json['content_pt'].toString(),
      content_id: json['content_id'].toString(),
      content_th: json['content_th'].toString(),
      content_ms: json['content_ms'].toString(),
      content_ar: json['content_ar'].toString(),
      content_fr: json['content_fr'].toString(),
      content_it: json['content_it'].toString(),
      content_de: json['content_de'].toString(),
      content_ko: json['content_ko'].toString(),
      content_zh_Hant_TW: json['content_zh_Hant_TW'].toString(),
      content_sk: json['content_sk'].toString(),
      content_sl: json['content_sl'].toString(),
      content_gr: json['content_gr'] ?? json['content'],
      content_br: json['content_br'] ?? json['content'],
      content_sa: json['content_sa'] ?? json['content'],
      content_el: json['content_el'] ?? json['content'],
      content_nl: json['content_nl'] ?? json['content'],
      content_kk: json['content_kk'] ?? json['content'],
      content_pl: json['content_pl'] ?? json['content'],
      content_bn: json['content_bn'] ?? json['content'],
      content_ur: json['content_ur'] ?? json['content'],
      content_ro: json['content_ro'] ?? json['content'],
      content_uk: json['content_uk'] ?? json['content'],
      content_uz: json['content_uz'] ?? json['content'],
      content_af: json['content_af'] ?? json['content'],
      content_az: json['content_az'] ?? json['content'],
      content_bs: json['content_bs'] ?? json['content'],
      content_bg: json['content_bg'] ?? json['content'],
      content_hr: json['content_hr'] ?? json['content'],
      content_cs: json['content_cs'] ?? json['content'],
      content_da: json['content_da'] ?? json['content'],
      content_fi: json['content_fi'] ?? json['content'],
      content_ht: json['content_ht'] ?? json['content'],
      content_cre: json['content_cre'] ?? json['content'],
      content_he: json['content_he'] ?? json['content'],
      content_hu: json['content_hu'] ?? json['content'],
      content_lv: json['content_lv'] ?? json['content'],
      content_no: json['content_no'] ?? json['content'],
      content_sr: json['content_sr'] ?? json['content'],
      author: json['author'].toString(),
      createdtime: json['createdtime'].toString(),
      updatetime: json['updatetime'].toString(),
      roles: json['roles'] != null ? int.parse(json['roles']) : 2,
      isMainSentence: json['isMainSentence'] != null
          ? (int.parse(json['isMainSentence']) == 1 ? true : false)
          : false,
    );
  }
  Map toJson() => {
        'id': this.id,
        'tid': this.ttid,
        'stepLevel': this.stepLevel,
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
        'createdtime': this.createdtime,
        'updatetime': this.updatetime,
        'roles': this.roles,
        'isMainSentence': this.isMainSentence
      };
}
