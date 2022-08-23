import 'dart:io';

import 'package:app_learn_english/Providers/dialog_provider.dart';
import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/main.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/speak/screen/practice_screen.dart';
import 'package:app_learn_english/presentation/speak/widgets/conversation_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainSpeakScreen extends StatefulWidget {
  final String id;
  final String title;
  final DataUser dataUser;

  const MainSpeakScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.dataUser,
  }) : super(key: key);

  static const routeName = '/main-speak';

  @override
  _MainSpeakScreenState createState() => _MainSpeakScreenState();
}

enum TtsState {
  playing,
  stopped,
  paused,
  continued,
}

enum BtnState {
  paused,
  play,
}

class _MainSpeakScreenState extends State<MainSpeakScreen> {
  late BtnState controllerBtn;
  late BtnState repeatControll;
  List<dynamic> listSentences = [];

  late FlutterTts tts;
  late int indexNum;
  late int indexRepeat;
  late String idListText;
  bool isClickItem = false;

  // HÀM SỬ DỤNG ĐỂ ĐỌC 1 ĐOẠN TEXT
  Future _speak(String text, int soThuTu, VoidCallback fnc) async {
    setState(() {
      indexNum = soThuTu;
    });
    await tts.awaitSpeakCompletion(true);
    await _setVoice();
    await tts.speak(text);
    printRed('$soThuTu');
    fnc();
  }

  // HÀM SỬ DỤNG ĐỂ SROLL ĐỂN VỊ TRÍ NÀO ĐÓ
  void scrollTo(int indexNum, ScrollController controller) {
    controller.animateTo(
      (130.0) * indexNum,
      duration: Duration(seconds: 1),
      curve: Curves.easeInQuad,
    );
  }

  // LẤY TRẠNG THÁI CỦA TEXT TO SPEECH
  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;

  TtsState ttsState = TtsState.stopped;
  late String text;
  late bool onListening;
  late double percentStudied;
  AdmobHelper admob = AdmobHelper();
  late CountHeartProvider heartProvider;

