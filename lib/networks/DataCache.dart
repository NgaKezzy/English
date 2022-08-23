import 'dart:convert';

import 'dart:io';

import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/NewWordCache.dart';
import 'package:app_learn_english/model_local/SettingModel.dart';
import 'package:app_learn_english/model_local/TalkCacheModel.dart';
import 'package:app_learn_english/model_local/TalkTextCacheModel.dart';
import 'package:app_learn_english/model_local/TargetOffline.dart';
import 'package:app_learn_english/models/AchievementModel.dart';
import 'package:app_learn_english/models/CateFollowModel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/CountryAll.dart';
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
import 'package:app_learn_english/models/TextReviewModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/UserTargetLogModel.dart';
import 'package:app_learn_english/models/VideoReviewModel.dart';
import 'package:app_learn_english/models/VipModel.dart';
import 'package:app_learn_english/models/cake_model.dart';
import 'package:app_learn_english/models/course_model.dart';
import 'package:app_learn_english/models/quiz/talk_detail_quiz_model.dart';
import 'package:app_learn_english/models/speak_home_model.dart';
import 'package:app_learn_english/models/video_history/history_model.dart';
import 'package:app_learn_english/networks/AchievementAPIs.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/vip/api_vip.dart';
import 'package:app_learn_english/presentation/speak/provider/course_chuyenmuc.dart';
import 'package:app_learn_english/presentation/speak/provider/course_trinhdo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCache {
  static final DataCache _singleton = DataCache._internal();
  factory DataCache() {
    return _singleton;
  }
  DataCache._internal();
  DataHome? _dataHomeCache; // data hiển thị trang home
  SubChannelData?
      _channelHasData; // data hiển thị tab kênh đăng ký khi đã có kênh đăng ký
  List<Category>?
      _listCategory; // data hiển thị tab kênh đăng ký khi chưa đăng ký (danh sách danh mục có thể dùng chỗ khác)
  List<TalkDetailQuizModel>? // data quiz
      _listQuiz;
  List<Lists>? // data quiz
      _listSpeakHome;
  List<History>? _listVideoHistory;

  DataSearchIndex? dataSearchIndex; // data hiển thị khi mở page tìm kiếm

  DataTextReview? listTextReview; // danh sách mẫu câu ôn tập

  DataVideoReview? listVideoReview; //danh sách video ôn tập

  // list talk video
  // khi mở video vào đây tìm
  // nếu có thì lấy ra dùng, không có thì call api load về dùng và lưu vào đây luôn
  List<TalkCacheModel> listTalkCache = [];

  // list talk text
  // khi mở video vào đây tìm
  // nếu có thì lấy ra dùng, không có thì call api load về dùng và lưu vào đây luôn
  List<TalkTextCacheModel> listTalkTextCache = [];

  List<TalkFollowLogModel> listTalkFollowLog = [];

  DataUser? userCache; // Lưu data User Global để dùng khắp app

  LanguageData? languageData; // lưu data language

  CountryData? countryData; //luu ngon ngu

  VipConfigData? vipConfigData; // lưu data Vip

  List<NewWordCacheModel> listNewWordCache = []; // lưu data từ vựng global

  UserTargetLogModel? userTargetModel;

  SettingOffline? settingData;

  List<UserAchievement>? dataAchievement;

  List<DataNewWord>? listVocab;
  List<DataTalk> randomVideoTalk = [];
  List<TrinhDoCourse?> listTrinhDo = [];
  List<ChuyenMucCourse?> listChuyenMuc = [];
  List<CakeItem> listKhoaHoc = [];
  List<CourseItem> listItemKhoaHoc = [];
  String _tempPassWord = '';

  clearGlobal() async {
    this._dataHomeCache = null;
    this._channelHasData = null;
    this._listCategory = null;
    this.dataSearchIndex = null;
    this.listTextReview = null;
    this.listVideoReview = null;
    this.userCache = null;
    this.listTalkCache = [];
    this.listTalkTextCache = [];
    this.listTalkFollowLog = [];
    this.dataAchievement = null;
    this.listVocab = null;
    this.randomVideoTalk = [];
    this.listTrinhDo = [];
    this.listChuyenMuc = [];
    this.listKhoaHoc = [];
    this.listItemKhoaHoc = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  String get tempPassWord => _tempPassWord;
  void setTempPassWord(String tempPassWord) {
    this._tempPassWord = tempPassWord;
  }

  setKhoaHoc(List<CakeItem> data) {
    this.listKhoaHoc = data;
  }

  Future getKhoaHoc() async {
    if (listKhoaHoc.length == 0) {
      List<CakeItem> data = [];
      data = await TalkAPIs().getDataCake();
      setKhoaHoc(data);
      return this.listKhoaHoc;
    }
    return this.listKhoaHoc;
  }

  setTrinhDoCourse(List<TrinhDoCourse?> data) {
    this.listTrinhDo = data;
  }

  getTrinhDoCourse() {
    return this.listTrinhDo;
  }

  setChuyenMucCourse(List<ChuyenMucCourse?> data) {
    this.listChuyenMuc = data;
  }

  getChuyenMucCourse() {
    return this.listChuyenMuc;
  }

  setRandomVideoTalk(List<DataTalk> data) {
    this.randomVideoTalk = data;
  }

  List<DataTalk> getRandomVideoTalk() {
    return this.randomVideoTalk;
  }

  setListVideoHistory(List<History>? data) {
    if (this._listVideoHistory == null) {
      return this._listVideoHistory = data;
    } else {
      if (data != null) {
        for (int i = 0; i < _listVideoHistory!.length; i++) {
          for (int j = 0; j < data.length; j++) {
            if (_listVideoHistory![i].vid != data[j].vid) {
              return this._listVideoHistory!.add(data[j]);
            }
          }
        }
      }
    }
  }

  List<History>? getListHistory() {
    return this._listVideoHistory;
  }

  clearListHistory() {
    this._listVideoHistory!.clear();
  }

  removerAtListHistory(int index) {
    this._listVideoHistory!.removeAt(index);
    return this._listVideoHistory;
  }

  setDataVocab(List<DataNewWord> data) {
    this.listVocab = data;
  }

  Future<List<DataNewWord>> getDataVocab() async {
    if (this.listVocab != null) {
      printCyan('hello');
      return this.listVocab!;
    } else {
      this.listVocab = [];
      var dataTextReview = await getListTextReview();
      for (var i = 0; i < dataTextReview.textReview.length; i++) {
        if (dataTextReview.textReview[i].type == 1) {
          DataNewWord? data = await TalkAPIs().getListNewWordSentence(
            talkTextId: dataTextReview.textReview[i].ttdid,
          );
          if (data != null) {
            listVocab!.add(data);
          }
        }
      }
      return this.listVocab!;
    }
  }

  setDataAchievement(List<UserAchievement> data) {
    this.dataAchievement = data;
  }

  getDataAchievement() async {
    if (this.dataAchievement != null) {
      return this.dataAchievement;
    } else {
      this.dataAchievement = await AchievementAPIs().getDataAchievement();
      return this.dataAchievement;
    }
  }

  updateAvatar(String avatar) async {
    this.userCache!.avatar = avatar;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(userCache!));
  }

  Future<UserAchievement> getDataAchievementByType(int typeInput) async {
    if (this.dataAchievement != null) {
      UserAchievement? res;
      this.dataAchievement!.forEach((element) {
        if (typeInput == element.achiData!.type) {
          res = element;
        }
      });
      return res!;
    } else {
      this.dataAchievement = await AchievementAPIs().getDataAchievement();
      UserAchievement? res;
      this.dataAchievement!.forEach((element) {
        if (typeInput == element.achiData!.type) {
          res = element;
        }
      });
      return res!;
    }
  }

  void updateCompleteInCache(int id) async {
    if (this.dataAchievement != null) {
      this.dataAchievement!.forEach((element) {
        if (id == element.achiId && element.uid == this.userCache!.uid) {
          if (element.complete < element.achiData!.count) {
            element.complete++;
          }
        }
      });
    } else {
      this.dataAchievement = await AchievementAPIs().getDataAchievement();
      this.dataAchievement!.forEach((element) {
        if (id == element.achiId && element.uid == this.userCache!.uid) {
          if (element.complete < element.achiData!.count) {
            element.complete++;
          }
        }
      });
    }
  }

  getDataConfig() async {
    if (this.languageData == null || this.vipConfigData == null) {
      TalkAPIs().fetchGetDataLanguage();
    }
    if (this.countryData == null) {
      TalkAPIs().fetchGetDataCountry();
    }
  }

  setCountryData(CountryData data) {
    this.countryData = data;
  }

  getCountryData() {
    return this.countryData;
  }

  setLanguageData(LanguageData data) {
    this.languageData = data;
  }

  getLanguageData() {
    return this.languageData;
  }

  setSettingData(SettingOffline data) {
    this.settingData = data;
  }

  String handleLanguage() {
    final String defaultLocale =
        Platform.localeName; // Returns locale string in the form 'en_US'
    return defaultLocale.split('_')[0].trim();
  }

  CountryModel getDefaultLang(
      CountryData countryData, String languageShortName) {
    CountryModel countryDefault = countryData.listCountry
        .firstWhere((element) => element.sortname == languageShortName);
    return countryDefault;
  }

  Future<CountryModel?> getModelLangDefault() async {
    CountryModel defaultLang;
    if (DataCache().getCountryData() != null) {
      countryData = DataCache().getCountryData();
      defaultLang = getDefaultLang(
        countryData!,
        handleLanguage(),
      );
    } else {
      countryData = await TalkAPIs().fetchGetDataCountry();
      defaultLang = getDefaultLang(
        countryData!,
        handleLanguage(),
      );
    }
    return defaultLang;
  }

  getSettingData() {
    if (this.settingData != null) {
      return this.settingData;
    } else {
      DataOffline().getDataSetting(keyData: "MainSetting").then((value) => {
            if (value.toString() != '') {DataCache().setSettingData(value)}
          });
      return this.settingData;
    }
  }

  setVipConfigData(VipConfigData data) {
    this.vipConfigData = data;
  }

  getVipConfigData() {
    return this.vipConfigData!;
  }

  setUserData(DataUser? data) {
    this.userCache = data;
  }

  setIsVipByLastLogin(int _isVip) {
    this.userCache!.isVip = _isVip;
  }

  Future setIsVip(int isVip) async {
    if (isVip == 1) {
      final realVip = await ApiVip().getactiveVip();
      if (realVip == 1) {
        this.userCache!.isVip = realVip;
        printRed('Thành công');
      }
    } else if (isVip == 2) {
      final fakeVip = await ApiVip().getTrialVip();
      if (fakeVip == 2) {
        this.userCache!.isVip = fakeVip;
      }
    } else {
      final cancelVip = await ApiVip().getcancelTryalVip();
      if (cancelVip == 3) {
        this.userCache!.isVip = cancelVip;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(userCache!));
  }

  updateTotalExp(int totalExp) async {
    this.userCache!.totalExp = totalExp;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(userCache!));
  }

  updateSocial(userData) async {
    this.userCache = userData;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(userCache!));
  }

  updateConfirmMail() async {
    this.userCache!.activeEmail = 1;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(userCache!));
  }

  getUserData() {
    return this.userCache != null ? this.userCache : null;
  }

  modifierUserData({int? totalTalk, int? totalVideo, int? totalVideoVip}) {
    this.userCache!.totalTalkComplete =
        totalTalk ?? this.userCache!.totalTalkComplete;
    this.userCache!.totalVideoComplete =
        totalVideo ?? this.userCache!.totalVideoComplete;
    this.userCache!.totalVideoPlus =
        totalVideoVip ?? this.userCache!.totalVideoPlus;
  }

  setListTalkFollow(List<TalkFollowLogModel> data) {
    this.listTalkFollowLog = data;
  }

  getListTalkFollow() {
    return this.listTalkFollowLog;
  }

  insertTalkFollowLog(TalkFollowLogModel newTalkFollowLog) {
    bool isNew = true;
    this.listTalkFollowLog.forEach((element) {
      if (newTalkFollowLog.idTalkLog == element.idTalkLog) {
        isNew = false;
      }
    });
    if (isNew) {
      this.listTalkFollowLog.add(newTalkFollowLog);
      printYellow("INSERT DATA TO CACHE OK");
    }
  }

  removeTalkFollowLog(TalkFollowLogModel newTalkFollowLog) {
    bool isNew = false;
    this.listTalkFollowLog.forEach((element) async {
      if (newTalkFollowLog.idTalkLog == element.idTalkLog) {
        isNew = true;
      }
      if (isNew) {
        this.listTalkFollowLog.remove(newTalkFollowLog);
        printYellow("remove DATA TO CACHE OK");
      }
    });
  }

  updateTalkFollowLog(TalkFollowLogModel newTalkFollowLog) {
    this.listTalkFollowLog.forEach((element) {
      if (newTalkFollowLog.idTalkLog == element.idTalkLog) {
        newTalkFollowLog.setSatus(0);
      }
    });
  }

  updateTalkLikeLog(TalkFollowLogModel newTalkFollowLog) {
    this.listTalkFollowLog.forEach((element) {
      if (newTalkFollowLog.idTalkLog == element.idTalkLog) {
        newTalkFollowLog.setSatusLike(0);
      }
    });
  }

  Future<bool> getTalkFollowStatus(int uid, int talkId) async {
    bool isFollow = false;
    this.listTalkFollowLog.forEach((element) {
      if (element.talkId == talkId && element.uid == uid && element.type == 1) {
        isFollow = element.isFollow == 1 ? true : false;
      }
    });
    if (isFollow == false) {
      var status = await TalkAPIs().checkFollowTalk(talkId, uid);
      if (status == 1) {
        isFollow = true;
      } else if (status == 0) {
        isFollow = false;
      }
    }
    return isFollow;
  }

  Future<bool> getTalkLikeStatus(int uid, int talkId) async {
    bool isLike = false;
    this.listTalkFollowLog.forEach((element) {
      if (element.talkId == talkId && element.uid == uid && element.type == 2) {
        isLike = element.isLike == 1 ? true : false;
      }
    });
    if (isLike == false) {
      var status = await TalkAPIs().checkLikeTalk(talkId, uid);
      if (status == 1) {
        isLike = true;
      } else if (status == 0) {
        isLike = false;
      }
    }
    return isLike;
  }

  Future<bool> getSubChannelHasData(int cId) async {
    bool isActive = false;
    if (this._channelHasData != null) {
      printRed(this._channelHasData!.listCatgoryFollow.toString());
      this._channelHasData!.listCatgoryFollow.forEach((element) {
        if (element.id == cId) {
          isActive = true;
        }
      });
    } else {
      DataUser dataUser = this.getUserData();
      int idUser = dataUser.uid;
      await TalkAPIs().fetchSubChannelFromApi(idUser);
      if (_channelHasData != null) {
        this._channelHasData!.listCatgoryFollow.forEach((element) {
          if (element.id == cId) {
            isActive = true;
          }
        });
      }
    }

    return isActive;
  }

  setDataHome(DataHome? data) {
    this._dataHomeCache = data;
  }

  modifierDataHomeWithNewVideo(List<DataTalk> listNewVideo) {
    for (var i = 0; i < listNewVideo.length; i++) {
      this._dataHomeCache!.listTalkNew.add(listNewVideo[i]);
    }
  }

  modifierDataHomeWithCategory(List<Category> listCategory) {
    for (var i = 0; i < listCategory.length; i++) {
      this._dataHomeCache!.listCatgory.add(listCategory[i]);
    }
  }

  modifierDataHomeWithSuggest(List<DataTalk> listSuggest) {
    for (var i = 0; i < listSuggest.length; i++) {
      this._dataHomeCache!.dataSugges.add(listSuggest[i]);
    }
  }

  DataHome? getDataHome() {
    return this._dataHomeCache;
  }

  setChannelHasData(SubChannelData data) {
    this._channelHasData = data;
  }

  getChannelHasData() {
    return this._channelHasData;
  }

  setListCategory(List<Category> data) {
    this._listCategory = data;
  }

  getListCategory() {
    return this._listCategory;
  }

  setListQuiz(List<TalkDetailQuizModel>? data) {
    this._listQuiz = data;
  }

  getListQuiz() {
    return this._listQuiz;
  }

  setListSpeakHome(List<Lists> dataNew) {
    this._listSpeakHome = dataNew;
  }

  getListSpeakHome() {
    return this._listSpeakHome;
  }

  setSearchIndex(DataSearchIndex data) {
    this.dataSearchIndex = data;
  }

  getSearchIndex() {
    return this.dataSearchIndex;
  }

  setListTextReview(DataTextReview data) {
    this.listTextReview = data;
  }

  setListVideoReview(DataVideoReview data) {
    this.listVideoReview = data;
  }

  insertListTextReview(TextReview newTextReview) {
    this.listTextReview?.textReview.add(newTextReview);
  }

  insertListVideoReview(VideoReview newVideoReview) {
    this.listVideoReview?.videoReview.add(newVideoReview);
  }

  insertDataSubChannel(Category newCateFollow) {
    if (this._channelHasData == null) {
      printCyan("VAO CHECK NULL");
      this._channelHasData =
          new SubChannelData(listCatgoryFollow: [], listTalk: []);
      this._channelHasData!.listCatgoryFollow.add(newCateFollow);
    } else {
      //check isNew
      this._channelHasData!.listCatgoryFollow.add(newCateFollow);
    }
    printBlue(this._channelHasData!.listCatgoryFollow.length.toString());
  }

  getLengthChannel() {
    return this._channelHasData!.listCatgoryFollow.length;
  }

  getlistCatgoryFollow() {
    return this._channelHasData!.listCatgoryFollow;
  }

  removeDataSubChannel(CateFollow newCateFollow) {
    bool isNew = false;
    this._channelHasData!.listCatgoryFollow.forEach((element) async {
      if (newCateFollow.id == element.id) {
        isNew = true;
      }
      if (isNew) {
        this._channelHasData!.listCatgoryFollow.remove(element);
        // printYellow("remove DATA  SUB  CHANNEL TO CACHE OK");
        printRed(this._channelHasData!.listCatgoryFollow.length.toString());
      }
    });
  }

  bool checkSentenceVideo(TalkDetailModel sub, int type) {
    var status = false;
    // print('Đây là list text: ' + this.listTextReview.toString());
    this.listTextReview?.textReview.forEach((element) {
      if (sub.id == element.ttdid && element.type == type) {
        status = true;
      }
    });
    return status;
  }

  Future<bool> checkReviewVideo(DataTalk sub) async {
    bool status = false;
    this.listVideoReview?.videoReview.forEach((element) {
      if (sub.id == element.id) {
        status = true;
      } else {}
    });
    return status;
  }

  Future<void> uncheckReviewVideo(DataTalk sub) async {
    this.listVideoReview!.videoReview.forEach((element) {
      if (sub.id == element.id) {
        this.listVideoReview!.videoReview.remove(element);
      } else {}
    });
  }

  Future<bool> deleteSentence(TextReview sentence) async {
    this
        .listTextReview
        ?.textReview
        .removeWhere((element) => sentence.ttrid == element.ttrid);
    return true;
  }

  Future<DataTextReview> getListTextReview() async {
    if (this.listTextReview != null) {
      return this.listTextReview!;
    } else {
      var data = await TalkAPIs().fetchReviewTextData(userData: this.userCache);
      this.listTextReview =
          data != null ? data : new DataTextReview(textReview: []);
      return this.listTextReview!;
    }
  }

  Future<DataVideoReview>? getListVideoReview() async {
    if (this.listVideoReview != null) {
      return this.listVideoReview!;
    } else {
      var data =
          await TalkAPIs().fetchReviewVideoData(userData: this.userCache);
      this.listVideoReview =
          data != null ? data : new DataVideoReview(videoReview: []);
      return this.listVideoReview!;
    }
  }

  insertTalkDetailToList(TalkCacheModel talkCacheDetail) {
    talkCacheDetail.toJSON();
    bool isNew = true;
    this.listTalkCache.forEach((element) {
      if (talkCacheDetail.getIdTalk() == element.getIdTalk()) {
        isNew = false;
      }
    });
    if (isNew) {
      this.listTalkCache.add(talkCacheDetail);
      printYellow("INSERT DATA TO CACHE OK");
    }
  }

  getAllDataTalkDetail() {
    return this.listTalkCache;
  }

  Future<TalkCacheModel> getTalkDetailByIdInCache(
      int talkDetailId, String langCode) async {
    var res = new TalkCacheModel();
    this.listTalkCache.forEach((element) {
      printGreen(element.getIdTalk().toString());
      if (element.getIdTalk() == talkDetailId) {
        res = element;
      }
    });
    // lấy data từ list nếu không có thì load từ API về
    if (res.getIdTalk() == null) {
      var snapot = await TalkAPIs().getListSubVideo(talkDetailId, langCode);
      res.setIdTalk(talkDetailId);
      res.setListSub(snapot);
      this.insertTalkDetailToList(res);
      return res;
    } else {
      return res;
    }
  }

  insertTalkTextDetailToList(TalkTextCacheModel talkTextCacheDetail) {
    talkTextCacheDetail.toJSON();
    bool isNew = true;
    this.listTalkTextCache.forEach((element) {
      if (talkTextCacheDetail.getIdTalk() == element.getIdTalk()) {
        isNew = false;
      }
    });
    if (isNew) {
      this.listTalkTextCache.add(talkTextCacheDetail);
      printYellow("INSERT DATA TO CAC HE OK");
    }
  }

  getAllDataTalkTextDetail() {
    return this.listTalkTextCache;
  }

  Future<TalkTextCacheModel> getTalkTextDetailByIdInCache(
      String talkTextDetailId) async {
    var res = TalkTextCacheModel();
    this.listTalkTextCache.forEach((element) {
      printGreen(element.getIdTalk().toString());
      if (element.getIdTalk() == talkTextDetailId) {
        res = element;
      }
    });
    // lấy data từ list nếu không có thì load từ API về
    if (res.getIdTalk() == null) {
      var snapot = await TalkAPIs().getTalkTalkDetail(talkTextDetailId);
      res.setIdTalk(int.parse(talkTextDetailId));
      res.setListSub(snapot);
      this.insertTalkTextDetailToList(res);
      return res;
    } else {
      return res;
    }
  }

  insertNewWordToList(NewWordCacheModel newWordCacheModel) {
    bool isNew = true;
    this.listNewWordCache.forEach((element) {
      if (newWordCacheModel.getIdSub() == element.getIdSub()) {
        isNew = false;
      }
    });
    if (isNew) {
      this.listNewWordCache.add(newWordCacheModel);
      printYellow("INSERT DATA TO CACHE OK");
    }
  }

  getAllDataNewWord() {
    return this.listNewWordCache;
  }

  Future<NewWordCacheModel> getListNewWordByIdInCache(int idSub) async {
    var res = new NewWordCacheModel();
    this.listNewWordCache.forEach((element) {
      if (element.getIdSub() == idSub) {
        res = element;
      }
    });
    // lấy data từ list nếu không có thì load từ API về
    if (res.getIdSub() == null) {
      var snapot = await TalkAPIs().getListNewWordSentence(talkTextId: idSub);
      if (snapot != null) {
        res.setIdSub(idSub);
        res.setListNewWord(snapot.listNewWord);
        this.insertNewWordToList(res);
      }
      return res;
    } else {
      return res;
    }
  }

  setUserTargetLogModel(UserTargetLogModel data) {
    this.userTargetModel = data;
  }

  setSetTarget(int targetKey) {
    ItemTargetModel targetData = TargetOffline().geTargetByKey(targetKey);
    this.userTargetModel!.targetData = targetData;
  }

  getUserTargetLogModel() {
    return this.userTargetModel;
  }
}
