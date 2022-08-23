import 'dart:convert';
import 'dart:io';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'package:async/async.dart';

class Session {
  static final Session _singleton = Session._internal();
  factory Session() {
    return _singleton;
  }
  Session._internal();

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  String BASE_URL = "api.phoenglish.com";
  String BASE_IMAGES = "https://img.phoenglish.com/";

// get và post có lưu lại Session
  Future<http.Response> get(String url) async {
    http.Response response = await http.get(Uri.https(BASE_URL, url));
    updateCookie(response);
    return response;
  }

  Future<http.Response> post(String url, dynamic data) async {
    http.Response response = await http.post(
      Uri.https(BASE_URL, url),
      body: data,
      headers: headers,
    );
    updateCookie(response);
    return response;
  }

  // getDefault và postDefault không lưu Sesion

  Future<http.Response> getDefault(String url,
      {Map<String, dynamic>? params}) async {
    http.Response response =
        await http.get(Uri.https(BASE_URL, url, params), headers: headers);
    return response;
  }

  Future<http.Response> deleteList(String url) async {
    final http.Response response =
        await http.delete(Uri.https(BASE_URL, url), headers: headers);
    return response;
  }

  Future<http.Response> getNoneHeaderWithParams(
      String url, Map<String, dynamic> params) async {
    var uri = Uri.https(BASE_URL, url, params);
    print("Uri:$uri");
    http.Response response = await http.get(uri);
    return response;
  }

  Future<http.Response> postDefault(String url, dynamic data,
      {bool header = true}) async {
    http.Response response = await http.post(
      Uri.https(BASE_URL, url),
      body: data,
      headers: header
          ? <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            }
          : null,
    );
    return response;
  }

  Future<http.StreamedResponse> postMedia(String url, File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.https('img.phoenglish.com', url);
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('picture', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    request.fields['uid'] = DataCache().getUserData().uid.toString();
    var response = await request.send();
    return response;
  }

  // Cập nhật lại cookie
  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'].toString();
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
