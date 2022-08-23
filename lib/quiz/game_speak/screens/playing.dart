// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'dart:async';

import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/listen_item.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/quiz/Modules/extrac_widget/widget_box.dart';

import 'package:app_learn_english/quiz/game_speak/screens/summary.dart';
import 'package:app_learn_english/utils/config_heart_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Playing extends StatefulWidget {
  const Playing({
    Key? key,
    required this.data,
    required this.filterTopicChoose10,
    required this.idChoose,
  }) : super(key: key);
  final List<ListenItem> data;
  final Function filterTopicChoose10;
  final int idChoose;

  @override
  _PlayingState createState() => _PlayingState();
}

class _PlayingState extends State<Playing> {
  int index = 0;
  late int count;
  List<bool> checkColor = [];
  List<bool> onClicked = [];
  late Color? colorRight;
  late Color? colorWrong;
  List<Map<String, dynamic>> listQTrue = [];
  late AudioPlayer player;
  double leap = 0;
  final FlutterTts flutterTts = FlutterTts();
  bool checkSpam = true;
  double _height1 = 80;
  double _height2 = 80;
  double percent = 0;
  late SharedPreferences prefs;
  bool _checkCount = true;
  late CountHeartProvider heartProvider;
  late List<ListenItem> dataQuest;
  DataUser userData = DataCache().getUserData();

