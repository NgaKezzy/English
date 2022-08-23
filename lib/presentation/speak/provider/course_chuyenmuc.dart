class ChuyenMucCourse {
  final int id;
  final String name;
  final String name_vi;
  final String name_zh;
  final String name_ja;
  final String name_hi;
  final String name_es;
  final String name_ru;
  final String name_tr;
  final String name_pt;
  final String name_id;
  final String name_th;
  final String name_ms;
  final String name_ar;
  final String name_fr;
  final String name_it;
  final String name_de;
  final String name_ko;
  final String name_zh_Hant_TW;
  final String name_sk;
  final String name_sl;
  final String description;
  final String description_vi;
  final String description_zh;
  final String description_ja;
  final String description_hi;
  final String description_es;
  final String description_ru;
  final String description_tr;
  final String description_pt;
  final String description_id;
  final String description_th;
  final String description_ms;
  final String description_ar;
  final String description_fr;
  final String description_it;
  final String description_de;
  final String description_ko;
  final String description_zh_Hant_TW;
  final String description_sk;
  final String description_sl;
  final int? parentId;
  final String slug;
  final String picture;
  final String picLink;
  final String picLink300;
  final int start;
  final int totalFollow;
  final int totalTalk;
  final int type;
  final int isActive;
  final List<dynamic> listCourse;

  ChuyenMucCourse(
    this.id,
    this.name,
    this.name_vi,
    this.name_zh,
    this.name_ja,
    this.name_hi,
    this.name_es,
    this.name_ru,
    this.name_tr,
    this.name_pt,
    this.name_id,
    this.name_th,
    this.name_ms,
    this.name_ar,
    this.name_fr,
    this.name_it,
    this.name_de,
    this.name_ko,
    this.name_zh_Hant_TW,
    this.name_sk,
    this.name_sl,
    this.description,
    this.description_vi,
    this.description_zh,
    this.description_ja,
    this.description_hi,
    this.description_es,
    this.description_ru,
    this.description_tr,
    this.description_pt,
    this.description_id,
    this.description_th,
    this.description_ms,
    this.description_ar,
    this.description_fr,
    this.description_it,
    this.description_de,
    this.description_ko,
    this.description_zh_Hant_TW,
    this.description_sk,
    this.description_sl,
    this.parentId,
    this.slug,
    this.picture,
    this.picLink,
    this.start,
    this.totalFollow,
    this.totalTalk,
    this.type,
    this.isActive,
    this.listCourse,
    this.picLink300,
  );

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
