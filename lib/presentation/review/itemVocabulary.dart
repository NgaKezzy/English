import 'package:app_learn_english/models/NewWord.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ItemVocabulary extends StatefulWidget {
  final NewWord newWords;
  ItemVocabulary({Key? key, required this.newWords}) : super(key: key);

  @override
  _ItemVocabulary createState() => _ItemVocabulary();
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

class _ItemVocabulary extends State<ItemVocabulary> {
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

  Future autoPlay(String title) async {
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
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.5),
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            width: ResponsiveWidget.isSmallScreen(context)
                ? width / 1.1
                : width / 1.1,
            child: Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    autoPlay(widget.newWords.content);
                    setState(() {
                      _isListening = true;
                    });
                  },
                  child: Icon(
                    Icons.volume_up_sharp,
                    color: _isListening ? Colors.white : Colors.black,
                    size: 30,
                  ),
                  backgroundColor:
                      _isListening ? Colors.black : Colors.pink.shade50,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Container(
                  width: ResponsiveWidget.isSmallScreen(context)
                      ? width / 1.5
                      : width / 1.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.newWords.content,
                        style: TextStyle(
                          fontSize: ResponsiveWidget.isSmallScreen(context)
                              ? width / 20
                              : width / 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.newWords.content_vi,
                        style: TextStyle(
                          fontSize: ResponsiveWidget.isSmallScreen(context)
                              ? width / 25
                              : width / 30,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            )),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
