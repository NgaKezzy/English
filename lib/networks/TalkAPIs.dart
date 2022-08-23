import 'dart:convert';
import 'dart:developer';

import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/CateFollowModel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/CountryAll.dart';
import 'package:app_learn_english/models/DataCourseModel.dart';
import 'package:app_learn_english/models/DataSearchIndexModel.dart';
import 'package:app_learn_english/models/HomeData.dart';
import 'package:app_learn_english/models/LanguageModel.dart';
import 'package:app_learn_english/models/NewWord.dart';
import 'package:app_learn_english/models/ReviewTextData.dart';
import 'package:app_learn_english/models/ReviewVideoData.dart';
import 'package:app_learn_english/models/SubChannelData.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkFollowLogModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/TalkTextDetailModel.dart';
import 'package:app_learn_english/models/TalkTextModel.dart';
import 'package:app_learn_english/models/TextReviewModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/VideoReviewModel.dart';
import 'package:app_learn_english/models/VipModel.dart';
import 'package:app_learn_english/models/cake_model.dart';
import 'package:app_learn_english/models/category_item.dart';
import 'package:app_learn_english/models/course_model.dart';
import 'package:app_learn_english/models/data_video_youtube.dart';
import 'package:app_learn_english/models/history_speak_model.dart';
import 'package:app_learn_english/models/learn_online/learn_offline.dart';
import 'package:app_learn_english/models/listen_item.dart';
import 'package:app_learn_english/models/question_item.dart';
import 'package:app_learn_english/models/quiz/quiz_model.dart';
import 'package:app_learn_english/models/record_model.dart';
import 'package:app_learn_english/models/speak_home_model.dart';
import 'package:app_learn_english/models/theme_item.dart';
import 'package:app_learn_english/models/total_notifi.dart';
import 'package:app_learn_english/models/video_history/video_history_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/src/provider.dart';

String search = 'https://youtube.googleapis.com';

class TalkAPIs {
  static final TalkAPIs _singleton = TalkAPIs._internal();
  DateTime now = DateTime.now();

  factory TalkAPIs() {
    return _singleton;
  }

  TalkAPIs._internal();

  Future<DataHome> fetchDataHome({uid: int}) async {
    printCyan("Lay tu API : fetchDataHome");
    var dataHome;
    var url = '/FlowerCategory/getDataHome/' + uid.toString();
    printRed(url);
    try {
      final response = await Session().getDefault(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        if (mapResponse['status'] == 1) {
          dataHome = DataHome.fromJson(mapResponse);
          DataCache().setDataHome(dataHome);
        } else {
          printYellow('Loi roi con cho');
        }
      }
    } catch (error) {
      print(error);
      throw error;
    }
    return dataHome;
  }

