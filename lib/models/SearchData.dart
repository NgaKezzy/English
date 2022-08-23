class DataSearch {
  int id;
  int catId;
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
  String createdtime;
  String updatetime;
  bool isVip;
  bool type;
  int catelog_id;

  DataSearch({
    required this.id,
    required this.catId,
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
    required this.isVip,
    required this.type,
    required this.catelog_id,
  });
  factory DataSearch.fromJson(Map<String, dynamic> json) {
    return DataSearch(
      id: int.parse(json['id']),
      catId: int.parse(json['catId']),
      picture: json['picture'].toString(),
      link_origin: json['link_origin'].toString(),
      totalLike: int.parse(json['totalLike']),
      totalSub: int.parse(json['totalSub']),
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
      isVip: int.parse(json['isVip']) == 1 ? true : false,
      type: int.parse(json['type']) == 1 ? true : false,
      catelog_id:
          json['catelog_id'] != null ? int.parse(json['catelog_id']) : 0,
    );
  }
}
