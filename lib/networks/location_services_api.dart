import 'dart:convert';

import 'package:app_learn_english/utils/utils.dart';
import 'package:http/http.dart' as http;

class LocationServicesApi {
  static final LocationServicesApi _singleton = LocationServicesApi._internal();
  factory LocationServicesApi() {
    return _singleton;
  }
  LocationServicesApi._internal();
  Future<String> getLanguageByIP() async {
    final Uri uri = Uri.http(
      'ip-api.com',
      'json',
    );
    String languageCode = 'en';
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          String countryCode = data['countryCode'];
          languageCode = Utils.titleLanguage(countryCode);
        }
        return languageCode;
      } else {
        print('Not found');
        return languageCode;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
