import 'dart:io';

import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/TalkCacheModel.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/quiz/Screens/advertise.dart';
import 'package:app_learn_english/quiz/train_listen/screen/quiz_video_screen.dart';
import 'package:app_learn_english/screens/new_play_video_screen_max.dart';
import 'package:app_learn_english/screens/play_video_screen.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemVideoResult extends StatefulWidget {
  final DataTalk talkData;
  final int type;

  const ItemVideoResult({Key? key, required this.talkData, required this.type})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemVideoResult(talkData: talkData, type: type);
  }
}

String splitYtId(String linkOrigin) {
  String ytId = "";
  List<String> strs = linkOrigin.split("v=");
  if (strs.length > 0) {
    ytId = strs[1];
  }
  printRed(ytId);
  return ytId;
}

class _ItemVideoResult extends State<ItemVideoResult> {
  DataTalk talkData;
  int type;
  _ItemVideoResult({Key? key, required this.talkData, required this.type});
  List<TalkDetailModel> listSubQuiz = [];
  String titleLanguage(String languageCode) {
    String title;

    switch (languageCode) {
      case 'vi':
        title = '${talkData.name_vi}';
        break;
      case 'ru':
        title = '${talkData.name_ru}';
        break;
      case 'es':
        title = '${talkData.name_es}';
        break;
      case 'zh':
        title = '${talkData.name_zh}';
        break;
      case 'ja':
        title = '${talkData.name_ja}';
        break;
      case 'hi':
        title = '${talkData.name_hi}';
        break;
      case 'tr':
        title = '${talkData.name_tr}';
        break;
      case 'pt':
        title = '${talkData.name_pt}';
        break;
      case 'id':
        title = '${talkData.name_id}';
        break;
      case 'th':
        title = '${talkData.name_th}';
        break;
      case 'ms':
        title = '${talkData.name_ms}';
        break;
      case 'ar':
        title = '${talkData.name_ar}';
        break;
      case 'fr':
        title = '${talkData.name_fr}';
        break;
      case 'it':
        title = '${talkData.name_it}';
        break;
      case 'de':
        title = '${talkData.name_de}';
        break;
      case 'ko':
        title = '${talkData.name_ko}';
        break;
      case 'zh_Hant_TW':
        title = '${talkData.name_zh_Hant_TW}';
        break;
      case 'sk':
        title = '${talkData.name_sk}';
        break;
      case 'sl':
        title = '${talkData.name_sl}';
        break;
      default:
        title = '${talkData.name}';
        break;
    }
    return title;
  }

  getListSub() async {
    var provider = context.read<LocaleProvider>();
    TalkCacheModel talkCache = await DataCache().getTalkDetailByIdInCache(
        widget.talkData.id,
        (provider.codeLangeSub != null)
            ? provider.codeLangeSub!
            : provider.locale!.languageCode);
    var listSub = talkCache.getListSub();
    listSubQuiz = listSub;
  }

  List<TalkDetailModel> handleListSub(
      List<TalkDetailModel> listSub, int numberSub, BuildContext context) {
    if (numberSub > listSub.length) {
      return [];
    } else if (numberSub == listSub.length) {
      return listSub;
    } else {
      List<TalkDetailModel> list = [];

      switch (numberSub) {
        case 2:
          var mapArr = listSub.map((e) => e.content.length).toList();
          mapArr.sort();
          for (var i = 0; i <= numberSub; i++) {
            // var indexSearch = mapArr.indexOf(mapArr[i]);
            list.add(listSub[i]);
          }
          break;
        case 3:
          var mapArr = listSub.map((e) => e.content.length).toList();
          mapArr.sort();
          for (var i = 0; i <= numberSub; i++) {
            // var indexSearchShort = mapArr.indexOf(mapArr[i]);
            list.add(listSub[i]);
          }
          // for (var j = numberSub - 1; j > numberSub - 2; j--) {
          //   var indexSearchLong = mapArr.indexOf(mapArr[j]);
          //   list.add(listSub[indexSearchLong]);
          // }
          break;
        case 4:
          var mapArr = listSub.map((e) => e.content.length).toList();
          mapArr.sort();
          for (var i = 0; i <= numberSub; i++) {
            // var indexSearchShort = mapArr.indexOf(mapArr[i]);
            list.add(listSub[i]);
          }
          // for (var j = numberSub - 1; j > numberSub - 3; j--) {
          //   var indexSearchLong = mapArr.indexOf(mapArr[j]);
          //   list.add(listSub[indexSearchLong]);
          // }
          break;
      }
      return list;
    }
  }

  @override
  void initState() {
    getListSub();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themePovider = context.watch<ThemeProvider>();
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    var URL_AVATAR_TEXT = Session().BASE_IMAGES + "images/talk_text_avatars/";
    var URL_AVATAR_VIDEO = Session().BASE_IMAGES + "images/talk_avatars/";
    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return Container(
          margin: const EdgeInsets.only(
            top: 8,
            bottom: 8,
          ),
          child: GestureDetector(
            onTap: () {
              if (type == 1) {
                talkData.yt_id = splitYtId(talkData.link_origin);
                AdsController().setRoute(PlayVideo.routeName);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return NewPlayVideoScreenNormal(
                        false,
                        dataTalk: talkData,
                        percent: 1,
                        ytId: '',
                        enablePop: true,
                      );
                    },
                  ),
                );
              } else if (type == 2) {
                AdsController().setRoute(MainSpeakScreen.routeName);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainSpeakScreen(
                            dataUser: DataCache().getUserData(),
                            title: talkData.name,
                            id: talkData.id.toString(),
                          )),
                );
              }
            },
            child: Card(
              elevation: 5,
              color: themePovider.mode == ThemeMode.dark
                  ? const Color.fromRGBO(42, 44, 50, 1)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 15, bottom: 10),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Center(
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Stack(children: [
                                  FadeInImage.memoryNetwork(
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: kTransparentImage,
                                      image: talkData.picLink.isEmpty
                                          ? (talkData.link_origin.isEmpty
                                              ? URL_AVATAR_TEXT +
                                                  talkData.picture
                                              : "https://img.youtube.com/vi/" +
                                                  splitYtId(
                                                      talkData.link_origin) +
                                                  "/sddefault.jpg")
                                          : talkData.picLink,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                            width: double.infinity,
                                            height: 160,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                'assets/linh_vat/linhvat2.png',
                                                fit: BoxFit.contain,
                                                width: 70,
                                              ),
                                            ));
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Opacity(
                                        opacity: 0.9,
                                        child: SvgPicture.asset(
                                          'assets/new_ui/home/play_ic_play.svg',
                                          height: 60,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 60,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              Utils.buildNameTalkWithRandomWord(talkData.name),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              titleLanguage(lang) == 'null'
                                  ? titleLanguage('en')
                                  : titleLanguage(lang),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ScaleTap(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Provider.of<CountHeartProvider>(context,
                                                    listen: false)
                                                .count ==
                                            0
                                        ? const Advertise(checkOnce: false)
                                        : TrainListen4Star(
                                            listSub: handleListSub(
                                                listSubQuiz, 2, context),
                                            dataTalk: talkData,
                                          )));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 57,
                        decoration: BoxDecoration(
                          color: ColorsUtils.Color_04D076,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).StartQuiz,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
