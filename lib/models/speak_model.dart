// ignore_for_file: file_names, non_constant_identifier_names

class SpeakItem {
  int? id;
  String? ttid;
  String? stepLevel;
  String? content;
  String? content_vi;
  String? content_zh;
  String? content_ja;
  String? content_hi;
  String? content_es;
  String? content_ru;
  String? content_tr;
  String? content_pt;
  String? content_id;
  String? content_th;
  String? content_ms;
  String? content_ar;
  String? content_fr;
  String? content_it;
  String? content_de;
  String? content_ko;
  String? content_zh_Hant_TW;
  String? content_sk;
  String? content_sl;
  String? author;
  String? createdtime;
  String? updatetime;

  SpeakItem({
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
  });

  factory SpeakItem.fromJson(Map<dynamic, dynamic> json) {
    final user = SpeakItem(
      id: int.parse('${json['id']}'),
      ttid: json['ttid'],
      stepLevel: json['stepLevel'],
      content: json['content'],
      content_vi: json['content_vi'],
      content_zh: json['content_zh'],
      content_ja: json['content_ja'],
      content_hi: json['content_hi'],
      content_es: json['content_es'],
      content_ru: json['content_ru'],
      content_tr: json['content_tr'],
      content_pt: json['content_pt'],
      content_id: json['content_id'],
      content_th: json['content_th'],
      content_ms: json['content_ms'],
      content_ar: json['content_ar'],
      content_fr: json['content_fr'],
      content_it: json['content_it'],
      content_de: json['content_de'],
      content_ko: json['content_ko'],
      content_zh_Hant_TW: json['content_zh_Hant_TW'],
      content_sk: json['content_sk'],
      content_sl: json['content_sl'],
      author: json['author'],
      createdtime: json['createdtime'],
      updatetime: json['updatetime'],
    );

    return user;
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'ttid': ttid,
        'stepLevel': stepLevel,
        'content': content,
        'content_vi': content_vi,
        'content_zh': content_zh,
        'content_ja': content_ja,
        'content_hi': content_hi,
        'content_es': content_es,
        'content_ru': content_ru,
        'content_tr': content_tr,
        'content_pt': content_pt,
        'content_id': content_id,
        'content_th': content_th,
        'content_ms': content_ms,
        'content_ar': content_ar,
        'content_fr': content_fr,
        'content_it': content_it,
        'content_de': content_de,
        'content_ko': content_ko,
        'content_zh_Hant_TW': content_zh_Hant_TW,
        'content_sk': content_sk,
        'content_sl': content_sl,
        'author': author,
        'createdtime': createdtime,
        'updatetime': updatetime,
      };
}
