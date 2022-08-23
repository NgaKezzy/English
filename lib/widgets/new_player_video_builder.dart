import 'dart:io';

import 'package:app_learn_english/Providers/dialog_provider.dart';
import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';

import 'package:app_learn_english/dialog/dialog_see_more.dart';
import 'package:app_learn_english/extentions/RoutersManager.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/homepage/widgets/new_item_chanel.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/SocialNetworks.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/home/home.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/quiz/train_listen/provider/quiz_video_provider.dart';
import 'package:app_learn_english/screens/login_account_screen.dart';
import 'package:app_learn_english/screens/quiz_screens.dart';
import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:app_learn_english/socket/utils/emit_event.dart';
import 'package:app_learn_english/socket/utils/parser_data.dart';
import 'package:app_learn_english/screens/review_quiz_screen.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/config_heart_utils.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:app_learn_english/widgets/custom_switch.dart';
import 'package:app_learn_english/widgets/item_sugges_in_video.dart';
import 'package:app_learn_english/widgets/list_button_social.dart';
import 'package:app_learn_english/widgets/list_quiz_video.dart';
import 'package:app_learn_english/widgets/video_suggest_category.dart';
import 'package:app_learn_english/widgets/web_view_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:lottie/lottie.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class NewPlayerVideoBuilder extends StatefulWidget {
  final bool pop;
  final Widget player;
  final YoutubePlayerController controllerYT;
  final List<TalkDetailModel> listSub;
  final DataTalk dataTalk;
  final double percent;
  final bool hideChannel;
  final bool enablePop;

  NewPlayerVideoBuilder({
    Key? key,
    required this.player,
    required this.controllerYT,
    required this.listSub,
    required this.dataTalk,
    required this.percent,
    this.hideChannel = false,
    this.enablePop = false,
    this.pop = true,
  }) : super(key: key);

  @override
  _NewPlayerVideoBuilderState createState() => _NewPlayerVideoBuilderState();
}

class _NewPlayerVideoBuilderState extends State<NewPlayerVideoBuilder> {
  CarouselController sliderController = CarouselController();
  String playrate = '1';
  bool checkEnd = true;
  PlayerState stateBtn = PlayerState.unknown;
  Duration ended = Duration(seconds: 0);
  Widget? itemSub;
  bool drillOn = false;
  bool longPress = true;
  bool hideSub = true;
  late LocaleProvider localeProvider;
  late Future _fetchChannel;
  late QuizVideoProvider quizVideoProvider;
  late int _heart;

  int indextLanguage = 0;
  bool _isMainSentence = true;
  String nativeLang = '';
  bool checkEndVideo = true;
  bool checkEndWithLoop = true;

  List<String> language = [];
  late SharedPreferences _prefs;

  bool status1 = true;
  bool status2 = false;
  bool status3 = true;
  bool _checkSetting = true;
  bool _activeSlide = true;
  bool resetCheckEnd = false;
  AdmobHelper admob = AdmobHelper();
  ScrollController scrController = ScrollController();

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey keyButtonSpeed = GlobalKey();
  GlobalKey keyButtonSub = GlobalKey();
  GlobalKey keyButtonSaveChat = GlobalKey();
  GlobalKey keyButtonReview = GlobalKey();
  GlobalKey keyButtonQuizVideo = GlobalKey();
  GlobalKey keyPositionFirst = GlobalKey();

  String handleLanguage() {
    final String defaultLocale =
        Platform.localeName; // Returns locale string in the form 'en_US'
    return defaultLocale.split('_')[0].trim();
  }

  void nextSlide(int indexPage) {
    setState(() {
      loop = 0;
    });
    sliderController.nextPage();
    if (indexPage + 1 >= widget.listSub.length) {
      widget.controllerYT.seekTo(
        Duration(
          milliseconds: widget.listSub[0].startTime,
        ),
      );
    } else {
      widget.controllerYT.seekTo(
        Duration(
          milliseconds: widget.listSub[indexPage + 1].startTime,
        ),
      );
    }
  }

  void previousSlide(int indexPage) {
    setState(() {
      loop = 0;
    });
    sliderController.previousPage();
    if (indexPage - 1 < 0) {
      widget.controllerYT.seekTo(
        Duration(
          milliseconds: widget.listSub[widget.listSub.length - 1].startTime,
        ),
      );
    } else {
      widget.controllerYT.seekTo(
        Duration(
          milliseconds: widget.listSub[indexPage - 1].startTime,
        ),
      );
    }
  }

  // Lấy ra index của mẫu câu Lặp
  void getIndexLoop(List<TalkDetailModel> listSub) {
    var filterIndex = listSub.indexWhere((element) => element.content
        .toLowerCase()
        .trim()
        .contains(widget.dataTalk.name.trim().toLowerCase()));
    if (filterIndex == -1) {
      _isMainSentence = false;
    } else {
      _isMainSentence = true;
      mauCauChinh = filterIndex;
    }
  }

  // Cắt thời gian để so sánh
  int cutNumber(int num) {
    String numString = '$num';
    if (numString.length == 1) {
      return 0;
    }

    int newNum = int.parse(
      numString.substring(0, (numString.length - 2)),
    );
    return newNum;
  }

  int cutNumber2(int num) {
    String numString = '$num';
    if (numString.length == 1) {
      return 0;
    }

    int newNum = int.parse(
      numString.substring(0, (numString.length - 3)),
    );
    return newNum;
  }

  setPlaybackRate() {
    if (playrate == '1') {
      widget.controllerYT.setPlaybackRate(0.75);
      setState(() {
        playrate = '0.75';
      });
    } else if (playrate == '0.75') {
      widget.controllerYT.setPlaybackRate(0.5);
      setState(() {
        playrate = '0.5';
      });
    } else {
      widget.controllerYT.setPlaybackRate(1);
      setState(() {
        playrate = '1';
      });
    }
  }

  void nextSub(event) {
    for (var i = 0; i < widget.listSub.length; i++) {
      if (cutNumber(Duration(milliseconds: widget.listSub[i].startTime)
              .inMilliseconds) ==
          cutNumber(event.position.inMilliseconds)) {
        if (_activeSlide) {
          sliderController.jumpToPage(i);
        }
        setState(() {
          index = i;
        });
      }
    }
  }