  Future _speak() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    if (index < dataQuest.length) {
      if (heartProvider.countHeart > 0) {
        await flutterTts.speak('${dataQuest[index].two_question}');
      }
    }
  }

  List<Widget> renderBox() {
    List<Widget> renderListBox = [];
    for (var i = 0; i < dataQuest.length; i++) {
      renderListBox.add(box(
        checkColor: checkColor[i],
        onClicked: onClicked[i],
      ));
    }
    return renderListBox;
  }

  @override
  void initState() {
    player = AudioPlayer();
    colorRight = Colors.transparent;
    colorWrong = Colors.transparent;
    dataQuest = widget.data;
    percent = 0;
    super.initState();
    _speak();
  }

  @override
  void didChangeDependencies() async {
    for (var i = 0; i < dataQuest.length; i++) {
      checkColor.add(false);
      onClicked.add(false);
    }
    if (_checkCount) {
      heartProvider = Provider.of<CountHeartProvider>(context);
      // prefs = await SharedPreferences.getInstance();
      // getCount();
      int initHeart = await UserAPIs().getHeart(
        username: DataCache().getUserData().username,
        uid: DataCache().getUserData().uid,
      );
      heartProvider.setCountHeart(initHeart);
    }

    setState(() {
      _checkCount = false;
    });
    super.didChangeDependencies();
  }

  // getCount() {
  //   if (DataCache().getUserData().isVip == 1) {
  //     count = 4;
  //   } else if (DataCache().getUserData().isVip == 2) {
  //     count = 3;
  //   } else {
  //     count = prefs.getInt("count_heart_game1") ?? 3;
  //   }
  // }

  // void setCount(int count) async {
  //   prefs.setInt('count_heart_game1', count);
  // }

  void adsCallback(BuildContext context) async {
    printRed("CALL BACK: ");

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
    Navigator.pop(context, numberHeart);
  }

  void showAds(BuildContext context) {
    AdsController().showAdsCallback(adsCallback, context);
  }

  void checkRight(String answer) async {
    setState(() {
      onClicked[index] = true;
    });
    if (answer == dataQuest[index].true_answer) {
      Map<String, Object> question = {
        'questionObject': dataQuest[index],
        'right': 1,
        'answer': answer,
      };
      listQTrue.add(question);
      setState(() {
        checkColor[index] = true;
      });
      await player.setAsset('assets/audio/dung.mp3');
      player.play();
    } else {
      Map<String, Object> question = {
        'questionObject': dataQuest[index],
        'right': 0,
        'answer': answer,
      };
      listQTrue.add(question);
      // setState(() {
      //   count--;
      // });
      // setCount(count);

      if (userData.isVip == 3 || userData.isVip == 0) {
        int heartDiv = await UserAPIs().addAndDivHeart(
          username: DataCache().getUserData().username,
          uid: DataCache().getUserData().uid,
          typeAction: ConfigHeart.choi_game_cross_the_sea,
        );
        heartProvider.setCountHeart(heartDiv);
      }

      await player.setAsset('assets/audio/tlsai.mp3');
      player.play();
    }
    if (index == dataQuest.length - 1) {
      Timer(
        Duration(seconds: 2),
        () async {
          var dataRestart = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Summary(
                listQTrue: listQTrue,
                data: dataQuest,
                filterTopicChoose10: widget.filterTopicChoose10,
                idChoose: widget.idChoose,
              ),
            ),
          );
          setState(() {
            dataQuest = dataRestart;
            index = 0;
            checkColor = [];
            onClicked = [];
            leap = 0;
            percent = 0;
            // count = prefs.getInt("count_heart_game1")!;
            for (var i = 0; i < dataQuest.length; i++) {
              checkColor.add(false);
              onClicked.add(false);
            }
          });
          _speak();
        },
      );
    }

    if (userData.isVip == 3 || userData.isVip == 0) {
      if (heartProvider.countHeart == 0 && index != dataQuest.length - 1) {
        // printBlue("heart");
        // var bonusCount = await Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Advertise(
        //       checkOnce: true,
        //     ),
        //   ),
        // );
        // heartProvider.setCountHeart(bonusCount);
        showbottom();
      }
    }
  }

  void showbottom() {
    showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        elevation: 100,
        backgroundColor: Colors.blueGrey[800],
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
            width: MediaQuery.of(context).size.width,
            height: 420,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      child: Lottie.asset(
                          'assets/new_ui/animation_lottie/diamond.json'),
                    ),
                    // Positioned(
                    //   top: 55,
                    //   left: 60,
                    //   child: Text(
                    //     '0',
                    //     style: const TextStyle(
                    //       color: Colors.orange,
                    //       fontSize: 50,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  S.of(context).OutOfDiamonds + ' !',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  child: Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                            child: Image.asset(
                          'assets/quiz/icon_ad.png',
                        )),
                        Spacer(),
                        Text(
                          S.of(context).Watchadstogetmorehearts,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  onPressed: () {
                    this.showAds(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    primary: Color.fromRGBO(83, 180, 81, 1),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VipWidget(),
                      ),
                    );
                  },
                  child: Text(
                    S.of(context).Tryusinginfinitehearts,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          S.of(context).EndOfQuiz,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    primary: Color.fromRGBO(83, 180, 81, 1),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/quiz/bg_quizgame.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: _checkCount
            ? Center(
                child: const PhoLoading(),
              )
            : Container(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: SvgPicture.asset(
                            'assets/new_ui/more/Iconly-Arrow-Left.svg',
                            color: Colors.white,
                          ),
                        ),
                        Expanded(child: Container()),
                        Stack(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child:
                                  SvgPicture.asset('assets/quiz/diamond.svg'),
                            ),
                            Positioned(
                              top: 8,
                              left: 9,
                              child: Text(
                                heartProvider.countHeart.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      height: 33,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...renderBox(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.10,
                    ),
                    Center(
                      child: FloatingActionButton(
                        backgroundColor: Colors.white30,
                        onPressed: () {
                          _speak();
                        },
                        child: const Icon(
                          Icons.mic_none,
                          size: 32,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(left: leap),
                      child: const PhoLoading(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width * 0.9,
                      animation: true,
                      lineHeight: 15.0,
                      animationDuration: 5,
                      percent: percent,
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Color.fromRGBO(83, 180, 81, 1),
                    ),
                    Expanded(child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // (index >= dataQuest.length)
                        //     ? Container()
                        //     : GestureDetector(
                        //         onTap: () {
                        //           if (heartProvider.countHeart == 0 &&
                        //               index != dataQuest.length - 1) {
                        //             showbottom();
                        //           } else {
                        //             if (checkSpam) {
                        //               checkSpam = false;
                        //               checkRight(dataQuest[index].answer_one!);
                        //               setState(() {
                        //                 percent += 0.1;
                        //                 if (dataQuest[index].answer_one! ==
                        //                     dataQuest[index].true_answer) {
                        //                   colorWrong = Colors.green;
                        //                   _height1 = 200;
                        //                   leap = leap +
                        //                       MediaQuery.of(context)
                        //                               .size
                        //                               .width *
                        //                           0.085;
                        //                 } else {
                        //                   colorRight = Colors.red;
                        //                   _height2 = 200;
                        //                   leap = leap +
                        //                       MediaQuery.of(context)
                        //                               .size
                        //                               .width *
                        //                           0.085;
                        //                 }

                        //                 Timer(Duration(milliseconds: 800), () {
                        //                   setState(() {
                        //                     colorRight = Colors.transparent;
                        //                     colorWrong = Colors.transparent;
                        //                     index++;
                        //                     checkSpam = true;
                        //                     _height1 = 80;
                        //                     _height2 = 80;
                        //                     _speak();
                        //                   });
                        //                 });
                        //               });
                        //             }
                        //           }
                        //         },
                        //         child: AnimatedContainer(
                        //           margin: dataQuest[index].answer_one! ==
                        //                   dataQuest[index].true_answer
                        //               ? EdgeInsets.only(bottom: _height1)
                        //               : EdgeInsets.only(bottom: _height2),
                        //           duration: Duration(
                        //             milliseconds: 800,
                        //           ),
                        //           curve: Curves.bounceOut,
                        //           alignment: Alignment.center,
                        //           height: 70,
                        //           width: 120,
                        //           padding: const EdgeInsets.only(left: 5),
                        //           decoration: BoxDecoration(
                        //             color: dataQuest[index].answer_one! ==
                        //                     dataQuest[index].true_answer
                        //                 ? colorWrong
                        //                 : colorRight,
                        //             border: Border.all(
                        //               color: Colors.white,
                        //               width: 1,
                        //             ),
                        //             borderRadius: BorderRadius.circular(20),
                        //           ),
                        //           child: Text(
                        //             dataQuest[index].answer_one!,
                        //             textAlign: TextAlign.center,
                        //             style: const TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 20,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        // (index >= dataQuest.length)
                        //     ? Container()
                        //     : GestureDetector(
                        //         onTap: () {
                        //           if (heartProvider.countHeart == 0 &&
                        //               index != dataQuest.length - 1) {
                        //             showbottom();
                        //           } else {
                        //             if (checkSpam) {
                        //               checkSpam = false;
                        //               checkRight(dataQuest[index].answer_two!);
                        //               setState(() {
                        //                 percent += 0.1;
                        //                 if (dataQuest[index].answer_two! ==
                        //                     dataQuest[index].true_answer) {
                        //                   colorWrong = Colors.green;
                        //                   _height1 = 200;
                        //                   leap = leap +
                        //                       MediaQuery.of(context)
                        //                               .size
                        //                               .width *
                        //                           0.085;
                        //                 } else {
                        //                   colorRight = Colors.red;
                        //                   _height2 = 200;
                        //                   leap = leap +
                        //                       MediaQuery.of(context)
                        //                               .size
                        //                               .width *
                        //                           0.085;
                        //                 }
                        //                 Timer(Duration(milliseconds: 800), () {
                        //                   setState(() {
                        //                     colorRight = Colors.transparent;
                        //                     colorWrong = Colors.transparent;
                        //                     index++;
                        //                     checkSpam = true;
                        //                     _height1 = 80;
                        //                     _height2 = 80;
                        //                     _speak();
                        //                   });
                        //                 });
                        //               });
                        //             }
                        //           }
                        //         },
                        //         child: AnimatedContainer(
                        //           margin: dataQuest[index].answer_two! ==
                        //                   dataQuest[index].true_answer
                        //               ? EdgeInsets.only(bottom: _height1)
                        //               : EdgeInsets.only(bottom: _height2),
                        //           duration: Duration(
                        //             milliseconds: 800,
                        //           ),
                        //           curve: Curves.bounceOut,
                        //           alignment: Alignment.center,
                        //           height: 70,
                        //           width: 120,
                        //           padding: const EdgeInsets.only(left: 5),
                        //           decoration: BoxDecoration(
                        //             color: dataQuest[index].answer_two! ==
                        //                     dataQuest[index].true_answer
                        //                 ? colorWrong
                        //                 : colorRight,
                        //             border: Border.all(
                        //               color: Colors.white,
                        //               width: 1,
                        //             ),
                        //             borderRadius: BorderRadius.circular(20),
                        //           ),
                        //           child: Text(
                        //             dataQuest[index].answer_two!,
                        //             textAlign: TextAlign.center,
                        //             style: const TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 20,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        (index >= dataQuest.length)
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  if (userData.isVip == 3 ||
                                      userData.isVip == 0) {
                                    if (heartProvider.countHeart == 0 &&
                                        index != dataQuest.length - 1) {
                                      showbottom();
                                    } else {
                                      if (checkSpam) {
                                        checkSpam = false;
                                        checkRight(
                                            dataQuest[index].answer_one!);
                                        setState(
                                          () {
                                            if (dataQuest[index].answer_one! ==
                                                dataQuest[index].true_answer) {
                                              colorWrong = Colors.green;
                                              _height1 = 180;
                                            } else {
                                              colorRight = Colors.red;
                                              _height2 = 180;
                                            }
                                            Timer(Duration(milliseconds: 800),
                                                () {
                                              setState(() {
                                                colorRight = Colors.transparent;
                                                colorWrong = Colors.transparent;
                                                index++;
                                                _height1 = 80;
                                                _height2 = 80;
                                                checkSpam = true;
                                              });
                                            });
                                          },
                                        );
                                      }
                                    }
                                  } else {
                                    if (checkSpam) {
                                      checkSpam = false;
                                      checkRight(dataQuest[index].answer_one!);
                                      setState(
                                        () {
                                          if (dataQuest[index].answer_one! ==
                                              dataQuest[index].true_answer) {
                                            colorWrong = Colors.green;
                                            _height1 = 180;
                                          } else {
                                            colorRight = Colors.red;
                                            _height2 = 180;
                                          }
                                          Timer(Duration(milliseconds: 800),
                                              () {
                                            setState(() {
                                              colorRight = Colors.transparent;
                                              colorWrong = Colors.transparent;
                                              index++;
                                              _height1 = 80;
                                              _height2 = 80;
                                              checkSpam = true;
                                            });
                                          });
                                        },
                                      );
                                    }
                                  }
                                },
                                child: AnimatedContainer(
                                  margin: dataQuest[index].answer_one! ==
                                          dataQuest[index].true_answer
                                      ? EdgeInsets.only(bottom: _height1)
                                      : EdgeInsets.only(bottom: _height2),
                                  duration: Duration(milliseconds: 800),
                                  curve: Curves.bounceOut,
                                  alignment: Alignment.center,
                                  height: 70,
                                  width: 120,
                                  padding: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    color: dataQuest[index].answer_two! ==
                                            dataQuest[index].true_answer
                                        ? colorRight
                                        : colorWrong,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    dataQuest[index].answer_one!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                        (index >= dataQuest.length)
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  if (userData.isVip == 3 ||
                                      userData.isVip == 0) {
                                    if (heartProvider.countHeart == 0 &&
                                        index != dataQuest.length - 1) {
                                      showbottom();
                                    } else {
                                      if (checkSpam) {
                                        checkSpam = false;
                                        checkRight(
                                            dataQuest[index].answer_two!);
                                        setState(
                                          () {
                                            if (dataQuest[index].answer_two! ==
                                                dataQuest[index].true_answer) {
                                              colorWrong = Colors.green;
                                              _height1 = 180;
                                            } else {
                                              colorRight = Colors.red;
                                              _height2 = 180;
                                            }
                                            Timer(Duration(milliseconds: 800),
                                                () {
                                              setState(() {
                                                colorRight = Colors.transparent;
                                                colorWrong = Colors.transparent;
                                                index++;
                                                _height1 = 80;
                                                _height2 = 80;
                                                checkSpam = true;
                                              });
                                            });
                                          },
                                        );
                                      }
                                    }
                                  } else {
                                    if (checkSpam) {
                                      checkSpam = false;
                                      checkRight(dataQuest[index].answer_two!);
                                      setState(
                                        () {
                                          if (dataQuest[index].answer_two! ==
                                              dataQuest[index].true_answer) {
                                            colorWrong = Colors.green;
                                            _height1 = 180;
                                          } else {
                                            colorRight = Colors.red;
                                            _height2 = 180;
                                          }
                                          Timer(Duration(milliseconds: 800),
                                              () {
                                            setState(() {
                                              colorRight = Colors.transparent;
                                              colorWrong = Colors.transparent;
                                              index++;
                                              _height1 = 80;
                                              _height2 = 80;
                                              checkSpam = true;
                                            });
                                          });
                                        },
                                      );
                                    }
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 800),
                                  curve: Curves.bounceOut,
                                  margin: dataQuest[index].answer_two! ==
                                          dataQuest[index].true_answer
                                      ? EdgeInsets.only(bottom: _height1)
                                      : EdgeInsets.only(bottom: _height2),
                                  alignment: Alignment.center,
                                  height: 70,
                                  width: 120,
                                  padding: const EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    color: dataQuest[index].answer_one! ==
                                            dataQuest[index].true_answer
                                        ? colorRight
                                        : colorWrong,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    dataQuest[index].answer_two!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
