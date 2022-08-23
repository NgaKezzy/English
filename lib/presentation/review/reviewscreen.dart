import 'dart:io';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/models/TalkTextModel.dart';
import 'package:app_learn_english/models/UserModel.dart';

import 'package:app_learn_english/models/history_speak_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';

import 'package:app_learn_english/networks/TalkAPIs.dart';

import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/review/SampleSentences.dart';
import 'package:app_learn_english/presentation/review/history_review.dart';
import 'package:app_learn_english/presentation/review/sample_sentences_first.dart';
import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/quiz/list_game/list_game.dart';
import 'package:app_learn_english/screens/all_video_history_review.dart';
import 'package:app_learn_english/screens/library_video_screens.dart';

import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class ReviewScreen extends StatefulWidget {
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  AdmobHelper admobHelper = AdmobHelper();
  List<HistorySpeakModel> historyTextTalk = [];
  bool _isLoading = true;
  List<DataTalkText> dataSpeak = [];
  bool onClickedSpeak = false;
  int page = 1;
  final _scollController = ScrollController();
  late int _userLever;
  var _isVip;
  String handleLanguage() {
    final String defaultLocale =
        Platform.localeName; // Returns locale string in the form 'en_US'
    return defaultLocale.split('_')[0].trim();
  }

  String convertWeekDay(int numbday) {
    String weekDayString = '';
    switch (numbday) {
      case 1:
        weekDayString = 'Thứ 2';
        break;
      case 2:
        weekDayString = 'Thứ 3';
        break;
      case 3:
        weekDayString = 'Thứ 4';
        break;
      case 4:
        weekDayString = 'Thứ 5';
        break;
      case 5:
        weekDayString = 'Thứ 6';
        break;
      case 6:
        weekDayString = 'Thứ 7';
        break;
      case 7:
        weekDayString = 'Chủ nhật';
        break;
      default:
    }
    return weekDayString;
  }

  String convertTime(int index) {
    var time = DateTime.parse(historyTextTalk[index].textTalk.createdtime);
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    var date = formatter.format(time);
    var weekDay = convertWeekDay(time.weekday);
    return '$date ($weekDay)';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isLoading) {
      UserAPIs()
          .fetchDataUser(DataCache().getUserData().uid.toString())
          .then((value) {
        _userLever = value.level;
      });
      historyTextTalk = await TalkAPIs().getHistorySpeak(page);
      setState(() {
        page++;
      });
    }
    setState(() {
      _isLoading = false;
    });

    _isVip = DataCache().getUserData().isVip;
    super.didChangeDependencies();
  }

  Future<List<HistorySpeakModel>> loadPage() async {
    var tempMoreHistory = await TalkAPIs().getHistorySpeak(page);
    var mirrorHistory = [...historyTextTalk];
    if (tempMoreHistory.isNotEmpty) {
      mirrorHistory.addAll(tempMoreHistory);
      setState(() {
        historyTextTalk = mirrorHistory;
        page++;
        print('đây là page: $page');
      });
    }
    return historyTextTalk;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: themeProvider.mode == ThemeMode.dark
              ? const Color.fromRGBO(24, 26, 33, 1)
              : Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: themeProvider.mode == ThemeMode.dark
                ? const Color.fromRGBO(45, 48, 57, 1)
                : Colors.white,
            title: Text(
              S.of(context).Review,
              style: TextStyle(
                fontSize: 20,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Divider(
                    thickness: 1,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.grey.shade700
                        : const Color(0xFFE4E4E4),
                    height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Divider(thickness: 1, color: Color(0xFFE4E4E4), height: 1),

                        const SizedBox(height: 20),
                        //View Game
                        GestureDetector(
                          onTap: () {
                            if (_userLever < 3 && _isVip != 1) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: _viewDialogTutorial());
                                  });
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => List_game()));
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            child: Center(
                              child: Lottie.asset(
                                  "assets/new_ui/animation_lottie/animation_button_game.json"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleSampleSentences(
                              ScopedModel(
                                model: userData,
                                child: SampleSentences(),
                              ),
                            ),
                            Container(
                              child: ScopedModel(
                                model: userData,
                                child: SampleSentencesFirst(),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        // Video Library
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTileVideoLibrary(ScopedModel(
                                model: userData, child: LibraryVideoScreens())),
                            const SizedBox(height: 10),
                            _buildButtomAndTwoItemVideoHistory(
                              ScopedModel(
                                  model: userData,
                                  child: AllVideoHistoryScreens(
                                    dataUser: userData,
                                    isHome: false,
                                  )),
                              ScopedModel(
                                  model: userData,
                                  child: LibraryVideoScreens()),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        //Speak library
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Consumer<LocaleProvider>(
                                builder: (ctx, localeProvider, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        // 'Lịch sử Speak',
                                        S.of(context).speakHistory,
                                        style: TextStyle(
                                          color: themeProvider.mode ==
                                                  ThemeMode.dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (historyTextTalk.length == 0) {
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HistoryReview(
                                                  historyTextTalk:
                                                      historyTextTalk,
                                                  loadMoreFnc: loadPage,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: RotatedBox(
                                          quarterTurns: 2,
                                          child: SvgPicture.asset(
                                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                                            height: 30,
                                            color: themeProvider.mode ==
                                                    ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  historyTextTalk.length > 0
                                      ? (_isLoading
                                          ? const Center(
                                              // child: CircularProgressIndicator(
                                              //     color: Colors.white),
                                              child: PhoLoading(),
                                            )
                                          : Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              height: 180,
                                              child: ListView.builder(
                                                controller: _scollController,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MainSpeakScreen(
                                                            dataUser: DataCache()
                                                                .getUserData(),
                                                            title:
                                                                historyTextTalk[
                                                                        index]
                                                                    .textTalk
                                                                    .name,
                                                            id: '${historyTextTalk[index].textTalk.id}',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              historyTextTalk[
                                                                      index]
                                                                  .textTalk
                                                                  .name,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                          const SizedBox(
                                                              height: 8),
                                                          localeProvider.locale!
                                                                      .languageCode ==
                                                                  'en'
                                                              ? const SizedBox()
                                                              : Text(
                                                                  Utils.changeLanguage(
                                                                              localeProvider
                                                                                  .locale!.languageCode,
                                                                              index,
                                                                              historyTextTalk) ==
                                                                          ''
                                                                      ? ''
                                                                      : Utils.changeLanguage(
                                                                          localeProvider
                                                                              .locale!
                                                                              .languageCode,
                                                                          index,
                                                                          historyTextTalk),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            convertTime(index),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 14,
                                                                    bottom: 14),
                                                            height: 0.5,
                                                            color: Colors.grey,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount:
                                                    historyTextTalk.length >= 2
                                                        ? 2
                                                        : historyTextTalk
                                                            .length,
                                              ),
                                            ))
                                      : Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              // Image.asset(
                                              //   'assets/new_ui/more/poor.png',
                                              //   height: 160,
                                              // ),
                                              const PhoLoading(),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                S.of(context).Nostudydatayet,
                                                overflow: TextOverflow.visible,
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                  if (historyTextTalk.length > 0)
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HistoryReview(
                                                      historyTextTalk:
                                                          historyTextTalk,
                                                      loadMoreFnc: loadPage,
                                                    )));
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 70),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              S.of(context).viewAll,
                                              style: TextStyle(
                                                color: themeProvider.mode ==
                                                        ThemeMode.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Icon(
                                              Icons.navigate_next,
                                              color: themeProvider.mode ==
                                                      ThemeMode.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            })),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTileVideoLibrary(Widget childWidget) {
    var themeProvider = context.watch<ThemeProvider>();
    return Row(children: [
      const SizedBox(width: 15),
      Text(
        S.of(context).vieoLibrary,
        style: TextStyle(
          color: themeProvider.mode == ThemeMode.dark
              ? Colors.white
              : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      const Spacer(),
      IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => childWidget));
        },
        icon: RotatedBox(
          quarterTurns: 2,
          child: SvgPicture.asset(
            'assets/new_ui/more/Iconly-Arrow-Left.svg',
            height: 30,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    ]);
  }

  Widget _buildButtomAndTwoItemVideoHistory(
      Widget childWidget, Widget screenViewAll) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: childWidget,
          ),
          const SizedBox(height: 10),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => screenViewAll));
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
          //     child: Container(
          //       width: MediaQuery.of(context).size.width,
          //       height: 40,
          //       decoration: BoxDecoration(
          //           border: Border.all(
          //             color: Colors.black26,
          //           ),
          //           borderRadius: BorderRadius.all(Radius.circular(5))),
          //       child: Center(
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text(S.of(context).viewAll,
          //                 style: const TextStyle(
          //                     fontSize: 18, color: Colors.black)),
          //             const SizedBox(width: 5),
          //             const Icon(Icons.navigate_next)
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ]);
  }

  Widget _buildTitleSampleSentences(Widget childWidget) {
    var themeProvider = context.watch<ThemeProvider>();
    return Row(children: [
      const SizedBox(width: 15),
      Text(
        S.of(context).mySentencePattern,
        style: TextStyle(
          color: themeProvider.mode == ThemeMode.dark
              ? Colors.white
              : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      const Spacer(),
      IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => childWidget));
        },
        icon: RotatedBox(
          quarterTurns: 2,
          child: SvgPicture.asset(
            'assets/new_ui/more/Iconly-Arrow-Left.svg',
            height: 30,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    ]);
  }

  ///View show dialog hướng dẫn khi click vào Game
  Widget _viewDialogTutorial() {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VipWidget(),
                ));
              },
              child: Container(
                child: Image.asset(
                  'assets/new_ui/more/game_dialog_vip.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              S.of(context).ban_can_dat,
              style: TextStyle(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: const Center(
                    child: Text(
                      'Ok',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VipWidget(),
                  ));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      S.of(context).become_vip,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
