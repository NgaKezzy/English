import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/models/TextReviewModel.dart';

import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';

import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ItemCentenceReview extends StatefulWidget {
  final TextReview textReview;
  final Function callReload;
  ItemCentenceReview(
      {Key? key, required this.textReview, required this.callReload})
      : super(key: key);

  @override
  _ItemVocabulary createState() => _ItemVocabulary(textReview: textReview);
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

class _ItemVocabulary extends State<ItemCentenceReview> {
  TextReview textReview;
  _ItemVocabulary({Key? key, required this.textReview});

  late BtnState controllerBtn;
  late FlutterTts tts;
  bool _isListening = false;

  Future _speak(String text) async {
    tts.setVoice({'name': 'en-AU-language', 'locale': 'en-AU'});
    await tts.awaitSpeakCompletion(true);
    await tts.speak(text);
  }




  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;
  TtsState ttsState = TtsState.stopped;
  @override
  void initState() {
    controllerBtn = BtnState.play;
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
        ttsState = TtsState.stopped;
      });
    });

    tts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
    super.initState();
  }

  Future autoPlay(String id, String title) async {
    tts.setVoice({'name': 'en-AU-language', 'locale': 'en-AU'});
    await tts.awaitSpeakCompletion(true);
    await tts.speak(title);
    controllerBtn = BtnState.paused;
    setState(() {
      _isListening = false;
    });
  }

  Future getVoices() async {
    print(await tts.getVoices);
  }

  Future _stop() async {
    var result = await tts.stop();
    if (result == 1)
      setState(() {
        ttsState = TtsState.stopped;
      });
  }

  Future _pause() async {
    var result = await tts.pause();
    if (result == 1)
      setState(() {
        ttsState = TtsState.paused;
      });
  }

  void playTalking() {
    setState(() {
      controllerBtn = BtnState.paused;
    });
  }

  void stopTalking() {
    _stop();
    setState(() {
      controllerBtn = BtnState.play;
    });
  }

  @override
  void dispose() {
    super.dispose();
    tts.stop();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      String lang = provider.locale!.languageCode;
      return Container(
        color: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(24, 26, 33, 1)
            : Colors.grey[200],
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.white,
                      width: 0.5),
                  color: themeProvider.mode == ThemeMode.dark
                      ? Color.fromRGBO(42, 44, 50, 1)
                      : Colors.white,
                ),
                width: MediaQuery.of(context).size.width,
                child: Container(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Color.fromRGBO(42, 44, 50, 1)
                      : Colors.white,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: _isListening
                                  ? Color.fromRGBO(83, 180, 81, 1)
                                  : themeProvider.mode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                          child: FloatingActionButton(
                            elevation: 0,
                            backgroundColor:  themeProvider.mode == ThemeMode.dark
                                    ? Color.fromRGBO(42, 44, 50, 1)
                                    : Colors.white,
                            onPressed: () {
                              autoPlay(
                                  textReview.id.toString(), textReview.content);
                              setState(() {
                                _isListening = true;
                              });
                            },
                            child: _isListening
                                ? Lottie.asset(
                                'assets/new_ui/animation_lottie/anim_loa.json',
                                 height: 30,
                               )
                                : SvgPicture.asset(
                                    'assets/new_ui/more/voice_11.svg',
                                    color: themeProvider.mode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              textReview.content.toString(),
                              style: TextStyle(
                                fontSize:
                                    ResponsiveWidget.isSmallScreen(context)
                                        ? width / 20
                                        : width / 30,
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              textReview.getContentByLanguage(lang),
                              style: TextStyle(
                                fontSize: 15,
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Color.fromRGBO(105, 106, 111, 1)
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }
}
