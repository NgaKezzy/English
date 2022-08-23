import 'dart:async';
import 'dart:math';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/extentions/constants.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/TalkTextCacheModel.dart';
import 'package:app_learn_english/models/quiz/quiz_lotti_model.dart';
import 'package:app_learn_english/networks/AchievementAPIs.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/presentation/speak/widgets/practice_builder_box.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../widgets/loading_circle.dart';

class PracticeBox extends StatefulWidget {
  final String idTalkText;

  const PracticeBox({
    Key? key,
    required this.idTalkText,
  }) : super(key: key);
  @override
  _PracticeBoxState createState() => _PracticeBoxState();
}

class _PracticeBoxState extends State<PracticeBox> {
  bool addBtnState = false;
  bool _isLoadingScreen = true;
  bool _isAction = true;
  // var listTalk;
  late TalkTextCacheModel talkTextFullData;

  int indexBox = 1;
  List<Widget> listWidget = [];
  late FlutterTts tts;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  int indexAuto = 0;
  bool checkSpeaking = false;
  bool checkToggle = false;
  List<List<String>> _listWrongWords = [];
  List<bool> _listCheckTalk = [];
  List<bool> _listCheckExactly = [];
  bool autoAction = true;
  double totalPercent = 0; // Cái này dựa vào để đánh giá star
  var random = Random();
  List<QuizLottiModel> listLottie = [];

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (_) {
        showBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            elevation: 10,
            context: context,
            builder: (context) {
              return Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  child: Column(
                    children: [
                      Align(
                        child: InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close_sharp,
                            size: 30,
                          ),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        child: Text(
                          S.of(context).VoiceNotRecognizedPleaseTryAgain,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        alignment: Alignment.center,
                      ),
                      Align(
                        child: InkWell(
                            onTap: () async {},
                            child: ElevatedButton(
                              child: Text(S.of(context).Close),
                              onPressed: () {},
                            )),
                        alignment: Alignment.center,
                      )
                    ],
                  ),
                ),
              );
            });
      },
    );
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    printGreen(indexAuto.toString());
    printCyan(_listWrongWords.toString());
    printCyan(_listCheckTalk.toString());
    List<String> convertTextApi = talkTextFullData
        .getListSub()[indexAuto]
        .content
        .replaceAll(new RegExp(r'[!\?\.\,]+'), '')
        .toLowerCase()
        .trim()
        .split(' ');
    List<String> convertRecogizeWords = result.recognizedWords
        .toLowerCase()
        .replaceAll(new RegExp(r'[!\?\.\,]+'), '')
        .trim()
        .split(' ');
    printRed(talkTextFullData
        .getListSub()[indexAuto]
        .content
        .replaceAll(new RegExp(r'[!\?\.\,]+'), '')
        .toLowerCase()
        .trim());
    printRed(result.recognizedWords
        .toLowerCase()
        .replaceAll(new RegExp(r'[!\?\.\,]+'), '')
        .trim());
    for (var i = 0; i < convertRecogizeWords.length; i++) {
      for (var j = 0; j < convertTextApi.length; j++) {
        if (convertRecogizeWords[i].compareTo(convertTextApi[j]) == 0) {
          convertTextApi.remove(convertRecogizeWords[i]);
          printCyan(convertTextApi.toString());
        }
      }
    }
    setState(() {
      checkSpeaking = false;
      _listWrongWords[indexAuto] = convertTextApi;
      _listCheckTalk[indexAuto] = true;
    });

    if (convertTextApi.length == 0) {
      setState(() {
        _listCheckExactly[indexAuto] = true;
      });
    }

    if (_speechToText.isNotListening) {
      if (indexAuto + 1 == talkTextFullData.getListSub().length) {
        showRateStar(context);
      }

      totalPercent += 100 -
          (convertTextApi.length /
                  talkTextFullData
                      .getListSub()[indexAuto]
                      .content
                      .replaceAll(new RegExp(r'[!\?\.\,]+'), '')
                      .toLowerCase()
                      .trim()
                      .split(' ')
                      .length) *
              100;

      setState(() {
        indexAuto++;
      });
      autoScroll();
    }
  }

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  TtsState ttsState = TtsState.stopped;

  @override
  void initState() {
    _initSpeech();
    tts = FlutterTts();
    tts.setLanguage('en');
    tts.setVolume(1.0);
    tts.setSpeechRate(0.5);
    tts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    tts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
        checkSpeaking = true;
      });
      _startListening();
    });

    tts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });
    super.initState();
  }

  Future _stop() async {
    var result = await tts.stop();
    if (result == 1)
      setState(() {
        ttsState = TtsState.stopped;
      });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isLoadingScreen) {
      // listTalk = await TextTalkDetail().getTalkTextId(widget.idTalkText);
      talkTextFullData =
          await DataCache().getTalkTextDetailByIdInCache(widget.idTalkText);
      for (var i = 0; i < talkTextFullData.getListSub().length; i++) {
        List<String> wrongWords = [];
        bool checkExactly = false;
        bool checkTalk = false;
        _listWrongWords.add(wrongWords);
        _listCheckExactly.add(checkExactly);
        _listCheckTalk.add(checkTalk);
      }
      setState(() {
        _isLoadingScreen = false;
        _isAction = false;
      });
    }
  }

  Widget renderStar(double percent) {
    printRed(percent.toString());
    if (percent <= 10) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star_half_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
        ],
      );
    } else if (percent <= 20) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
        ],
      );
    } else if (percent <= 30) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_half_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
        ],
      );
    } else if (percent <= 40) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
        ],
      );
    } else if (percent <= 50) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_half_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
        ],
      );
    } else if (percent <= 60) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
        ],
      );
    } else if (percent <= 70) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_half_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
        ],
      );
    } else if (percent <= 80) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_outline_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
        ],
      );
    } else if (percent <= 90) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star_rounded,
            size: 35,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_half_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
            size: 35,
          ),
        ],
      );
    }
  }

  void showRateStar(BuildContext context) {
    //update achievement
    var now = new DateTime.now();
    if (now.weekday == 6 || now.weekday == 7) {
      DataCache().getDataAchievementByType(Constants.ACHI_LEARN_LAST_WEEK).then(
          (value) =>
              {AchievementAPIs().updateAchievement(achiId: value.achiId)});
    }
    DataCache().getDataAchievementByType(Constants.ACHI_TALK_COMPLETE).then(
        (value) => {AchievementAPIs().updateAchievement(achiId: value.achiId)});

    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          int num =
              random.nextInt(Utils().setListLottieQuizRight(context).length);
          return Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Column(
                children: [
                  Align(
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close_sharp,
                        size: 30,
                      ),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        S.of(context).TheNumberOfStars,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600],
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: renderStar(
                        totalPercent /
                            (talkTextFullData.getListSub().length /
                                2.floor() *
                                100) *
                            100,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Lottie.asset(listLottie[num].lottie,
                          width: 200, height: 150),
                    ),
                    alignment: Alignment.bottomCenter,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future talkOrder() async {
    printGreen(indexAuto.toString());
    printCyan(_listWrongWords.toString());
    printCyan(_listCheckTalk.toString());

    if (ttsState == TtsState.stopped || ttsState == TtsState.paused) {
      await tts.awaitSpeakCompletion(true);
      await tts.setVoice({'name': 'en-AU-language', 'locale': 'en-AU'});
      await tts.speak(talkTextFullData.getListSub()[indexAuto].content);
      if (indexAuto + 1 == talkTextFullData.getListSub().length) {
        showRateStar(context);
      }
      setState(() {
        indexAuto++;
      });
      autoScroll();
    }
  }

  Color color = Colors.white;

  void setIndexAuto(int num) async {
    setState(() {
      indexAuto = num;
    });
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  ScrollController scrController = ScrollController();

  void autoScroll() {
    if (indexAuto < talkTextFullData.getListSub().length) {
      scrController.animateTo((80.0) * indexAuto,
          duration: Duration(seconds: 1), curve: Curves.easeInQuad);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (listLottie.isEmpty) {
      listLottie = Utils().setListLottieQuizRight(context);
    }
    var themeProvider = context.watch<ThemeProvider>();
    if (_isLoadingScreen) {
      return const Center(child: PhoLoading());
    } else {
      if (indexAuto % 2 == 0) {
        talkOrder();
      }
      return Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrController,
                itemBuilder: (ctx, index) {
                  return PracticeBuilderBox(
                    key: ValueKey(index),
                    setIndexAuto: setIndexAuto,
                    checkExactly: _listCheckExactly,
                    checkTalk: _listCheckTalk,
                    ttsState: ttsState,
                    indexAuto: indexAuto,
                    wrongWords: _listWrongWords,
                    talkTextFullData: talkTextFullData,
                    index: index,
                  );
                },
                itemCount: talkTextFullData.getListSub().length,
              ),
            ),
            Container(
              color: themeProvider.mode == ThemeMode.dark
                  ? Color.fromRGBO(42, 43, 49, 1)
                  : Colors.grey[100],
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Align(
                    child: _speechToText.isListening
                        ? Text(S.of(context).Listening)
                        : Text(S.of(context).ClickTheButtonToStartSpeaking),
                    alignment: Alignment.center,
                  ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: InkWell(
                        onTap: () {},
                        child: AvatarGlow(
                          animate: checkSpeaking,
                          duration: const Duration(milliseconds: 2000),
                          repeat: checkSpeaking,
                          glowColor: Colors.red,
                          repeatPauseDuration: Duration(
                            milliseconds: 100,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (checkSpeaking) {
                                _stopListening();
                                setState(() {
                                  checkSpeaking = false;
                                });
                              } else {
                                _startListening();
                                setState(() {
                                  checkSpeaking = true;
                                });
                              }
                            },
                            child: Card(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  checkSpeaking ? Icons.mic : Icons.mic_none,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              elevation: 10,
                            ),
                          ),
                          endRadius: 45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