  Future initSpeak() async {
    heartProvider = Provider.of<CountHeartProvider>(
      context,
      listen: false,
    );
    admob.createInterstitialAd();
    tts = FlutterTts();
    await tts.setLanguage('en'); // KHỞI TẠO NGÔN NGỮ NÓI MẶC ĐỊNH LÀ TIẾNG ANH
    await tts.setVolume(1.0); // KHỞI TẠO VOICELUME
    await tts.setSpeechRate(0.4); // KHỞI TẠO TỐC ĐỘ ĐỌC
    tts.setStartHandler(() {
      // SET TRẠNG THÁI KHI BẮT ĐẦU NÓI
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    tts.setCompletionHandler(() {
      // SET TRẠNG THÁI KHI HOÀN THÀNH CÂU NÓI
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    tts.setCancelHandler(() {
      // SET TRẠNG THAI KHI DỪNG HOẶC HỦY CÂU NÓI
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });
  }

  @override
  void initState() {
    percentStudied = 0;
    text = '';
    onListening = false;
    indexNum = 0;
    indexRepeat = 0;
    controllerBtn = BtnState.play;
    repeatControll = BtnState.paused;
    admob.getBannerAd();
    initSpeak();
    super.initState();
  }

  Future<void> _setVoice() async {
    var voice = await tts.getVoices;
    var voifilter =
        voice.where((element) => element['locale'] == 'en-US').toList();
    print(voifilter);
    if (indexNum % 2 == 0) {
      Platform.isAndroid
          ? await tts.setVoice({"name": "en-us-x-tpf-local", "locale": "en-US"})
          : await tts.setVoice({'name': 'Karen', 'locale': 'en-AU'});
    } else {
      Platform.isAndroid
          ? await tts
              .setVoice({"name": "en-au-x-aud-network", "locale": "en-AU"})
          : await tts.setVoice({'name': 'Daniel', 'locale': 'en-GB'});
    }
  }

  // KHI BẮT ĐẦU SAU KHI HOÀN THÀNH VIỆC INIT SẼ NHẢY VÀO HÀM NÀY ĐỂ BẮT ĐẦU VIỆC TỰ ĐỘNG NÓI
  Future autoPlay(listText) async {
    var voice = await tts.getVoices;
    print(voice);
    if (listSentences != []) {
      listSentences = listText;
    }
    if (indexNum <= listText.length) {
      if (controllerBtn == BtnState.paused) {
        _stop();
      } else {
        if (ttsState == TtsState.stopped || ttsState == TtsState.paused) {
          await tts.awaitSpeakCompletion(true);
          await _setVoice();
          await tts.speak(listText[indexNum].content);
          setState(() {
            indexNum = indexNum + 1;
          });
          if (indexNum == listText.length) {
            setState(() {
              indexNum = 0;
              controllerBtn = BtnState.paused;
            });
          }
        }
      }
    }
  }

  // HÀM LẶP LẠI CÂU NÓI
  Future repeatSentence() async {
    printCyan('$indexNum');
    if (ttsState == TtsState.stopped || ttsState == TtsState.paused) {
      await _setVoice();
      await tts.speak(listSentences[indexNum].content);
      await tts.awaitSpeakCompletion(true);
    }
  }

  Future _stop() async {
    var result = await tts.stop();
    if (result == 1)
      setState(() {
        ttsState = TtsState.stopped;
      });
  }

  void stopTalking() {
    _stop();
    setState(() {
      controllerBtn = BtnState.play;
    });
  }

  void changeBtn() {
    if (repeatControll == BtnState.play) {
      _stop();
      setState(() {
        repeatControll = BtnState.paused;
      });
    }
    if (controllerBtn == BtnState.paused) {
      setState(() {
        controllerBtn = BtnState.play;
      });
    } else {
      _stop();
      setState(() {
        controllerBtn = BtnState.paused;
      });
    }
  }

  void changeRepeat() {
    setState(() {
      indexRepeat = indexNum;
    });
    _stop();
    setState(() {
      controllerBtn = BtnState.paused;
    });
    if (repeatControll == BtnState.paused) {
      setState(() {
        repeatControll = BtnState.play;
      });
    } else {
      setState(() {
        repeatControll = BtnState.paused;
      });
    }
  }

  // HÀM RENDER RA WIDGET DỪNG, LẶP LẠI, TẬP NÓI
  Widget _buildButtonControll(String text, VoidCallback fnc) {
    var themeProvider = context.watch<ThemeProvider>();
    return InkWell(
      onTap: fnc,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: (text == S.of(context).Repeat)
            ? ((repeatControll == BtnState.paused)
                ? themeProvider.mode == ThemeMode.dark
                    ? Color.fromRGBO(73, 76, 84, 1)
                    : Colors.white
                : Colors.black)
            : (themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(73, 76, 84, 1)
                : Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: (text == S.of(context).Repeat)
                  ? ((repeatControll == BtnState.paused)
                      ? themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black
                      : Colors.white)
                  : (themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  // HÀM DỪNG VIỆC TỰ ĐỘNG NÓI
  void disableAutoPlay() {
    setState(() {
      controllerBtn = BtnState.paused;
    });
  }

  // RESTART LẠI CÁC HÀM
  void restart() {
    setState(() {
      text = '';
      onListening = false;
      indexNum = 0;
      indexRepeat = 0;
      controllerBtn = BtnState.paused;
      repeatControll = BtnState.paused;
      tts = FlutterTts();
      tts.setLanguage('en');
      tts.setVolume(1.0);
      tts.setSpeechRate(0.4);
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
        });
      });

      tts.setCancelHandler(() {
        setState(() {
          print("Cancel");
          ttsState = TtsState.stopped;
        });
      });
    });
  }

  void updatePercent({double percent = 0}) {
    setState(() {
      percentStudied += percent;
    });
  }

  @override
  void dispose() async {
    if (heartProvider.buttonAds) {
      printBlue("START ADS");
      print('Đang gọi quảng cáo');
      PlyrVideoPlayer().initAdsBanner(admob.bannerAd);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      heartProvider.setButtonAds(false);
      prefs.setBool('isShowAds', false);
      // admob.showInterstitialAd();
    }
    super.dispose();
    tts.stop();
  }

  @override
  Widget build(BuildContext context) {
    // getVoices();
    var themeProvider = context.watch<ThemeProvider>();
    // var dialogProvider = context.watch<DialogProvider>();
    // isClickItem
    print('Mã ${widget.id}');
    return Consumer<DialogProvider>(
      builder: (BuildContext context, dialogProvider, Widget? child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                elevation: 1,
                backgroundColor: themeProvider.mode == ThemeMode.dark
                    ? const Color.fromRGBO(45, 48, 57, 1)
                    : Colors.white,
                title: Text(
                  widget.title,
                  style: TextStyle(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    'assets/new_ui/more/Iconly-Arrow-Left.svg',
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              body: Column(
                children: [
                  Divider(
                      thickness: 1,
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.grey.shade700
                          : const Color(0xFFE4E4E4),
                      height: 1),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeProvider.mode == ThemeMode.dark
                            ? const Color.fromRGBO(24, 26, 33, 1)
                            : Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    height: 500,
                                    // child: ChangeNotifierProvider(
                                    //   create: (_) => TextTalkDetail(),
                                    child: ConversationBox(
                                      context: context,
                                      stopTalking: _stop,
                                      stopAuto: disableAutoPlay,
                                      stateBtn: controllerBtn,
                                      fnc: scrollTo,
                                      ctx: context,
                                      idTalkText: widget.id,
                                      autoPlay: autoPlay,
                                      speak: _speak,
                                      ttsState: ttsState,
                                      indexNum: indexNum,
                                      dataUser: widget.dataUser,
                                      repeatBtn: repeatControll,
                                      repeatSentence: repeatSentence,
                                      updatePercentFnc: updatePercent,
                                    ),
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: themeProvider.mode == ThemeMode.dark
                                  ? const Color.fromRGBO(42, 43, 49, 1)
                                  : Colors.white,
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey.withOpacity(0.4),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildButtonControll(
                                    S.of(context).Repeat, changeRepeat),
                                InkWell(
                                  onTap: changeBtn,
                                  child: (controllerBtn == BtnState.play)
                                      ? InkWell(
                                          child: SvgPicture.asset(
                                              'assets/new_ui/more/btn_pause.svg'),
                                        )
                                      : InkWell(
                                          child: SvgPicture.asset(
                                              'assets/new_ui/more/btn_play.svg'),
                                        ),
                                ),
                                _buildButtonControll(
                                    S.of(context).PracticeSpeaking, () {
                                  setState(() {
                                    repeatControll = BtnState.paused;
                                    controllerBtn = BtnState.paused;
                                  });
                                  tts.stop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) {
                                        return PracticeSceen(
                                          idText: widget.id,
                                          title: widget.title,
                                          restartSpeaking: restart,
                                        );
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (dialogProvider.isClickItem == true)
                ? _viewShowAll()
                : const SizedBox()
          ],
        );
      },
    );
  }

  ///View show all
  Widget _viewShowAll() {
    var dialogProvider = context.read<DialogProvider>();
    return GestureDetector(
      onTap: () {
        dialogProvider.setClickItem(false);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.85),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                width: MediaQuery.of(context).size.width / 1.35,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "${dialogProvider.titleContent}",
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.start,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "${dialogProvider.titleSub}",
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Colors.black26,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: dialogProvider.widgetRecorder)
          ],
        ),
      ),
    );
  }
}
