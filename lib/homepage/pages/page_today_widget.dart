import 'dart:io';
import 'dart:math';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/widgets/item_category_home_widget.dart';
import 'package:app_learn_english/homepage/widgets/item_talk_sugges_home.dart';

import 'package:app_learn_english/models/HomeData.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/quiz/talk_detail_quiz_model.dart';
import 'package:app_learn_english/models/speak_home_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';

import 'package:app_learn_english/networks/TalkAPIs.dart';

import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/provider/all_list_talk_course.dart';

import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_looadding_white.dart';

import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class PageToday extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageToday();
  }
}

class _PageToday extends State<PageToday> {
  bool _isLoading = true;
  late String? token;
  late var dataHome;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isLoading) {
      var localeProvider = Provider.of<LocaleProvider>(context, listen: false);
      TalkAPIs().fetchDataSpeakHone(
          langugeCode: (localeProvider.codeLangeSub != null)
              ? localeProvider.codeLangeSub
              : localeProvider.locale?.languageCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('tokenFCM');
      dataHome = getDataHome(
        DataCache().getUserData(),
        Center(
          child: Text(
            S.of(context).Anerrordata,
          ),
        ),
        (localeProvider.codeLangeSub != null)
            ? localeProvider.codeLangeSub!
            : (localeProvider.locale != null
                ? localeProvider.locale!.languageCode
                : "en"),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  getDataHome(DataUser userData, Widget widget, String languageCode) {
    print('nhảy vào đây á');
    return FutureBuilder(
        future: TalkAPIs().fetchDataHome2(
          uid: userData.uid,
          langugeCode: languageCode,
          token: token != null ? token : '',
        ),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              // child: Platform.isAndroid
              //     ? const CircularProgressIndicator()
              //     : const CupertinoActivityIndicator(),
              child: PhoLoading(),
            );
          }
          return snapshot.hasData
              ? PageListToday(
                  dataHome: snapshot.data,
                  userData: userData,
                  lang: languageCode,
                  callDataReload: () =>
                      callBackReloadWidget(userData, languageCode),
                )
              : widget;
        });
  }

  callBackReloadWidget(DataUser userData, String languageCode) {
    setState(() {
      DataCache().setDataHome(null);
    });

    TalkAPIs().fetchDataHome2(
      uid: userData.uid,
      langugeCode: languageCode,
    );
    TalkAPIs().fetchDataSpeakHone(
        langugeCode: (context.watch<LocaleProvider>().codeLangeSub != null)
            ? context.watch<LocaleProvider>().codeLangeSub
            : context.watch<LocaleProvider>().locale?.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Consumer<LocaleProvider>(
        child: Center(
          child: Text(
            S.of(context).Anerrordata,
          ),
        ),
        builder: (ctx, localeProvider, widget) {
          return Center(
            child: (DataCache().getDataHome() != null
                ? PageListToday(
                    dataHome: DataCache().getDataHome()!,
                    userData: userData,
                    lang: (localeProvider.locale != null
                        ? localeProvider.locale!.languageCode
                        : "en"),
                    callDataReload: () => callBackReloadWidget(
                        userData,
                        (localeProvider.locale != null
                            ? localeProvider.locale!.languageCode
                            : "en")),
                  )
                : dataHome),
          );
        },
      );
    });
  }
}

class PageListToday extends StatefulWidget {
  final DataHome dataHome;
  final DataUser userData;
  String lang;
  final VoidCallback callDataReload;

  PageListToday(
      {Key? key,
      required this.dataHome,
      required this.userData,
      required this.lang,
      required this.callDataReload})
      : super(key: key);

  @override
  State<PageListToday> createState() => _PageListTodayState();
}

class _PageListTodayState extends State<PageListToday> {
  late BannerAd _ad;
  bool _isAdLoaded = false;
  var random = Random();
  int page = 1;
  bool _isLoadingPage = true;
  late int _heart;
  bool _isAstray = false;

  @override
  void dispose() {
    super.dispose();

    _ad.dispose();
  }