  Future<DataHome> fetchDataHome2(
      {uid: int, langugeCode: String, token: String}) async {
    printCyan("Lay tu API : fetchDataHome");
    var dataHome;
    var url = 'Home/getDataHome/${uid}';
    printRed(url);
    try {
      final response = await Session().getNoneHeaderWithParams(
          url, {'lang': '$langugeCode', 'token': '$token'});
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        if (mapResponse['status'] == 1) {
          dataHome = DataHome.fromJson(mapResponse);
          DataCache().setDataHome(dataHome);
        } else {
          printYellow('Loi roi con cho');
        }
      }
    } catch (error) {
      print(error);
      throw error;
    }
    return dataHome;
  }

  Future<bool> fetchMoreDataHomeNewVideo(
      {uid: int, langugeCode: String, page: int}) async {
    printCyan("Lay tu API : fetchDataHome");

    var url = '/Home/getNewTalk';
    printRed(url);
    List<DataTalk> moreData = [];
    try {
      final response = await Session().getNoneHeaderWithParams(url, {
        'lang': '$langugeCode',
        'page': '$page',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        if (mapResponse['status'] == 1) {
          for (var i = 0; i < mapResponse['dataNew'].length; i++) {
            moreData.add(DataTalk.fromJson(mapResponse['dataNew'][i]));
          }
          DataCache().modifierDataHomeWithNewVideo(moreData);
          return true;
        } else {
          printYellow('Loi roi con cho');
          return false;
        }
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> fetchDataVideoHistory(
      {uid: int, langugeCode: String, page: int}) async {
    var url = 'UsersLogVideo/getHistory';
    try {
      final response = await Session().getNoneHeaderWithParams(url, {
        'uid': '$uid',
        'page': '$page',
        'lang': '$langugeCode',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        VideoHistory videoHistoryModel = VideoHistory.fromJson(mapResponse);
        DataCache().setListVideoHistory(videoHistoryModel.listHistory);
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<int> deleteVideoHistory(String uid, String id, String vid) async {
    int status = 0;
    var url = '/UsersLogVideo/delete';
    var formData = jsonEncode(<String, dynamic>{
      'uid': int.parse(uid),
      'vid': int.parse(vid),
      'id': int.parse(id),
    });
    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      print(mapResponse);
      status = mapResponse['status'];
    }
    return status;
  }

  Future<bool> fetchMoreDataHomeCategory(
      {uid: int, langugeCode: String, page: int}) async {
    printCyan("Lay tu API : fetchDataHome");

    var url = '/Home/getDataHomeByCategory';
    printRed(url);
    List<Category> moreData = [];
    try {
      final response = await Session().getNoneHeaderWithParams(url, {
        'lang': '$langugeCode',
        'page': '$page',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        if (mapResponse['status'] == 1) {
          for (var i = 0; i < mapResponse['listCategory'].length; i++) {
            moreData.add(Category.fromJson(mapResponse['listCategory'][i]));
          }
          DataCache().modifierDataHomeWithCategory(moreData);
          return true;
        } else {
          printYellow('Loi roi con cho');
          return false;
        }
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> fetchMoreDataHomeSuggest(
      {uid: int, langugeCode: String, page: int}) async {
    printCyan("Lay tu API : fetchDataHome");

    var url = 'home/getListTalkSugges/${uid}';
    printRed(url);
    List<DataTalk> moreData = [];
    try {
      final response = await Session().getNoneHeaderWithParams(url, {
        'lang': '$langugeCode',
        'page': '$page',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        if (mapResponse['status'] == 1) {
          for (var i = 0; i < mapResponse['dataSugges'].length; i++) {
            moreData.add(DataTalk.fromJson(mapResponse['dataSugges'][i]));
          }
          DataCache().modifierDataHomeWithSuggest(moreData);
          return true;
        } else {
          printYellow('Loi roi con cho');
          return false;
        }
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> fetchDataSpeakHone({langugeCode: String}) async {
    var url = 'home/getSpeaks';
    try {
      printRed("LanguageCode:$langugeCode");
      final response = await Session().getNoneHeaderWithParams(url, {
        'lang': '$langugeCode',
        'page': '1',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        SpeakHomeModel speakModel = SpeakHomeModel.fromJson(mapResponse);

        DataCache().setListSpeakHome(speakModel.lists!);
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<SubChannelData> getDataSubChannel() async {
    var dataChannel;
    dataChannel = await DataCache().getChannelHasData();
    return dataChannel;
  }

  Future<SubChannelData> fetchDataSubChannel(
      {userData: DataUser, String lang = 'en', int page = 1}) async {
    printCyan("Lay tu API: fetchDataSubChannel");

    var dataChannel;
    var url =
        'FlowerCategory/getChannelDataFollowByUser/' + userData.uid.toString();
    var params = {'lang': lang, 'page': page.toString()};
    final response = await Session().getDefault(url, params: params);

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse['status'] == 1) {
        SubChannelData dataChannel = SubChannelData.fromJson(mapResponse);
        DataCache().setChannelHasData(dataChannel);
        return dataChannel;
      } else {
        printYellow('Loi roi con cho');
      }
    } else {
      throw Exception('Failed to load album');
    }
    print(dataChannel);
    return dataChannel;
  }

  Future<List<Category>> getListCategory() async {
    var listCategory;
    var url = 'FlowerCategory/flowerCategory';
    final response = await Session().getDefault(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      if (mapResponse['status'] == 1) {
        listCategory = mapResponse['listFlowerCategory'] != null
            ? mapResponse['listFlowerCategory'].map<Category>((json) {
                return Category.fromJson(json);
              }).toList()
            : [];
        DataCache().setListCategory(listCategory);
      } else {
        printYellow('Loi roi con cho');
      }
    } else {
      throw Exception('Failed to load album');
    }
    return listCategory;
  }

  Future<QuizModel> getListQuiz(String lang) async {
    var quizModel;
    var url = 'Quiz/getQuizToday';
    final response =
        await Session().getNoneHeaderWithParams(url, {'lang': '$lang'});
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      QuizModel quizModel = QuizModel.fromJson(mapResponse);
      DataCache().setListQuiz(quizModel.talkDetailQuiz);
      return quizModel;
    }
    return quizModel;
  }

  Future<Map<String, dynamic>> fetchDataSearch(
      {inputSearch: String,
      required String languageCode,
      bool isRoom = false}) async {
    var dataSearch;
    Uri uri = Uri.https(
      Session().BASE_URL,
      'FlowerUser/search',
    );

    // var formData = jsonEncode(<String, dynamic>{"input": inputSearch});
    Map<String, dynamic> formData = {
      'input': inputSearch,
      'lang': languageCode,
      if (isRoom) 'screen': 'online',
    };
    final response = await http.post(uri, body: formData);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());

      dataSearch = mapResponse;
    } else {
      throw Exception('Failed to load album');
    }
    return dataSearch;
  }

  Future<DataSearchIndex> fetchDataSearchIndex(
      {userData: DataUser, String lang = 'en', int page = 1}) async {
    printCyan("Lay tu API: fetchDataSearchIndex");

    var dataSearchIndex;
    var url = 'FlowerCategory/getDataSearchSugges/' + userData.uid.toString();
    var params = {'lang': lang, 'page': page.toString()};
    printBlue(url);
    final response = await Session().getDefault(url, params: params);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      if (mapResponse['status'] == 1) {
        dataSearchIndex = DataSearchIndex.fromJson(mapResponse);
        DataCache().setSearchIndex(dataSearchIndex);
      } else {
        printYellow('Loi roi con cho');
      }
    } else {
      throw Exception('Failed to load album');
    }
    return dataSearchIndex;
  }

  Future<List<DataTalk>> getListTalkByCategoryId(int catId,
      {int page = 1, String lang = 'en'}) async {
    printCyan("Lay tu API: fetchDataSearchIndex");
    List<DataTalk> list = [];
    var url = 'FlowerCategory/getListTalk/' + catId.toString();
    var params = {'page': page.toString(), 'lang': lang};
    final response = await Session().getDefault(url, params: params);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      if (mapResponse['status'] == 1) {
        list = mapResponse['listTalk'].map<DataTalk>((json) {
          return DataTalk.fromJson(json);
        }).toList();
      } else {
        printYellow('Loi roi con cho');
      }
    } else {
      throw Exception('Failed to load album');
    }
    return list;
  }

  Future<LanguageData> fetchGetDataLanguage() async {
    var listLanguahe;
    var vipConfig;
    var url = 'FlowerUser/getListLanguge';
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      listLanguahe = LanguageData.fromJson(mapResponse);
      vipConfig = VipConfigData.fromJson(mapResponse['vipConfig']);
      DataCache().setLanguageData(listLanguahe);
      DataCache().setVipConfigData(vipConfig);
    } else {
      throw Exception('Failed to load album');
    }
    return listLanguahe;
  }

  Future<CountryData> fetchGetDataCountry() async {
    var listCountry;
    var url = 'TblCountries/getCountryAll';
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      listCountry = CountryData.fromJson(mapResponse);
      DataCache().setCountryData(listCountry);
    } else {
      throw Exception('Failed to load album');
    }
    return listCountry;
  }

  Future<DataTextReview?> fetchReviewTextData({userData: DataUser}) async {
    DataTextReview? dataTextReview;
    var url =
        'FlowerSentenceReview/getListTextReview/' + userData.uid.toString();
    print('đây là url: $url');
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      var mapResponse = json.decode(response.body);
      if (mapResponse['status'] == 1) {
        dataTextReview = DataTextReview.fromJson(mapResponse);
        DataCache().setListTextReview(dataTextReview);
      } else {
        printYellow('Call Failed');
      }
    } else {
      print('Xảy ra lỗi load dataTextReview');
      return null;
    }
    return dataTextReview;
  }

  Future<DataVideoReview?> fetchReviewVideoData({userData: DataUser}) async {
    var dataVideoReview;
    var url = 'FlowerVideoReview/getListVideoReview/' + userData.uid.toString();
    final response = await Session().getDefault(url);
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        if (mapResponse['status'] == 1) {
          dataVideoReview = DataVideoReview.fromJson(mapResponse);
          DataCache().setListVideoReview(dataVideoReview);
        }
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print(e);
    }
    return dataVideoReview;
  }

  Future<DataVideoReview> deleteReviewVideoData(
      {userData: DataUser, id: String}) async {
    var dataVideoReview;
    var url = 'FlowerVideoReview/getListVideoReview/' +
        userData.uid.toString() +
        "/listVideoReview/" +
        id;
    final response = await Session().deleteList(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      if (mapResponse['status'] == 1) {
        dataVideoReview = DataVideoReview.fromJson(mapResponse);
        DataCache().setListVideoReview(dataVideoReview);
      } else {
        printYellow('Delete Error');
      }
    } else {
      throw Exception('Failed to load album');
    }
    return dataVideoReview;
  }

  Future<CourseModel> getListCourse() async {
    var dataSourse;
    var url = 'FlowerCategory/getListCourse';
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      if (mapResponse['status'] == 1) {
        dataSourse = CourseModel.fromJson(mapResponse);
      } else {
        printYellow('Loi roi con cho');
      }
    } else {
      throw Exception('Failed to load album');
    }
    return dataSourse;
  }

  List<Category> getAllListCourse(listCourse) {
    List<Category> listResult = [];
    for (var course in listCourse) listResult.add(course);
    return listResult;
  }

  Future<List<TalkDetailModel>> getListSubVideo(
      int idTalk, String langugeCode) async {
    log(idTalk.toString());
    var dataSub;
    var url = 'FlowerTalk/getFlowerTalkInfoById/' + idTalk.toString();
    final response =
        await Session().getNoneHeaderWithParams(url, {'lang': '$langugeCode'});
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      if (mapResponse['status'] == 1) {
        dataSub = mapResponse['talk_detail_data'].map<TalkDetailModel>((json) {
          return TalkDetailModel.fromJson(json);
        }).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
    return dataSub;
  }

  Future<bool> updateReviewTextData(int ttrId) async {
    bool result = false;
    var url = 'FlowerSentenceReview/updateTotalReview/' + ttrId.toString();
    var response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      var status = mapResponse['status'];
      if (status == 1) {
        result = true;
        // cập nhật lại cache
        // trên API bắn về thằng textReview mới update
        // lưu vào danh sách trong cache
      }
    } else {
      throw Exception('Failed to update textReview.');
    }
    return result;
  }

  Future<int> addItemCourse(
      String uid, String ttdid, int type, String languageCode) async {
    int status = 0;
    var url = 'FlowerSentenceReview/add';

    var formData = jsonEncode(<String, dynamic>{
      'uid': int.parse(uid),
      'ttdid': int.parse(ttdid),
      'type': type,
      'lang': languageCode,
    });

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        // thêm thành công
        // cập nhật vào cache
        TextReview newTextReview =
            TextReview.fromJson(mapResponse['newTextReview']);
        DataCache().insertListTextReview(newTextReview);
      }
    }
    return status;
  }

  Future<int> addVideoCourse(
      String uid, String tid, String languageCode, String hourNoti) async {
    int status = 0;
    var url = 'FlowerVideoReview/add';

    var formData = jsonEncode(<String, dynamic>{
      'uid': int.parse(uid),
      'tid': int.parse(tid),
      'lang': languageCode,
      'hourNoti': hourNoti,
    });

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        // thêm thành công
        // cập nhật vào cache
        VideoReview newVideoReview =
            VideoReview.fromJson(mapResponse['newVideoReview']);
        DataCache().insertListVideoReview(newVideoReview);
      }
    }
    return status;
  }

  Future<bool> reportErrorVideoCourse({
    required String uid,
    required String vid,
    required String subid,
    required String reasonid,
    String? reason,
    String? sign,
  }) async {
    int status = 0;
    var url = 'ReportVideoError/add';
    var formData = jsonEncode(<String, dynamic>{
      'uid': '${int.parse(uid)}',
      'vid': '${int.parse(vid)}',
      'subid': subid,
      'reason': reason,
      'reasonid': reasonid,
      'sign': sign
    });
    try {
      final response = await Session().postDefault(url, formData);

      if (response.statusCode == 200) {
        Map mapResponse = json.decode(response.body.toString());
        status = mapResponse['error'];
        print("check1" + jsonEncode(mapResponse));
        if (status == 1) {
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> destroyVideoCourse(String uid, String tid, String vrid) async {
    int status = 0;
    var url = 'FlowerVideoReview/removeVideoReview';

    var formData = jsonEncode(<String, dynamic>{
      'uid': int.parse(uid),
      'tid': int.parse(tid),
      'vrid': int.parse(vrid),
    });

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      print(mapResponse);
      status = mapResponse['status'];
    }
    return status;
  }

  Future<int> followDataSubChannel(
      int uid, Category channel, String languageCode) async {
    int status = 0;
    var url = 'FlowerCateFollowLog/followCategory';

    var formData = jsonEncode(<String, dynamic>{
      'uid': uid.toString(),
      'cid': channel.id,
      'lang': languageCode,
    });

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        // thêm thành công
        // cập nhật vào cache
        Category newCateFollow = new Category(
          id: channel.id,
          name: channel.name,
          name_vi: channel.name_vi,
          name_zh: channel.name_zh,
          name_ja: channel.name_ja,
          name_hi: channel.name_hi,
          name_es: channel.name_es,
          name_ru: channel.name_ru,
          name_tr: channel.name_tr,
          name_pt: channel.name_pt,
          name_id: channel.name_id,
          name_th: channel.name_th,
          name_ms: channel.name_ms,
          name_ar: channel.name_ar,
          name_fr: channel.name_fr,
          name_it: channel.name_it,
          name_de: channel.name_de,
          name_ko: channel.name_ko,
          name_zh_Hant_TW: channel.name_zh_Hant_TW,
          name_sk: channel.name_sk,
          name_sl: channel.name_sl,
          description: channel.description,
          description_vi: channel.description_vi,
          description_zh: channel.description_zh,
          description_ja: channel.description_ja,
          description_hi: channel.description_hi,
          description_es: channel.description_es,
          description_ru: channel.description_ru,
          description_tr: channel.description_tr,
          description_pt: channel.description_pt,
          description_id: channel.description_id,
          description_th: channel.description_th,
          description_ms: channel.description_ms,
          description_ar: channel.description_ar,
          description_fr: channel.description_fr,
          description_it: channel.description_it,
          description_de: channel.description_de,
          description_ko: channel.description_ko,
          description_zh_Hant_TW: channel.description_zh_Hant_TW,
          description_sk: channel.description_sk,
          description_sl: channel.description_sl,
          parentId: channel.parentId,
          slug: channel.slug,
          picture: channel.picture,
          start: channel.start,
          totalFollow: channel.totalFollow,
          totalTalk: channel.totalTalk,
          type: channel.type,
          isActive: channel.isActive,
          listChannel: channel.listChannel,
          listCourse: channel.listCourse,
          listTalk: channel.listTalk,
          picLink: channel.picLink,
        );
        DataCache().insertDataSubChannel(newCateFollow);
      }
    }
    return status;
  }

  Future<void> fetchSubChannelFromApi(int idUser) async {
    int status = 0;
    String url = 'FlowerCategory/getChannelDataFollowByUser/$idUser';

    try {
      final http.Response response = await Session().getDefault(url);
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        status = data['status'];
        List listChannel = data['dataChannelFollow'];

        if (status == 1) {
          listChannel.forEach((channel) {
            Category newCategory = Category(
              id: channel['id'],
              name: channel['name'],
              name_vi: channel['name_vi'],
              name_zh: channel['name_zh'],
              name_ja: channel['name_ja'],
              name_hi: channel['name_hi'],
              name_es: channel['name_es'],
              name_ru: channel['name_ru'],
              name_tr: channel['name_tr'],
              name_pt: channel['name_pt'],
              name_id: channel['name_id'],
              name_th: channel['name_th'],
              name_ms: channel['name_ms'],
              name_ar: channel['name_ar'],
              name_fr: channel['name_fr'],
              name_it: channel['name_it'],
              name_de: channel['name_de'],
              name_ko: channel['name_ko'],
              name_zh_Hant_TW: channel['name_zh_Hant_TW'],
              name_sk: channel['name_sk'],
              name_sl: channel['name_sl'],
              description: channel['description'],
              description_vi: channel['description_vi'],
              description_zh: channel['description_zh'],
              description_ja: channel['description_ja'],
              description_hi: channel['description_hi'],
              description_es: channel['description_es'],
              description_ru: channel['description_ru'],
              description_tr: channel['description_tr'],
              description_pt: channel['description_pt'],
              description_id: channel['description_id'],
              description_th: channel['description_th'],
              description_ms: channel['description_ms'],
              description_ar: channel['description_ar'],
              description_fr: channel['description_fr'],
              description_it: channel['description_it'],
              description_de: channel['description_de'],
              description_ko: channel['description_ko'],
              description_zh_Hant_TW: channel['description_zh_Hant_TW'],
              description_sk: channel['description_sk'],
              description_sl: channel['description_sl'],
              parentId: channel['parentId'],
              slug: channel['slug'],
              picture: channel['picture'],
              start: channel['start'],
              totalFollow: channel['totalFollow'],
              totalTalk: channel['totalTalk'],
              type: channel['type'],
              isActive: channel['isActive'],
              listChannel: channel['listChannel'],
              listCourse: channel['listCourse'],
              listTalk: channel['listTalk'],
              picLink: channel['picLink'],
            );
            DataCache().insertDataSubChannel(newCategory);
          });
        }
      }
    } catch (e) {
      print('loi fetch data channel roi nay');
      throw e;
    }
  }

  Future<int> unFollowDataSubChannel(
      int uid, Category channel, String languageCode) async {
    int status = 0;
    var url = 'FlowerCateFollowLog/unFollowCategory';

    var formData = jsonEncode(<String, dynamic>{
      'uid': uid.toString(),
      'cid': channel.id,
      'lang': languageCode,
    });

    printRed('$uid');
    printGreen('${channel.id}');

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        //xóa thành công
        // cập nhật vào cache
        CateFollow newCateFollow = new CateFollow(
          id: channel.id,
          name: channel.name,
          name_vi: channel.name_vi,
          name_zh: channel.name_zh,
          name_ja: channel.name_ja,
          name_hi: channel.name_hi,
          name_es: channel.name_es,
          name_ru: channel.name_ru,
          name_tr: channel.name_tr,
          name_pt: channel.name_pt,
          name_id: channel.name_id,
          name_th: channel.name_th,
          name_ms: channel.name_ms,
          name_ar: channel.name_ar,
          name_fr: channel.name_fr,
          name_it: channel.name_it,
          name_de: channel.name_de,
          name_ko: channel.name_ko,
          name_zh_Hant_TW: channel.name_zh_Hant_TW,
          name_sk: channel.name_sk,
          name_sl: channel.name_sl,
          description: channel.description,
          description_vi: channel.description_vi,
          description_zh: channel.description_zh,
          description_ja: channel.description_ja,
          description_hi: channel.description_hi,
          description_es: channel.description_es,
          description_ru: channel.description_ru,
          description_tr: channel.description_tr,
          description_pt: channel.description_pt,
          description_id: channel.description_id,
          description_th: channel.description_th,
          description_ms: channel.description_ms,
          description_ar: channel.description_ar,
          description_fr: channel.description_fr,
          description_it: channel.description_it,
          description_de: channel.description_de,
          description_ko: channel.description_ko,
          description_zh_Hant_TW: channel.description_zh_Hant_TW,
          description_sk: channel.description_sk,
          description_sl: channel.description_sl,
          parentId: channel.parentId,
          slug: channel.slug,
          picture: channel.picture,
          start: channel.start,
          totalFollow: channel.totalFollow,
          totalTalk: channel.totalTalk,
          type: channel.type,
          isActive: channel.isActive,
        );
        DataCache().removeDataSubChannel(newCateFollow);
      }
    }
    return status;
  }

  Future<int> deleteItemCourse(
    String ttrid,
  ) async {
    int status = 0;
    var url = 'FlowerSentenceReview/delete/' + ttrid;

    final response = await Session().getDefault(url);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status != 1) {
        printGreen(mapResponse['message'].toString());
      }
    }
    return status;
  }

  Future<List<TalkTextDetailModel>> getTalkTalkDetail(String id) async {
    var dataSub;
    String url = 'FlowerTalkTextDetail/listTalkTextDetailByIdTalkText/' + id;
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      if (mapResponse['status'] == 1) {
        dataSub =
            mapResponse['listTalkTextDetail'].map<TalkTextDetailModel>((json) {
          return TalkTextDetailModel.fromJson(json);
        }).toList();
      } else {
        printYellow('Loi roi con cho');
        return [];
      }
    } else {
      throw Exception('Failed to load album');
    }
    return dataSub;
  }

  // follow takl APIs

  Future<int> followTalk({uid: int, talkId: int, languageCode: String}) async {
    int status = 0;
    var url = 'FlowerTalkFollowLog/followTalk';

    var formData = jsonEncode(<String, dynamic>{
      'uid': uid,
      'talkId': talkId,
      'type': 1,
      'lang': languageCode,
    });

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        TalkFollowLogModel talkFollowLogModel =
            TalkFollowLogModel.fromJson(mapResponse['flowerFollowTalkLog']);
        talkFollowLogModel.setSatus(1);
        DataCache().insertTalkFollowLog(talkFollowLogModel);
      }
    }
    return status;
  }

  Future<int> checkFollowTalk(int tid, int uid) async {
    int status = 0;
    var url = 'FlowerTalkFollowLog/checkFollowTalk';

    var formData = jsonEncode(<String, dynamic>{
      'uid': uid,
      'talkId': tid,
      'type': 1,
    });

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        TalkFollowLogModel talkFollowLogModel =
            TalkFollowLogModel.fromJson(mapResponse['flowerFollowTalkLog']);
        talkFollowLogModel.setSatus(1);
        DataCache().insertTalkFollowLog(talkFollowLogModel);
      } else if (status == 0) {
        TalkFollowLogModel talkFollowLogModel = new TalkFollowLogModel(
            idTalkLog: 0,
            uid: uid,
            talkId: tid,
            status: 0,
            createdtime: "",
            updatetime: "",
            isFollow: 0,
            isLike: 0,
            type: 1);
        talkFollowLogModel.setSatus(0);
        DataCache().insertTalkFollowLog(talkFollowLogModel);
      }
    }
    return status;
  }

  Future<int> unFollowTalk(
      {uid: int, talkId: int, languageCode: String}) async {
    int status = 0;
    var url = 'FlowerTalkFollowLog/unFollowTalk';

    var formData = jsonEncode(<String, dynamic>{
      'uid': uid,
      'talkId': talkId,
      'type': 1,
      'lang': languageCode,
    });

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {}
    }
    return status;
  }

  // Like Takl APIs

  Future<int> likeTalk({uid: int, talkId: int, languageCode: String}) async {
    int status = 0;
    var url = 'FlowerTalkFollowLog/likeTalk';

    var formData = jsonEncode(<String, dynamic>{
      'uid': '$uid',
      'talkId': '$talkId',
      'type': 2,
      'lang': '$languageCode',
    });

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        TalkFollowLogModel talkFollowLogModel =
            TalkFollowLogModel.fromJson(mapResponse['flowerLikeTalkLog']);
        talkFollowLogModel.setSatusLike(1);
        DataCache().insertTalkFollowLog(talkFollowLogModel);
      }
    }
    return status;
  }

  Future<int> checkLikeTalk(int tid, int uid) async {
    int status = 0;
    var url = 'FlowerTalkFollowLog/checkLikeTalk';

    var formData = jsonEncode(<String, dynamic>{
      'uid': uid,
      'talkId': tid,
      'type': 2,
    });

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        TalkFollowLogModel talkFollowLogModel =
            TalkFollowLogModel.fromJson(mapResponse['flowerLikeTalkLog']);
        talkFollowLogModel.setSatus(1);
        DataCache().insertTalkFollowLog(talkFollowLogModel);
      } else if (status == 0) {
        TalkFollowLogModel talkFollowLogModel = new TalkFollowLogModel(
            idTalkLog: 0,
            uid: uid,
            talkId: tid,
            status: 0,
            createdtime: "",
            updatetime: "",
            isFollow: 0,
            isLike: 0,
            type: 1);
        talkFollowLogModel.setSatus(0);
        DataCache().insertTalkFollowLog(talkFollowLogModel);
      }
    }
    return status;
  }

  Future<int> unLikeTalk({uid: int, talkId: int, languageCode: String}) async {
    int status = 0;
    var url = 'FlowerTalkFollowLog/unLikeTalk';

    var formData = jsonEncode(<String, dynamic>{
      'uid': uid,
      'talkId': talkId,
      'type': 2,
      'lang': languageCode,
    });

    final response = await Session().postDefault(url, formData);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body.toString());
      status = mapResponse['status'];
      if (status == 1) {
        TalkFollowLogModel talkFollowLogModel = new TalkFollowLogModel(
            idTalkLog: 0,
            uid: uid,
            talkId: talkId,
            status: 0,
            createdtime: "",
            updatetime: "",
            isFollow: 0,
            isLike: 0,
            type: 2);

        DataCache().removeTalkFollowLog(talkFollowLogModel);
      }
    }
    return status;
  }

  Future<DataNewWord?> getListNewWordSentence({talkTextId: int}) async {
    DataNewWord? dataNewWord;
    var url =
        'FlowerNewWordTalkLog/getListNewWordByTalk/' + talkTextId.toString();
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      var status = mapResponse['status'];
      if (status == 1) {
        dataNewWord = DataNewWord.fromJson(mapResponse);
      }
    } else {
      throw Exception('Failed to load new word');
    }
    printGreen("2");
    return dataNewWord;
  }

  Future<Category?> getCategoryById({categoryId: int}) async {
    Category? dataCate;

    var url = 'FlowerCategory/getCategoryById/' + categoryId.toString();
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      var status = mapResponse['status'];
      if (status == 1) {
        dataCate = Category.fromJson(mapResponse['flowerCategory']);
      }
    } else {
      throw Exception('Failed to load new word');
    }
    return dataCate;
  }

  Future<DataTalk> getVideoTalkById({categoryId: int}) async {
    var dataCate;
    var url = 'FlowerTalk/getTalkDetailFullData/' + categoryId.toString();
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      var status = mapResponse['status'];
      if (status == 1) {
        dataCate = DataTalk.fromJson(mapResponse['talk']);
      }
    } else {
      throw Exception('Failed to load new word');
    }
    return dataCate;
  }

  Future<DataTalkText> getTalkTextById({categoryId: int}) async {
    var dataCate;
    var url =
        'FlowerTalkText/getTalkTextDetailFullData/' + categoryId.toString();
    final response = await Session().getDefault(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body.toString());
      var status = mapResponse['status'];
      if (status == 1) {
        dataCate = DataTalkText.fromJson(mapResponse['text_talk']);
      }
    } else {
      throw Exception('Failed to load new word');
    }
    return dataCate;
  }

  Future<List<ThemeItem>> getCate() async {
    final Uri uri = Uri.https(Session().BASE_URL, '/Question/getListCategory');
    final List<ThemeItem> listCateParse = [];
    final http.Response response = await http.get(uri);
    if (response.statusCode == 200) {}
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listCate = data['listCategory'];
        listCate.forEach((value) {
          Map<dynamic, dynamic> val = value;
          listCateParse.add(ThemeItem.fromJson(val));
        });
        return listCateParse;
      } else {
        print('Not found');
        return listCateParse;
      }
    } catch (e) {
      print('hinh nhu la code ben tren sai');

      throw e;
    }
  }

  Future<List<QuestionItem>> getDataQuestion() async {
    final Uri uri = Uri.https(Session().BASE_URL, 'question/getArrQuestion');
    final List<QuestionItem> listQuestionParse = [];
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listQuestion = data['data'];
        listQuestion.forEach((value) {
          Map<dynamic, dynamic> val = value;
          listQuestionParse.add(QuestionItem.fromJson(val));
        });
        return listQuestionParse;
      } else {
        print('Not found');
        return listQuestionParse;
      }
    } catch (e) {
      print('hinh nhu la code ben tren sai');
      throw e;
    }
  }

  Future<List<CatrgoryItem>> getDataListCate() async {
    final Uri uri = Uri.https(Session().BASE_URL, '/Question/getListCategory');
    final List<CatrgoryItem> listCateParse = [];
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listCate = data['listCategory'];
        listCate.forEach((value) {
          Map<dynamic, dynamic> val = value;
          listCateParse.add(CatrgoryItem.fromJson(val));
        });
        return listCateParse;
      } else {
        print('not found');
        return listCateParse;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<ListenItem>> getDataListen() async {
    final Uri uri =
        Uri.https(Session().BASE_URL, '/Question/getMyQuestionMini/1');
    final List<ListenItem> listListenParse = [];
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listListen = data['data'];
        listListen.forEach((value) {
          Map<dynamic, dynamic> val = value;
          listListenParse.add(ListenItem.fromJson(val));
        });
        return listListenParse;
      } else {
        print('not found');
        return listListenParse;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<CakeItem>> getDataCake() async {
    final Uri uri =
        Uri.https(Session().BASE_URL, '/FlowerCategory/getListParentCourse');
    final List<CakeItem> listCakeParse = [];
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listCake = data['dataParentCourse'];
        listCake.forEach((value) {
          Map<dynamic, dynamic> val = value;
          listCakeParse.add(CakeItem.fromJson(val));
        });
        return listCakeParse;
      } else {
        print('not found');
        return listCakeParse;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<CourseItem>> getCourseChild(int idCourseChild) async {
    final Uri uri = Uri.https(Session().BASE_URL,
        '/FlowerCategory/getListChildenCourse/$idCourseChild');
    final List<CourseItem> listCourseChil = [];
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listCourse = data['dataChildenCourse'];
        listCourse.forEach((value) {
          Map<String, dynamic> val = value;
          // printRed("DEBUG: " + val.toString());
          listCourseChil.add(CourseItem.fromJson(val));
        });

        return listCourseChil;
      } else {
        print('not found');
        return listCourseChil;
      }
    } catch (e) {
      throw e;
    }
  }

// Lấy thông tin các bài hội thoại của khoá học nhỏ
  Future<List?> getDataDetailCourse(
    int idCourseChild,
    int uid,
  ) async {
    final Uri uri =
        Uri.https(Session().BASE_URL, '/FlowerCategory/getCourseDetail/');
    List? courseDetail;
    // printGreen("ID: " + idCourseChild.toString());
    // printRed("URL: " + baseurl);
    // printRed("idCourseChild: " + '$idCourseChild');
    // printRed("uid: " + '$uid');
    try {
      final http.Response response = await http.post(uri, body: {
        'courseId': '$idCourseChild',
        'uid': '$uid',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final listCourse = data['courseDetail'];
        final listDataTalk = listCourse['listTalk'];
        final listDataTalkText = listCourse['listTalkText'];

        courseDetail = [listDataTalk, listDataTalkText];

        return courseDetail;
      } else {
        print('not found');
        return courseDetail;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> submitCourseOnClicked(
    int idCourseChild,
    int uid,
    int idTalk,
    int type,
  ) async {
    final Uri uri = Uri.https(
      Session().BASE_URL,
      '/FlowerUserCourseElementLog/submitCourse',
    );

    try {
      final http.Response response = await http.post(uri, body: {
        'courseId': '$idCourseChild',
        'uid': '$uid',
        'elementId': '$idTalk',
        'type': '$type',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final message = data['message'];
        print(message);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkLike(
    int idCourseParent,
    int uid,
  ) async {
    final Uri uri = Uri.https(
      Session().BASE_URL,
      'FlowerUserCourseLog/checkLikeCourse',
    );

    try {
      final http.Response response = await http.post(uri, body: {
        'uid': '$uid',
        'cid': '$idCourseParent',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final message = data['likeCourse'];
        if (message != null) {
          return data['likeCourse']['status'] == 1 ? true : false;
        }
        return false;
      }
      return false;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> likeCourse(
    int idCourseParent,
    int uid,
  ) async {
    final Uri uri = Uri.https(
      Session().BASE_URL,
      'FlowerUserCourseLog/likeCourse',
    );

    try {
      final http.Response response = await http.post(uri, body: {
        'uid': '$uid',
        'cid': '$idCourseParent',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final message = data['likeCourse'];
        if (message != null) {
          return data['likeCourse']['status'] == 1 ? true : false;
        }
        return false;
      }
      return false;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> unlikeCourse(
    int idCourseParent,
    int uid,
  ) async {
    final Uri uri = Uri.https(
      Session().BASE_URL,
      'FlowerUserCourseLog/unLikeCourse',
    );

    try {
      final http.Response response = await http.post(uri, body: {
        'uid': '$uid',
        'cid': '$idCourseParent',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final message = data['likeCourse'];
        if (message != null) {
          return data['likeCourse']['status'] == 1 ? true : false;
        }
        return false;
      }
      return false;
    } catch (e) {
      throw e;
    }
  }

  Future<List<DataVideoYoutube>?> search(String keyword) async {
    final String domainYt = 'www.googleapis.com';
    final List<DataVideoYoutube> videos = [];
    final Uri uri = Uri.https(domainYt, 'youtube/v3/search', {
      "part": "snippet",
      "maxResults": "50",
      "q": "$keyword",
      "key": "AIzaSyDc9t4E1IYjE1zb2GJQBei6dOZwiSjT0dw",
    });

    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final itemVideos = data['items'];
        itemVideos.forEach((video) {
          videos.add(
            DataVideoYoutube(
              id: video['id']["videoId"],
              title: video['snippet']['title'],
              linkOrigin:
                  'https://www.youtube.com/watch?v=${video["id"]["videoId"]}',
              thumb: video['snippet']['thumbnails']['default']['url'],
            ),
          );
        });
      }
      return videos;
    } catch (e) {
      throw e;
    }
  }

  Future<DataTalk?> detailVideo({required String id}) async {
    DataTalk? detailVideo;
    final uri = Uri.https(Session().BASE_URL, 'FlowerTalk/detail/$id');
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        detailVideo = DataTalk.fromJson(data['data']);
        return detailVideo;
      }
      return detailVideo;
    } catch (e) {
      print(e);
      return detailVideo;
    }
  }

  Future<List<RecordModel>> getRecord({required int vid}) async {
    final Uri uri = Uri.https(
        Session().BASE_URL, 'UsersLogHeart/getTopQuizVideo', {'vid': '$vid'});
    final List<RecordModel> listRecordParse = [];
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listRecord = data['resultes'];
        listRecord.forEach((value) {
          Map<dynamic, dynamic> val = value;
          listRecordParse.add(RecordModel.fromJson(val));
        });
        return listRecordParse;
      } else {
        print('Not found');
        return listRecordParse;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<HistorySpeakModel>> getHistorySpeak(int page) async {
    final List<HistorySpeakModel> listHistorySpeakParse = [];
    try {
      final Uri uri = Uri.https(
        Session().BASE_URL,
        'UsersLogSpeak/getHistory',
        {'uid': DataCache().userCache!.uid.toString(), 'page': '$page'},
      );
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listHistorySpeak = data['historys'];
        listHistorySpeak.forEach((value) {
          Map<String, dynamic> val = value;
          listHistorySpeakParse.add(HistorySpeakModel.fromJson(val));
        });
        return listHistorySpeakParse;
      } else {
        print('Not found');
        return listHistorySpeakParse;
      }
    } catch (e) {
      printRed('on error: $e');
      throw e;
    }
  }

  Future<bool> removeSpeak(
    String uid,
    String sid,
  ) async {
    final Uri uri = Uri.https(
      Session().BASE_URL,
      '/UsersLogSpeak/delete',
    );

    try {
      final http.Response response = await http.post(uri, body: {
        'uid': '${int.parse(uid)}',
        'sid': '${int.parse(sid)}',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final status = data['error'];
        final message = data['msg'];
        print(message);
        if (status == 1) {
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      throw e;
    }
  }

  Future<List<DataTalk>> getFlashViewVideo(
      int page, String languageCode) async {
    //nếu link api dạng ?uid = ... thì sẽ truyền uri như này
    final Uri uri = Uri.https(
      Session().BASE_URL,
      'Home/getFlashView',
      {'page': '$page', 'lang': languageCode},
    );
    final List<DataTalk> listFlashViewVideoParse = [];
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> listFlashViewVideo = data['listAllTalk'];
        listFlashViewVideo.forEach((value) {
          Map<String, dynamic> val = value;
          listFlashViewVideoParse.add(DataTalk.fromJson(val));
        });
        return listFlashViewVideoParse;
      } else {
        print('Not found');
        return listFlashViewVideoParse;
      }
    } catch (e) {
      printRed('on error: $e');
      return [];
    }
  }

  Future<bool> deleteSentenceReview(
      String username, String password, int ttrid, int uid) async {
    final Uri uri = Uri.https(
      Session().BASE_URL,
      '/FlowerSentenceReview/deleteSentence',
    );
    Map data = {
      'username': username,
      'password': password,
      'ttrid': '$ttrid',
      'uid': '$uid',
    };
    try {
      final http.Response response = await http.post(uri, body: data);
      if (response.statusCode == 200) {
        final dataRes = json.decode(response.body);
        final listFlashViewVideo = dataRes['status'];
        if (int.parse('$listFlashViewVideo') == 1) {
          return true;
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      printRed('on error: $e');
      return false;
    }
  }

  Future<List<DataTalk>> searchAllApp({
    required String languageCode,
    required String inputSearch,
    bool onlineRoom = false,
  }) async {
    final Uri uri = Uri.https(
      Session().BASE_URL,
      'FlowerUser/searchOnline',
      {
        'input': inputSearch,
        'lang': languageCode,
        if (onlineRoom) 'screen': 'online',
      },
    );
    List<DataTalk> listQueryVideo = [];
    try {
      http.Response res = await http.get(uri);
      if (res.statusCode == 200) {
        var dataDecode = json.decode(res.body);
        var dataMapVideo = dataDecode['dataTalk'];
        if (dataMapVideo.isNotEmpty) {
          dataMapVideo.forEach((video) {
            listQueryVideo.add(DataTalk.fromJson(video));
          });
        }
      }
      return listQueryVideo;
    } catch (e) {
      print('Đây là lỗi gọi api phần tìm kiếm: $e');
      return listQueryVideo;
    }
  }

  Future<List<ListUser>> getListUserOffline(BuildContext context,
      {page: int, uid: int, lang: String}) async {
    List<ListUser> listUser = [];

    var socketProvider = context.read<SocketProvider>();
    var url = '/user/list';
    try {
      final response = await Session().getNoneHeaderWithParams(
          url, {'page': '$page', 'uid': '$uid', 'lang': '$lang'});
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        var learnOffline = LearnOffline.fromJson(mapResponse);
        listUser.clear();
        listUser = learnOffline.list!;
        List<ListUser> newList = socketProvider.listUserOffline;
        newList.insertAll(newList.length, listUser);
        print("PageLoad:$page");
        socketProvider.setListUserOffline(newList);
      }
    } catch (error) {
      print(error);
      throw error;
    }
    return listUser;
  }

  Future<bool> pushNotificationServer({
    required String vid,
    required String uid,
    required String username,
    required String fullname,
    required String username_invited,
    required String fullname_invited,
    required String uid_invited,
    required String lang,
    required String roomid,
  }) async {
    int status = 0;
    var url = '/user/inviteOffline';
    try {
      final response = await Session().getNoneHeaderWithParams(url, {
        'vid': vid,
        'uid': uid,
        'username': username,
        'fullname': fullname,
        'username_invited': username_invited,
        'fullname_invited': fullname_invited,
        'uid_invited': uid_invited,
        'lang': lang,
        'roomid': roomid,
      });
      if (response.statusCode == 200) {
        Map mapResponse = json.decode(response.body.toString());
        status = mapResponse['status'];
        if (status == 1) {
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<ListUser>> searchListUserOffline(BuildContext context,
      {lang: String, input: String}) async {
    List<ListUser> listSearchUser = [];

    var socketProvider = context.read<SocketProvider>();
    var url = '/user/search';
    try {
      final response = await Session()
          .getNoneHeaderWithParams(url, {'lang': '$lang', 'input': '$input'});
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        var learnOffline = LearnOffline.fromJson(mapResponse);
        listSearchUser.clear();
        listSearchUser = learnOffline.list!;
        socketProvider.setListUserOffline(listSearchUser);
      }
    } catch (error) {
      print(error);
      throw error;
    }
    return listSearchUser;
  }

  getTotalNotifiHome(BuildContext context, {userId: String}) async {
    var socketProvider = context.read<SocketProvider>();
    var url = 'FlowerNotificationUser/getTotal/$userId';
    try {
      final response = await Session().getDefault(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        var totalNoti = TotalNotifi.fromJson(mapResponse);
        socketProvider.setTotalNoti(totalNoti.total!);
        printBlue('NotifiTotal:${totalNoti.total}');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  setClickNotifi(BuildContext context, {userId: String}) async {
    var socketProvider = context.read<SocketProvider>();
    var url = 'FlowerNotificationUser/read/$userId';
    try {
      final response = await Session().getDefault(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse =
            json.decode(response.body.toString());
        var totalNoti = TotalNotifi.fromJson(mapResponse);
        socketProvider.setTotalNoti(totalNoti.total!);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<Category>> getCategory({String lang = 'en', int page = 1}) async {
    var url = 'category/list';
    var queryParams = {
      'page': page.toString(),
      'lang': lang,
    };
    try {
      final response = await Session().getDefault(url, params: queryParams);
      if (response.statusCode == 200) {
        var mapResponse = json.decode(response.body);
        if (mapResponse['status'] == 1) {
          List<Category> cate = mapResponse['list']
              .map<Category>((json) => Category.fromJson(json))
              .toList();
          return cate;
        }
      }
      return [];
    } catch (error) {
      print(error);
      return [];
    }
  }
}
