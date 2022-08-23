import 'dart:convert';
import 'dart:io';

import 'package:app_learn_english/networks/DataCache.dart';
import 'package:http/http.dart' as http;

class ApiVip {
  final _baseURL = 'api.phoenglish.com';
  final id = DataCache().userCache!.uid;
  Future<int> getTrialVip() async {
    Uri uri = Uri.https(
      _baseURL,
      'FlowerUser/tryalVip',
    );
    print(uri);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    String body = jsonEncode(<String, String>{'uid': '$id'});

    try {
      http.Response response = await http.post(
        uri,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (int.parse('${data['status']}') == 1) {
          return int.parse('${data['isVip']}');
        }
        return 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Hình như lỗi phần get dùng thử vip');
      throw e;
    }
  }

  Future<int> getcancelTryalVip() async {
    Uri uri = Uri.https(
      _baseURL,
      'FlowerUser/cancelTryalVip',
    );
    print(uri);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    String body = jsonEncode(<String, String>{'uid': '$id'});

    try {
      http.Response response = await http.post(
        uri,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (int.parse('${data['status']}') == 1) {
          return int.parse('${data['isVip']}');
        }
        return 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Lỗi phần huỷ dùng thử vip');
      throw e;
    }
  }

  Future<int> getactiveVip() async {
    Uri uri = Uri.https(
      _baseURL,
      'FlowerUser/activeVip',
    );
    print(uri);

    Map<String, String> body = {'uid': '$id'};

    try {
      http.Response response = await http.post(
        uri,
        body: body,
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (int.parse('${data['status']}') == 1) {
          return int.parse('${data['isVip']}');
        }
        return 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Có lỗi ở phần kích hoạt vip rồi');
      throw e;
    }
  }
}
