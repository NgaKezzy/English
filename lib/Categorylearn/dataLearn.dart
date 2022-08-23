import 'package:app_learn_english/networks/Session.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DataLearn {
  final int id;
  final String name;
  final String description;
  final int parentId;
  final String slug;
  final String picteure;
  final int start;
  final int totalFollow;
  final int totalTalk;
  final int type;

  DataLearn({
    required this.id,
    required this.name,
    required this.description,
    required this.parentId,
    required this.slug,
    required this.picteure,
    required this.start,
    required this.totalFollow,
    required this.totalTalk,
    required this.type,
  });
  factory DataLearn.fromJson(Map<String, dynamic> json) {
    return DataLearn(
      id: int.parse(json['id']),
      name: json['name'].toString(),
      description: json['description'].toString(),
      parentId: int.parse(json['parentId']),
      slug: json['slug'].toString(),
      picteure: json['picteure'].toString(),
      start: int.parse(json['start']),
      totalFollow: int.parse(json['totalFollow']),
      totalTalk: int.parse(json['totalTalk']),
      type: int.parse(json['type']),
    );
  }
}

Future<List<DataLearn>> fetchData(http.Client client) async {
  var url_api = 'http://${Session().BASE_URL}/FlowerCategory/flowerCategory';
  // var url_api = 'http://apitest.myfeel.me/FlowerCategory/flowerCategory';
  final response = await client.get(
    Uri.parse(url_api),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (mapResponse['status'] == 1) {
      final datas =
          mapResponse["listFlowerCategory"].cast<Map<String, dynamic>>();
      final listData = await datas.map<DataLearn>((json) {
        return DataLearn.fromJson(json);
      }).toList();
      return listData;
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load album');
  }
}