  List<DataTalk> randomSugges = [];
  List<DataTalk> groupDataTalk = [];
  List<DataTalk> filterDataTalk = [];
  List<TalkDetailQuizModel> listQuiz = [];
  List<DataTalk> flashViewTalk = [];
  List<Lists> listSpeakHome = [];

  List<int> randomIndex = [];

  Future<List<DataTalk>> loadPage(BuildContext context) async {
    var tempMoreFlashView = await TalkAPIs().getFlashViewVideo(
        page,
        Provider.of<LocaleProvider>(context, listen: false)
            .locale!
            .languageCode);
    var mirrorHistory = [...flashViewTalk];
    if (tempMoreFlashView.isNotEmpty) {
      mirrorHistory.addAll(tempMoreFlashView);
      setState(() {
        flashViewTalk = mirrorHistory;
        page++;
        print('đây là page: $page');
      });
    }
    return flashViewTalk;
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4902285970438994/7295997864';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4902285970438994/2446425042';
    }
    throw new UnsupportedError("Unsupported platform");
  }

  void groupDataTalkFnc() {
    for (var i = 0; i < widget.dataHome.listCatgory.length; i++) {
      for (var j = 0; j < widget.dataHome.listCatgory[i].listTalk.length; j++) {
        groupDataTalk.add(widget.dataHome.listCatgory[i].listTalk[j]);
      }
    }
  }

  void filterVideo() {
    groupDataTalk.forEach((element) {
      if (element.yt_id.isNotEmpty) {
        filterDataTalk.add(element);
      }
    });
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<AllListTalkCourse>(context, listen: true)
        .getAllTalkByCategory(context, 1);
    Provider.of<AllListTalkCourse>(context).listCourseTalks();
  }

  setFirstApp(bool isFirst) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstAppVideo', isFirst);
  }

  Future<bool> getFirstApp() async {
    var _isFirst;
    final prefs = await SharedPreferences.getInstance();
    _isFirst = (prefs.getBool('firstAppVideo') != null)
        ? prefs.getBool('firstAppVideo')!
        : false;
    print("ItemFirst:$isLoadFirst");
    return _isFirst;
  }

  _startInstagram() async {
    const url = "https://www.instagram.com/pho.english/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // can't launch url
    }
  }

  @override
  void didChangeDependencies() async {
    if (_isLoadingPage) {
      listSpeakHome = DataCache().getListSpeakHome();
      // flashViewTalk = await TalkAPIs().getFlashViewVideo(
      //     page, Provider.of<LocaleProvider>(context).locale!.languageCode);

      setState(() {
        _isLoadingPage = false;
        page++;
      });
    }
    super.didChangeDependencies();
  }

  final _controllerNewVideo = ScrollController();
  final _controllerNewCategory = ScrollController();
  final _controllerNewSuggest = ScrollController();
  final _controllerFlashView = ScrollController();
  var number = 2;
  var numberLoadCate = 2;
  var numberLoadSuggest = 2;
  var _isLoadingCate = false;
  var _isLoadingNewVideo = false;
  var _isLoadingSuggest = false;
  int _lever = 1;
  bool _isLoadingTop = false;

  bool _isLoad = false;
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey keyVideoFirst = GlobalKey();

  bool isLoadFirst = false;

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "keyVideoFirst",
        keyTarget: keyVideoFirst,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).ImPhoComplete,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
  }

  void showTutorial() {
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.black.withOpacity(0.5),
      textSkip: S.of(context).skip,
      hideSkip: true,
      paddingFocus: 10,
      alignSkip: Alignment.topLeft,
      opacityShadow: 0.8,
      onFinish: () {
        setFirstApp(true);
      },
      onClickTarget: (target) {
        setFirstApp(true);
        Future.delayed(Duration(seconds: 0), () {
          videoProvider.setVal(true);
          videoProvider.setdataTalk(randomSugges[0]);
          videoProvider.miniplayerController.animateToHeight(
            state: PanelState.MAX,
          );
        });
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        setFirstApp(true);
      },
      onSkip: () {
        setFirstApp(true);
      },
    )..show();
  }

  @override
  void initState() {
    super.initState();
    getDataQuiz();
    getDataVideoHistoryReview();
    addEventController();
    addEventControllerCate();
    addEventControllerSuggest();

    randomSugges = widget.dataHome.dataSugges;
    _ad = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    //  Load an ad
    _ad.load();

    _controllerFlashView.addListener(() async {
      // print(_scollController.position.extentAfter);
      if (_controllerFlashView.position.extentAfter == 0.0) {
        setState(() {
          _isLoad = true;
        });
        await loadPage(context);
        setState(() {
          _isLoad = false;
        });
      }
    });

    getFirstApp().then((value) => {
          if (value == false) {Future.delayed(Duration.zero, showTutorial)},
        });
  }

  Future getDataQuiz() async {
    var lang = Provider.of<LocaleProvider>(context, listen: false)
        .locale!
        .languageCode;
    await TalkAPIs().getListQuiz(lang);
  }

  Future getDataVideoHistoryReview() async {
    await TalkAPIs().fetchDataVideoHistory(
        uid: widget.userData.uid,
        langugeCode: widget.userData.langnative,
        page: 0);
  }

  void addEventController() async {
    _controllerNewVideo.addListener(() async {
      if (_controllerNewVideo.position.extentAfter < 300 &&
          _isLoadingNewVideo == false) {
        setState(() {
          _isLoadingNewVideo = true;
        });
        bool check = await TalkAPIs().fetchMoreDataHomeNewVideo(
            langugeCode: Provider.of<LocaleProvider>(context, listen: false)
                .locale!
                .languageCode,
            page: number,
            uid: DataCache().getUserData().uid);
        if (check) {
          setState(() {
            number++;
          });
        }
        setState(() {
          _isLoadingNewVideo = false;
        });
      }
    });
  }

  void addEventControllerSuggest() async {
    _controllerNewSuggest.addListener(() async {
      if (_controllerNewSuggest.position.extentAfter < 300 &&
          _isLoadingSuggest == false) {
        setState(() {
          _isLoadingSuggest = true;
        });
        bool check = await TalkAPIs().fetchMoreDataHomeSuggest(
            langugeCode: Provider.of<LocaleProvider>(context, listen: false)
                .locale!
                .languageCode,
            page: numberLoadSuggest,
            uid: DataCache().getUserData().uid);
        if (check) {
          setState(() {
            numberLoadSuggest++;
          });
        }
        setState(() {
          _isLoadingSuggest = false;
        });
      }
    });
  }

  void addEventControllerCate() async {
    var localProvider = context.read<LocaleProvider>();

    _controllerNewCategory.addListener(() async {
      if (_controllerNewCategory.position.extentAfter < 300 &&
          _isLoadingCate == false) {
        setState(() {
          _isLoadingCate = true;
        });
        bool check = await TalkAPIs().fetchMoreDataHomeCategory(
            langugeCode: Provider.of<LocaleProvider>(context, listen: false)
                .locale!
                .languageCode,
            page: numberLoadCate,
            uid: DataCache().getUserData().uid);
        if (check) {
          setState(() {
            numberLoadCate++;
          });
        }
        setState(() {
          _isLoadingCate = false;
        });
      }

      if (_controllerNewCategory.position.pixels > 2000 &&
          localProvider.isFirstOpen == false) {
        localProvider.setIsFirstApp(true);
        Future.delayed(Duration(seconds: 5), () {
          localProvider.setIsFirstApp(false);
          localProvider.setIsFirstOpen(true);
        });
        // Utils().showNotificationTop(true, S.of(context).LooksLikeYou);

      }

      if (_controllerNewCategory.position.pixels < -130) {
        setState(() {
          _isLoadingTop = false;
        });
        widget.callDataReload();
      } else if (_controllerNewCategory.position.pixels < -50) {
        setState(() {
          _isLoadingTop = true;
        });
      } else {
        setState(() {
          _isLoadingTop = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var widthScreen = MediaQuery.of(context).size.width;
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      return Container(
        color: themeProvider.mode == ThemeMode.dark
            ? const Color.fromRGBO(42, 44, 50, 1)
            : Colors.white,
        // margin: const EdgeInsets.only(top: 20),
        child: Stack(
          children: [
            ListView(
              controller: _controllerNewCategory,
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                _isLoadingTop
                    ? const SizedBox(
                        height: 50,
                        child: Center(
                          child: PhoLoading(),
                        ),
                      )
                    : const SizedBox(),

                randomSugges.length > 0
                    ? Container(
                        height: MediaQuery.of(context).size.width / 0.92,
                        margin: const EdgeInsets.only(
                          left: 16,
                        ),
                        padding: const EdgeInsets.only(
                          right: 0,
                          left: 0,
                          bottom: 3,
                        ),
                        decoration: BoxDecoration(
                          color: themeProvider.mode == ThemeMode.dark
                              ? const Color.fromRGBO(42, 44, 50, 1)
                              : Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 18,
                            ),
                            Text(
                              S.of(context).SuggestionsForYou,
                              style: TextStyle(
                                  color: themeProvider.mode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Container(
                              height:
                                  (MediaQuery.of(context).size.width / 0.9375) *
                                      0.83,
                              child: GridView.builder(
                                controller: _controllerNewSuggest,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      MediaQuery.of(context).size.width / 0.1,
                                  childAspectRatio: 1.1,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 15,
                                ),
                                itemCount: randomSugges.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext ctx, index) {
                                  return (index == 0)
                                      ? ItemSuggesHomeView(
                                          key: keyVideoFirst,
                                          title:
                                              S.of(context).SuggestionsForYou,
                                          talkData: randomSugges[0],
                                          type: 1,
                                          userData: widget.userData,
                                        )
                                      : ItemSuggesHomeView(
                                          title:
                                              S.of(context).SuggestionsForYou,
                                          talkData: randomSugges[index],
                                          type: 1,
                                          userData: widget.userData,
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),

                // //Start Quiz
                // Container(
                //   padding: const EdgeInsets.only(
                //     left: 10,
                //     right: 10,
                //     top: 0,
                //     bottom: 10,
                //   ),
                //   height: 60,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       if (this._lever <= 4) {
                //         startQuiz(context);
                //       } else {
                //         _clearLeverQuiz();
                //         startQuiz(context);
                //       }
                //     },
                //     child: Center(
                //       child: Text(
                //         (this._lever <= 4)
                //             ? S.of(context).StartQuiz + " Lever ${this._lever}"
                //             : S.of(context).clearQuiz,
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.w600,
                //           fontSize: 18,
                //         ),
                //       ),
                //     ),
                //     style: ButtonStyle(
                //       backgroundColor: MaterialStateProperty.all<Color>(
                //         (this._lever <= 4)
                //             ? const Color.fromRGBO(83, 180, 81, 1)
                //             : Colors.deepOrange,
                //       ),
                //     ),
                //   ),
                // ),

                Container(
                  height: 15,
                  width: MediaQuery.of(context).size.width,
                  color: themeProvider.mode == ThemeMode.dark
                      ? const Color.fromRGBO(24, 26, 33, 1)
                      : ColorsUtils.Color_C8EBD6,
                ),

                widget.dataHome.listTalkNew.length > 0
                    ? Container(
                        margin: const EdgeInsets.only(left: 16),
                        height: MediaQuery.of(context).size.width / 0.965,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 18,
                            ),
                            Text(
                              S.of(context).LatestUpdates,
                              style: TextStyle(
                                  color: themeProvider.mode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Container(
                              height:
                                  (MediaQuery.of(context).size.width / 0.9375) *
                                      0.82,
                              child: GridView.builder(
                                controller: _controllerNewVideo,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      MediaQuery.of(context).size.width / 0.1,
                                  childAspectRatio: 1.1,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 15,
                                ),
                                itemCount: widget.dataHome.listTalkNew.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext ctx, index) {
                                  return ItemSuggesHomeView(
                                    title: S.of(context).LatestUpdates,
                                    talkData:
                                        widget.dataHome.listTalkNew[index],
                                    type: 1,
                                    userData: widget.userData,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),

                const SizedBox(height: 15),
                Container(
                  height: 15,
                  width: MediaQuery.of(context).size.width,
                  color: themeProvider.mode == ThemeMode.dark
                      ? const Color.fromRGBO(24, 26, 33, 1)
                      : ColorsUtils.Color_C8EBD6,
                ),
                const SizedBox(height: 15),
//Flash đang ẩn
                // randomSugges.length > 0
                //     ? Container(
                //         padding: const EdgeInsets.only(right: 20, left: 15),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Row(
                //               children: [
                //                 Text(
                //                   'F',
                //                   style: TextStyle(
                //                     color: themeProvider.mode == ThemeMode.dark
                //                         ? Colors.white
                //                         : Colors.black,
                //                     fontWeight: FontWeight.w700,
                //                     fontSize: 20,
                //                   ),
                //                 ),
                //                 SvgPicture.asset(
                //                   'assets/icons-svg/flash_icon.svg',
                //                   height: 25,
                //                   color: Colors.yellow[700],
                //                 ),
                //                 Text(
                //                   'ash',
                //                   style: TextStyle(
                //                     color: themeProvider.mode == ThemeMode.dark
                //                         ? Colors.white
                //                         : Colors.black,
                //                     fontWeight: FontWeight.w700,
                //                     fontSize: 20,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             const SizedBox(height: 20),
                //             Container(
                //               height: 250,
                //               child: ListView(
                //                 controller: _controllerFlashView,
                //                 physics: const BouncingScrollPhysics(),
                //                 scrollDirection: Axis.horizontal,
                //                 children: [
                //                   for (int i = 0; i < flashViewTalk.length; i++)
                //                     ItemFlashView(
                //                       idx: i,
                //                       talk: flashViewTalk[i],
                //                       userData: widget.userData,
                //                       flashViewTalk: flashViewTalk,
                //                       currentPage: page,
                //                     ),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     : const SizedBox(),

                listSpeakHome != null && listSpeakHome.length > 0
                    ? Container(
                        padding: const EdgeInsets.only(right: 20, left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              S.of(context).Speak,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black26,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              S.of(context).hoc_bai_audio_de_cu,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            RefreshIndicator(
                              onRefresh: () => _refreshProducts(context),
                              child: Container(
                                child: Column(
                                  children: [
                                    for (int i = 0;
                                        i < listSpeakHome.length;
                                        i++)
                                      _viewItemSpeakHome(listSpeakHome[i])
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                Container(
                  height: 15,
                  width: MediaQuery.of(context).size.width,
                  color: themeProvider.mode == ThemeMode.dark
                      ? const Color.fromRGBO(24, 26, 33, 1)
                      : ColorsUtils.Color_C8EBD6,
                ),

                for (var i = 0; i < widget.dataHome.listCatgory.length - 1; i++)
                  widget.dataHome.listCatgory[i].listTalk.length > 0
                      ? (i == 2)
                          ? Column(
                              children: [
                                (randomSugges.length > 0)
                                    ? _viewLeadEnglish(randomSugges[0])
                                    : const SizedBox(),
                                Container(
                                  height: 15,
                                  width: MediaQuery.of(context).size.width,
                                  color: themeProvider.mode == ThemeMode.dark
                                      ? const Color.fromRGBO(24, 26, 33, 1)
                                      : ColorsUtils.Color_C8EBD6,
                                ),
                              ],
                            )
                          : (i == 6)
                              ? Column(
                                  children: [
                                    _viewFollowInstagram(),
                                    Container(
                                      height: 15,
                                      width: MediaQuery.of(context).size.width,
                                      color: themeProvider.mode ==
                                              ThemeMode.dark
                                          ? const Color.fromRGBO(24, 26, 33, 1)
                                          : ColorsUtils.Color_C8EBD6,
                                    ),
                                  ],
                                )
                              : ScopedModel(
                                  model: widget.userData,
                                  child: Column(
                                    children: [
                                      ItemCategoryHomeWidget(
                                        category:
                                            widget.dataHome.listCatgory[i],
                                      ),
                                      const SizedBox(height: 15),
                                      Container(
                                        height: 15,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? const Color.fromRGBO(
                                                    24, 26, 33, 1)
                                                : ColorsUtils.Color_C8EBD6,
                                      ),
                                    ],
                                  ),
                                )
                      : const SizedBox(),
              ],
            ),
            (provider.isFirstApp) ? _viewAstray() : SizedBox()
          ],
        ),
      );
    });
  }

  ///View lạc hướng
  Widget _viewAstray() {
    return Positioned(
      top: 0,
      left: -30,
      child: Container(
        child: Row(
          children: [
            RotationTransition(
              turns: new AlwaysStoppedAnimation(60 / 360),
              child: Lottie.asset(
                  'assets/new_ui/animation_lottie/lac_huong.json',
                  width: 100),
            ),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                width: MediaQuery.of(context).size.width / 2,
                child: Center(
                  child: Text(
                    S.of(context).LooksLikeYou,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Roboto'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///View Item SpeakHome
  Widget _viewItemSpeakHome(Lists item) {
    var themeProvider = context.watch<ThemeProvider>();
    var data = DataCache().userCache!;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return MainSpeakScreen(
                  dataUser: data, id: '${item.id}', title: item.name!);
            },
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            color: themeProvider.mode == ThemeMode.dark
                ? const Color.fromRGBO(59, 61, 66, 1)
                : Colors.white,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: ValueKey('images/cat_avatars/${item.picture}'),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: '${item.picture}',
                        placeholder: (context, url) => const PhoLoading(),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/new_ui/more/defaut.png',
                        ),
                        fit: BoxFit.fill,
                        height: 70,
                        width: 70 * 3 / 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // height: 90,
                      margin: const EdgeInsets.only(left: 20, top: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: Text(
                              item.name!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            (Utils.changeLanguageSpeakHome(widget.lang, item) !=
                                    null)
                                ? Utils.changeLanguageSpeakHome(
                                    widget.lang, item)!
                                : '',
                            style: TextStyle(
                              fontSize: 16,
                              color: themeProvider.mode == ThemeMode.dark
                                  ? const Color.fromRGBO(157, 158, 161, 1)
                                  : Colors.grey[700],
                            ),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(
            color: themeProvider.mode == ThemeMode.dark
                ? ColorsUtils.Color_555555
                : const Color.fromRGBO(224, 224, 226, 1),
            height: 10,
            thickness: 1.2,
          ),
        ],
      ),
    );
  }

  ///View 'học anh ngữ đơn gian như ăn phở'
  Widget _viewLeadEnglish(DataTalk talkData) {
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    var widthScreen = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.width) * 0.75,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 182, 88, 1),
            Color.fromRGBO(0, 207, 106, 1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            child: PhoLoadingWhite(),
          ),
          SizedBox(
            height: (widthScreen <= 360) ? 10 : 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AutoSizeText(
              S.of(context).hoc_tieng_anh_nhu_an_pho,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: (widthScreen <= 360) ? 25 : 40,
          ),
          ScaleTap(
            onPressed: () {
              Future.delayed(Duration(seconds: 0), () {
                videoProvider.setVal(true);
                videoProvider.setdataTalk(talkData);
                videoProvider.miniplayerController.animateToHeight(
                  state: PanelState.MAX,
                );
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: AutoSizeText(
                  S.of(context).hoc_video_hom_nay_ngay,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///View folow instagram
  Widget _viewFollowInstagram() {
    var widthScreen = MediaQuery.of(context).size.width;
    return Container(
      width: widthScreen,
      height: widthScreen * 0.75,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 182, 88, 1),
            Color.fromRGBO(0, 207, 106, 1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/new_ui/home/ic_follow_instagram.svg',
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: (widthScreen <= 360) ? 10 : 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AutoSizeText(
              S.of(context).PhoEnglishsOfficialInstagram,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: (widthScreen <= 360) ? 25 : 40,
          ),
          ScaleTap(
            onPressed: () {
              _startInstagram();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      S.of(context).FollowNow,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    SvgPicture.asset('assets/new_ui/home/ic_pho_instagram.svg')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => throw UnimplementedError();
}
