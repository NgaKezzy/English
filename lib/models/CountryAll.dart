class CountryModel {
  int id;
  String sortname;
  String name;
  int status;

  CountryModel({
    required this.id,
    required this.sortname,
    required this.name,
    required this.status,
  });
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      sortname: json['sortname'].toString().toLowerCase(),
      name: json['name'].toString(),
      id: json['id'],
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'sortname': this.sortname,
        'name': this.name,
        'status': this.status,
      };
}

class CountryData {
  List<CountryModel> listCountry;

  CountryData({
    required this.listCountry,
  });
  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      listCountry: json['datas'].map<CountryModel>((json) {
        return CountryModel.fromJson(json);
      }).toList(),
    );
  }
  Map<String, dynamic> toJson() => {'datas': this.listCountry};
}