  void listener(event) async {
    try {
      if (widget.listSub[mauCauChinh].endTime != 0) {
        if (status3) {
          if (_isMainSentence) {
            if (cutNumber(Duration(
                            milliseconds: widget.listSub[mauCauChinh].endTime)
                        .inMilliseconds) ==
                    cutNumber(event.position.inMilliseconds) &&
                loop < 2) {
              Future.delayed(
                  Duration(
                      milliseconds: widget.listSub[mauCauChinh].endTime -
                          widget.listSub[mauCauChinh].startTime), () async {
                setState(() {
                  checkRepeat = true;
                });
              });
              if (checkRepeat) {
                widget.controllerYT.seekTo(Duration(
                    milliseconds: (widget.listSub[mauCauChinh].startTime)));
                // sliderController.jumpToPage(mauCauChinh);
                _activeSlide = false;
                loop++;
                setState(() {
                  checkRepeat = false;
                });
                if (loop == 2) {
                  _activeSlide = true;
                }
              }
            } else {
              nextSub(event);
            }
          } else {
            nextSub(event);
          }
        } else {
          nextSub(event);
        }
      } else {
        if (status3) {
          if (_isMainSentence) {
            if (cutNumber(Duration(
                            milliseconds:
                                widget.listSub[mauCauChinh + 1].startTime)
                        .inMilliseconds) ==
                    cutNumber(event.position.inMilliseconds) &&
                loop < 2) {
              Future.delayed(
                  Duration(
                      milliseconds: widget.listSub[mauCauChinh + 1].startTime -
                          widget.listSub[mauCauChinh].startTime), () async {
                setState(() {
                  checkRepeat = true;
                });
              });
              if (checkRepeat) {
                widget.controllerYT.seekTo(Duration(
                    milliseconds: (widget.listSub[mauCauChinh].startTime)));
                // sliderController.jumpToPage(mauCauChinh);
                _activeSlide = false;
                loop++;
                setState(() {
                  checkRepeat = false;
                });
                if (loop == 2) {
                  _activeSlide = true;
                }
              }
            } else {
              nextSub(event);
            }
          } else {
            nextSub(event);
          }
        } else {
          nextSub(event);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      if (event.isReady) {
        if (status1) {
          if (event.playerState == PlayerState.unknown) {
            widget.controllerYT.play();
          }
        }
      }
      if (mounted) {
        setState(() {
          stateBtn = event.playerState;
          ended = event.position;
        });
      }

      if (event.playerState == PlayerState.paused &&
          checkEndVideo == false &&
          status2 == true) {
        widget.controllerYT.play();
        setState(() {
          checkEndVideo = true;
        });
      }

      if (event.playerState == PlayerState.ended && checkEndVideo == true) {
        if (checkEndVideo) {
          widget.controllerYT
              .seekTo(Duration(milliseconds: (widget.listSub[0].startTime)));
          setState(() {
            checkEndVideo = false;
            loop = 0;
          });
          widget.controllerYT.pause();
        }
      }
    }
  }

  List<String> _listCheck = [];

  //tạo String để chọn ra từ chính
  List<TextSpan> createTextSpans(String texEnglish, String mainSentence) {
    var themeProvider = context.watch<ThemeProvider>();
    // print("texEnglish:$texEnglish");
    _listCheck.clear();
    final arrayMainSentence = mainSentence.split(",");
    final arrayStrings = texEnglish.split(" ");
    List<String> convertArray = [];
    if (arrayMainSentence.isNotEmpty) {
      arrayMainSentence.forEach((element) {
        convertArray.add(element.replaceAll(RegExp(r'[^\w\s]+'), ''));
      });
    }

    List<TextSpan> arrayOfTextSpan = [];
    for (int index = 0; index < arrayStrings.length; index++) {
      final text = arrayStrings[index];
      String textLanguage = text
          .replaceAll(",", "")
          .replaceAll("!", "")
          .replaceAll(".", "")
          .replaceAll("''", "")
          .replaceAll("?", "");

      if (!_listCheck.contains(textLanguage)) {
        _listCheck.add(textLanguage);
        Provider.of<DialogProvider>(context, listen: false)
            .checkLanguage(textLanguage, convertArray);
      } else {
        Provider.of<DialogProvider>(context, listen: false)
            .checkLanguage("", convertArray);
      }

      bool check = Provider.of<DialogProvider>(context, listen: false).isCheck;

      final span = TextSpan(
        text: "",
        children: [
          WidgetSpan(
            child: check
                ? GestureDetector(
                    onTap: () {
                      if (convertArray.length > 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                    index: convertArray.indexOf(textLanguage),
                                    listLanguage: arrayMainSentence,
                                    controller: widget.controllerYT,
                                  )),
                        );
                        widget.controllerYT.pause();
                      } else {
                        Utils().showNotificationBottom(
                            false, S.of(context).ThisWordIsCurrently);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: themeProvider.mode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                  width: 1))),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height <= 667
                              ? 17
                              : 21,
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 1.0),
                    child: Text(text,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height <= 667
                                ? 17
                                : 21,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center),
                  ),
          ),
          const TextSpan(
            text: " ",
          )
        ],
      );
      arrayOfTextSpan.add(span);
    }
    return arrayOfTextSpan;
  }

  void logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.clear().then((value) => {
          printYellow("CLEAR OK "),
          SocialNetworks().facebookLogout(),
          SocialNetworks().googleLogout(),
          DataOffline().clearCache(),
          RoutersManager().clearRoute(),
          Provider.of<LocaleProvider>(context, listen: false)
              .reloadWithLogout(),
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginAccountScreen(),
            ),
            (route) => false,
          ),
        });
    var staticsticalProvider = Provider.of<StaticsticalProvider>(
      context,
      listen: false,
    );
    staticsticalProvider.clear();

    print('Đây là count: ${prefs.getInt('Heart_Global')}');
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

  setFirstNewPlayVideo(bool isFirst) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstNewPlayVideo', isFirst);
  }

  Future<bool> getFirstNewPlayVideo() async {
    var _isFirst;
    final prefs = await SharedPreferences.getInstance();
    _isFirst = (prefs.getBool('firstNewPlayVideo') != null)
        ? prefs.getBool('firstNewPlayVideo')!
        : false;
    return _isFirst;
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "keyButtonSub",
        keyTarget: keyButtonSub,
        alignSkip: Alignment.topRight,
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
                      S.of(context).ClickHereToHide,
                      style: TextStyle(
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

    targets.add(
      TargetFocus(
        identify: "keyButtonSaveChat",
        keyTarget: keyButtonSaveChat,
        alignSkip: Alignment.topRight,
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
                      S.of(context).ClickHereToSave,
                      style: TextStyle(
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
        shape: ShapeLightFocus.Circle,
        radius: 5,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyButtonReview",
        keyTarget: keyButtonReview,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).YouCanPractice,
                      style: TextStyle(
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
    targets.add(
      TargetFocus(
        identify: "keyButtonQuizVideo",
        keyTarget: keyButtonQuizVideo,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).ClickHereToPlay,
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

  void autoScroll(GlobalKey key) {
    scrController.position
        .ensureVisible(key.currentContext!.findRenderObject()!);
  }

  void showTutorial() {
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.black.withOpacity(0.5),
      textSkip: S.of(context).skip,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
        if (target.keyTarget == keyButtonSaveChat) {
          autoScroll(keyButtonReview);
        } else if (target.keyTarget == keyButtonReview) {
          autoScroll(keyButtonQuizVideo);
        } else if (target.keyTarget == keyButtonQuizVideo) {
          setFirstNewPlayVideo(true);
        }
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        setFirstNewPlayVideo(true);
      },
      onSkip: () {
        setFirstNewPlayVideo(true);
      },
    )..show();
  }

  void adsCallback(BuildContext context) async {
    printRed("CALL BACK: ");
    // int count = 3;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setInt("count_heart", count);
    // printGreen("ADDED: ");
    var heartProvider = Provider.of<CountHeartProvider>(
      context,
      listen: false,
    );
    var numberHeart = await UserAPIs().addAndDivHeart(
      username: DataCache().getUserData().username,
      uid: DataCache().getUserData().uid,
      typeAction: ConfigHeart.nhan_tim_tu_admob_cong_tim,
    );
    heartProvider.setCountHeart(numberHeart);
    // Navigator.pop(context, numberHeart);
  }

  @override
  void initState() {
    admob.showRewaredGameHasCallback(adsCallback, context);
    Future.delayed(const Duration(seconds: 2), () {
      _tooltipController.showTooltip(immediately: false, autoClose: true);
    });
    nativeLang = handleLanguage();
    getIndexLoop(widget.listSub);
    widget.controllerYT.listen(listener);
    _fetchChannel = TalkAPIs().getCategoryById(
      categoryId: widget.dataTalk.catId,
    );
    playerExpandProgress.addListener(() {
      if (playerExpandProgress.value == 70.0) {
        if (widget.controllerYT.value.playerState == PlayerState.paused) {
          widget.controllerYT.play();
        }
      }
      if (playerExpandProgress.value == MediaQuery.of(context).size.height) {
        if (widget.controllerYT.value.playerState == PlayerState.paused) {
          widget.controllerYT.play();
        }
      }
    });
    getFirstNewPlayVideo().then((value) => {
          if (value == false) {Future.delayed(Duration.zero, showTutorial)}
        });

    super.initState();
  }

  bool _isFirstUse = true;

  @override
  void didChangeDependencies() async {
    quizVideoProvider = Provider.of<QuizVideoProvider>(
      context,
      listen: false,
    );

    print('Nhảy vào player video builder lần nữa');

    localeProvider = Provider.of<LocaleProvider>(
      context,
      listen: false,
    );

    language = [
      'ALL',
      'EN',
      localeProvider.locale!.languageCode.toUpperCase(),
      'OFF'
    ];
    if (_checkSetting) {
      await admob.getBannerSmall();
      _prefs = await SharedPreferences.getInstance();
      if (_prefs.containsKey('settingVideo-autoPlay')) {
        status1 = _prefs.getBool('settingVideo-autoPlay')!;
      } else {
        _prefs.setBool('settingVideo-autoPlay', status1);
      }
      if (_prefs.containsKey('settingVideo-autoLoopSentence')) {
        status3 = _prefs.getBool('settingVideo-autoLoopSentence')!;
      } else {
        _prefs.setBool('settingVideo-autoLoop', status3);
      }
      if (_prefs.containsKey('settingVideo-autoLoop')) {
        status2 = _prefs.getBool('settingVideo-autoLoop')!;
      } else {
        _prefs.setBool('settingVideo-autoLoop', status2);
      }
      if (_prefs.containsKey('isFirstUse')) {
        _isFirstUse = _prefs.getBool('isFirstUse')!;
      } else {
        _prefs.setBool('isFirstUse', _isFirstUse);
      }
    }
    setState(() {
      _checkSetting = false;
    });
    super.didChangeDependencies();
  }

  void modifierSetting({required int idButton, required bool value}) async {
    if (idButton == 1) {
      _prefs.setBool('settingVideo-autoPlay', value);
    } else if (idButton == 3) {
      _prefs.setBool('settingVideo-autoLoop', value);
    }
  }

  bool repeat = false;
  int index = 0;
  int loop = 0;
  int mauCauChinh = 2;
  bool checkRepeat = true;
  int indexNew = 0;
  bool firstTime = true;
  DataUser userData = DataCache().getUserData();
  final _tooltipController = JustTheController();

  Widget _buildTooltips(int index) {
    if (_isFirstUse) {
      return JustTheTooltip(
        controller: _tooltipController,
        child: const Icon(
          Icons.add,
          size: 25,
        ),
        onDismiss: () {
          _prefs.setBool('isFirstUse', false);
          setState(() {
            _isFirstUse = false;
          });
        },
        showDuration: Duration(seconds: 15),
        content: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            S.of(context).ClickHereToAddSampleSentencesToTheReviewSection,
          ),
        ),
      );
    }
    return const Icon(
      Icons.add,
      size: 25,
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var localeProvider = Provider.of<LocaleProvider>(context);
    var socketProvider = context.read<SocketProvider>();
    socketProvider.setIsInsideRoom(false);
    print(MediaQuery.of(context).size.height);
    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return !_checkSetting
            ? GestureDetector(
                onTap: () {
                  print(
                    'Đây là height hiện tại của mini: ${playerExpandProgress.value}',
                  );
                  if (playerExpandProgress.value == 70.0) {
                    final videoProvider =
                        Provider.of<VideoProvider>(context, listen: false);
                    videoProvider.miniplayer.animateToHeight(
                      state: PanelState.MAX,
                    );
                  }
                },
                onPanUpdate: widget.enablePop
                    ? (details) {
                        if (details.delta.dx > 0) {
                          Navigator.pop(context);
                        }
                      }
                    : null,
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 0,
                  ),
                  color: widget.percent == 0
                      ? Colors.black.withOpacity(0.8)
                      : themeProvider.mode == ThemeMode.dark
                          ? const Color.fromRGBO(24, 26, 33, 1)
                          : Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: widget.percent < 0.5
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 20),
                                child: Stack(
                                  children: [
                                    widget.player,
                                    Container(
                                      width: widget.percent < 0.3
                                          ? 124
                                          : MediaQuery.of(context).size.width,
                                      height: widget.percent < 0.3
                                          ? 124 * 9 / 16
                                          : MediaQuery.of(context).size.width *
                                              9 /
                                              16,
                                      child: stateBtn == PlayerState.playing
                                          ? InkWell(
                                              onTap: () {
                                                widget.controllerYT.pause();
                                              },
                                              onDoubleTap: () {},
                                              child: Container(
                                                width: widget.percent < 0.3
                                                    ? 124
                                                    : MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                height: widget.percent < 0.3
                                                    ? 124 * 9 / 16
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        9 /
                                                        16,
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.center,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    checkEndVideo = true;
                                                  });
                                                  if (stateBtn ==
                                                      PlayerState.ended) {
                                                    nextSlide(
                                                        widget.listSub.length -
                                                            1);
                                                    widget.controllerYT.play();
                                                    setState(() {
                                                      loop = 0;
                                                    });
                                                  } else {
                                                    widget.controllerYT.play();
                                                  }
                                                },
                                                child: Container(
                                                  width: widget.percent < 0.3
                                                      ? 124
                                                      : MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  height: widget.percent < 0.3
                                                      ? 124 * 9 / 16
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          9 /
                                                          16,
                                                  child: widget.percent < 0.5
                                                      ? const Icon(
                                                          Icons.play_circle,
                                                          size: 30,
                                                          color: Colors.white,
                                                        )
                                                      : const Icon(
                                                          Icons.play_circle,
                                                          size: 60,
                                                          color: Colors.white,
                                                        ),
                                                ),
                                              ),
                                            ),
                                    ),

                                    // IconButton(
                                    //   onPressed: () {
                                    //     Navigator.pop(context);
                                    //   },
                                    //   icon: Icon(
                                    //     Icons.navigate_before,
                                    //     size: 30,
                                    //   ),
                                    // ),
                                    if (widget.percent > 0.9)
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 20, right: 6),
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Expanded(
                                                      child: SizedBox()),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      mystate) {
                                                            return Container(
                                                              height: 350,
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            16),
                                                                    child: Row(
                                                                        children: [
                                                                          Text(
                                                                              S.of(context).Setting,
                                                                              style: TextStyle(fontSize: 22)),
                                                                          const Expanded(
                                                                              child: SizedBox()),
                                                                          GestureDetector(
                                                                            child:
                                                                                Icon(
                                                                              Icons.close,
                                                                              size: 30,
                                                                              color: themeProvider.mode == ThemeMode.dark ? Colors.white : Colors.black,
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          )
                                                                        ]),
                                                                  ),
                                                                  Container(
                                                                    height: 1,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            16),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(S
                                                                            .of(context)
                                                                            .subtitle),
                                                                        const Expanded(
                                                                            child:
                                                                                SizedBox()),
                                                                        Radio(
                                                                          value:
                                                                              0,
                                                                          groupValue:
                                                                              indextLanguage,
                                                                          onChanged:
                                                                              (val) {
                                                                            mystate(() {
                                                                              indextLanguage = 0;
                                                                            });
                                                                          },
                                                                        ),
                                                                        Text(
                                                                          language[
                                                                              0],
                                                                        ),
                                                                        Radio(
                                                                          value:
                                                                              1,
                                                                          groupValue:
                                                                              indextLanguage,
                                                                          onChanged:
                                                                              (val) {
                                                                            mystate(() {
                                                                              indextLanguage = 1;
                                                                            });
                                                                          },
                                                                        ),
                                                                        Text(
                                                                          language[
                                                                              1],
                                                                        ),
                                                                        Radio(
                                                                          value:
                                                                              2,
                                                                          groupValue:
                                                                              indextLanguage,
                                                                          onChanged:
                                                                              (val) {
                                                                            mystate(() {
                                                                              indextLanguage = 2;
                                                                            });
                                                                          },
                                                                        ),
                                                                        localeProvider.locale!.languageCode.toUpperCase() ==
                                                                                'EN'
                                                                            ? const SizedBox()
                                                                            : Row(
                                                                                children: [
                                                                                  Text(
                                                                                    language[2],
                                                                                  ),
                                                                                  Radio(
                                                                                    value: 3,
                                                                                    groupValue: indextLanguage,
                                                                                    onChanged: (val) {
                                                                                      mystate(() {
                                                                                        indextLanguage = 3;
                                                                                      });
                                                                                    },
                                                                                  )
                                                                                ],
                                                                              ),
                                                                        Text(
                                                                          language[
                                                                              3],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            16),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(S
                                                                            .of(context)
                                                                            .Autoplay),
                                                                        const Expanded(
                                                                            child:
                                                                                SizedBox()),
                                                                        CustomSwitch(
                                                                          activeColor:
                                                                              Colors.pinkAccent,
                                                                          value:
                                                                              status1,
                                                                          onChanged:
                                                                              (value) {
                                                                            mystate(() {
                                                                              status1 = value;
                                                                            });
                                                                            modifierSetting(
                                                                                idButton: 1,
                                                                                value: value);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            16),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(S
                                                                            .of(context)
                                                                            .AutoRepeat),
                                                                        const Expanded(
                                                                            child:
                                                                                SizedBox()),
                                                                        CustomSwitch(
                                                                          activeColor:
                                                                              Colors.pinkAccent,
                                                                          value:
                                                                              status2,
                                                                          onChanged:
                                                                              (value) {
                                                                            mystate(() {
                                                                              status2 = value;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            16),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(S
                                                                            .of(context)
                                                                            .RepeatMainSentencePattern),
                                                                        const Expanded(
                                                                            child:
                                                                                SizedBox()),
                                                                        CustomSwitch(
                                                                          activeColor:
                                                                              Colors.pinkAccent,
                                                                          value:
                                                                              status3,
                                                                          onChanged:
                                                                              (value) {
                                                                            mystate(() {
                                                                              status3 = value;
                                                                            });
                                                                            modifierSetting(
                                                                                idButton: 3,
                                                                                value: value);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                        },
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.settings,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Expanded(child: SizedBox()),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    indextLanguage++;
                                                  });
                                                  if (indextLanguage >=
                                                      language.length) {
                                                    setState(() {
                                                      indextLanguage = 0;
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  margin:
                                                      const EdgeInsets.all(8),
                                                  height: 25,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Text(
                                                    language[indextLanguage],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                width: widget.percent < 0.1
                                    ? 124
                                    : MediaQuery.of(context).size.width,
                                height: widget.percent < 0.1
                                    ? 124 * 9 / 16
                                    : MediaQuery.of(context).size.width *
                                        9 /
                                        16,
                              ),
                              if (widget.percent < 0.5)
                                const SizedBox(width: 10),
                              if (widget.percent < 0.5)
                                Opacity(
                                  opacity: 1 - (2 * widget.percent),
                                  child: SizedBox(
                                    width: 130,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        widget.dataTalk.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (widget.percent < 0.5)
                            Opacity(
                              opacity: 1,
                              child: InkWell(
                                  onTap: () {
                                    if (stateBtn == PlayerState.ended) {
                                      nextSlide(widget.listSub.length - 1);
                                      widget.controllerYT.play();
                                    } else if (stateBtn ==
                                        PlayerState.playing) {
                                      widget.controllerYT.pause();
                                    } else {
                                      widget.controllerYT.play();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    child: stateBtn == PlayerState.playing
                                        ? const Icon(
                                            Icons.pause,
                                            size: 35,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            Icons.play_arrow,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                  )),
                            ),
                          // SizedBox(width: 10 - (10 * widget.percent)),
                          if (widget.percent < 0.5)
                            Opacity(
                              opacity: 1,
                              child: InkWell(
                                onTap: () {
                                  Provider.of<VideoProvider>(context,
                                          listen: false)
                                      .setdataTalk(null);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.clear,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          // SizedBox(
                          //   width: 15 - (15 * widget.percent),
                          // ),
                        ],
                      ),
                      widget.percent < 0.5
                          ? const SizedBox()
                          : Expanded(
                              child: Opacity(
                                opacity: widget.percent,
                                child: AnimatedContainer(
                                  duration: const Duration(seconds: 50),
                                  child: ListView(
                                    controller: scrController,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.all(0),
                                    children: [
                                      CarouselSlider.builder(
                                        key: keyPositionFirst,
                                        carouselController: sliderController,
                                        itemCount: widget.listSub.length == 0
                                            ? 1
                                            : widget.listSub.length,
                                        options: CarouselOptions(
                                          scrollPhysics:
                                              const NeverScrollableScrollPhysics(),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2.3,
                                          autoPlay: false,
                                          viewportFraction: 1,
                                        ),
                                        itemBuilder: (context, itemIndex,
                                                pageViewIndex) =>
                                            SwipeTo(
                                          // Swiping in right direction.
                                          onLeftSwipe: () {
                                            if (widget.listSub.length > 1) {
                                              nextSlide(itemIndex);
                                            }
                                          },

                                          // Swiping in left direction.
                                          onRightSwipe: () {
                                            if (widget.listSub.length > 1) {
                                              previousSlide(itemIndex);
                                            }
                                          },
                                          offsetDx: 0,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  color: themeProvider.mode ==
                                                          ThemeMode.dark
                                                      ? const Color.fromRGBO(
                                                          24, 26, 33, 1)
                                                      : Colors.white,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 2,
                                                    vertical: 2,
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (stateBtn ==
                                                          PlayerState.playing) {
                                                        widget.controllerYT
                                                            .pause();
                                                      } else if (stateBtn ==
                                                          PlayerState.paused) {
                                                        widget.controllerYT
                                                            .play();
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: Colors.white
                                                          //     .withOpacity(.1),
                                                          color: themeProvider
                                                                      .mode ==
                                                                  ThemeMode.dark
                                                              ? const Color
                                                                      .fromRGBO(
                                                                  42, 44, 50, 1)
                                                              : Colors.white
                                                                  .withOpacity(
                                                                      .1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                            color: themeProvider
                                                                        .mode ==
                                                                    ThemeMode
                                                                        .dark
                                                                ? Colors.black
                                                                : Colors.grey,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: hideSub
                                                              ? ((DataCache().getUserData().isVip ==
                                                                              0 ||
                                                                          DataCache().getUserData().isVip ==
                                                                              3) &&
                                                                      (widget.dataTalk
                                                                              .isVip ==
                                                                          true))
                                                                  ? Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Align(
                                                                                  alignment: Alignment.center,
                                                                                  child: Icon(
                                                                                    Icons.lock,
                                                                                    size: 25,
                                                                                    color: Colors.grey[600],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(height: 10),
                                                                                Align(
                                                                                  alignment: Alignment.center,
                                                                                  child: Text(
                                                                                    S.of(context).ExclusivelyForTurtleVIPMembers,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                300,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                ElevatedButton(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                    height: 30,
                                                                                    width: 30,
                                                                                    child: SvgPicture.asset('assets/icons-svg/icon_ruby.svg'),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Container(
                                                                                    constraints: BoxConstraints(maxWidth: 220),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        S.of(context).Use1heart,
                                                                                        style: const TextStyle(fontSize: 16, color: Colors.white),
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              onPressed: () async {
                                                                                var providerHeart = Provider.of<CountHeartProvider>(context, listen: false);
                                                                                if (userData.uid == 0) {
                                                                                  logOut(context);
                                                                                } else if (providerHeart.countHeart == 0) {
                                                                                  await showModalBottomSheet(
                                                                                    context: context,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    builder: (BuildContext context) {
                                                                                      return StatefulBuilder(
                                                                                        builder: (ctx, innerState) {
                                                                                          var heartProvider = Provider.of<CountHeartProvider>(context, listen: false);
                                                                                          void adsCallback(BuildContext context) async {
                                                                                            var numberHeart = await UserAPIs().addAndDivHeart(
                                                                                              username: DataCache().getUserData().username,
                                                                                              uid: DataCache().getUserData().uid,
                                                                                              typeAction: ConfigHeart.nhan_tim_tu_admob_cong_tim,
                                                                                            );
                                                                                            heartProvider.setCountHeart(numberHeart);
                                                                                            Navigator.pop(context);
                                                                                          }

                                                                                          void showAds(BuildContext context) {
                                                                                            AdsController().showAdsCallback(adsCallback, context);
                                                                                          }

                                                                                          return Container(
                                                                                            padding: const EdgeInsets.all(16),
                                                                                            height: MediaQuery.of(context).size.height / 2.7,
                                                                                            color: themeProvider.mode == ThemeMode.dark ? const Color.fromRGBO(42, 44, 50, 1) : Colors.grey[100],
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Align(
                                                                                                  alignment: Alignment.centerRight,
                                                                                                  child: GestureDetector(
                                                                                                    onTap: () {
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: Icon(
                                                                                                      Icons.close,
                                                                                                      size: 25,
                                                                                                      color: themeProvider.mode == ThemeMode.dark ? Colors.white : Colors.black,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Stack(
                                                                                                  alignment: Alignment.center,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      width: 90,
                                                                                                      height: 90,
                                                                                                      child: SvgPicture.asset(
                                                                                                        'assets/icons-svg/icon_ruby.svg',
                                                                                                        fit: BoxFit.cover,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      '${heartProvider.countHeart}',
                                                                                                      style: const TextStyle(
                                                                                                        color: Colors.white,
                                                                                                        fontSize: 22,
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                                const SizedBox(height: 10),
                                                                                                Align(
                                                                                                  alignment: Alignment.center,
                                                                                                  child: Text(
                                                                                                    S.of(context).NumberOfDiamondsOwned,
                                                                                                    style: const TextStyle(
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      fontSize: 18,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                heartProvider.countHeart == 7 ? SizedBox(height: 10) : SizedBox(),
                                                                                                heartProvider.countHeart == 7
                                                                                                    ? Align(
                                                                                                        alignment: Alignment.center,
                                                                                                        child: Text(S.of(context).Youhaveofhearts),
                                                                                                      )
                                                                                                    : const SizedBox(),
                                                                                                const SizedBox(height: 10),
                                                                                                heartProvider.countHeart == 7
                                                                                                    ? ElevatedButton(
                                                                                                        onPressed: () {
                                                                                                          Navigator.pop(context);
                                                                                                        },
                                                                                                        child: const Text('OK'),
                                                                                                      )
                                                                                                    : ElevatedButton(
                                                                                                        onPressed: () {
                                                                                                          showAds(ctx);
                                                                                                        },
                                                                                                        child: Text(S.of(context).Watchadstogetmorehearts),
                                                                                                      )
                                                                                              ],
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                } else {
                                                                                  var numberHeart = await UserAPIs().addAndDivHeart(
                                                                                    username: DataCache().getUserData().username,
                                                                                    uid: DataCache().getUserData().uid,
                                                                                    typeAction: ConfigHeart.xem_video_vip,
                                                                                  );
                                                                                  providerHeart.setCountHeart(numberHeart);
                                                                                  Utils().showNotificationBottom(true, S.of(context).Used1heart + '($numberHeart)');

                                                                                  setState(() {
                                                                                    hideSub = false;
                                                                                  });
                                                                                }
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                300,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                ElevatedButton(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                      child: Image.asset(
                                                                                    'assets/icons-svg/icon_vip.png',
                                                                                    width: 40,
                                                                                  )),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Text(
                                                                                    S.of(context).StartUsingVIP,
                                                                                    style: const TextStyle(fontSize: 16, color: Colors.white),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              onPressed: () {
                                                                                Navigator.of(context).push(
                                                                                  MaterialPageRoute(
                                                                                    builder: (_) {
                                                                                      return VipWidget();
                                                                                    },
                                                                                  ),
                                                                                );
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ))
                                                                  : Column(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Card(
                                                                                        key: keyButtonSpeed,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(50),
                                                                                          side: BorderSide(
                                                                                            color: Colors.grey[300]!,
                                                                                            width: 1,
                                                                                          ),
                                                                                        ),
                                                                                        elevation: 0,
                                                                                        child: InkWell(
                                                                                          hoverColor: Colors.red,
                                                                                          onTap: setPlaybackRate,
                                                                                          child: Container(
                                                                                            padding: const EdgeInsets.symmetric(
                                                                                              horizontal: 5,
                                                                                              vertical: 10,
                                                                                            ),
                                                                                            width: 65,
                                                                                            child: Align(
                                                                                              child: Text(
                                                                                                '${playrate}x',
                                                                                                style: TextStyle(
                                                                                                  fontSize: 14,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                ),
                                                                                              ),
                                                                                              alignment: Alignment.center,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      widget.listSub.length != 0
                                                                                          ? (drillOn
                                                                                              ? const SizedBox()
                                                                                              : InkWell(
                                                                                                  hoverColor: Colors.red,
                                                                                                  onTap: () {
                                                                                                    widget.controllerYT.seekTo(Duration(milliseconds: (widget.listSub[index].startTime)));
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    width: 45,
                                                                                                    height: 45,
                                                                                                    child: Card(
                                                                                                      elevation: 10,
                                                                                                      child: SvgPicture.asset(
                                                                                                        'assets/new_ui/more/repeat.svg',
                                                                                                        color: themeProvider.mode == ThemeMode.dark ? Colors.white : Colors.black,
                                                                                                        fit: BoxFit.scaleDown,
                                                                                                      ),
                                                                                                      shape: RoundedRectangleBorder(
                                                                                                        borderRadius: BorderRadius.circular(50),
                                                                                                        side: BorderSide(
                                                                                                          color: Colors.white,
                                                                                                          width: 0.5,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ))
                                                                                          : const SizedBox(),
                                                                                    ],
                                                                                  ),
                                                                                  if (widget.listSub.length != 0)
                                                                                    FlutterSwitch(
                                                                                      key: keyButtonSub,
                                                                                      value: drillOn,
                                                                                      activeText: 'Drill',
                                                                                      inactiveText: 'Drill',
                                                                                      borderRadius: 20,
                                                                                      inactiveColor: Colors.grey,
                                                                                      showOnOff: true,
                                                                                      onToggle: (val) {
                                                                                        if (!val) {
                                                                                          setState(() {
                                                                                            longPress = !val;
                                                                                          });
                                                                                        }

                                                                                        setState(() {
                                                                                          drillOn = val;
                                                                                        });
                                                                                      },
                                                                                      valueFontSize: Platform.isAndroid ? 16 : 13,
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              longPress
                                                                                  ? const SizedBox()
                                                                                  : RichText(
                                                                                      text: TextSpan(children: createTextSpans(widget.listSub[itemIndex].content, widget.listSub[itemIndex].mainSentence)),
                                                                                    ),
                                                                              (indextLanguage == 3
                                                                                  ? Container(
                                                                                      child: Text(
                                                                                        '[${S.of(context).SubtitlesAreHiding}]',
                                                                                        style: const TextStyle(
                                                                                          fontSize: 21,
                                                                                          height: 1.5,
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  : widget.listSub.length != 0
                                                                                      ? (drillOn
                                                                                          ? const SizedBox()
                                                                                          : (indextLanguage != 1 && indextLanguage != 0
                                                                                              ? const SizedBox()
                                                                                              : RichText(
                                                                                                  text: TextSpan(children: createTextSpans(widget.listSub[itemIndex].content, widget.listSub[itemIndex].mainSentence)),
                                                                                                )))
                                                                                      : const SizedBox()),
                                                                              const SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              longPress
                                                                                  ? const SizedBox()
                                                                                  : Text(
                                                                                      Utils.changeLanguageVideo((localeProvider.codeLangeSub != null) ? localeProvider.codeLangeSub! : localeProvider.locale!.languageCode, itemIndex, widget.listSub) == 'null'
                                                                                          ? Utils.changeLanguageVideo('en', itemIndex, widget.listSub)
                                                                                          : Utils.changeLanguageVideo(
                                                                                              (localeProvider.codeLangeSub != null) ? localeProvider.codeLangeSub! : localeProvider.locale!.languageCode,
                                                                                              itemIndex,
                                                                                              widget.listSub,
                                                                                            ),
                                                                                      textAlign: TextAlign.left,
                                                                                      style: TextStyle(
                                                                                        fontSize: MediaQuery.of(context).size.height <= 667.0 ? 14 : 17,
                                                                                        height: 1.2,
                                                                                        color: Colors.grey[600],
                                                                                      ),
                                                                                    ),
                                                                              widget.listSub.length != 0
                                                                                  ? (drillOn
                                                                                      ? const SizedBox()
                                                                                      : localeProvider.locale!.languageCode == "en"
                                                                                          ? (localeProvider.codeLangeSub != null && localeProvider.codeLangeSub != 'en')
                                                                                              ? Text(
                                                                                                  Utils.changeLanguageVideo((localeProvider.codeLangeSub != null) ? localeProvider.codeLangeSub! : localeProvider.locale!.languageCode, itemIndex, widget.listSub),
                                                                                                  textAlign: TextAlign.left,
                                                                                                  style: TextStyle(
                                                                                                    fontSize: MediaQuery.of(context).size.height <= 667.0 ? 14 : 17,
                                                                                                    height: 1.2,
                                                                                                    color: Colors.grey[600],
                                                                                                  ),
                                                                                                )
                                                                                              : const SizedBox()
                                                                                          : (indextLanguage != 2 && indextLanguage != 0
                                                                                              ? const SizedBox()
                                                                                              : Text(
                                                                                                  Utils.changeLanguageVideo((localeProvider.codeLangeSub != null) ? localeProvider.codeLangeSub! : localeProvider.locale!.languageCode, itemIndex, widget.listSub),
                                                                                                  textAlign: TextAlign.left,
                                                                                                  style: TextStyle(
                                                                                                    fontSize: MediaQuery.of(context).size.height <= 667.0 ? 14 : 17,
                                                                                                    height: 1.2,
                                                                                                    color: Colors.grey[600],
                                                                                                  ),
                                                                                                )))
                                                                                  : const SizedBox(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        widget.listSub.length !=
                                                                                0
                                                                            ? (drillOn
                                                                                ? const SizedBox()
                                                                                : Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            '${itemIndex + 1}',
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.grey[600],
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            '/${widget.listSub.length}',
                                                                                            style: TextStyle(
                                                                                              color: Colors.grey[600],
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      InkWell(
                                                                                        key: keyButtonSaveChat,
                                                                                        child: Card(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(
                                                                                              50,
                                                                                            ),
                                                                                            side: BorderSide(
                                                                                              color: Colors.grey[300]!,
                                                                                            ),
                                                                                          ),
                                                                                          elevation: 0,
                                                                                          child: DataCache().checkSentenceVideo(widget.listSub[itemIndex], 1) == false
                                                                                              ? Padding(
                                                                                                  padding: const EdgeInsets.all(5),
                                                                                                  child: InkWell(
                                                                                                    onTap: DataCache().getUserData().uid == 0
                                                                                                        ? () {
                                                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LoginAccountScreen()));
                                                                                                          }
                                                                                                        : () async {
                                                                                                            TalkAPIs().addItemCourse('${DataCache().getUserData().uid}', widget.listSub[itemIndex].id.toString(), 1, lang).then((value) {
                                                                                                              (context as Element).markNeedsBuild();
                                                                                                              if (value == 1) {
                                                                                                                Utils().showNotificationBottom(true, S.of(context).AddedSuccess);
                                                                                                              } else if (value == 0) {
                                                                                                                Utils().showNotificationBottom(false, S.of(context).AddFailedSentence);
                                                                                                              } else if (value == -1) {
                                                                                                                Utils().showNotificationBottom(false, S.of(context).SentencePatternAlready);
                                                                                                              }
                                                                                                            });
                                                                                                            await TalkAPIs().fetchReviewTextData(userData: DataCache().getUserData());
                                                                                                          },
                                                                                                    child: _buildTooltips(itemIndex),
                                                                                                  ),
                                                                                                )
                                                                                              : InkWell(
                                                                                                  onTap: () {
                                                                                                    Utils().showNotificationBottom(false, S.of(context).SentencePatternAlready);
                                                                                                  },
                                                                                                  // child: const Icon(
                                                                                                  //   Icons.check,
                                                                                                  //   color: Colors.green,
                                                                                                  //   size: 25,
                                                                                                  // ),
                                                                                                  child: Lottie.asset(
                                                                                                    'assets/new_ui/animation_lottie/tick.json',
                                                                                                    height: 35,
                                                                                                    repeat: false,
                                                                                                  ),
                                                                                                ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ))
                                                                            : const SizedBox(),
                                                                      ],
                                                                    )
                                                              : Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Card(
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(50),
                                                                                      side: BorderSide(
                                                                                        color: Colors.grey[300]!,
                                                                                        width: 1,
                                                                                      ),
                                                                                    ),
                                                                                    elevation: 0,
                                                                                    child: InkWell(
                                                                                      hoverColor: Colors.red,
                                                                                      onTap: setPlaybackRate,
                                                                                      child: Container(
                                                                                        padding: const EdgeInsets.symmetric(
                                                                                          horizontal: 5,
                                                                                          vertical: 10,
                                                                                        ),
                                                                                        width: 65,
                                                                                        child: Align(
                                                                                          child: Text(
                                                                                            '${playrate}x',
                                                                                            style: const TextStyle(
                                                                                              fontSize: 14,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                          alignment: Alignment.center,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  widget.listSub.length != 0
                                                                                      ? (drillOn
                                                                                          ? const SizedBox()
                                                                                          : Card(
                                                                                              color: Colors.transparent,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(50),
                                                                                                side: BorderSide(
                                                                                                  color: Colors.grey[300]!,
                                                                                                  width: 1,
                                                                                                ),
                                                                                              ),
                                                                                              elevation: 0,
                                                                                              child: InkWell(
                                                                                                hoverColor: Colors.red,
                                                                                                onTap: () {},
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.symmetric(
                                                                                                    horizontal: 8,
                                                                                                    vertical: 8,
                                                                                                  ),
                                                                                                  child: SvgPicture.asset(
                                                                                                    'assets/new_ui/more/repeat.svg',
                                                                                                    color: themeProvider.mode == ThemeMode.dark ? Colors.white : Colors.black,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ))
                                                                                      : const SizedBox(),
                                                                                ],
                                                                              ),
                                                                              if (widget.listSub.length != 0)
                                                                                FlutterSwitch(
                                                                                  value: drillOn,
                                                                                  activeText: 'Drill',
                                                                                  inactiveText: 'Drill',
                                                                                  borderRadius: 20,
                                                                                  inactiveColor: Colors.grey[300]!,
                                                                                  showOnOff: true,
                                                                                  onToggle: (val) {
                                                                                    if (!val) {
                                                                                      setState(() {
                                                                                        longPress = !val;
                                                                                      });
                                                                                    }
                                                                                    if (val) {
                                                                                      widget.controllerYT.pause();
                                                                                    } else {
                                                                                      widget.controllerYT.play();
                                                                                    }
                                                                                    setState(() {
                                                                                      drillOn = val;
                                                                                    });
                                                                                  },
                                                                                  valueFontSize: Platform.isAndroid ? 16 : 13,
                                                                                ),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          longPress
                                                                              ? const SizedBox()
                                                                              : Text(
                                                                                  widget.listSub[itemIndex].content,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: const TextStyle(
                                                                                    fontSize: 21,
                                                                                    height: 1.5,
                                                                                  ),
                                                                                ),
                                                                          widget.listSub.length != 0
                                                                              ? (drillOn
                                                                                  ? const SizedBox()
                                                                                  : Text(
                                                                                      widget.listSub[itemIndex].content,
                                                                                      textAlign: TextAlign.left,
                                                                                      style: const TextStyle(
                                                                                        fontSize: 21,
                                                                                        height: 1.5,
                                                                                      ),
                                                                                    ))
                                                                              : const SizedBox(),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          longPress
                                                                              ? const SizedBox()
                                                                              : Text(
                                                                                  Utils.changeLanguageVideo(localeProvider.locale!.languageCode, itemIndex, widget.listSub),
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(
                                                                                    fontSize: MediaQuery.of(context).size.height <= 667.0 ? 14 : 17,
                                                                                    height: 1.2,
                                                                                    color: Colors.grey[600],
                                                                                  ),
                                                                                ),
                                                                          widget.listSub.length != 0
                                                                              ? (drillOn
                                                                                  ? const SizedBox()
                                                                                  : Text(
                                                                                      Utils.changeLanguageVideo(
                                                                                        localeProvider.locale!.languageCode,
                                                                                        itemIndex,
                                                                                        widget.listSub,
                                                                                      ),
                                                                                      textAlign: TextAlign.left,
                                                                                      style: TextStyle(
                                                                                        fontSize: MediaQuery.of(context).size.height <= 667.0 ? 14 : 17,
                                                                                        height: 1.2,
                                                                                        color: Colors.grey[600],
                                                                                      ),
                                                                                    ))
                                                                              : const SizedBox(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    widget.listSub.length !=
                                                                            0
                                                                        ? (drillOn
                                                                            ? const SizedBox()
                                                                            : Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        '${itemIndex + 1}',
                                                                                        style: TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: Colors.grey[600],
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        '/${widget.listSub.length}',
                                                                                        style: TextStyle(
                                                                                          color: Colors.grey[600],
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  InkWell(
                                                                                    child: Card(
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(
                                                                                          50,
                                                                                        ),
                                                                                        side: BorderSide(
                                                                                          color: Colors.grey[300]!,
                                                                                        ),
                                                                                      ),
                                                                                      elevation: 0,
                                                                                      child: Padding(
                                                                                        child: DataCache().checkSentenceVideo(widget.listSub[itemIndex], 1) == false
                                                                                            ? InkWell(
                                                                                                onTap: () {
                                                                                                  TalkAPIs().addItemCourse('${DataCache().getUserData().uid}', widget.listSub[itemIndex].id.toString(), 1, lang).then((value) {
                                                                                                    (context as Element).markNeedsBuild();
                                                                                                    if (value == 1) {
                                                                                                      Utils().showNotificationBottom(true, S.of(context).AddedSuccess);
                                                                                                    } else if (value == 0) {
                                                                                                      Utils().showNotificationBottom(false, S.of(context).AddFailedSentence);
                                                                                                    } else if (value == -1) {
                                                                                                      Utils().showNotificationBottom(false, S.of(context).SentencePatternAlready);
                                                                                                    }
                                                                                                  });
                                                                                                },
                                                                                                child: const Icon(
                                                                                                  Icons.add,
                                                                                                  size: 25,
                                                                                                ),
                                                                                              )
                                                                                            : InkWell(
                                                                                                onTap: () {
                                                                                                  Utils().showNotificationBottom(false, S.of(context).SentencePatternAlready);
                                                                                                },
                                                                                                child: const Icon(
                                                                                                  Icons.check,
                                                                                                  size: 25,
                                                                                                ),
                                                                                              ),
                                                                                        padding: const EdgeInsets.all(5),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ))
                                                                        : const SizedBox(),
                                                                  ],
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (stateBtn ==
                                                    PlayerState.paused)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              if (widget.listSub
                                                                      .length >
                                                                  0) {
                                                                previousSlide(
                                                                    itemIndex);
                                                              }
                                                            },
                                                            child: Card(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 0,
                                                                  right: 5,
                                                                  top: 5,
                                                                  bottom: 5,
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .chevron_left_sharp,
                                                                ),
                                                              ),
                                                              elevation: 0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          50),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          50),
                                                                ),
                                                                side:
                                                                    BorderSide(
                                                                  color: Colors
                                                                          .grey[
                                                                      300]!,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              if (widget.listSub
                                                                      .length >
                                                                  0) {
                                                                nextSlide(
                                                                    itemIndex);
                                                              }
                                                            },
                                                            child: Card(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 5,
                                                                  right: 0,
                                                                  top: 5,
                                                                  bottom: 5,
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .chevron_right_sharp,
                                                                ),
                                                              ),
                                                              elevation: 0,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          50),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          50),
                                                                ),
                                                                side:
                                                                    BorderSide(
                                                                  color: Colors
                                                                          .grey[
                                                                      300]!,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                drillOn
                                                    ? GestureDetector(
                                                        onTap: () {},
                                                        onTapDown: (detail) {
                                                          if (drillOn)
                                                            setState(() {
                                                              longPress = false;
                                                            });
                                                        },
                                                        onTapUp: (detail) {
                                                          if (drillOn)
                                                            setState(() {
                                                              longPress = true;
                                                            });
                                                        },
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 65,
                                                            ),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.5,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2.3 /
                                                                1.5,
                                                            color: Colors
                                                                .transparent,
                                                            child: !longPress
                                                                ? const SizedBox()
                                                                : Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Align(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .touch_app_outlined,
                                                                          color:
                                                                              Colors.grey[700],
                                                                          size:
                                                                              35,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        S
                                                                            .of(context)
                                                                            .LongPressToSeeSubtitles,
                                                                      )
                                                                    ],
                                                                  ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                if (widget.listSub.length == 0)
                                                  const Align(
                                                    child: Text(
                                                        'Video không có sub'),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: const SizedBox(height: 10),
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? const Color.fromRGBO(
                                                    24, 26, 33, 1)
                                                : Colors.white,
                                      ),
                                      Container(
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? const Color.fromRGBO(
                                                    24, 26, 33, 1)
                                                : Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                child: Text(
                                                  (Utils.changeLanguageTalkName(
                                                              provider.locale!
                                                                  .languageCode,
                                                              widget.dataTalk)
                                                          .contains('null'))
                                                      ? widget.dataTalk.name
                                                      : (Utils
                                                          .changeLanguageTalkName(
                                                              provider.locale!
                                                                  .languageCode,
                                                              widget.dataTalk)),
                                                  style: TextStyle(
                                                    color: themeProvider.mode ==
                                                            ThemeMode.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 2,
                                                )),
                                            const Spacer(),
                                            InkWell(
                                              onTap: () {
                                                showModalBottomSheet<void>(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return DialogSeeMore(
                                                        listSub: widget.listSub,
                                                        dataTalk:
                                                            widget.dataTalk,
                                                      );
                                                    });
                                              }, // Handle your callback.
                                              splashColor:
                                                  Colors.brown.withOpacity(0.5),
                                              child: Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          themeProvider.mode ==
                                                                  ThemeMode.dark
                                                              ? Colors.white
                                                              : Colors.black,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: Icon(
                                                  Icons.more_horiz,
                                                  size: 25,
                                                  color: themeProvider.mode ==
                                                          ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: const SizedBox(height: 10),
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? const Color.fromRGBO(
                                                    24, 26, 33, 1)
                                                : Colors.white,
                                      ),
                                      Container(
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? const Color.fromRGBO(
                                                    24, 26, 33, 1)
                                                : Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: ListButtonSocial(
                                            talkData: widget.dataTalk,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Container(
                                        key: keyButtonReview,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ColorsUtils.Color_53DAC0,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ReviewQuizScreen(
                                              leverQuiz: 2,
                                              listQuiz: Utils().convertListQuiz(
                                                  widget.listSub), admobHelper: admob),
                                        ),
                                      ),
                                      Container(
                                        child: const SizedBox(height: 16),
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? const Color.fromRGBO(
                                                    24, 26, 33, 1)
                                                : Colors.white,
                                      ),
                                      Container(
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? const Color.fromRGBO(
                                                    24, 26, 33, 1)
                                                : Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              S
                                                  .of(context)
                                                  .ChallengetobreaktherecordofListeningPracticeQuiz,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Container(
                                              child: const SizedBox(height: 16),
                                              color: themeProvider.mode ==
                                                      ThemeMode.dark
                                                  ? const Color.fromRGBO(
                                                      24, 26, 33, 1)
                                                  : Colors.white,
                                            ),
                                            ListQuizVideo(
                                              key: keyButtonQuizVideo,
                                              listSub: widget.listSub,
                                              controllerYT: widget.controllerYT,
                                              dataTalk: widget.dataTalk,
                                            ),
                                            Container(
                                              child: const SizedBox(height: 10),
                                              color: themeProvider.mode ==
                                                      ThemeMode.dark
                                                  ? const Color.fromRGBO(
                                                      24, 26, 33, 1)
                                                  : Colors.white,
                                            ),
                                            widget.hideChannel
                                                ? const SizedBox()
                                                : FutureBuilder(
                                                    future: _fetchChannel,
                                                    builder: (context,
                                                        AsyncSnapshot
                                                            categoryData) {
                                                      if (categoryData
                                                          .hasData) {
                                                        itemSub = ItemChanelNew(
                                                          percent:
                                                              widget.percent,
                                                          category:
                                                              categoryData.data,
                                                        );
                                                        return itemSub!;
                                                      } else {
                                                        return itemSub != null
                                                            ? itemSub!
                                                            : Container(
                                                                color: themeProvider
                                                                            .mode ==
                                                                        ThemeMode
                                                                            .dark
                                                                    ? const Color
                                                                            .fromRGBO(
                                                                        24,
                                                                        26,
                                                                        33,
                                                                        1)
                                                                    : Colors
                                                                        .white,
                                                                child:
                                                                    const Center(
                                                                  child:
                                                                      PhoLoading(),
                                                                ),
                                                              );
                                                      }
                                                    },
                                                  ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Lottie.asset(
                                        'assets/new_ui/animation_lottie/learning-online.json',
                                        height: 200,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            widget.controllerYT.pause();
                                            if (DataCache().getUserData().uid ==
                                                0) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          LoginAccountScreen()));
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: _viewDialog(),
                                                  );
                                                },
                                              );
                                              var socketProvider = context
                                                  .read<SocketProvider>();

                                              if (socketProvider
                                                      .socketChannel ==
                                                  null) {
                                                HomePageState().runningSocket();

                                                socketProvider
                                                    .socketChannel!.sink
                                                    .add(
                                                  ParseDataSocket
                                                      .convertSendDataParseCreateRoom(
                                                    tableIndex: 1,
                                                    roomId: 0,
                                                    moneyBet: 0,
                                                    idVideo: widget.dataTalk.id,
                                                    nameVideo:
                                                        widget.dataTalk.name,
                                                  ),
                                                );
                                                socketProvider
                                                    .setIsShowing(true);
                                                socketProvider
                                                    .setOpenSocket(true);
                                              } else {
                                                socketProvider.setTable([]);
                                                socketProvider.setVideoId(
                                                    widget.dataTalk.id);
                                                String command =
                                                    EmitEvent.emitJoinZone();
                                                socketProvider
                                                    .socketChannel!.sink
                                                    .add(command);
                                                socketProvider
                                                    .socketChannel!.sink
                                                    .add(
                                                  ParseDataSocket
                                                      .convertSendDataParseCreateRoom(
                                                    tableIndex: 1,
                                                    roomId: 0,
                                                    moneyBet: 0,
                                                    idVideo: widget.dataTalk.id,
                                                    nameVideo:
                                                        widget.dataTalk.name,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              color: Color(0xFF04D076),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .width <=
                                                      375
                                                  ? 45
                                                  : 50,
                                              alignment: Alignment.center,
                                              child: Text(
                                                S.of(context).tao_phong,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width <=
                                                              375
                                                          ? 20
                                                          : 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: const SizedBox(height: 16),
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? const Color.fromRGBO(
                                                    24, 26, 33, 1)
                                                : Colors.white,
                                      ),
                                      !widget.hideChannel
                                          ? FutureBuilder(
                                              future: _fetchChannel,
                                              builder: (context,
                                                  AsyncSnapshot dataVideo) {
                                                if (dataVideo.hasData) {
                                                  return dataVideo.data.listTalk
                                                          .isNotEmpty
                                                      ? Container(
                                                          color: themeProvider
                                                                      .mode ==
                                                                  ThemeMode.dark
                                                              ? const Color
                                                                      .fromRGBO(
                                                                  24, 26, 33, 1)
                                                              : Colors.white,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 15,
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              admob
                                                                  .showBannerAdSmall(
                                                                      context),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                S
                                                                    .of(context)
                                                                    .VideosSame,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 18,
                                                                  color: themeProvider
                                                                              .mode ==
                                                                          ThemeMode
                                                                              .dark
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 300,
                                                                child:
                                                                    VideoSuggest(
                                                                  pop: widget
                                                                      .pop,
                                                                  data:
                                                                      dataVideo
                                                                          .data,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox();
                                                } else {
                                                  return const SizedBox();
                                                }
                                              },
                                            )
                                          : const SizedBox(),
                                      DataCache().getDataHome() != null &&
                                              !widget.hideChannel
                                          ? Container(
                                              child: const SizedBox(height: 16),
                                              color: themeProvider.mode ==
                                                      ThemeMode.dark
                                                  ? const Color.fromRGBO(
                                                      24, 26, 33, 1)
                                                  : Colors.white,
                                            )
                                          : const SizedBox(),
                                      DataCache().getDataHome() != null &&
                                              !widget.hideChannel
                                          ? Container(
                                              color: themeProvider.mode ==
                                                      ThemeMode.dark
                                                  ? const Color.fromRGBO(
                                                      24, 26, 33, 1)
                                                  : Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    S
                                                        .of(context)
                                                        .SuggestionsForYou,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18,
                                                      color:
                                                          themeProvider.mode ==
                                                                  ThemeMode.dark
                                                              ? Colors.white
                                                              : Colors.black,
                                                    ),
                                                  ),
                                                  ItemSuggesInVideo(
                                                    pop: widget.pop,
                                                    data: DataCache()
                                                        .getDataHome()!
                                                        .listTalkNew,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: themeProvider.mode == ThemeMode.dark
                    ? const Color.fromRGBO(24, 26, 33, 1)
                    : Colors.white,
                body: const Center(
                  // child: Platform.isAndroid
                  //     ? const CircularProgressIndicator()
                  //     : const CupertinoActivityIndicator(),
                  child: PhoLoading(),
                ),
              );
      },
    );
  }

  Widget _viewDialog() {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: AutoSizeText(
              "Create Room. Please Wait!",
              style: TextStyle(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/new_ui/more/poor.png',
              //   height: 90,
              // ),
              // SizedBox(
              //   width: 5,
              // ),
              // // CircularProgressIndicator(
              // //   color: Colors.green,
              // // ),
              const PhoLoading(),
            ],
          )
        ],
      ),
    );
  }
}
