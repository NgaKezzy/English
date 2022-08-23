import 'package:app_learn_english/models/quiz/talk_detail_quiz_model.dart';

class TalkDetailModel {
  int id;
  int tid;
  int stepLevel;
  String content;
  String mainSentence;
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
  String content_fl;
  String content_ht;
  String content_cre;
  String content_he;
  String content_hu;
  String content_lv;
  String content_no;
  String content_sr;
  String author;
  int startTime;
  int endTime;
  String createdtime;
  String updatetime;
  bool isMainSentence;

  TalkDetailModel({
    required this.id,
    required this.tid,
    required this.stepLevel,
    required this.content,
    required this.mainSentence,
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
    required this.content_fl,
    required this.content_ht,
    required this.content_cre,
    required this.content_he,
    required this.content_hu,
    required this.content_lv,
    required this.content_no,
    required this.content_sr,
    required this.author,
    required this.startTime,
    required this.endTime,
    required this.createdtime,
    required this.updatetime,
    required this.isMainSentence,
  });

  factory TalkDetailModel.fromJson(Map<String, dynamic> json) {
    return TalkDetailModel(
      id: int.parse('${json['id']}'),
      tid: int.parse('${json['tid']}'),
      stepLevel:
          json['stepLevel'] == null ? 0 : int.parse('${json['stepLevel']}'),
      content: json['content'] ?? '',
      mainSentence: json['mainSentence'] ?? '',
      content_vi: json['content_vi'] ?? '',
      content_zh: json['content_zh'] ?? '',
      content_ja: json['content_ja'] ?? '',
      content_hi: json['content_hi'] ?? '',
      content_es: json['content_es'] ?? '',
      content_ru: json['content_ru'] ?? '',
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
      content_el: json['content_el'] ?? '',
      content_nl: json['content_nl'] ?? '',
      content_kk: json['content_kk'] ?? '',
      content_pl: json['content_pl'] ?? '',
      content_bn: json['content_bn'] ?? '',
      content_ur: json['content_ur'] ?? '',
      content_ro: json['content_ro'] ?? '',
      content_uk: json['content_uk'] ?? '',
      content_uz: json['content_uz'] ?? '',
      content_af: json['content_af'] ?? '',
      content_az: json['content_az'] ?? '',
      content_bs: json['content_bs'] ?? '',
      content_bg: json['content_bg'] ?? '',
      content_hr: json['content_hr'] ?? '',
      content_cs: json['content_cs'] ?? '',
      content_da: json['content_da'] ?? '',
      content_fl: json['content_fl'] ?? '',
      content_ht: json['content_ht'] ?? '',
      content_cre: json['content_cre'] ?? '',
      content_he: json['content_he'] ?? '',
      content_hu: json['content_hu'] ?? '',
      content_lv: json['content_lv'] ?? '',
      content_no: json['content_no'] ?? '',
      content_sr: json['content_sr'] ?? '',
      author: json['author'].toString(),
      startTime: int.parse('${json['starttime']}'),
      endTime: int.parse('${json['endtime']}'),
      createdtime: json['createdtime'].toString(),
      updatetime: json['updatetime'].toString(),
      isMainSentence: json['isMainSentence'] != null
          ? (int.parse(json['isMainSentence']) == 1 ? true : false)
          : false,
    );
  }

  Map toJson() => {
        'id': this.id,
        'tid': this.tid,
        'stepLevel': this.stepLevel,
        'content': this.content,
        'mainSentence': this.mainSentence,
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
        'content_el': this.content_el,
        'content_nl': this.content_nl,
        'content_kk': this.content_kk,
        'content_pl': this.content_pl,
        'content_bn': this.content_bn,
        'content_ur': this.content_ur,
        'content_ro': this.content_ro,
        'content_uk': this.content_uk,
        'content_uz': this.content_uz,
        'content_af': this.content_af,
        'content_az': this.content_az,
        'content_bs': this.content_bs,
        'content_bg': this.content_bg,
        'content_hr': this.content_hr,
        'content_cs': this.content_cs,
        'content_da': this.content_da,
        'content_fl': this.content_fl,
        'content_ht': this.content_ht,
        'content_cre': this.content_cre,
        'content_he': this.content_he,
        'content_hu': this.content_hu,
        'content_lv': this.content_lv,
        'content_no': this.content_no,
        'content_sr': this.content_sr,
        'author': this.author,
        'starttime': this.startTime,
        'endtime': this.endTime,
        'createdtime': this.createdtime,
        'updatetime': this.updatetime,
        'isMainSentence': this.isMainSentence,
      };

  TalkDetailQuizModel convertToTalkDetailQuiz() {
    TalkDetailQuizModel res = new TalkDetailQuizModel(
      id: this.id,
      contentVi: this.content_vi,
      contentZh: this.content_zh,
      contentJa: this.content_ja,
      contentHi: this.content_hi,
      contentEs: this.content_es,
      contentRu: this.content_ru,
      contentTr: this.content_tr,
      contentPt: this.content_pt,
      contentId: this.content_id,
      contentTh: this.content_th,
      contentMs: this.content_ms,
      contentAr: this.content_ar,
      contentFr: this.content_fr,
      contentIt: this.content_it,
      contentDe: this.content_de,
      contentKo: this.content_ko,
      contentZh_Hant_TW: this.content_zh_Hant_TW,
      contentSk: this.content_sk,
      contentSl: this.content_sl,
      content: this.content,
      starttime: this.startTime,
      endtime: this.endTime,
      mainSentence: this.mainSentence,
      author: this.author,
      createdtime: this.createdtime,
      updatetime: this.updatetime,
    );
    return res;
  }
}
