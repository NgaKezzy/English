import 'dart:io';
import 'package:http/http.dart' as http;
import '../utilities/keys.dart';

class CallAPI {
  final String _baseURL = 'www.googleapis.com';

  Future<String> featchVideo(String videoId) async {
    Map<String, String> params = {
      'id': videoId,
      'key': YOUTUBE_API_KEY,
      'part': 'snippet'
    };

    Uri uri = Uri.https(_baseURL, 'youtube/v3/videos', params);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = response.body;
      return data;
    }
    return 'Wrong';
  }
}
