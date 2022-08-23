import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TextReviewModel.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/review/itemSentenceReview.dart';
import 'package:app_learn_english/presentation/speak/widgets/conversation_box.dart';
import 'package:app_learn_english/presentation/speak/widgets/showMessageNotify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:substring_highlight/substring_highlight.dart';

class SpeakSample extends StatefulWidget {
  static const routeName = '/reviewspeak';
  final TextReview textReview;
  SpeakSample({Key? key, required this.textReview}) : super(key: key);
  @override
  _SpeakSampleState createState() => _SpeakSampleState();
}

class _SpeakSampleState extends State<SpeakSample> {
  late FlutterTts tts;
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _speechEnabled = false;
  List<String> _wrongWords = [];

  bool autoSpeakOneTime = true;
  bool _isListening = false;
  bool _checkTalk = false;

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (_) {
        showMaterialModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            elevation: 10,
            backgroundColor: Colors.white,
            context: context,
            builder: (BuildContext ctx) {
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
                          child: const Icon(
                            Icons.close_sharp,
                            size: 30,
                          ),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        child: Text(
                          S.of(context).VoiceNotRecognizedPleaseTryAgain,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
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
    List<String> convertTextApi = widget.textReview.content
        .replaceAll(new RegExp(r'[!\?\.\,]+'), '')
        .toLowerCase()
        .trim()
        .split(' ');
    List<String> convertRecogizeWords = result.recognizedWords
        .toLowerCase()
        .replaceAll(new RegExp(r'[!\?\.\,]+'), '')
        .trim()
        .split(' ');
    printRed(widget.textReview.content
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
      _wrongWords = convertTextApi;
      _checkTalk = true;
    });

    if (convertTextApi.length == 0) {
      // NẾU MẢNG CHỨA CÁC TỪ CÒN SÓT LẠI CÓ ĐỘ DÀI BẰNG 0 THÌ CÂU NÀY HOÀN TOÀN NÓI ĐÚNG
      if (_speechToText.isNotListening) {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          context: context,
          builder: (_) => ShowMessageNotify(
            message: '${S.of(context).GreatExactly}',
            stateVoice: CheckVoiceState.Right,
            speechToText: _speechToText,
          ),
        );
      }
      setState(() {
        _isListening = false;
      });
    } else {
      double percentLoading = (_wrongWords.length /
              (widget.textReview.content // MẪU CÂU CHÍNH CẦN SO SÁNH
                  .replaceAll(new RegExp(r'[!\?\.\,]+'),
                      '') // REGULAR EXPRESSION LỌC CÁC KÝ TỰ ĐẶC BIỆT TRONG CÂU
                  .toLowerCase()
                  .trim()
                  .split(' ')
                  .length)) *
          100;
      if (_speechToText.isNotListening) {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          elevation: 10,
          context: context,
          builder: (_) => ShowMessageNotify(
            message: (100 - percentLoading == 0)
                ? S.of(context).SorryTryHarder
                : '${S.of(context).GreatYouAreRight} ${NumberFormat("###.0#", "en_US").format(100 - percentLoading)}%',
            stateVoice: CheckVoiceState.Wrong,
            speechToText: _speechToText,
          ),
        );
        setState(() {
          _isListening = false;
        });
      }
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
    tts.setSpeechRate(0.45);
    tts.setStartHandler((){
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
    autoPlay();
    super.initState();
  }

  String changeLanguage(String languageCode) {
    String sample = '';

    switch (languageCode) {
      case 'en':
        sample = widget.textReview.content;
        break;
      case 'ru':
        sample = widget.textReview.content_ru;
        break;
      case 'vi':
        sample = widget.textReview.content_vi;
        break;
      case 'es':
        sample = widget.textReview.content_es;
        break;
      case 'hi':
        sample = widget.textReview.content_hi;
        break;
      case 'ja':
        sample = widget.textReview.content_ja;
        break;
      case 'zh':
        sample = widget.textReview.content_zh;
        break;
      case 'tr':
        sample = widget.textReview.content_tr;
        break;
      case 'pt':
        sample = widget.textReview.content_pt;
        break;
      case 'id':
        sample = widget.textReview.content_id;
        break;
      case 'th':
        sample = widget.textReview.content_th;
        break;
      case 'ms':
        sample = widget.textReview.content_ms;
        break;
      case 'ar':
        sample = widget.textReview.content_ar;
        break;
      case 'fr':
        sample = widget.textReview.content_fr;
        break;
      case 'it':
        sample = widget.textReview.content_it;
        break;
      case 'de':
        sample = widget.textReview.content_de;
        break;
      case 'ko':
        sample = widget.textReview.content_ko;
        break;
      case 'zh_Hant_TW':
        sample = widget.textReview.content_zh_Hant_TW;
        break;
      case 'sk':
        sample = widget.textReview.content_sk;
        break;
      case 'sl':
        sample = widget.textReview.content_sl;
        break;
      default:
    }

    printRed(languageCode);

    return sample;
  }

  void autoPlay() async {

    await tts.awaitSpeakCompletion(true);

    await tts.setVoice({'name': 'en-AU-language', 'locale': 'en-AU'});

    await tts.speak(widget.textReview.content);

    setState(() {
      autoSpeakOneTime = false;
    });
  }

  @override
  void dispose() {
    tts.stop();
    tts.pause();
    tts.stop();
    _speechToText.cancel();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(builder: (ctx, provider, snapshot) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            changeLanguage('en'),
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Colors.blue.shade400,
            //     Colors.tealAccent.shade400,
            //   ],
            // ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubstringHighlight(
                          text: changeLanguage('en'),
                          words: true,
                          terms: _wrongWords,
                          textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color:
                                _checkTalk ? Colors.green[400] : Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          changeLanguage(provider.locale!.languageCode) == ''
                              ? ''
                              : changeLanguage(provider.locale!.languageCode),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.green,
                ),
                child: IconButton(
                  onPressed: () async {
                    await tts.speak(widget.textReview.content);
                  },
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: _isListening,
          child: FloatingActionButton(
            onPressed: () {
              if (_isListening) {
                setState(() {
                  _isListening = false;
                });
                _stopListening();
              } else {
                setState(() {
                  _isListening = true;
                });
                _startListening();
              }
            },
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
            ),
          ),
        ),
      );
    });
  }
}
