import 'dart:math';

import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';

import 'package:app_learn_english/model_local/TalkCacheModel.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/quiz/talk_detail_quiz_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/quiz/Screens/advertise.dart';
import 'package:app_learn_english/quiz/train_listen/screen/quiz_video_screen.dart';
import 'package:app_learn_english/screens/play_video_screen.dart';
import 'package:app_learn_english/screens/quiz_screens.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTalkWidget extends StatefulWidget {
  final DataTalk talkData;
  final DataUser userData;
  final int type;

  const ItemTalkWidget(
      {Key? key,
      required this.talkData,
      required this.type,
      required this.userData})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ItemTalkWidgetState(talkData: talkData, type: type);
  }
}

class _ItemTalkWidgetState extends State<ItemTalkWidget> {
  DataTalk talkData;
  int type;
  bool isImages = true;
  bool isFollowed = false;
  bool isLiked = false;
  late LocaleProvider localeProvider;
  late String _nameVideo;
  late int _heart;
  List<TalkDetailModel> listSubQuiz = [];

  _ItemTalkWidgetState({Key? key, required this.talkData, required this.type});

  void itemOnclick(DataUser userData) async {
    var statisticalProvider =
        Provider.of<StaticsticalProvider>(context, listen: false);
    var username = DataCache().getUserData().username;
    var uid = DataCache().getUserData().uid;
    List<int> checkAddVideo = await TargetAPIs().updateWatchedVideo(
      isVip: talkData.isVip ? 1 : 0,
      uid: uid,
      username: username,
      videoId: talkData.id,
    );
    if (checkAddVideo.isNotEmpty) {
      statisticalProvider.updateTotalVideos(checkAddVideo[0]);
      statisticalProvider.updateTotalVideosVip(checkAddVideo[1]);
    }

    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    // if (talkData.isVip == true &&
    //     (widget.userData.isVip == 0 || widget.userData.isVip == 3)) {
    //   // activeDialog(context, 'Show giao diện VIP');
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (_) {
    //         return VipWidget();
    //       },
    //     ),
    //   );
    // } else {
    if (type == 1) {
      AdsController().setRoute(PlayVideo.routeName);
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (_) {
      //       return ScopedModel(
      //           model: userData,
      //           child: PlayVideo(
      //             talkData: talkData,
      //           ));
      //     },
      //   ),
      // );
      if (videoProvider.getdataTalk() != null) {
        videoProvider.setdataTalk(null);
      }
      //
      Future.delayed(Duration(seconds: 0), () {
        videoProvider.setVal(true);
        videoProvider.setdataTalk(talkData);
        videoProvider.miniplayerController.animateToHeight(
          state: PanelState.MAX,
        );
      });
    } else if (type == 2) {
      AdsController().setRoute(MainSpeakScreen.routeName);

      Navigator.of(context).pushNamed(
        MainSpeakScreen.routeName,
        arguments: {
          'id': talkData.id.toString(),
          'title': talkData.name,
          'dataUser': userData,
        },
      );
      // }
    }
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
  void didChangeDependencies() {
    localeProvider = Provider.of<LocaleProvider>(context);
    super.didChangeDependencies();
  }

  String titleLanguage(String languageCode) {
    String title;

    switch (languageCode) {
      case 'vi':
        title = widget.talkData.name_vi;
        break;
      case 'ru':
        title = widget.talkData.name_ru;
        break;
      case 'es':
        title = widget.talkData.name_es;
        break;
      case 'zh':
        title = widget.talkData.name_zh;
        break;
      case 'ja':
        title = widget.talkData.name_ja;
        break;
      case 'hi':
        title = widget.talkData.name_hi;
        break;
      case 'tr':
        title = widget.talkData.name_tr;
        break;
      case 'pt':
        title = widget.talkData.name_pt;
        break;
      case 'id':
        title = widget.talkData.name_id;
        break;
      case 'th':
        title = widget.talkData.name_th;
        break;
      case 'ms':
        title = widget.talkData.name_ms;
        break;
      case 'ar':
        title = widget.talkData.name_ar;
        break;
      case 'fr':
        title = widget.talkData.name_fr;
        break;
      case 'it':
        title = widget.talkData.name_it;
        break;
      case 'de':
        title = widget.talkData.name_de;
        break;
      case 'ko':
        title = widget.talkData.name_ko;
        break;
      case 'zh_Hant_TW':
        title = widget.talkData.name_zh_Hant_TW;
        break;
      case 'sk':
        title = widget.talkData.name_sk;
        break;
      case 'sl':
        title = widget.talkData.name_sl;
        break;
      case 'el':
        title = widget.talkData.name_el;
        break;
      case 'nl':
        title = widget.talkData.name_nl;
        break;
      case 'kk':
        title = widget.talkData.name_kk;
        break;
      case 'pl':
        title = widget.talkData.name_pl;
        break;
      case 'bn':
        title = widget.talkData.name_bn;
        break;
      case 'ur':
        title = widget.talkData.name_ur;
        break;
      case 'ro':
        title = widget.talkData.name_ro;
        break;
      case 'uk':
        title = widget.talkData.name_uk;
        break;
      case 'uz':
        title = widget.talkData.name_uz;
        break;
      case 'af':
        title = widget.talkData.name_af;
        break;
      case 'az':
        title = widget.talkData.name_az;
        break;
      case 'bs':
        title = widget.talkData.name_bs;
        break;
      case 'bg':
        title = widget.talkData.name_bg;
        break;
      case 'hr':
        title = widget.talkData.name_hr;
        break;
      case 'cs':
        title = widget.talkData.name_cs;
        break;
      case 'da':
        title = widget.talkData.name_da;
        break;
      case 'fl':
        title = widget.talkData.name_fl;
        break;
      case 'ht':
        title = widget.talkData.name_ht;
        break;
      case 'cre':
        title = widget.talkData.name_cre;
        break;
      case 'he':
        title = widget.talkData.name_he;
        break;
      case 'hu':
        title = widget.talkData.name_hu;
        break;
      case 'lv':
        title = widget.talkData.name_lv;
        break;
      case 'no':
        title = widget.talkData.name_no;
        break;
      case 'sr':
        title = widget.talkData.name_sr;
        break;
      default:
        title = widget.talkData.name;
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

  getHeart() async {
    var countHeartProvider =
        Provider.of<CountHeartProvider>(context, listen: false);
    _heart = await UserAPIs().getHeart(
      username: DataCache().getUserData().username,
      uid: DataCache().getUserData().uid,
    );
    countHeartProvider.setCountHeart(_heart);
  }

  @override
  void initState() {
    _nameVideo = Utils.buildNameTalkWithRandomWord(widget.talkData.name);
    print('Đây là tên của video $_nameVideo');
    getListSub();
    DataCache()
        .getTalkFollowStatus(widget.userData.uid, widget.talkData.id)
        .then(
      (value) {
        if (value != null) {
          if (mounted) {
            setState(() {
              isFollowed = value;
            });
          }
        }
      },
    );
    DataCache().getTalkLikeStatus(widget.userData.uid, widget.talkData.id).then(
      (value) {
        if (mounted) {
          setState(
            () {
              isLiked = value;
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final URL_AVATAR_TEXT = Session().BASE_IMAGES + 'images/talk_text_avatars/';
  final URL_AVATAR_VIDEO = Session().BASE_IMAGES + 'images/talk_avatars/';

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var widthScreen = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        itemOnclick(widget.userData);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: themeProvider.mode == ThemeMode.dark
                  ? const Color.fromRGBO(59, 61, 66, 1)
                  : Colors.white,
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Container(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 15,
                right: 16,
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: CachedNetworkImage(
                              imageUrl: talkData.picLink.isEmpty
                                  ? 'https://img.youtube.com/vi/' +
                                      talkData.yt_id +
                                      '/maxresdefault.jpg'
                                  : talkData.picLink,
                              fit: BoxFit.cover,
                              errorWidget: (context, error, stackTrace) =>
                                  CachedNetworkImage(
                                imageUrl: 'https://img.youtube.com/vi/' +
                                    talkData.yt_id +
                                    '/mqdefault.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: 0.9,
                            child: SvgPicture.asset(
                              'assets/new_ui/home/play_ic_play.svg',
                              height: 60,
                            ),
                          ),
                        ),
                        if (talkData.isVip == true)
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, left: 10),
                              width: 30,
                              height: 30,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Lottie.asset(
                                    'assets/new_ui/animation_lottie/load_look_vip_home.json',
                                    height: 30),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: (titleLanguage(
                            (localeProvider.codeLangeSub != null)
                                ? localeProvider.codeLangeSub!
                                : localeProvider.locale!.languageCode,
                          ).contains('null'))
                              ? const SizedBox(
                                  height: 20,
                                )
                              : Text(
                                  titleLanguage(
                                    (localeProvider.codeLangeSub != null)
                                        ? localeProvider.codeLangeSub!
                                        : localeProvider.locale!.languageCode,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            _nameVideo,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: themeProvider.mode == ThemeMode.dark
                                  ? const Color.fromRGBO(157, 158, 161, 1)
                                  : ColorsUtils.Color_555555,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(height: (widthScreen <= 360) ? 20 : 35),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
