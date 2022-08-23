import 'dart:math';
import 'dart:io';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/CateFollowModel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/CountryAll.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/TalkTextDetailModel.dart';
import 'package:app_learn_english/models/history_speak_model.dart';
import 'package:app_learn_english/models/quiz/quiz_lotti_model.dart';
import 'package:app_learn_english/models/quiz/talk_detail_quiz_model.dart';
import 'package:app_learn_english/models/speak_home_model.dart';

import 'package:app_learn_english/presentation/speak/provider/course_trinhdo.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static String titleLanguage(String regionCode) {
    String languageCode;

    switch (regionCode) {
      case 'VN':
        languageCode = 'vi';
        break;
      case 'RU':
        languageCode = 'ru';
        break;
      case 'ES':
        languageCode = 'es';
        break;
      case 'CN':
        languageCode = 'zh';
        break;
      case 'JP':
        languageCode = 'ja';
        break;
      case 'IN':
        languageCode = 'hi';
        break;
      case 'TR':
        languageCode = 'tr';
        break;
      case 'PT':
        languageCode = 'pt';
        break;
      case 'ID':
        languageCode = 'id';
        break;
      case 'TH':
        languageCode = 'th';
        break;
      case 'MY':
        languageCode = 'ms';
        break;
      case 'SA':
        languageCode = 'ar';
        break;
      case 'EG':
        languageCode = 'ar';
        break;
      case 'AE':
        languageCode = 'ar';
        break;
      case 'JO':
        languageCode = 'ar';
        break;
      case 'DZ':
        languageCode = 'ar';
        break;
      case 'SD':
        languageCode = 'ar';
        break;
      case 'IQ':
        languageCode = 'ar';
        break;
      case 'SY':
        languageCode = 'ar';
        break;
      case 'TN':
        languageCode = 'ar';
        break;
      case 'FR':
        languageCode = 'fr';
        break;
      case 'IT':
        languageCode = 'it';
        break;
      case 'DE':
        languageCode = 'de';
        break;
      case 'KR':
        languageCode = 'ko';
        break;
      case 'TW':
        languageCode = 'zh_Hant_TW';
        break;
      case 'SK':
        languageCode = 'sk';
        break;
      case 'SI':
        languageCode = 'sl';
        break;
      default:
        languageCode = 'en';
        break;
    }
    return languageCode;
  }

  static String changeLanguageChannelName(String languageCode, Category cate) {
    String sample = '';
    switch (languageCode) {
      case 'en':
        sample = cate.name;
        break;
      case 'ru':
        sample = cate.name_ru;
        break;
      case 'vi':
        sample = cate.name_vi;
        break;
      case 'es':
        sample = cate.name_es;
        break;
      case 'hi':
        sample = cate.name_hi;
        break;
      case 'ja':
        sample = cate.name_ja;
        break;
      case 'zh':
        sample = cate.name_zh;
        break;
      case 'tr':
        sample = cate.name_tr;
        break;
      case 'pt':
        sample = cate.name_pt;
        break;
      case 'id':
        sample = cate.name_id;
        break;
      case 'th':
        sample = cate.name_th;
        break;
      case 'ms':
        sample = cate.name_ms;
        break;
      case 'ar':
        sample = cate.name_ar;
        break;
      case 'fr':
        sample = cate.name_fr;
        break;
      case 'it':
        sample = cate.name_it;
        break;
      case 'de':
        sample = cate.name_de;
        break;
      case 'ko':
        sample = cate.name_ko;
        break;
      case 'zh_Hant_TW':
        sample = cate.name_zh_Hant_TW;
        break;
      case 'sk':
        sample = cate.name_sk;
        break;
      case 'sl':
        sample = cate.name_sl;
    }
    return sample;
  }

  static String changeLanguageChannelNameFollow(
      String languageCode, CateFollow cate) {
    String sample = '';
    switch (languageCode) {
      case 'en':
        sample = cate.name;
        break;
      case 'ru':
        sample = cate.name_ru;
        break;
      case 'vi':
        sample = cate.name_vi;
        break;
      case 'es':
        sample = cate.name_es;
        break;
      case 'hi':
        sample = cate.name_hi;
        break;
      case 'ja':
        sample = cate.name_ja;
        break;
      case 'zh':
        sample = cate.name_zh;
        break;
      case 'tr':
        sample = cate.name_tr;
        break;
      case 'pt':
        sample = cate.name_pt;
        break;
      case 'id':
        sample = cate.name_id;
        break;
      case 'th':
        sample = cate.name_th;
        break;
      case 'ms':
        sample = cate.name_ms;
        break;
      case 'ar':
        sample = cate.name_ar;
        break;
      case 'fr':
        sample = cate.name_fr;
        break;
      case 'it':
        sample = cate.name_it;
        break;
      case 'de':
        sample = cate.name_de;
        break;
      case 'ko':
        sample = cate.name_ko;
        break;
      case 'zh_Hant_TW':
        sample = cate.name_zh_Hant_TW;
        break;
      case 'sk':
        sample = cate.name_sk;
        break;
      case 'sl':
        sample = cate.name_sl;
    }
    return sample;
  }

  static String changeLanguageChannelDescription(
      String languageCode, Category cate) {
    String sample = '';
    switch (languageCode) {
      case 'en':
        sample = cate.description;
        break;
      case 'ru':
        sample = cate.description_ru;
        break;
      case 'vi':
        sample = cate.description_vi;
        break;
      case 'es':
        sample = cate.description_es;
        break;
      case 'hi':
        sample = cate.description_hi;
        break;
      case 'ja':
        sample = cate.description_ja;
        break;
      case 'zh':
        sample = cate.description_zh;
        break;
      case 'tr':
        sample = cate.description_tr;
        break;
      case 'pt':
        sample = cate.description_pt;
        break;
      case 'id':
        sample = cate.description_id;
        break;
      case 'th':
        sample = cate.description_th;
        break;
      case 'ms':
        sample = cate.description_ms;
        break;
      case 'ar':
        sample = cate.description_ar;
        break;
      case 'fr':
        sample = cate.description_fr;
        break;
      case 'it':
        sample = cate.description_it;
        break;
      case 'de':
        sample = cate.description_de;
        break;
      case 'ko':
        sample = cate.description_ko;
        break;
      case 'zh_Hant_TW':
        sample = cate.description_zh_Hant_TW;
        break;
      case 'sk':
        sample = cate.description_sk;
        break;
      case 'sl':
        sample = cate.description_sl;
    }
    return sample;
  }

  static String changeLanguageVideo(
      String languageCode, int index, List<TalkDetailModel> listSub) {
    String sample = '';
    switch (languageCode) {
      case 'en':
        sample = listSub[index].content;
        break;
      case 'ru':
        sample = listSub[index].content_ru;
        break;
      case 'vi':
        sample = listSub[index].content_vi;
        break;
      case 'es':
        sample = listSub[index].content_es;
        break;
      case 'hi':
        sample = listSub[index].content_hi;
        break;
      case 'ja':
        sample = listSub[index].content_ja;
        break;
      case 'zh':
        sample = listSub[index].content_zh;
        break;
      case 'tr':
        sample = listSub[index].content_tr;
        break;
      case 'pt':
        sample = listSub[index].content_pt;
        break;
      case 'id':
        sample = listSub[index].content_id;
        break;
      case 'th':
        sample = listSub[index].content_th;
        break;
      case 'ms':
        sample = listSub[index].content_ms;
        break;
      case 'ar':
        sample = listSub[index].content_ar;
        break;
      case 'fr':
        sample = listSub[index].content_fr;
        break;
      case 'it':
        sample = listSub[index].content_it;
        break;
      case 'de':
        sample = listSub[index].content_de;
        break;
      case 'ko':
        sample = listSub[index].content_ko;
        break;
      case 'zh_Hant_TW':
        sample = listSub[index].content_zh_Hant_TW;
        break;
      case 'sk':
        sample = listSub[index].content_sk;
        break;
      case 'sl':
        sample = listSub[index].content_sl;
        break;
      case 'el':
        sample = listSub[index].content_el;
        break;
      case 'nl':
        sample = listSub[index].content_nl;
        break;
      case 'kk':
        sample = listSub[index].content_kk;
        break;
      case 'pl':
        sample = listSub[index].content_pl;
        break;
      case 'bn':
        sample = listSub[index].content_bn;
        break;
      case 'ur':
        sample = listSub[index].content_ur;
        break;
      case 'ro':
        sample = listSub[index].content_ro;
        break;
      case 'uk':
        sample = listSub[index].content_uk;
        break;
      case 'uz':
        sample = listSub[index].content_uz;
        break;
      case 'af':
        sample = listSub[index].content_af;
        break;
      case 'az':
        sample = listSub[index].content_az;
        break;
      case 'bs':
        sample = listSub[index].content_bs;
        break;
      case 'bg':
        sample = listSub[index].content_bg;
        break;
      case 'hr':
        sample = listSub[index].content_hr;
        break;
      case 'cs':
        sample = listSub[index].content_cs;
        break;
      case 'da':
        sample = listSub[index].content_da;
        break;
      case 'fl':
        sample = listSub[index].content_fl;
        break;
      case 'ht':
        sample = listSub[index].content_ht;
        break;
      case 'cre':
        sample = listSub[index].content_cre;
        break;
      case 'he':
        sample = listSub[index].content_he;
        break;
      case 'hu':
        sample = listSub[index].content_hu;
        break;
      case 'lv':
        sample = listSub[index].content_lv;
        break;
      case 'no':
        sample = listSub[index].content_no;
        break;
      case 'sr':
        sample = listSub[index].content_sr;
        break;
    }
    return sample;
  }

  static String changeLanguage(
      String languageCode, int index, List<HistorySpeakModel> historyTextTalk) {
    String sample = '';

    switch (languageCode) {
      case 'en':
        sample = historyTextTalk[index].textTalk.name;
        break;
      case 'ru':
        sample = historyTextTalk[index].textTalk.name_ar;
        break;
      case 'vi':
        sample = historyTextTalk[index].textTalk.name_vi;
        break;
      case 'es':
        sample = historyTextTalk[index].textTalk.name_es;
        break;
      case 'hi':
        sample = historyTextTalk[index].textTalk.name_hi;
        break;
      case 'ja':
        sample = historyTextTalk[index].textTalk.name_ja;
        break;
      case 'zh':
        sample = historyTextTalk[index].textTalk.name_zh;
        break;
      case 'tr':
        sample = historyTextTalk[index].textTalk.name_tr;
        break;
      case 'pt':
        sample = historyTextTalk[index].textTalk.name_pt;
        break;
      case 'id':
        sample = historyTextTalk[index].textTalk.name_id;
        break;
      case 'th':
        sample = historyTextTalk[index].textTalk.name_th;
        break;
      case 'ms':
        sample = historyTextTalk[index].textTalk.name_ms;
        break;
      case 'ar':
        sample = historyTextTalk[index].textTalk.name_ar;
        break;
      case 'fr':
        sample = historyTextTalk[index].textTalk.name_fr;
        break;
      case 'it':
        sample = historyTextTalk[index].textTalk.name_it;
        break;
      case 'de':
        sample = historyTextTalk[index].textTalk.name_de;
        break;
      case 'ko':
        sample = historyTextTalk[index].textTalk.name_ko;
        break;
      case 'zh_Hant_TW':
        sample = historyTextTalk[index].textTalk.name_zh_Hant_TW;
        break;
      case 'sk':
        sample = historyTextTalk[index].textTalk.name_sk;
        break;
      case 'sl':
        sample = historyTextTalk[index].textTalk.name_sl;
        break;
      default:
    }

    return sample;
  }

  static String changeLanguageTalkName(String languageCode, DataTalk talk) {
    String sample = '';
    switch (languageCode) {
      case 'en':
        sample = talk.name;
        break;
      case 'ru':
        sample = talk.name_ru;
        break;
      case 'vi':
        sample = talk.name_vi;
        break;
      case 'es':
        sample = talk.name_es;
        break;
      case 'hi':
        sample = talk.name_hi;
        break;
      case 'ja':
        sample = talk.name_ja;
        break;
      case 'zh':
        sample = talk.name_zh;
        break;
      case 'tr':
        sample = talk.name_tr;
        break;
      case 'pt':
        sample = talk.name_pt;
        break;
      case 'id':
        sample = talk.name_id;
        break;
      case 'th':
        sample = talk.name_th;
        break;
      case 'ms':
        sample = talk.name_ms;
        break;
      case 'ar':
        sample = talk.name_ar;
        break;
      case 'fr':
        sample = talk.name_fr;
        break;
      case 'it':
        sample = talk.name_it;
        break;
      case 'de':
        sample = talk.name_de;
        break;
      case 'ko':
        sample = talk.name_ko;
        break;
      case 'zh_Hant_TW':
        sample = talk.name_zh_Hant_TW;
        break;
      case 'sk':
        sample = talk.name_sk;
        break;
      case 'sl':
        sample = talk.name_sl;
    }
    return sample;
  }

  static String changeLanguageTalkShowModel(
      String languageCode, int index, List<TalkDetailModel> talk) {
    String sample = '';
    switch (languageCode) {
      case 'en':
        sample = talk[index].content;
        break;
      case 'ru':
        sample = talk[index].content_ru;
        break;
      case 'vi':
        sample = talk[index].content_vi;
        break;
      case 'es':
        sample = talk[index].content_es;
        break;
      case 'hi':
        sample = talk[index].content_hi;
        break;
      case 'ja':
        sample = talk[index].content_ja;
        break;
      case 'zh':
        sample = talk[index].content_zh;
        break;
      case 'tr':
        sample = talk[index].content_tr;
        break;
      case 'pt':
        sample = talk[index].content_pt;
        break;
      case 'id':
        sample = talk[index].content_id;
        break;
      case 'th':
        sample = talk[index].content_th;
        break;
      case 'ms':
        sample = talk[index].content_ms;
        break;
      case 'ar':
        sample = talk[index].content_ar;
        break;
      case 'fr':
        sample = talk[index].content_fr;
        break;
      case 'it':
        sample = talk[index].content_it;
        break;
      case 'de':
        sample = talk[index].content_de;
        break;
      case 'ko':
        sample = talk[index].content_ko;
        break;
      case 'zh_Hant_TW':
        sample = talk[index].content_zh_Hant_TW;
        break;
      case 'sk':
        sample = talk[index].content_sk;
        break;
      case 'sl':
        sample = talk[index].content_sl;
    }
    return sample;
  }

  static String? changeLanguageSpeakHome(String languageCode, Lists talk) {
    String? sample = '';
    switch (languageCode) {
      case 'en':
        sample = talk.name;
        break;
      case 'ru':
        sample = talk.name_ru;
        break;
      case 'vi':
        sample = talk.name_vi;
        break;
      case 'es':
        sample = talk.name_es;
        break;
      case 'hi':
        sample = talk.name_hi;
        break;
      case 'ja':
        sample = talk.name_ja;
        break;
      case 'zh':
        sample = talk.name_zh;
        break;
      case 'tr':
        sample = talk.name_tr;
        break;
      case 'pt':
        sample = talk.name_pt;
        break;
      case 'id':
        sample = talk.name_id;
        break;
      case 'th':
        sample = talk.name_th;
        break;
      case 'ms':
        sample = talk.name_ms;
        break;
      case 'ar':
        sample = talk.name_ar;
        break;
      case 'fr':
        sample = talk.name_fr;
        break;
      case 'it':
        sample = talk.name_it;
        break;
      case 'de':
        sample = talk.name_de;
        break;
      case 'ko':
        sample = talk.name_ko;
        break;
      case 'zh_Hant_TW':
        sample = talk.name_zh_Hant_TW;
        break;
      case 'sk':
        sample = talk.name_sk;
        break;
      case 'sl':
        sample = talk.name_sl;
    }
    return sample;
  }

  static String changeLanguageLuyenDoc(
      String languageCode, TrinhDoCourse talk) {
    String sample = '';
    switch (languageCode) {
      case 'en':
        sample = talk.name;
        break;
      case 'ru':
        sample = talk.name_ru;
        break;
      case 'vi':
        sample = talk.name_vi;
        break;
      case 'es':
        sample = talk.name_es;
        break;
      case 'hi':
        sample = talk.name_hi;
        break;
      case 'ja':
        sample = talk.name_ja;
        break;
      case 'zh':
        sample = talk.name_zh;
        break;
      case 'tr':
        sample = talk.name_tr;
        break;
      case 'pt':
        sample = talk.name_pt;
        break;
      case 'id':
        sample = talk.name_id;
        break;
      case 'th':
        sample = talk.name_th;
        break;
      case 'ms':
        sample = talk.name_ms;
        break;
      case 'ar':
        sample = talk.name_ar;
        break;
      case 'fr':
        sample = talk.name_fr;
        break;
      case 'it':
        sample = talk.name_it;
        break;
      case 'de':
        sample = talk.name_de;
        break;
      case 'ko':
        sample = talk.name_ko;
        break;
      case 'zh_Hant_TW':
        sample = talk.name_zh_Hant_TW;
        break;
      case 'sk':
        sample = talk.name_sk;
        break;
      case 'sl':
        sample = talk.name_sl;
    }
    return sample;
  }

  static int randomNum(List<String> words) {
    Random random = Random();
    int numRandom = random.nextInt(words.length);
    if (words[numRandom].length < 2)
      return randomNum(words);
    else
      return numRandom;
  }

  static int getPlatfromID() {
    if (Platform.isAndroid) {
      return 1;
    } else if (Platform.isIOS) {
      return 2;
    } else {
      return 3;
    }
  }

  static String buildNameTalkWithRandomWord(String name) {
    List<String> words = name.split(' ');
    print('Đây là words này: $words');

    int ranNumber = randomNum(words);
    words[ranNumber] = List.generate(words[ranNumber].length, (index) => '_')
        .toList()
        .join('');
    return words.join(' ');
  }

  showNotificationBottom(bool isSuccess, String title) {
    showSimpleNotification(
      Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: isSuccess ? Colors.green : Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(title),
        ),
      ),
      background: Colors.transparent,
      position: NotificationPosition.bottom,
    );
  }

  showNotificationTop(bool isSuccess, String title) {
    showSimpleNotification(
      Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: isSuccess ? Colors.green : Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Row(
            children: [
              Image.asset(
                'assets/new_ui/more/ic_splash.png',
                width: 60,
                height: 60,
              ),
              SizedBox(
                width: 10,
              ),
              Text(title),
            ],
          ),
        ),
      ),
      duration: Duration(seconds: 3),
      background: Colors.transparent,
      position: NotificationPosition.top,
    );
  }

  getPermissionRecord() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      print(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
  }

  /// Random lại các phần tử trong list
  List<String> shuffle(List<String> array) {
    var random = Random(); //import 'dart:math';

    // Go through all elementsof list
    for (var i = array.length - 1; i > 0; i--) {
      // Pick a random number according to the lenght of list
      var n = random.nextInt(i + 1);
      var temp = array[i];
      array[i] = array[n];
      array[n] = temp;
    }
    return array;
  }

  List<TalkDetailQuizModel> convertListQuiz(List<TalkDetailModel> listSub) {
    List<TalkDetailQuizModel> listSubNew = [];
    for (var item in listSub) {
      listSubNew.add(item.convertToTalkDetailQuiz());
    }
    return listSubNew;
  }

  List<CountryModel> listCountryMain() {
    List<CountryModel> listCountryMain = [
      CountryModel(
        id: 1,
        sortname: 'VI',
        name: 'Tiếng Việt',
        status: 0,
      ),
      CountryModel(
        id: 2,
        sortname: 'ID',
        name: 'Bahasa Indonesia',
        status: 0,
      ),
      CountryModel(
        id: 3,
        sortname: 'ZH',
        name: 'Chinese',
        status: 1,
      ),
      CountryModel(
        id: 4,
        sortname: 'JA',
        name: 'Japanese',
        status: 1,
      ),
      CountryModel(
        id: 5,
        sortname: 'KO',
        name: 'Korean',
        status: 1,
      ),
      CountryModel(
        id: 6,
        sortname: 'SL',
        name: 'Slovenian',
        status: 1,
      ),
      CountryModel(
        id: 7,
        sortname: 'RU',
        name: 'Русский',
        status: 1,
      ),
      CountryModel(
        id: 8,
        sortname: 'TH',
        name: 'Thai language',
        status: 1,
      ),
      CountryModel(
        id: 10,
        sortname: 'AR',
        name: 'Arabia',
        status: 1,
      ),
      CountryModel(
        id: 11,
        sortname: 'FR',
        name: 'Français',
        status: 1,
      ),
      CountryModel(
        id: 12,
        sortname: 'IT',
        name: 'Italiano',
        status: 1,
      ),
      CountryModel(
        id: 13,
        sortname: 'DE',
        name: 'Deutsch',
        status: 1,
      ),
      CountryModel(
        id: 14,
        sortname: 'TR',
        name: 'Türkçe',
        status: 1,
      ),
      CountryModel(
        id: 15,
        sortname: 'HI',
        name: 'Hindi',
        status: 1,
      ),
      CountryModel(
        id: 16,
        sortname: 'ES',
        name: 'Español (LATAM)',
        status: 1,
      ),
      CountryModel(
        id: 17,
        sortname: 'PT',
        name: 'Português (BR)',
        status: 1,
      ),
      CountryModel(
        id: 18,
        sortname: 'zh_Hant_TW',
        name: 'Chinese (Taiwan)',
        status: 1,
      ),
      CountryModel(
        id: 43,
        sortname: 'SK',
        name: 'Slovak',
        status: 1,
      ),
      CountryModel(
        id: 44,
        sortname: 'MS',
        name: 'Malaysia',
        status: 1,
      ),
      CountryModel(
        id: 45,
        sortname: 'EN',
        name: 'English',
        status: 1,
      ),
      CountryModel(
        id: 46,
        sortname: 'insetLang',
        name: 'InsetView',
        status: 1,
      ),
    ];
    return listCountryMain;
  }

  List<CountryModel> listCountryModel() {
    List<CountryModel> listCountry = [
      CountryModel(
        id: 19,
        sortname: 'EL',
        name: 'Greek',
        status: 1,
      ),
      CountryModel(
        id: 20,
        sortname: 'NL',
        name: 'Dutch',
        status: 1,
      ),
      CountryModel(
        id: 21,
        sortname: 'KK',
        name: 'Kazakh',
        status: 1,
      ),
      CountryModel(
        id: 22,
        sortname: 'PL',
        name: 'Polish',
        status: 1,
      ),
      CountryModel(
        id: 23,
        sortname: 'BN',
        name: 'Bengali',
        status: 1,
      ),
      CountryModel(
        id: 24,
        sortname: 'UR',
        name: 'Urdu',
        status: 1,
      ),
      CountryModel(
        id: 25,
        sortname: 'RO',
        name: 'Romanian',
        status: 1,
      ),
      CountryModel(
        id: 26,
        sortname: 'UK',
        name: 'Ukrainian',
        status: 1,
      ),
      CountryModel(
        id: 27,
        sortname: 'UZ',
        name: 'Uzbek',
        status: 1,
      ),
      CountryModel(
        id: 28,
        sortname: 'AF',
        name: 'Afrikaans',
        status: 1,
      ),
      CountryModel(
        id: 29,
        sortname: 'AZ',
        name: 'Azerbaijani',
        status: 1,
      ),
      CountryModel(
        id: 30,
        sortname: 'BS',
        name: 'Bosnian',
        status: 1,
      ),
      CountryModel(
        id: 31,
        sortname: 'BG',
        name: 'Bulgarian',
        status: 1,
      ),
      CountryModel(
        id: 32,
        sortname: 'HR',
        name: 'Croatian',
        status: 1,
      ),
      CountryModel(
        id: 33,
        sortname: 'CS',
        name: 'Czech',
        status: 1,
      ),
      CountryModel(
        id: 34,
        sortname: 'DA',
        name: 'Danish',
        status: 1,
      ),
      CountryModel(
        id: 35,
        sortname: 'FL',
        name: 'Finnish',
        status: 1,
      ),
      CountryModel(
        id: 36,
        sortname: 'HT',
        name: 'Haitian',
        status: 1,
      ),
      CountryModel(
        id: 37,
        sortname: 'CRE',
        name: 'Creole',
        status: 1,
      ),
      CountryModel(
        id: 38,
        sortname: 'HE',
        name: 'Hebrew',
        status: 1,
      ),
      CountryModel(
        id: 39,
        sortname: 'HU',
        name: 'Hungarian',
        status: 1,
      ),
      CountryModel(
        id: 40,
        sortname: 'LV',
        name: 'Lithuanian',
        status: 1,
      ),
      CountryModel(
        id: 41,
        sortname: 'NO',
        name: 'Norwegian',
        status: 1,
      ),
      CountryModel(
        id: 42,
        sortname: 'SR',
        name: 'Serbian',
        status: 1,
      ),
    ];

    return listCountry;
  }

  bool checkLanguage(String languageCode) {
    bool isCheck = false;
    for (var item in listCountryModel()) {
      if (item.sortname.toLowerCase() == languageCode.toLowerCase()) {
        isCheck = true;
        break;
      }
    }
    return isCheck;
  }

  static String nameCountry(String languageCode) {
    String sample = '';
    switch (languageCode) {
      case 'en':
        sample = 'English';
        break;
      case 'ru':
        sample = 'Россия';
        break;
      case 'vi':
        sample = 'Việt Nam';
        break;
      case 'es':
        sample = 'España';
        break;
      case 'hi':
        sample = 'भारत';
        break;
      case 'ja':
        sample = '日本';
        break;
      case 'zh':
        sample = '英語';
        break;
      case 'tr':
        sample = 'İngilizce';
        break;
      case 'id':
        sample = 'bahasa';
        break;
      case 'th':
        sample = 'ภาษาอังกฤษ';
        break;
      case 'ms':
        sample = 'Inggeris';
        break;
      case 'ar':
        sample = 'إنجليزي';
        break;
      case 'fr':
        sample = 'Anglais';
        break;
      case 'it':
        sample = 'Linglese';
        break;
      case 'de':
        sample = 'Het Engels';
        break;
      case 'ko':
        sample = '영어';
        break;
      case 'zh_Hant_TW':
        sample = '英語';
        break;
      case 'sk':
        sample = 'Angličtina';
        break;
      case 'sl':
        sample = 'Angleščina';
        break;
      case 'el':
        sample = 'Greek';
        break;
      case 'nl':
        sample = 'Dutch';
        break;
      case 'kk':
        sample = 'Kazakh';
        break;
      case 'pl':
        sample = 'Polish';
        break;
      case 'bn':
        sample = 'Bengali';
        break;
      case 'ur':
        sample = 'Urdu';
        break;
      case 'ro':
        sample = 'Romanian';
        break;
      case 'uk':
        sample = 'Ukrainian';
        break;
      case 'uz':
        sample = 'Uzbek';
        break;
      case 'af':
        sample = 'Afrikaans';
        break;
      case 'az':
        sample = 'Azerbaijani';
        break;
      case 'bs':
        sample = 'Bosnian';
        break;
      case 'bg':
        sample = 'Bulgarian';
        break;
      case 'hr':
        sample = 'Croatian';
        break;
      case 'cs':
        sample = 'Czech';
        break;
      case 'da':
        sample = 'Danish';
        break;
      case 'fl':
        sample = 'Finnish';
        break;
      case 'ht':
        sample = 'Haitian';
        break;
      case 'cre':
        sample = 'Creole';
        break;
      case 'he':
        sample = 'Hebrew';
        break;
      case 'hu':
        sample = 'Hungarian';
        break;
      case 'lv':
        sample = 'Lithuanian';
        break;
      case 'no':
        sample = 'Norwegian';
        break;
      case 'sr':
        sample = 'Serbian';
        break;
    }
    return sample;
  }

  static String checkSubSpeak(String code, TalkTextDetailModel listTalk) {
    String name = listTalk.content;
    switch (code) {
      case "en":
        name = listTalk.content;
        break;
      case "vi":
        name = listTalk.content_vi;
        break;
      case "hi":
        name = listTalk.content_hi;
        break;
      case "es":
        name = listTalk.content_es;
        break;
      case "ru":
        name = listTalk.content_ru;
        break;
      case "ja":
        name = listTalk.content_ja;
        break;
      case "zh":
        name = listTalk.content_zh;
        break;
      case "tr":
        name = listTalk.content_tr;
        break;
      case "pt":
        name = listTalk.content_pt;
        break;
      case "id":
        name = listTalk.content_id;
        break;
      case "th":
        name = listTalk.content_th;
        break;
      case "ms":
        name = listTalk.content_ms;
        break;
      case "ar":
        name = listTalk.content_ar;
        break;
      case "fr":
        name = listTalk.content_fr;
        break;
      case "it":
        name = listTalk.content_it;
        break;
      case "de":
        name = listTalk.content_de;
        break;
      case "ko":
        name = listTalk.content_ko;
        break;
      case "zh_Hant_TW":
        name = listTalk.content_zh_Hant_TW;
        break;
      case "sk":
        name = listTalk.content_sk;
        break;
      case "sl":
        name = listTalk.content_sl;
        break;
      case 'gr':
        name = listTalk.content_gr;
        break;
      case 'br':
        name = listTalk.content_br;
        break;
      case 'sa':
        name = listTalk.content_sa;
        break;
      case 'el':
        name = listTalk.content_el;
        break;
      case 'nl':
        name = listTalk.content_nl;
        break;
      case 'kk':
        name = listTalk.content_kk;
        break;
      case 'pl':
        name = listTalk.content_pl;
        break;
      case 'bn':
        name = listTalk.content_bn;
        break;
      case 'ur':
        name = listTalk.content_ur;
        break;
      case 'ro':
        name = listTalk.content_ro;
        break;
      case 'uk':
        name = listTalk.content_uk;
        break;
      case 'uz':
        name = listTalk.content_uz;
        break;
      case 'af':
        name = listTalk.content_af;
        break;
      case 'az':
        name = listTalk.content_az;
        break;
      case 'bs':
        name = listTalk.content_bs;
        break;
      case 'bg':
        name = listTalk.content_bg;
        break;
      case 'hr':
        name = listTalk.content_hr;
        break;
      case 'cs':
        name = listTalk.content_cs;
        break;
      case 'da':
        name = listTalk.content_da;
        break;
      case 'fi':
        name = listTalk.content_fi;
        break;
      case 'ht':
        name = listTalk.content_ht;
        break;
      case 'cre':
        name = listTalk.content_cre;
        break;
      case 'he':
        name = listTalk.content_he;
        break;
      case 'hu':
        name = listTalk.content_hu;
        break;
      case 'lv':
        name = listTalk.content_lv;
        break;
      case 'no':
        name = listTalk.content_no;
        break;
      case 'sr':
        name = listTalk.content_sr;
        break;
      default:
    }
    return name;
  }

  int idVideoNew = 0;
  setIdVideo(int idVideo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('videoOffline', idVideo);
    idVideoNew = prefs.getInt('videoOffline')!;
  }

  int getIdVideo() {
    return idVideoNew;
  }

  List<QuizLottiModel> setListLottieQuizRight(BuildContext context) {
    List<QuizLottiModel> listLottieRight = [
      QuizLottiModel(
          title: S.of(context).Great,
          lottie: 'assets/new_ui/animation_lottie/quiz_dung_1.json'),
      QuizLottiModel(
          title: S.of(context).Congrats,
          lottie: 'assets/new_ui/animation_lottie/quiz_dung_2.json'),
      QuizLottiModel(
          title: S.of(context).EasyAsEatingPho,
          lottie: 'assets/new_ui/animation_lottie/quiz_dung_3.json'),
      QuizLottiModel(
          title: S.of(context).Great,
          lottie: 'assets/new_ui/animation_lottie/quiz_dung_4.json'),
      QuizLottiModel(
          title: S.of(context).burger,
          lottie: 'assets/new_ui/animation_lottie/quiz_dung_5.json'),
    ];
    return listLottieRight;
  }

  List<QuizLottiModel> setListLottieQuizWrong(BuildContext context) {
    List<QuizLottiModel> listLottieWrong = [
      QuizLottiModel(
          title: S.of(context).Cat,
          lottie: 'assets/new_ui/animation_lottie/quiz_sai_1.json'),
      QuizLottiModel(
          title: S.of(context).IncorrectTryMore,
          lottie: 'assets/new_ui/animation_lottie/quiz_sai_2.json'),
      QuizLottiModel(
          title: S.of(context).LearningRequires,
          lottie: 'assets/new_ui/animation_lottie/quiz_sai_3.json'),
      QuizLottiModel(
          title: S.of(context).FightingPho,
          lottie: 'assets/new_ui/animation_lottie/quiz_sai_4.json'),
      QuizLottiModel(
          title: S.of(context).DoYourBest,
          lottie: 'assets/new_ui/animation_lottie/quiz_sai_5.json'),
    ];
    return listLottieWrong;
  }
}
