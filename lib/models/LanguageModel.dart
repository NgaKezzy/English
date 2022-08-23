class LanguageModel {
  String key;
  String name;

  LanguageModel({
    required this.key,
    required this.name,
  });
  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      key: json['key'].toString(),
      name: json['name'].toString(),
    );
  }
  Map<String, dynamic> toJson() => {'key': this.key, 'name': this.name};
}

class LanguageData {
  List<LanguageModel> listLanguage;

  LanguageData({
    required this.listLanguage,
  });
  factory LanguageData.fromJson(Map<String, dynamic> json) {
    return LanguageData(
      listLanguage: json['listLanguage'].map<LanguageModel>((json) {
        return LanguageModel.fromJson(json);
      }).toList(),
    );
  }
  Map<String, dynamic> toJson() => {'listLanguage': this.listLanguage};
}
