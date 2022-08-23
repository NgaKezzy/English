// ignore_for_file: file_names, non_constant_identifier_names

class CourseItem {
  int? id;
  String? name;
  String? name_vi;
  String? name_zh;
  String? name_ja;
  String? name_hi;
  String? name_es;
  String? name_ru;
  String? name_tr;
  String? name_pt;
  String? name_id;
  String? name_th;
  String? name_ms;
  String? name_ar;
  String? name_fr;
  String? name_it;
  String? name_de;
  String? name_ko;
  String? name_zh_Hant_TW;
  String? name_sk;
  String? name_sl;
  String? description;
  String? description_vi;
  String? description_zh;
  String? description_ja;
  String? description_hi;
  String? description_es;
  String? description_ru;
  String? description_tr;
  String? description_pt;
  String? description_id;
  String? description_th;
  String? description_ms;
  String? description_ar;
  String? description_fr;
  String? description_it;
  String? description_de;
  String? description_ko;
  String? description_zh_Hant_TW;
  String? description_sk;
  String? description_sl;
  int? parentId;
  String? picture;
  int? start;
  int? type;
  int? isActive;

  CourseItem(
      {required this.id,
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
      required this.parentId,
      required this.picture,
      required this.start,
      required this.type,
      required this.isActive});

  factory CourseItem.fromJson(Map<dynamic, dynamic> json) {
    final user = CourseItem(
      id: int.parse('${json['id']}'),
      name: json['name'],
      name_vi: json['name_vi'],
      name_zh: json['name_zh'],
      name_ja: json['name_ja'],
      name_hi: json['name_hi'],
      name_es: json['name_es'],
      name_ru: json['name_ru'],
      name_tr: json['name_tr'],
      name_pt: json['name_pt'],
      name_id: json['name_id'],
      name_th: json['name_th'],
      name_ms: json['name_ms'],
      name_ar: json['name_ar'],
      name_fr: json['name_fr'],
      name_it: json['name_it'],
      name_de: json['name_de'],
      name_ko: json['name_ko'],
      name_zh_Hant_TW: json['name_zh_Hant_TW'],
      name_sk: json['name_sk'],
      name_sl: json['name_sl'],
      description: json['description'],
      description_vi: json['description_vi'],
      description_zh: json['description_zh'],
      description_ja: json['description_ja'],
      description_hi: json['description_hi'],
      description_es: json['description_es'],
      description_ru: json['description_ru'],
      description_tr: json['description_tr'],
      description_pt: json['description_pt'],
      description_id: json['description_id'],
      description_th: json['description_th'],
      description_ms: json['description_ms'],
      description_ar: json['description_ar'],
      description_fr: json['description_fr'],
      description_it: json['description_it'],
      description_de: json['description_de'],
      description_ko: json['description_ko'],
      description_zh_Hant_TW: json['description_zh_Hant_TW'],
      description_sk: json['description_sk'],
      description_sl: json['description_sl'],
      parentId: int.parse('${json['parentId']}'),
      picture: json['picture'],
      start: int.parse('${json['start']}'),
      type: int.parse('${json['type']}'),
      isActive: int.parse('${json['isActive']}'),
    );

    return user;
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_vi': name_vi,
        'name_zh': name_zh,
        'name_ja': name_ja,
        'name_hi': name_hi,
        'name_es': name_es,
        'name_ru': name_ru,
        'name_tr': name_tr,
        'name_pt': name_pt,
        'name_id': name_id,
        'name_th': name_th,
        'name_ms': name_ms,
        'name_ar': name_ar,
        'name_fr': name_fr,
        'name_it': name_it,
        'name_de': name_de,
        'name_ko': name_ko,
        'name_zh_Hant_TW': name_zh_Hant_TW,
        'name_sk': name_sk,
        'name_sl': name_sl,
        'description': description,
        'description_vi': description_vi,
        'description_zh': description_zh,
        'description_ja': description_ja,
        'description_hi': description_hi,
        'description_es': description_es,
        'description_ru': description_ru,
        'description_tr': description_tr,
        'description_pt': description_pt,
        'description_id': description_id,
        'description_th': description_th,
        'description_ms': description_ms,
        'description_ar': description_ar,
        'description_fr': description_fr,
        'description_it': description_it,
        'description_de': description_de,
        'description_ko': description_ko,
        'description_zh_Hant_TW': description_zh_Hant_TW,
        'description_sk': description_sk,
        'description_sl': description_sl,
        'parentId': parentId,
        'picture': picture,
        'start': start,
        'type': type,
        'isActive': isActive,
      };
}
