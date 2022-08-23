class VipModel {
  String key;
  String name;
  int price;
  VipModel({
    required this.key,
    required this.name,
    required this.price,
  });
  factory VipModel.fromJson(Map<String, dynamic> json) {
    return VipModel(
      key: json['key'].toString(),
      name: json['title'].toString(),
      price: json['price'],
    );
  }
}

class VipConfigData {
  List<VipModel> data;
  List<String> mainContent;
  List<String> subContent;

  VipConfigData({
    required this.data,
    required this.mainContent,
    required this.subContent,
  });
  factory VipConfigData.fromJson(Map<String, dynamic> json) {
    return VipConfigData(
      data: json['data'].map<VipModel>((json) {
        return VipModel.fromJson(json);
      }).toList(),
      mainContent: json['main_content'].map<String>((json) {
        return json.toString();
      }).toList(),
      subContent: json['sub_content'].map<String>((json) {
        return json.toString();
      }).toList(),
    );
  }
}
