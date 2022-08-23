import 'dart:convert';
import 'dart:io';

import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/TalkTextModel.dart';
import 'package:http/http.dart' as http;
import '../models/notifications.dart';

class getInfomationNotify {
  static List<Notifications> listNotify = [];
  static Future<List<Notifications>> getNotify(
      int id, int page, String lang) async {
    final String url = 'FlowerNotificationUser/getListNotificationLog/$id';
    final String _baseURL = 'api.phoenglish.com';
    var params = {
      'page': page.toString(),
      'lang': lang,
    };

    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    Uri uri = Uri.https(
      _baseURL,
      url,
      params,
    );
    try {
      // final http.Response response = await Session().getDefault(url);
      final http.Response response = await http.get(
        uri,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> dataListNotify = data['listNotification'];
        final List<Notifications> loadedList = [];
        for (int i = 0; i < dataListNotify.length; i++) {
          if (int.parse('${dataListNotify[i]['type']}') == 1) {
            if (dataListNotify[i]['data'] != null) {
              Map<String, dynamic> dataMap = dataListNotify[i]['data'];
              loadedList.add(Notifications(
                listTalk: DataTalk.fromJson(dataMap),
                status: (dataListNotify[i]['status'] == 1) ? true : false,
                nuid: int.parse('${dataListNotify[i]['nuid']}'),
                nid: int.parse('${dataListNotify[i]['nid']}'),
                uid: int.parse('${dataListNotify[i]['uid']}'),
                createdTime: dataListNotify[i]['createdtime'],
                updatedTime: dataListNotify[i]['updatetime'],
                type: int.parse('${dataListNotify[i]['type']}'),
                parentId: int.parse('${dataListNotify[i]['parrentId']}'),
                catId: int.parse('${dataListNotify[i]['catId']}'),
              ));
            }
          } else if (dataListNotify[i]['type'] == "2") {
            if (dataListNotify[i]['data'] != null) {
              Map<String, dynamic> dataMap = dataListNotify[i]['data'];
              loadedList.add(Notifications(
                listTalkText: DataTalkText.fromJson(dataMap),
                status: (dataListNotify[i]['status'] == 1) ? true : false,
                nuid: int.parse(dataListNotify[i]['nuid']),
                nid: int.parse(dataListNotify[i]['nid']),
                uid: int.parse(dataListNotify[i]['uid']),
                createdTime: dataListNotify[i]['createdtime'],
                updatedTime: dataListNotify[i]['updatetime'],
                type: int.parse(dataListNotify[i]['type']),
                parentId: int.parse(dataListNotify[i]['parrentId']),
                catId: int.parse(dataListNotify[i]['catId']),
              ));
            }
          }
        }
        listNotify = loadedList;
      }
      return listNotify;
    } catch (error) {
      printCyan(error.toString());
      printRed('Lỗi phần api thông báo này. Lấy được đếch đâu????');
      throw error;
    }
  }
}
