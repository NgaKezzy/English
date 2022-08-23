import 'dart:convert';
import 'dart:io';

import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/models/talk_percent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/src/provider.dart';
import '../provider/course_chuyenmuc.dart';
import '../provider/course_trinhdo.dart';

class AllListTalkCourse with ChangeNotifier {
  List<ChuyenMucCourse?> _items = [];
  List<TrinhDoCourse?> _itemsTrinhDo = [];
  late TalkPercent _percentSpeak;
  final _baseURL = 'api.phoenglish.com';

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json'
  };

  Future<void> getAllTalkByCategory(BuildContext context, int page) async {
    // Uri uri = Uri.https(
    //   _baseURL,
    //   'FlowerCategory/getListCourse',
    // );
    var uri = 'CategorysSpeaks/getList';
    var localProvider = context.read<LocaleProvider>();
    String lang = (localProvider.codeLangeSub != null)
        ? localProvider.codeLangeSub!
        : localProvider.locale!.languageCode;
    try {
      // final http.Response response = await http.get(uri, headers: headers);
      final http.Response response = await Session()
          .getNoneHeaderWithParams(uri, {'lang': '$lang', 'page': '$page'});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> dataCourse = data['dataCourse'];
        final List<ChuyenMucCourse> loadedCourse = [];
        dataCourse.forEach((courseChuyenMuc) {
          loadedCourse.add(
            ChuyenMucCourse(
              int.parse('${courseChuyenMuc['id']}'),
              courseChuyenMuc['name'],
              courseChuyenMuc['name_vi'],
              courseChuyenMuc['name_zh'],
              courseChuyenMuc['name_ja'],
              courseChuyenMuc['name_hi'],
              courseChuyenMuc['name_es'],
              courseChuyenMuc['name_ru'],
              courseChuyenMuc['name_tr'],
              courseChuyenMuc['name_pt'],
              courseChuyenMuc['name_id'],
              courseChuyenMuc['name_th'],
              courseChuyenMuc['name_ms'],
              courseChuyenMuc['name_ar'],
              courseChuyenMuc['name_fr'],
              courseChuyenMuc['name_it'],
              courseChuyenMuc['name_de'],
              courseChuyenMuc['name_ko'],
              courseChuyenMuc['name_zh_Hant_TW'],
              courseChuyenMuc['name_sk'],
              courseChuyenMuc['name_sl'],
              courseChuyenMuc['description'],
              courseChuyenMuc['description_vi'],
              courseChuyenMuc['description_zh'],
              courseChuyenMuc['description_ja'],
              courseChuyenMuc['description_hi'],
              courseChuyenMuc['description_es'],
              courseChuyenMuc['description_ru'],
              courseChuyenMuc['description_tr'],
              courseChuyenMuc['description_pt'],
              courseChuyenMuc['description_id'],
              courseChuyenMuc['description_th'],
              courseChuyenMuc['description_ms'],
              courseChuyenMuc['description_ar'],
              courseChuyenMuc['description_fr'],
              courseChuyenMuc['description_it'],
              courseChuyenMuc['description_de'],
              courseChuyenMuc['description_ko'],
              courseChuyenMuc['description_zh_Hant_TW'],
              courseChuyenMuc['description_sk'],
              courseChuyenMuc['description_sl'],
              (courseChuyenMuc['parentId'] == null)
                  ? 0
                  : int.parse('${courseChuyenMuc['parentId']}'),
              courseChuyenMuc['slug'],
              courseChuyenMuc['picture'],
              courseChuyenMuc['picLink'],
              int.parse('${courseChuyenMuc['start']}'),
              int.parse('${courseChuyenMuc['totalFollow']}'),
              int.parse('${courseChuyenMuc['totalTalk']}'),
              int.parse('${courseChuyenMuc['type']}'),
              int.parse('${courseChuyenMuc['isActive']}'),
              courseChuyenMuc['listCourse'],
              courseChuyenMuc['picLink300'],
            ),
          );
        });
        _items.addAll(loadedCourse);
        final List<TrinhDoCourse> listCourses = [];
        _items.forEach((item) {
          if (item!.listCourse.length > 0) {
            item.listCourse.forEach((element) {
              if (int.parse('${element["type"]}') == 2) {
                listCourses.add(TrinhDoCourse(
                  int.parse('${element['id']}'),
                  element['name'],
                  element['name_vi'],
                  element['name_zh'],
                  element['name_ja'],
                  element['name_hi'],
                  element['name_es'],
                  element['name_ru'],
                  element['name_tr'],
                  element['name_pt'],
                  element['name_id'],
                  element['name_th'],
                  element['name_ms'],
                  element['name_ar'],
                  element['name_fr'],
                  element['name_it'],
                  element['name_de'],
                  element['name_ko'],
                  element['name_zh_Hant_TW'],
                  element['name_sk'],
                  element['name_sl'],
                  element['description'],
                  element['description_vi'],
                  element['description_zh'],
                  element['description_ja'],
                  element['description_hi'],
                  element['description_es'],
                  element['description_ru'],
                  element['description_tr'],
                  element['description_pt'],
                  element['description_id'],
                  element['description_th'],
                  element['description_ms'],
                  element['description_ar'],
                  element['description_fr'],
                  element['description_it'],
                  element['description_de'],
                  element['description_ko'],
                  element['description_zh_Hant_TW'],
                  element['description_sk'],
                  element['description_sl'],
                  (element['parentId'] == null)
                      ? 0
                      : int.parse('${element['parentId']}'),
                  element['slug'],
                  element['picture'],
                  element['picLink'],
                  int.parse('${element['start']}'),
                  int.parse('${element['totalFollow']}'),
                  int.parse('${element['totalTalk']}'),
                  int.parse('${element['type']}'),
                  int.parse('${element['isActive']}'),
                  element['listTalk'],
                  element['picLink300'],
                ));
              }
            });
          }
        });
        _itemsTrinhDo = listCourses;
        DataCache().setTrinhDoCourse(_itemsTrinhDo);
        DataCache().setChuyenMucCourse(_items);
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<double> getPercentSpeak(int userId, int talkId) async {
    print('$userId voi talk $talkId');
    Map<String, dynamic> params = {
      'uid': "$userId",
      'tid': "$talkId",
    };
    Uri uri = Uri.https(
      _baseURL,
      'FlowerUserTalkLog/getPercent',
    );
    try {
      final http.Response response = await http.post(
        uri,
        body: params,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> talkPercent = data['talkPercent'];
        _percentSpeak = TalkPercent(
          uid: int.parse('${talkPercent['uid']}'),
          tid: int.parse('${talkPercent['tid']}'),
          cid: int.parse('${talkPercent['cid']}'),
          percent: double.parse('${talkPercent['percent']}'),
          firstRead: talkPercent['first_read'],
          id: int.parse('${talkPercent['id']}'),
          createTime: talkPercent['createdtime'],
        );
        return _percentSpeak.percent;
      } else {
        printRed('Lỗi id gì gì đó rồi');
        return 0;
      }
    } catch (e) {
      print('Lỗi phần lấy dữ liệu phần trăm');
      throw e;
    }
  }

  Future<String> updatePercentSpeak(
      int userId, int talkId, double percent) async {
    Map<String, dynamic> params = {
      'uid': " $userId",
      'tid': "$talkId",
      'percent': "$percent",
    };
    Uri uri = Uri.https(
      _baseURL,
      'FlowerUserTalkLog/updatePercent',
    );
    try {
      final http.Response response = await http.post(
        uri,
        body: params,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> talkPercent = data['talkPercent'];
        _percentSpeak = TalkPercent(
          uid: int.parse('${talkPercent['uid']}'),
          tid: int.parse('${talkPercent['tid']}'),
          cid: int.parse('${talkPercent['cid']}'),
          percent: double.parse('${talkPercent['percent']}'),
          firstRead: talkPercent['first_read'],
          id: talkPercent['id'],
          createTime: talkPercent['createdtime'],
        );
        print('Cập nhật thành công');

        return 'Cập nhật thành công';
      }
      print('Cập nhật không thành công');

      return 'Cập nhật dữ liệu không thành công';
    } catch (e) {
      print('Lỗi cập nhật dữ liệu phần trăm');
      throw e;
    }
  }

  void listCourseTalks() {
    final List<TrinhDoCourse> listCourses = [];
    _items.forEach((item) {
      if (item!.listCourse.length > 0) {
        item.listCourse.forEach((element) {
          listCourses.add(TrinhDoCourse(
            int.parse(element['id']),
            element['name'],
            element['name_vi'],
            element['name_zh'],
            element['name_ja'],
            element['name_hi'],
            element['name_es'],
            element['name_ru'],
            element['name_tr'],
            element['name_pt'],
            element['name_id'],
            element['name_th'],
            element['name_ms'],
            element['name_ar'],
            element['name_fr'],
            element['name_it'],
            element['name_de'],
            element['name_ko'],
            element['name_zh_Hant_TW'],
            element['name_sk'],
            element['name_sl'],
            element['description'],
            element['description_vi'],
            element['description_zh'],
            element['description_ja'],
            element['description_hi'],
            element['description_es'],
            element['description_ru'],
            element['description_tr'],
            element['description_pt'],
            element['description_id'],
            element['description_th'],
            element['description_ms'],
            element['description_ar'],
            element['description_fr'],
            element['description_it'],
            element['description_de'],
            element['description_ko'],
            element['description_zh_Hant_TW'],
            element['description_sk'],
            element['description_sl'],
            int.parse(element['parentId']),
            element['slug'],
            element['picture'],
            element['picLink'],
            int.parse(element['start']),
            int.parse(element['totalFollow']),
            int.parse(element['totalTalk']),
            int.parse(element['type']),
            int.parse(element['isActive']),
            element['listTalk'],
            element['picLink300'],
          ));
        });
      }
    });
    _itemsTrinhDo = listCourses;
  }

  List<TrinhDoCourse?> getListFilterLevel(int level) {
    List<TrinhDoCourse?> listFiltered = [];
    switch (level) {
      case 1:
        listFiltered = _itemsTrinhDo.where((element) {
          return element!.start == 1;
        }).toList();
        break;
      case 2:
        listFiltered = _itemsTrinhDo.where((element) {
          return element!.start == 2;
        }).toList();
        break;
      case 3:
        listFiltered = _itemsTrinhDo.where((element) {
          return element!.start == 3;
        }).toList();
        break;
      case 4:
        listFiltered = _itemsTrinhDo.where((element) {
          return element!.start == 4;
        }).toList();
        break;
      default:
        break;
    }
    return listFiltered;
  }

  dynamic getCourse(int id) {
    var filterTrinhDoCourse = _itemsTrinhDo.firstWhere(
      (element) => element!.id == id,
      orElse: () => null,
    );
    return filterTrinhDoCourse;
  }

  List<ChuyenMucCourse?> get items {
    return [..._items];
  }

  get percent => _percentSpeak.id;

  get itemsTrinhDo {
    return [..._itemsTrinhDo];
  }
}
