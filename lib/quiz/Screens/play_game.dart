import 'dart:async';

import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/question_item.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/quiz/Modules/extrac_widget/widget_box.dart';
import 'package:app_learn_english/quiz/Screens/Result.dart';
import 'package:app_learn_english/quiz/Screens/advertise.dart';
import 'package:app_learn_english/utils/config_heart_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

class PlayGame extends StatefulWidget {
  const PlayGame({
    Key? key,
    required this.data,
    required this.filterTopicChoose10,
    required this.idChoose,
  }) : super(key: key);
  final List<QuestionItem> data;
  final Function filterTopicChoose10;
  final int idChoose;

  @override
  _PlayGameState createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  late AudioPlayer player;
  int index = 0;

  // late int count;
  List<bool> CheckColor = [];
  List<bool> onClicked = [];
  List<Map<String, dynamic>> listQTrue = [];
  late Color? colorRight;
  late Color? colorWrong;
  double _height1 = 80;
  double _height2 = 80;
  bool checkSpam = true;
  late SharedPreferences prefs;
  bool _checkCount = true;
  late List<QuestionItem> dataQuest;
  late CountHeartProvider heartProvider;
  AdmobHelper admobHelper = AdmobHelper();
  DataUser userData = DataCache().getUserData();

  List<Widget> renderBox() {
    List<Widget> renderListBox = [];

    for (var i = 0; i < dataQuest.length; i++) {
      renderListBox.add(box(
        checkColor: CheckColor[i],
        onClicked: onClicked[i],
      ));
    }
    return renderListBox;
  }

  @override
  void initState() {
    colorRight = Colors.transparent;
    colorWrong = Colors.transparent;
    dataQuest = widget.data;
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    for (var i = 0; i < dataQuest.length; i++) {
      CheckColor.add(false);
      onClicked.add(false);
    }
    if (_checkCount) {
      heartProvider = Provider.of<CountHeartProvider>(context);
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
  //     count = prefs.getInt("count_heart") ?? 3;
  //   }
  // }

  // void setCount(int count) async {
  //   prefs.setInt('count_heart', count);
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
        CheckColor[index] = true;
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
      if (userData.isVip == 3||userData.isVip==0) {
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
              builder: (context) => Result(
                listQTrue: listQTrue,
                data: dataQuest,
                idChoose: widget.idChoose,
                filterTopicChoose10: widget.filterTopicChoose10,
              ),
            ),
          );
          setState(() {
            dataQuest = dataRestart;
            index = 0;
            CheckColor = [];
            // count = prefs.getInt("count_heart")!;
            onClicked = [];
            for (var i = 0; i < dataQuest.length; i++) {
              CheckColor.add(false);
              onClicked.add(false);
            }
          });
        },
      );
    }
    if (userData.isVip == 3||userData.isVip==0) {
      if (heartProvider.countHeart == 0 && index != dataQuest.length - 1) {
        // int bonusCount = await Navigator.push(
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
                      child: SvgPicture.asset(
                        'assets/icons-svg/icon_ruby.svg',
                      ),
                    ),
                    Positioned(
                      top: 55,
                      left: 60,
                      child: Text(
                        '0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                Spacer(),
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
                // child: CircularProgressIndicator(),
                child: const PhoLoading(),
              )
            : Container(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                              left: 12,
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
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Center(
                      child: Text(
                        (index >= dataQuest.length)
                            ? dataQuest[dataQuest.length - 1].question!
                            : dataQuest[index].question!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        (index >= dataQuest.length)
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  if (userData.isVip == 3||userData.isVip==0) {
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
                                  if (userData.isVip == 3||userData.isVip==0) {
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
