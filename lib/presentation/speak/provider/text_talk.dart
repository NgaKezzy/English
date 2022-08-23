import 'dart:convert';
import 'dart:io';
import 'package:app_learn_english/networks/Session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TextTalk with ChangeNotifier {
  Future<List<dynamic>> _getAllTalk() async {
    List<dynamic> allTalk = [];
    Uri uri = Uri.https(Session().BASE_URL, 'FlowerTalkText/flowerTalkText');
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    http.Response data = await http.get(uri, headers: headers);
    if (data.statusCode == 200) {
      var body = json.decode(data.body);
      allTalk = body['listFlowerTalkText'];
      return allTalk;
    }
    return allTalk;
  }

  get dataAllTalk {
    return _getAllTalk();
  }
}
