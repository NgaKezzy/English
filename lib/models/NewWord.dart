class NewWord {
  int wId;
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
  String createdtime;
  String updatetime;
  NewWord({
    required this.wId,
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
    required this.createdtime,
    required this.updatetime,
  });
  factory NewWord.fromJson(Map<String, dynamic> json) {
    return NewWord(
        wId: json['wid'],
        content: json['content'],
        content_vi: json['content_vi'],
        content_zh: json['content_zh'],
        content_ja: json['content_ja'],
        content_hi: json['content_hi'],
        content_es: json['content_es'].toString(),
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
        createdtime: json['createdtime'],
        updatetime: json['updatetime']);
  }
  Map toJson() => {
        'wId': this.wId,
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
        'createdtime': this.createdtime,
        'updatetime': this.updatetime,
      };
}

class DataNewWord {
  List<NewWord> listNewWord;
  DataNewWord({
    required this.listNewWord,
  });

  factory DataNewWord.fromJson(Map<String, dynamic> json) {
    return DataNewWord(
        listNewWord: json['listNewWord'] != null
            ? json['listNewWord'].map<NewWord>((json) {
                return NewWord.fromJson(json);
              }).toList()
            : []);
  }
  Map toJson() => {
        'listNewWord': this.listNewWord,
      };
}
