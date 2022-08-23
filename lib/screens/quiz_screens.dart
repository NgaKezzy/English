import 'dart:math';

import 'package:app_learn_english/Providers/dialog_provider.dart';
import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/quiz/fill_text_controller_model.dart';
import 'package:app_learn_english/models/quiz/list_choose_model.dart';
import 'package:app_learn_english/models/quiz/talk_detail_quiz_model.dart';
import 'package:app_learn_english/models/quiz/wrong_sentence_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/home/component/getRewarded.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/screens/cheer_quiz_screen.dart';
import 'package:app_learn_english/utils/color_utils.dart';

import 'package:app_learn_english/utils/config_heart_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class QuizScreens extends StatefulWidget {
  final int leverQuiz;
  final List<TalkDetailQuizModel> listQuiz;

  QuizScreens({Key? key, required this.leverQuiz, required this.listQuiz})
      : super(key: key);

  @override
  State<QuizScreens> createState() => _QuizScreensState();
}

class _QuizScreensState extends State<QuizScreens> {
  late AudioPlayer player;
  final _random = new Random();
  final myController = TextEditingController();
  final _key = GlobalKey();
  GlobalKey _scaffold = GlobalKey();
  late List<TalkDetailQuizModel> list10Quiz;
  late List<ChooseModel> _listChooseModel;
  late List<ChooseModel> _listChooseTextSpanModel;
  late List<FillTextControllerModer> _listFillTextSpanModel;
  late int leverUser;

  SpeechToText _speechToText = SpeechToText();
  DataUser userData = DataCache().getUserData();
  Record recorder = Record();

  List<String> _listFill = [];
  List<String> _listCheckQuiz = [];
  List<int> _listIndexTextChoose = [];
  List<int> _listCheckLever = [];
  List<String> _listMainResult = [];
  List<TalkDetailQuizModel> _listTemporary = [];
  List<WrongSentenceModel> _listWrongSentence = [];

  // TextToSpeech _textToSpeech = TextToSpeech();
  FlutterTts _textToSpeech = FlutterTts();

  String _textLanguageLocal = "";
  String _textLanguageEnglish = "";
  String _textMainSentence = "";
  int count = 0;
  int countWrong = 0;
  int countFill = 0;
  int countCenter = 0;
  int _heart = 0;
  double unitProgress = 0;
  double progress = 0;

  bool isRight = false;
  bool isRefresh = false;
  bool isFillIndex1 = false;
  bool isFillIndex2 = false;
  bool isFillIndex3 = false;
  bool isReady = false;
  bool isCenterProgress = false;
  bool isRecord = false;
  bool _speechEnabled = false;
  bool _isOpenRecord = false;
  bool _isClickAds = false;
  bool _isFirstOpenCheer = false;
  bool _isFinishedReading = false;

  String _textChoose1 = "";
  String _textChoose2 = "";
  String _textChoose3 = "";
  String _stringRecord = "";

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _speechEnabled = true;
    });
  }

  ///stop listening micro
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _speechEnabled = false;
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _stringRecord = result.recognizedWords + " ";
      checkStringIsNull(_stringRecord);
    });
  }

  ///check xem có mẫu câu chính hay không
  bool getBoolMainSentence() {
    if (list10Quiz[0].mainSentence!.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  /// tạo text gợi ý cho câu trả lời
  String setTextHint() {
    var text = "";
    var arrayMainSentence = this._textMainSentence.split(",");
    var textHintEnglish = this._textLanguageEnglish;
    if (this.leverUser <= 2) {
      arrayMainSentence.removeAt(1);
      arrayMainSentence.removeAt(1);
    } else if (this.leverUser > 2) {
      arrayMainSentence.removeAt(2);
    }
    text = textHintEnglish;
    for (var item in arrayMainSentence) {
      if (textHintEnglish.contains(item)) {
        text = text.replaceAll(
            item, item.replaceAll(new RegExp('(?<=.)[^]'), '_'));
      }
    }
    return text;
  }

  /// sét text hiển thị của view top theo chức năng học
  String setTextToViewTop() {
    var title = "";
    if (this.isRecord) {
      title = S.of(context).noi_cau_duoi_day;
    } else {
      if (this.leverUser == 1 && this.progress < 0.5) {
        title = S.of(context).xem_cau_truc_va_y_nghia;
      } else {
        title = S.of(context).hoan_thanh_cau_sau;
      }
    }
    return title;
  }

  /// fun show Hint
  void showMoreText(String text) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: text,
        textStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Quicksand'),
        height: 150,
        width: calcTextSize(text, TextStyle(fontSize: 18)).width,
        backgroundColor: Colors.green[300],
        padding: EdgeInsets.only(top: 8.0, left: 10, right: 10, bottom: 5),
        borderRadius: BorderRadius.circular(10.0),
        onDismiss: () {});

    popup.show(widgetKey: this._key);
  }

  ///close quiz
  void closeQuiz(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    Navigator.pop(context, this.leverUser);
  }

  ///check xem user đã điền chữ hay chưa
  checkStringIsNull(String value) {
    if (value.isNotEmpty) {
      this.isReady = true;
    } else {
      this.isReady = false;
    }
    setState(() {});
  }

  ///lấy các câu tiếng anh ra đọc ở lever1
  textLanguage(List<TalkDetailQuizModel> listQuiz, String lang) async {
    if (count < listQuiz.length) {
      setState(() {
        this._textLanguageLocal = changeLanguage(lang, count, listQuiz)!;
        this._textLanguageEnglish = listQuiz[count].content!;
        this.isReady = true;
        this.countCenter++;
        this.count++;
      });
      await _textToSpeech
          .setVoice({'name': 'en-AU-language', 'locale': 'en-AU'});
      await _textToSpeech.speak(this._textLanguageEnglish);
      await _textToSpeech.setLanguage('en-US');
      await _textToSpeech.setVolume(1.0);
      await _textToSpeech.setSpeechRate(0.4);
      _textToSpeech.setStartHandler(() {
        setState(() {
          _isFinishedReading = true;
        });
      });
      _textToSpeech.setCompletionHandler(() {
        setState(() {
          _isFinishedReading = false;
        });
      });
    } else {
      setState(() {
        count = 0;
      });
    }
  }

  /// đọc lại câu hiện tại khi click vào icon loa
  Future readEnglish(String textEnglish) async {
    await _textToSpeech.setVoice({'name': 'en-AU-language', 'locale': 'en-AU'});
    await _textToSpeech.speak(textEnglish);
    await _textToSpeech.setLanguage('en-US');
    await _textToSpeech.setVolume(1.0);
    await _textToSpeech.setSpeechRate(0.4);
    _textToSpeech.setCompletionHandler(() {
      setState(() {
        _isFinishedReading = false;
      });
    });
  }

  /// lấy các câu tiếng anh cho chức năng chọn từ
  void textChooseTheWord(List<TalkDetailQuizModel> listQuiz, String lang) {
    if (count < listQuiz.length) {
      setState(() {
        if (listQuiz[count].mainSentence!.isEmpty) {
          count = count + 1;
        }
        // tạo ra một list model chứa các thuộc tính để so sánh
        _listChooseModel = List.generate(3, (index) => ChooseModel(""));
        this._textLanguageEnglish = listQuiz[count].content!;
        this._textLanguageLocal = changeLanguage(lang, count, listQuiz)!;

        //check xem các từ chính sever trả về có đủ 3 từ không, nếu không đủ phải add thêm để đủ số lượng từ để user chọn.
        if (listQuiz[count].mainSentence!.split(",").length == 3) {
          this._textMainSentence = listQuiz[count].mainSentence!;
        } else if (listQuiz[count].mainSentence!.split(",").length > 3) {
          var list = listQuiz[count].mainSentence!.split(",");
          this._textMainSentence = list[0];
          for (int i = 1; i < 3; i++) {
            this._textMainSentence = this._textMainSentence + ",${list[i]}";
          }
        } else {
          if (listQuiz[count].mainSentence!.isNotEmpty) {
            //nếu không đủ 3 từ main thì random lấy một từ main được lấy từ list main trước đó
            int i = (count >= 8) ? 1 : count + 1;
            var _listRandom = listQuiz[i].content!.split(" ");
            var element = _listRandom[_random.nextInt(_listRandom.length)];
            if (listQuiz[count]
                    .mainSentence![listQuiz[count].mainSentence!.length - 1] ==
                ",") {
              listQuiz[count].mainSentence = listQuiz[count]
                  .mainSentence!
                  .substring(0, listQuiz[count].mainSentence!.length - 1);
              this._textMainSentence =
                  listQuiz[count].mainSentence! + ",$element";
              if (this._textMainSentence[this._textMainSentence.length - 1] ==
                  ",") {
                this._textMainSentence = this
                    ._textMainSentence
                    .substring(0, this._textMainSentence.length - 1);
              }
            } else {
              this._textMainSentence =
                  listQuiz[count].mainSentence! + ",$element";
              if (this._textMainSentence[this._textMainSentence.length - 1] ==
                  ",") {
                this._textMainSentence = this
                    ._textMainSentence
                    .substring(0, this._textMainSentence.length - 1);
              }
            }
            if (this._textMainSentence.split(",").length < 3) {
              var textMain2 = listQuiz[i].mainSentence;
              //nếu không đủ từ main thì dừng lại bài học,nếu đủ main thì tiếp tục học
              if (textMain2!.length > 0) {
                if (textMain2[textMain2.length - 1] == ",") {
                  textMain2 = textMain2.substring(0, textMain2.length - 1);
                }
                var _listRandom2 = textMain2.split(",");
                var element1 =
                    _listRandom2[_random.nextInt(_listRandom2.length)];

                this._textMainSentence = this._textMainSentence + ",$element1";
                if (this._textMainSentence[this._textMainSentence.length - 1] ==
                    ",") {
                  this._textMainSentence = this
                      ._textMainSentence
                      .substring(0, this._textMainSentence.length - 1);
                }
              } else {
                closeQuiz(context);
                Navigator.pop(context, this.leverUser);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GetRewarded()));
              }
            }
          }
        }
        Provider.of<DialogProvider>(context, listen: false)
            .setListRandomChoose(this._textMainSentence.split(","));
        //tạo một mảng từ string tiếng anh đầu vào để so sánh item khi chọn từ.
        _listChooseTextSpanModel = List.generate(
            this._textLanguageEnglish.split(" ").length,
            (index) => ChooseModel(""));

        //tạo một mảng chứa các string  khi  người dùng điền từ vào ô trống
        _listFillTextSpanModel = List.generate(
            this._textLanguageEnglish.split(" ").length,
            (index) =>
                FillTextControllerModer("", index, TextEditingController()));

        this.isReady = false;
        this.count++;

        if (count == listQuiz.length - 1) {
          this.count = 1;
        }
      });
    } else {
      if (countWrong < _listWrongSentence.length) {
        setState(() {
          // tạo ra một list model chứa các thuộc tính để so sánh
          _listChooseModel = List.generate(3, (index) => ChooseModel(""));
          this._textLanguageEnglish =
              _listWrongSentence[countWrong].stringEnglish;
          this._textMainSentence =
              _listWrongSentence[countWrong].stringMainSentence;

          //tạo một mảng từ string tiếng anh đầu vào để so sánh item khi chọn từ.
          _listChooseTextSpanModel = List.generate(
              this._textLanguageEnglish.split(" ").length,
              (index) => ChooseModel(""));

          this.isReady = false;

          this.countWrong++;
          if (this.isRight) {
            _listWrongSentence.removeAt(countWrong - 1);
            this.countWrong = this.countWrong - 1;
          }
        });
      } else {
        setState(() {
          countWrong = 0;
        });
      }
    }
  }

  /// tính kích thước with height của một chuỗi String.
  Size calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance!.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }

  /// tăng progress khi hoàn thành một câu trong bài ôn tập
  void setProgress() {
    setState(() {
      this.progress =
          double.parse((progress + unitProgress).toStringAsFixed(2));
    });
  }

  ///set Text để tích with của view khi chọn một text trong list Text
  String setWithTextForTextSpan(int index, List<int> listIndexTextChoose) {
    // trả ra một string theo thứ tự từ 0 -> v.v.v
    String _text = "";
    if (listIndexTextChoose.length > 0 && _listFill.length > 0) {
      if (index == listIndexTextChoose[0] && isFillIndex1) {
        _text = _listFill[0];
      }
      if (listIndexTextChoose.length >= 2 &&
          _listFill.length >= 2 &&
          index == listIndexTextChoose[1] &&
          isFillIndex2) {
        _text = _listFill[1];
      }
      if (listIndexTextChoose.length >= 3 &&
          _listFill.length >= 3 &&
          index == listIndexTextChoose[2] &&
          isFillIndex3) {
        _text = _listFill[2];
      }
    }
    return _text;
  }

  ///check xem câu trả lời phần CHỌN TỪ VÀO Ô TRỐNG có đúng không , nếu đúng thì next không đúng thì add vào list để trả lời lại
  checkTheAnswer(int leverQuiz) {
    if (_listFill.length == (leverQuiz <= 2 ? 1 : 2)) {
      setState(() {
        _listMainResult = _listFill;
        this.isRight =
            Provider.of<DialogProvider>(context, listen: false).isRight;
        if (this.isRight) {
          if (this.leverUser == 1) {
            this.countCenter++;
            setProgress();
          } else if (this.leverUser == 2) {
            if (this.progress != 0.65 && this.progress != 0.5) {
              setProgress();
            }
          } else if (this.leverUser == 3) {
            if (this.progress != 0.45) {
              setProgress();
            }
          }
          player.setAsset('assets/audio/dung.mp3');
          player.play();
        }
        this.isRefresh = true;
        //check nếu sai thì add vào list để học lại
        if (this.isRight == false) {
          if (!_listWrongSentence.contains(WrongSentenceModel(
              this._textLanguageEnglish, this._textMainSentence))) {
            _listWrongSentence.add(WrongSentenceModel(
                this._textLanguageEnglish, this._textMainSentence));
          }
          player.setAsset('assets/audio/tlsai.mp3');
          player.play();
          if (userData.isVip == 3 || userData.isVip == 0) {
            if (_heart > 0) {
              _heart = _heart - 1;
            }
            context.read<CountHeartProvider>().setCountHeart(_heart);
            //trừ đá khi sai
            plusMinusHeart(ConfigHeart.quiz_video_tru_tim);
          }
        }
      });
    }
  }

  ///check kết quả GHI ÂM
  checkResultRecord() {
    if (isReady) {
      setState(() {
        final listRecord = _stringRecord.split(" ");
        final listEnglish = this._textLanguageEnglish.split(" ");
        if (listEnglish.length == listRecord.length) {
          for (var i = 0; i < listEnglish.length - 1; i++) {
            var textRecord = listRecord[i]
                .replaceAll(",", "")
                .replaceAll("!", "")
                .replaceAll(".", "")
                .replaceAll("?", "")
                .replaceAll("''", "");

            var textEnglish = listEnglish[i]
                .replaceAll(",", "")
                .replaceAll("!", "")
                .replaceAll(".", "")
                .replaceAll("?", "")
                .replaceAll("''", "");

            if (textRecord.toLowerCase() == textEnglish.toLowerCase()) {
              this.isRight = true;
            } else {
              this.isRight = false;
              break;
            }
          }
        } else {
          this.isRight = false;
        }
        if (this.isRight == false) {
          _heart = _heart - 1;
          player.setAsset('assets/audio/tlsai.mp3');
          player.play();
        } else {
          player.setAsset('assets/audio/dung.mp3');
          player.play();
        }
        this.isRefresh = true;
      });
    }
  }

  ///check kết quả khi điền text vào ô trống
  checkResultFill() {
    if (isReady) {
      setState(() {
        this.isRight =
            Provider.of<DialogProvider>(context, listen: false).isRight;
        if (this.isRight) {
          this.countCenter++;
          setProgress();
          player.setAsset('assets/audio/dung.mp3');
          player.play();
        } else {
          player.setAsset('assets/audio/tlsai.mp3');
          player.play();
          if (userData.isVip == 3 || userData.isVip == 0) {
            if (_heart > 0) {
              _heart = _heart - 1;
            }
            context.read<CountHeartProvider>().setCountHeart(_heart);
            //trừ đá khi sai
            plusMinusHeart(ConfigHeart.quiz_video_tru_tim);
          }
        }
        this.isRefresh = true;
      });
    }
  }

  ///so sánh chuỗi String user nhập vào và câu chính ở lever4
  checkResultString() {
    var listStringEnglish = this._textLanguageEnglish.split(" ");
    var listStringUser = this.myController.text.split(" ");
    if (listStringEnglish.length == listStringUser.length) {
      _listMainResult = listStringUser;
      for (var i = 0; i < listStringEnglish.length - 1; i++) {
        var item1 = listStringEnglish[i]
            .replaceAll(",", "")
            .replaceAll("!", "")
            .replaceAll(".", "")
            .replaceAll("?", "")
            .replaceAll("''", "");
        var item2 = listStringUser[i]
            .replaceAll(",", "")
            .replaceAll("!", "")
            .replaceAll(".", "")
            .replaceAll("?", "")
            .replaceAll("''", "");

        if (item1.toLowerCase() == item2.toLowerCase()) {
          this.isRight = true;
        } else {
          this.isRight = false;
          break;
        }
      }
      setState(() {
        if (this.isRight == true) {
          if (this.progress != 0.1 && this.progress != 0.65) {
            setProgress();
          }
        }
      });
    } else {
      setState(() {
        this.isRight = false;
      });
    }
    if (this.isRight == false) {
      _heart = _heart - 1;
      player.setAsset('assets/audio/tlsai.mp3');
      player.play();
    } else {
      player.setAsset('assets/audio/dung.mp3');
      player.play();
    }
    this.isRefresh = true;
  }

  ///set Text được chọn vào ô trống trong phần chơi chọn từ
  setTextForTextSpan(int index, List<int> listIndexTextChoose) {
    if (listIndexTextChoose.length > 0 && _listFill.length > 0) {
      if (index == listIndexTextChoose[0] && isFillIndex1) {
        if (_listChooseTextSpanModel[index].title == _listFill[0] &&
            _listChooseTextSpanModel[index].isFirst == true) {
          _listFill[0] = "";
          _listChooseTextSpanModel[index].title = "";
        } else {
          _listChooseTextSpanModel[index].title = _listFill[0];
          _listChooseTextSpanModel[index].isFirst = false;
        }
      }
      if (listIndexTextChoose.length >= 2 &&
          _listFill.length >= 2 &&
          index == listIndexTextChoose[1] &&
          isFillIndex2) {
        if (_listChooseTextSpanModel[index].title == _listFill[1] &&
            _listChooseTextSpanModel[index].isFirst == true) {
          _listFill[1] = "";
          _listChooseTextSpanModel[index].title = "";
        } else {
          _listChooseTextSpanModel[index].title = _listFill[1];
          _listChooseTextSpanModel[index].isFirst = false;
        }
      }
      if (listIndexTextChoose.length >= 3 &&
          _listFill.length >= 3 &&
          index == listIndexTextChoose[2] &&
          isFillIndex3) {
        if (_listChooseTextSpanModel[index].title == _listFill[2] &&
            _listChooseTextSpanModel[index].isFirst == true) {
          _listFill[2] = "";
          _listChooseTextSpanModel[index].title = "";
        } else {
          _listChooseTextSpanModel[index].title = _listFill[2];
          _listChooseTextSpanModel[index].isFirst = false;
        }
      }
      setReady();
    }
  }

  ///set màu cho các ô chữ được chọn
  setColorsTextSpan(int index, List<int> listIndexTextChoose) {
    if (listIndexTextChoose.length > 0 && _listFill.length > 0) {
      if (index == listIndexTextChoose[0] && isFillIndex1) {
        if (_listChooseTextSpanModel[index].isSelected == true &&
            _listChooseTextSpanModel[index].isFirst == true) {
          _listChooseTextSpanModel[index].isSelected = false;
        } else {
          if (_listChooseTextSpanModel[index].title.isNotEmpty) {
            _listChooseTextSpanModel[index].isSelected = true;
            _listChooseTextSpanModel[index].isFirst = false;
          }
        }
      }

      if (listIndexTextChoose.length >= 2 &&
          _listFill.length >= 2 &&
          index == listIndexTextChoose[1] &&
          isFillIndex2) {
        if (_listChooseTextSpanModel[index].isSelected == true &&
            _listChooseTextSpanModel[index].isFirst == true) {
          _listChooseTextSpanModel[index].isSelected = false;
        } else {
          if (_listChooseTextSpanModel[index].title.isNotEmpty) {
            _listChooseTextSpanModel[index].isSelected = true;
            _listChooseTextSpanModel[index].isFirst = false;
          }
        }
      }
      if (listIndexTextChoose.length >= 3 &&
          _listFill.length >= 3 &&
          index == listIndexTextChoose[2] &&
          isFillIndex3) {
        if (_listChooseTextSpanModel[index].isSelected == true &&
            _listChooseTextSpanModel[index].isFirst == true) {
          _listChooseTextSpanModel[index].isSelected = false;
        } else {
          if (_listChooseTextSpanModel[index].title.isNotEmpty) {
            _listChooseTextSpanModel[index].isSelected = true;
            _listChooseTextSpanModel[index].isFirst = false;
          }
        }
      }
    }
  }

  ///check xem user đã chọn đủ từ theo lever hay chưa , nếu đủ rồi thì cho next không thì không cho next.
  setReady() {
    if (_listFill.length == (this.leverUser <= 2 ? 1 : 2)) {
      for (var item in _listFill) {
        if (item.isNotEmpty) {
          this.isReady = true;
        } else {
          this.isReady = false;
          break;
        }
      }
    }
  }

  /// check ngôn ngữ dịch
  String? changeLanguage(
      String languageCode, int index, List<TalkDetailQuizModel> listQuiz) {
    String? sample = '';

    switch (languageCode) {
      case 'en':
        sample = listQuiz[index].content;
        break;
      case 'ru':
        sample = listQuiz[index].contentRu;
        break;
      case 'vi':
        sample = listQuiz[index].contentVi;
        break;
      case 'es':
        sample = listQuiz[index].contentEs;
        break;
      case 'hi':
        sample = listQuiz[index].contentHi;
        break;
      case 'ja':
        sample = listQuiz[index].contentJa;
        break;
      case 'zh':
        sample = listQuiz[index].contentZh;
        break;
      case 'tr':
        sample = listQuiz[index].contentTr;
        break;
      case 'pt':
        sample = listQuiz[index].contentPt;
        break;
      case 'id':
        sample = listQuiz[index].contentId;
        break;
      case 'th':
        sample = listQuiz[index].contentTh;
        break;
      case 'ms':
        sample = listQuiz[index].contentMs;
        break;
      case 'ar':
        sample = listQuiz[index].contentAr;
        break;
      case 'fr':
        sample = listQuiz[index].contentFr;
        break;
      case 'it':
        sample = listQuiz[index].contentIt;
        break;
      case 'de':
        sample = listQuiz[index].contentDe;
        break;
      case 'ko':
        sample = listQuiz[index].contentKo;
        break;
      case 'zh_Hant_TW':
        sample = listQuiz[index].contentZh_Hant_TW;
        break;
      case 'sk':
        sample = listQuiz[index].contentSk;
        break;
      case 'sl':
        sample = listQuiz[index].contentSl;
        break;
      default:
        sample = listQuiz[index].content;
    }
    return sample;
  }

  ///check xem người dùng đã điền vào ô trống hay chưa
  setReadyTextFill(int index) {
    for (var i in _listIndexTextChoose) {
      if (_listFillTextSpanModel[i].tileChange.isNotEmpty) {
        this.isReady = true;
      } else {
        this.isReady = false;
        break;
      }
    }
    setState(() {});
  }

  ///tạo câu có ông trống và chọn từ vào ô trống
  List<TextSpan> createTextSpans(
      String texEnglish, String mainSentence, int lever) {
    var themeProvider = context.watch<ThemeProvider>();
    _listCheckQuiz.clear();
    _listIndexTextChoose.clear();
    final arrayMainSentence = mainSentence.split(",");
    if (arrayMainSentence.length == 3) {
      if (lever == 1) {
        arrayMainSentence.removeAt(1);
        arrayMainSentence.removeAt(1);
      } else if (lever >= 2) {
        arrayMainSentence.removeAt(2);
      }
    }
    final arrayStrings = texEnglish.split(" ");
    List<TextSpan> arrayOfTextSpan = [];
    for (int index = 0; index < arrayStrings.length; index++) {
      final text = arrayStrings[index];

      String textLanguage = text
          .replaceAll(",", "")
          .replaceAll("!", "")
          .replaceAll(".", "")
          .replaceAll("''", "")
          .replaceAll("?", "");

      if (!_listCheckQuiz.contains(textLanguage)) {
        _listCheckQuiz.add(textLanguage);
        Provider.of<DialogProvider>(context, listen: false)
            .checkLanguage(textLanguage, arrayMainSentence);
      } else {
        Provider.of<DialogProvider>(context, listen: false)
            .checkLanguage("", arrayMainSentence);
      }
      bool check = Provider.of<DialogProvider>(context, listen: false).isCheck;

      if (check) {
        _listIndexTextChoose.add(index);
      }
      setTextForTextSpan(index, _listIndexTextChoose);
      setColorsTextSpan(index, _listIndexTextChoose);

      final span = TextSpan(
        text: "",
        children: [
          WidgetSpan(
            child: check
                ? GestureDetector(
                    onTap: () {
                      if (_listChooseTextSpanModel[index].title.isNotEmpty) {
                        setState(() {
                          if (_listCheckLever.length > 0) {
                            _listCheckLever.removeAt(0);
                          }
                          for (int i = 0; i < _listChooseModel.length; i++) {
                            if (_listChooseModel[i].title ==
                                _listChooseTextSpanModel[index].title) {
                              _listChooseModel[i].isSelected = false;
                            }
                          }
                          _listChooseTextSpanModel[index].isFirst = true;
                          _listChooseTextSpanModel[index].isSelected = true;
                        });
                      }
                    },
                    child: Container(
                      width: calcTextSize(
                                  (setWithTextForTextSpan(
                                              index, _listIndexTextChoose)
                                          .isEmpty)
                                      ? text
                                      : setWithTextForTextSpan(
                                          index, _listIndexTextChoose),
                                  TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600))
                              .width +
                          16,
                      height: 40,
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: (_listChooseTextSpanModel[index].isSelected ==
                                  true)
                              ? Colors.green
                              : ColorsUtils.Color_888888.withOpacity(0.2),
                          border: Border.all(
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : ColorsUtils.Color_888888.withOpacity(0.2),
                              width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(
                            _listChooseTextSpanModel[index].title,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                                fontFamily: 'Roboto'),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      text,
                      style: TextStyle(
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                          fontFamily: 'Roboto'),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
          TextSpan(text: " ")
        ],
      );

      arrayOfTextSpan.add(span);
    }
    try {
      Provider.of<DialogProvider>(context, listen: false).checkResults(
          arrayStrings, _listChooseTextSpanModel, _listIndexTextChoose);
    } catch (e) {}

    return arrayOfTextSpan;
  }

  /// tạo câu có ông trống và điền từ vào ô trống.
  List<TextSpan> createTextSpansFill(
      String texEnglish, String mainSentence, int lever) {
    var themeProvider = context.watch<ThemeProvider>();
    _listCheckQuiz.clear();
    _listIndexTextChoose.clear();
    final arrayMainSentence = mainSentence.split(",");
    if (arrayMainSentence.length == 3) {
      if (lever <= 2) {
        arrayMainSentence.removeAt(1);
        arrayMainSentence.removeAt(1);
      } else {
        arrayMainSentence.removeAt(2);
      }
    }

    final arrayStrings = texEnglish.split(" ");
    List<TextSpan> arrayOfTextSpan = [];

    for (int index = 0; index < arrayStrings.length; index++) {
      final text = arrayStrings[index];

      String textLanguage = text
          .replaceAll(",", "")
          .replaceAll("!", "")
          .replaceAll(".", "")
          .replaceAll("''", "")
          .replaceAll("?", "");

      if (!_listCheckQuiz.contains(textLanguage)) {
        _listCheckQuiz.add(textLanguage);
        Provider.of<DialogProvider>(context, listen: false)
            .checkLanguage(textLanguage, arrayMainSentence);
      } else {
        Provider.of<DialogProvider>(context, listen: false)
            .checkLanguage("", arrayMainSentence);
      }
      bool check = Provider.of<DialogProvider>(context, listen: false).isCheck;
      if (check) {
        _listIndexTextChoose.add(index);
      }
      final spanFill = TextSpan(
        text: "",
        children: [
          WidgetSpan(
            child: check
                ? GestureDetector(
                    onTap: () {},
                    child: Material(
                      child: Container(
                        width: calcTextSize(
                                    text,
                                    TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700))
                                .width +
                            10,
                        height: 50,
                        decoration: BoxDecoration(
                            color: ColorsUtils.Color_888888.withOpacity(0.2),
                            border: Border.all(
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : ColorsUtils.Color_888888.withOpacity(0.2),
                                width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Container(
                          child: TextField(
                              controller:
                                  _listFillTextSpanModel[index].textController,
                              onChanged: (value) => {
                                    _listFillTextSpanModel[index].tileChange =
                                        value,
                                    setReadyTextFill(index)
                                  },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.lightGreen),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: themeProvider.mode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Quicksand'),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              cursorColor: Colors.green),
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      text,
                      style: TextStyle(
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          fontFamily: 'Roboto'),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
          TextSpan(text: " ")
        ],
      );
      _listMainResult.add(_listFillTextSpanModel[index].textController.text);
      arrayOfTextSpan.add(spanFill);
    }
    Provider.of<DialogProvider>(context, listen: false).checkResultsTextFill(
        arrayStrings, _listIndexTextChoose, _listFillTextSpanModel);
    return arrayOfTextSpan;
  }

  ///Tạo Text Span để hiển thị xem User trả lời đúng bao nhiêu phần trăm
  List<TextSpan> createTextSpansResult(
      String texEnglish, String mainSentence, List<String> arrayMainSentence) {
    _listCheckQuiz.clear();
    final arrayStrings = texEnglish.split(" ");
    List<TextSpan> arrayOfTextSpan = [];
    final arrayMain = mainSentence.split(",");
    var textCheck = "";
    if (this.leverUser <= 2) {
      arrayMain.removeAt(1);
      arrayMain.removeAt(1);
    } else {
      arrayMain.removeAt(2);
    }

    for (int index = 0; index < arrayStrings.length; index++) {
      final text = arrayStrings[index];
      if (index < arrayMainSentence.length) {
        textCheck = arrayMainSentence[index];
      }

      String textLanguage = text
          .replaceAll(",", "")
          .replaceAll("!", "")
          .replaceAll(".", "")
          .replaceAll("''", "")
          .replaceAll("?", "");

      if (!_listCheckQuiz.contains(textLanguage)) {
        _listCheckQuiz.add(textLanguage);
        Provider.of<DialogProvider>(context, listen: false)
            .checkLanguage(textLanguage, arrayMain);
      } else {
        Provider.of<DialogProvider>(context, listen: false)
            .checkLanguage("", arrayMain);
      }

      bool check = Provider.of<DialogProvider>(context, listen: false).isCheck;

      Provider.of<DialogProvider>(context, listen: false)
          .checkResultError(textLanguage, textCheck);

      bool checkResult =
          Provider.of<DialogProvider>(context, listen: false).isResult;

      final span = _isOpenRecord
          ? TextSpan(
              text: "",
              children: [
                TextSpan(
                  text: text,
                  style: TextStyle(
                      color: checkResult ? Colors.black : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                      fontFamily: 'Quicksand'),
                ),
                TextSpan(text: " ")
              ],
            )
          : TextSpan(
              text: "",
              children: [
                TextSpan(
                  text: text,
                  style: TextStyle(
                      color: check ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                      fontFamily: 'Quicksand'),
                ),
                TextSpan(text: " ")
              ],
            );
      arrayOfTextSpan.add(span);
    }
    return arrayOfTextSpan;
  }

  ///check dữ liệu đầu vào theo lever
  checkDataFlowLever(int leverUser, String lang) {
    if (leverUser == 1) {
      textLanguage(list10Quiz, lang);
    } else if (leverUser >= 2) {
      textChooseTheWord(list10Quiz, lang);
    }
  }

  plusMinusHeart(int typeAction) async {
    await UserAPIs().addAndDivHeart(
      username: DataCache().getUserData().username,
      uid: DataCache().getUserData().uid,
      typeAction: typeAction,
    );
  }

  ///call back ads
  void adsCallback(BuildContext context) async {
    setState(() {
      _heart = _heart + 4;
      plusMinusHeart(ConfigHeart.nhan_tim_tu_admob_cong_tim);
    });
    context.read<CountHeartProvider>().setCountHeart(_heart);
    Navigator.pop(context);
  }

  ///show ads
  void showAds(BuildContext context) {
    AdsController().showAdsCallback(adsCallback, context);
  }

  /// show dialog hỏi ý kiên khi user muốn thoát quiz
  showDialogCloseQuiz() {
    showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        elevation: 100,
        backgroundColor: Colors.blueGrey[800],
        context: _scaffold.currentContext!,
        builder: (BuildContext ctx) {
          var themeProvider = context.watch<ThemeProvider>();
          return Container(
            padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
            width: MediaQuery.of(context).size.width,
            height: 350,
            decoration: BoxDecoration(
                color: themeProvider.mode == ThemeMode.dark
                    ? Color.fromRGBO(42, 44, 50, 1)
                    : Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    'assets/new_ui/more/ic_splash.png',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(S.of(context).tiec_Qua,
                    style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontFamily: 'Quicksand')),
                Text(S.of(context).ban_co_chac_muon_thoat,
                    style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white30
                            : Colors.black38,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontFamily: 'Quicksand')),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Center(
                        child: Text(S.of(context).tiep_Tuc,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                                fontFamily: 'Quicksand')),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    closeQuiz(context);
                  },
                  child: Text(
                    S.of(context).EndOfQuiz,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  ///Show dialog hỏi ý kiến khi hết tim
  void showBottomDialog() {
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
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Container(
                padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                width: MediaQuery.of(context).size.width,
                height: 420,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Lottie.asset(
                          'assets/new_ui/animation_lottie/diamond.json',
                          height: 150,
                        ),
                        // Positioned(
                        //   top: 55,
                        //   left: 60,
                        //   child: Text(
                        //     '0',
                        //     style: const TextStyle(
                        //       color: Colors.white,
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
                        child: Stack(
                          children: [
                            Center(
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
                            _isClickAds
                                ? Center(
                                    // child: CircularProgressIndicator(),
                                    child: const PhoLoading(),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                      onPressed: () {
                        this.showAds(context);
                        setState(() {
                          _isClickAds = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        primary: Color.fromRGBO(83, 180, 81, 1),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Container(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              S.of(context).Tryusinginfinitehearts,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VipWidget(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        primary: Color.fromRGBO(83, 180, 81, 1),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        closeQuiz(context);
                      },
                      child: Text(
                        S.of(context).EndOfQuiz,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }).then((value) => setState(() {
          _isClickAds = false;
        }));
  }

  /// action back khi ấn back của điện thoại
  Future<bool> _onBackPressed() {
    return showDialogCloseQuiz();
  }

  ///Check các câu phải có 2 từ trở lên thì mới cho
  List<TalkDetailQuizModel> setListEnglish(List<TalkDetailQuizModel> listQuiz) {
    List<TalkDetailQuizModel> listNew = [];
    for (var item in listQuiz) {
      if (item.content!.split(' ').length >= 2) {
        listNew.add(item);
      }
    }
    return listNew;
  }

  @override
  void initState() {
    _listFill.clear();
    this.leverUser = widget.leverQuiz;
    _heart = Provider.of<CountHeartProvider>(context, listen: false).count;
    list10Quiz = setListEnglish(widget.listQuiz);
    unitProgress = double.parse((0.5 / (list10Quiz.length)).toStringAsFixed(2));

    this.isCenterProgress = false;
    var lang = Provider.of<LocaleProvider>(context, listen: false)
        .locale!
        .languageCode;
    checkDataFlowLever(this.leverUser, lang);

    player = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  ///
  /// Phần View hiển thị của toàn bộ game Qiz
  ///
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<LocaleProvider>(builder: (context, localeProvider, child) {
      String lang = localeProvider.locale!.languageCode;
      return WillPopScope(
        key: _scaffold,
        onWillPop: _onBackPressed,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              color: themeProvider.mode == ThemeMode.dark
                  ? Color.fromRGBO(24, 26, 33, 1)
                  : Colors.white,
              child: Column(
                children: [
                  _buildTopScreens(),
                  _buildCenterScreens(this.leverUser),
                  _buildBottomScreen(this.leverUser, lang)
                ],
              ),
            )),
      );
    });
  }

  /// View tính điểm Tim ,progress , hiển thị nghĩa từ của câu , view hướng dẫn.
  Widget _buildTopScreens() {
    var themeProvider = context.watch<ThemeProvider>();
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          _buildProgress(),
          Text(
            setTextToViewTop(),
            style: TextStyle(
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                fontFamily: 'Quicksand'),
          ),
          SizedBox(
            height: 10,
          ),
          _buildTranslateLanguage(),
          SizedBox(
            height: 10,
          ),
          (this.leverUser == 1 && this.progress < 0.5)
              ? SizedBox()
              : _buildHint()
        ],
      ),
    );
  }

  /// View Center các loại hình thức học, như ghi âm , điền từ , viết câu v.v.v...
  Widget _buildCenterScreens(int leverQuiz) {
    return Expanded(child: _checkWidgetLeverQuiz(leverQuiz));
  }

  ///check xem đang là lever bao nhiêu , để thực hiện bài học theo lever đó
  Widget _checkWidgetLeverQuiz(int leverQuiz) {
    switch (leverQuiz) {
      case 1:
        return _quizLever1Screen();
      case 2:
        return _quizLever2Screen();
      case 3:
        return _quizLever3Screen();
      case 4:
        return _quizLever4Screen();
      default:
        return Container();
    }
  }

  /// View Quiz lever1
  /// Nghe 10 câu tiếng anh đầu tiên , sau đó học các bài chọn từ điền vào câu
  Widget _quizLever1Screen() {
    return Container(
      child: (this.progress >= 0.5)
          ? _buildChooseTheWord(1)
          : _buildHearkenEnglish(),
    );
  }

  /// View Quiz lever2
  /// 50% đầu tiên chọn từ còn thiếu (chọn 1 từ )
  /// 20% tiếp theo điền từ còn thiếu vào câ (điền 1 từ)
  /// 30% tiếp theo là bài luyện nói . Nếu user không nói được thì sẽ chuyển thành bài chọn từ(chọn 1 từ)
  Widget _quizLever2Screen() {
    return Container(
      child: (this.progress >= 0.7)
          ? (this.isRecord == true)
              ? _buildRecord()
              : _buildChooseTheWord(1)
          : (this.progress < 0.5)
              ? _buildChooseTheWord(1)
              : _buildFillTheWord(2),
    );
  }

  /// View Quiz lever3
  /// 50% đầu tiên chọn từ còn thiếu (chọn 2 từ )
  /// 20% tiếp theo điền từ còn thiếu vào câ (điền 2 từ)
  /// 30% tiếp theo là bài luyện nói . Nếu user không nói được thì sẽ chuyển thành bài chọn từ(chọn 2 từ)
  Widget _quizLever3Screen() {
    return Container(
        child: (this.progress < 0.5)
            ? _buildChooseTheWord(3)
            : (this.progress < 0.7)
                ? _buildFillTheWord(3)
                : (this.isRecord == true)
                    ? _buildRecord()
                    : _buildChooseTheWord(3));
  }

  /// View Quiz lever4
  /// 15% đầu tiên viết lại câu tiếng anh
  /// 55% tiếp theo điền từ còn thiếu vào câ (điền 2 từ)
  /// 30% tiếp theo là bài luyện nói . Nếu user không nói được thì sẽ chuyển thành bài điền từ (điền 2 từ)
  Widget _quizLever4Screen() {
    return Container(
        child: (this.progress < 0.15)
            ? _buildRewriteTheSentence()
            : (this.progress < 0.7)
                ? _buildFillTheWord(4)
                : (this.isRecord == true)
                    ? _buildRecord()
                    : _buildFillTheWord(4));
  }

  /// View Bottom trả kết quả của quá trình làm bài , đúng hay sai.
  Widget _buildBottomScreen(int leverQuiz, String lang) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Stack(
          children: [
            isRefresh
                ? isRight
                    ? Container(
                        height: double.infinity,
                        color: Colors.blue[100],
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30.0, left: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        child: Center(
                                          child: Lottie.asset(
                                              'assets/new_ui/animation_lottie/tick_done.json',
                                              height: 50,
                                              repeat: false),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        S.of(context).dung_Roi,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700,
                                            decoration: TextDecoration.none,
                                            fontFamily: 'Quicksand'),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      )
                    : Container(
                        height: double.infinity,
                        color: Colors.red[100],
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.of(context).sai_Roi,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 23,
                                            fontWeight: FontWeight.w700,
                                            decoration: TextDecoration.none,
                                            fontFamily: 'Quicksand'),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            children: createTextSpansResult(
                                                this._textLanguageEnglish,
                                                this._textMainSentence,
                                                this._listMainResult)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      )
                : SizedBox(),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isRecord ? _buildNotRecord() : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      isRefresh
                          ? _buildButtomNext(lang)
                          : _buildButtomOk(leverQuiz, lang),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  /// View buttom Ok check câu trả lời hoặc next bài học
  Widget _buildButtomOk(int leverQuiz, String lang) {
    var themeProvider = context.watch<ThemeProvider>();
    return GestureDetector(
      onTap: () {
        if (leverQuiz == 1) {
          //10 câu nghe đầu tiền chỉ ấn next
          if (this.progress < 0.5) {
            if (getBoolMainSentence() == false) {
              closeQuiz(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GetRewarded()));
            }
            textLanguage(list10Quiz, lang);
            setProgress();
          }
          // xong 10 câu nghe thì chuyển sang hiển thị bài chọn từ  vào chỗ trống
          //isCenterProgress là điều kiện để không tự động sang câu mới khi check kết quả.
          if (this.progress >= 0.5 && this.isCenterProgress == false) {
            //nếu câu tiếp theo ko có từ main thì chỉ dừng ở bài nghe
            textChooseTheWord(list10Quiz, lang);
            if (getBoolMainSentence() == true) {
              this.isCenterProgress = true;
            } else {
              closeQuiz(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GetRewarded()));
            }
          }
          // check kết quả của bài chọn từ vào chỗ trống
          if (this.progress >= 0.5) {
            if (_listChooseTextSpanModel.isNotEmpty) {
              checkTheAnswer(leverQuiz);
            } else {
              closeQuiz(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GetRewarded()));
            }
          }
        } else if (leverQuiz == 2) {
          //10 câu đầu là chọn từ vào chỗ trống
          if (this.progress < 0.5) {
            checkTheAnswer(leverQuiz);
          }
          if (0.5 <= this.progress && this.progress < 0.7) {
            //check kết quả điền từ vào ô trống
            checkResultFill();
          }
          //check ghi âm
          if (this.progress >= 0.7) {
            //nếu không nghe được thì check chọn từ
            if (this.isRecord == false) {
              checkTheAnswer(leverQuiz);
            } else {
              // nếu nghe được thì check kết quả ghi âm
              checkResultRecord();
            }
          }
        } else if (leverQuiz == 3) {
          //check kết quả chọn từ vào ô trống
          if (this.progress < 0.5) {
            checkTheAnswer(leverQuiz);
          }
          //check kết quà điền vào ô trống
          if (0.5 <= this.progress && this.progress < 0.7) {
            checkResultFill();
          }
          //check ghi âm
          if (this.progress >= 0.7) {
            //nếu không nghe được thì check chọn từ
            if (this.isRecord == false) {
              checkTheAnswer(leverQuiz);
            } else {
              // nếu nghe được thì check kết quả ghi âm
              checkResultRecord();
            }
          }
        } else {
          //Check kết quả của lever 4
          if (this.progress < 0.15) {
            // check kết quả viết cả câu
            checkResultString();
          } else if (this.progress >= 0.15 && this.progress < 0.7) {
            //check kết quả điền câu
            checkResultFill();
          }
          //check ghi âm
          if (this.progress >= 0.7) {
            //nếu không nghe được thì check chọn từ
            if (this.isRecord == false) {
              checkResultFill();
            } else {
              // nếu nghe được thì check kết quả ghi âm
              checkResultRecord();
            }
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color:
              isReady ? Colors.indigoAccent : Color.fromRGBO(255, 255, 255, 0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: isReady ? Color.fromRGBO(255, 255, 255, 1) : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            "Ok",
            style: TextStyle(
                color: isReady ? Colors.white : Colors.grey,
                fontSize: 25,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
                fontFamily: 'Quicksand'),
          ),
        ),
      ),
    );
  }

  /// View click buttom "Tiếp theo"
  Widget _buildButtomNext(String lang) {
    return GestureDetector(
      onTap: () {
        //Nếu tim lớn hớn 0 thì mới chạy vào check
        if (_heart > 0 || (userData.isVip != 3 && userData.isVip != 0)) {
          // khi chưa hoàn thành được hết số câu hỏi
          if (this.progress < 1) {
            for (var item in _listFillTextSpanModel) {
              item.textController.clear();
            }
            if (this.countCenter >= 0.5 && _isFirstOpenCheer == false) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CheerQuiz()));
              _isFirstOpenCheer = true;
            }
            textChooseTheWord(list10Quiz, lang);
            myController.clear();
            _listMainResult.clear();

            if (this.leverUser == 2 && this.isRight) {
              if (this.progress == 0.45) {
                setProgress();
              }
              if (this.progress == 0.65) {
                this.isRecord = true;
                this._isOpenRecord = true;
                setProgress();
              }
            }
            if (this.leverUser == 3 && this.isRight) {
              if (this.progress == 0.45) {
                setProgress();
              }
              if (this.progress == 0.65) {
                this.isRecord = true;
                this._isOpenRecord = true;
                setProgress();
              }
            }
            if (this.leverUser == 4 && this.isRight) {
              if (this.progress == 0.1) {
                setProgress();
              }
              if (this.progress == 0.65) {
                this.isRecord = true;
                this._isOpenRecord = true;
                setProgress();
              }
            }
            _listCheckLever.clear();
            _listFill.clear();
            this.isRight = false;
            this.isRefresh = false;
          } else {
            //khi trả lời đúng hết số câu hỏi
            context.read<CountHeartProvider>().setCountHeart(_heart + 1);
            //trừ đá khi sai
            plusMinusHeart(ConfigHeart.quiz_video_cap_do_2);
            setState(() {
              this.progress = 0;
              this.leverUser =
                  (this.leverUser + 1 > 4) ? 5 : (this.leverUser + 1);
              this.isRefresh = false;
              this.isReady = false;
              closeQuiz(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GetRewarded()));
            });
          }
        } else {
          //show dialog hỏi ý kiến xem quảng cáo nhận tim
          showBottomDialog();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            color: this.isRight ? Colors.green : Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            S.of(context).tiep_Theo,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
                fontFamily: 'Quicksand'),
          ),
        ),
      ),
    );
  }

  ///View khi click vào hiện không nói được
  Widget _buildNotRecord() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            // khi user click không nói được thì ẩn bài học nói ,
            // và chuyển các trạng thái liên quan đến ghi âm về trạng thái default
            this.isRecord = false;
            this._isOpenRecord = false;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 40,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Text(S.of(context).hien_khong_noi_duoc,
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                    fontFamily: 'Quicksand')),
          ),
        ),
      ),
    );
  }

  /// view progress top
  Widget _buildProgress() {
    var themeProvider = context.watch<ThemeProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/quiz/diamond.svg'),
                SizedBox(
                  width: 5,
                ),
                Text(
                  (userData.isVip == 3 || userData.isVip == 0)
                      ? _heart.toString()
                      : '∞',
                  style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand'),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: 250,
              height: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: progress,
                  valueColor:
                      AlwaysStoppedAnimation<Color>((this.progress < 0.5)
                          ? Colors.deepOrange
                          : (this.progress < 0.8)
                              ? Colors.indigoAccent
                              : Color(0xff00ff00)),
                  backgroundColor: Color(0xffD6D6D6),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
                onTap: () {
                  showDialogCloseQuiz();
                },
                child: Icon(
                  Icons.close,
                  size: 30,
                )),
          ],
        ),
      ),
    );
  }

  ///View dịch câu tiếng anh sang tiếng local
  Widget _buildTranslateLanguage() {
    var themeProvider = context.watch<ThemeProvider>();
    var localProvider = context.watch<LocaleProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        decoration: BoxDecoration(
            border: Border.all(
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black26,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: (localProvider.locale!.languageCode == 'en')
                ? PhoLoading()
                : Text(
                    this.isRecord
                        ? this._textLanguageEnglish
                        : this._textLanguageLocal,
                    style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black.withOpacity(0.5),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        fontFamily: 'Quicksand'),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
          ),
        ),
      ),
    );
  }

  /// View gợi ý câu trả lời
  Widget _buildHint() {
    var themeProvider = context.watch<ThemeProvider>();
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //icon nghe lại câu
          ScaleTap(
            onPressed: () {
              readEnglish(this._textLanguageEnglish);
              setState(() {
                _isFinishedReading = true;
              });
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: _isFinishedReading
                  ? Lottie.asset(
                      'assets/new_ui/animation_lottie/anim_loa.json',
                      height: 20,
                    )
                  : Icon(
                      Icons.volume_up,
                      color: Colors.green,
                      size: 20,
                    ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          // buttom click hiển thị popup gợi ý
          GestureDetector(
            onTap: () {
              showMoreText(setTextHint());
            },
            child: Container(
                width: 100,
                height: 30,
                key: _key,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(S.of(context).hint,
                      style: TextStyle(
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontFamily: 'Quicksand')),
                )),
          ),
        ],
      ),
    );
  }

  /// Widget viết lại cả câu tiếng anh
  Widget _buildRewriteTheSentence() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: TextField(
          controller: myController,
          onChanged: (value) => {checkStringIsNull(value)},
          decoration: InputDecoration(
              hintText: S.of(context).hoan_thanh_cau_tren,
              hintStyle: TextStyle(fontSize: 16, color: Color(0xFFB3B1B1)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.green),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1)),
              fillColor: Colors.lightGreen),
          style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.none,
              fontFamily: 'Quicksand'),
          textAlign: TextAlign.start,
          maxLines: 2,
          cursorColor: Colors.green,
        ),
      ),
    );
  }

  /// Widget học nghe
  Widget _buildHearkenEnglish() {
    var themeProvider = context.watch<ThemeProvider>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              this._textLanguageEnglish,
              style: TextStyle(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                  fontFamily: 'Quicksand'),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ScaleTap(
            onPressed: () {
              readEnglish(this._textLanguageEnglish);
              setState(() {
                _isFinishedReading = true;
              });
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black54,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: _isFinishedReading
                  ? Lottie.asset(
                      'assets/new_ui/animation_lottie/anim_loa.json',
                      height: 50,
                    )
                  : Icon(
                      Icons.volume_up,
                      color: Colors.green,
                      size: 50,
                    ),
            ),
          )
        ],
      ),
    );
  }

  ///Widget điền từ vào ô trống
  Widget _buildFillTheWord(int lever) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
        child: RichText(
          text: TextSpan(
              children: createTextSpansFill(
                  this._textLanguageEnglish, this._textMainSentence, lever)),
        ),
      ),
    );
  }

  /// Widget chọn từ vào ô chống
  Widget _buildChooseTheWord(int lever) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
            child: RichText(
              text: TextSpan(
                  children: createTextSpans(this._textLanguageEnglish,
                      this._textMainSentence, lever)),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          _buildChoose(lever)
        ],
      ),
    );
  }

  /// danh sách các từ để chọn
  Widget _buildChoose(int lever) {
    return Center(
      child: Container(
        height: 60,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _listChooseModel.length,
            itemBuilder: (BuildContext context, int index) {
              var listRandomChoose =
                  context.watch<DialogProvider>().listRandomChoose;
              // Provider.of<DialogProvider>(context, listen: false)
              //     .listRandomChoose;
              return _buildItemChoose(listRandomChoose, index, lever);
            }),
      ),
    );
  }

  /// item text được chọn vào ô trống
  Widget _buildItemChoose(List<String> listChoose, int index, int lever) {
    var themeProvider = context.watch<ThemeProvider>();
    return GestureDetector(
      onTap: () {
        //item 1 đầu tiên
        if (index == 0) {
          //điều kiện nếu item chưa được chọn ,
          // và số từ hiện tại được phép điền vào câu chưa đến từ giới hạn của câu đó.
          if (_listChooseModel[index].isSelected == false &&
              _listCheckLever.length < lever) {
            setState(() {
              Provider.of<DialogProvider>(context, listen: false)
                  .setIndexFill(index);
              _textChoose1 = listChoose[index];
              if (!_listFill.contains(_textChoose1)) {
                if (_listFill.contains("")) {
                  _listFill[_listFill.indexOf("")] = _textChoose1;
                } else {
                  _listFill.add(_textChoose1);
                }
              }
              setReady();
              _listCheckLever.add(1);
              _listChooseModel[index].isSelected = true;
              _listChooseModel[index].title = _textChoose1;
              if (_textChoose2.isEmpty && _textChoose3.isEmpty) {
                isFillIndex1 = true;
              } else {
                isFillIndex2 = true;
              }
            });
          }
        }
        //item thứ 2
        else if (index == 1) {
          if (_listChooseModel[index].isSelected == false &&
              _listCheckLever.length < lever) {
            setState(() {
              Provider.of<DialogProvider>(context, listen: false)
                  .setIndexFill(index);
              _textChoose2 = listChoose[index];
              if (!_listFill.contains(_textChoose2)) {
                if (_listFill.contains("")) {
                  _listFill[_listFill.indexOf("")] = _textChoose2;
                } else {
                  _listFill.add(_textChoose2);
                }
              }
              setReady();
              _listCheckLever.add(1);
              _listChooseModel[index].isSelected = true;
              _listChooseModel[index].title = _textChoose2;
              if (_textChoose1.isEmpty && _textChoose3.isEmpty) {
                isFillIndex1 = true;
                isFillIndex3 = true;
              } else {
                isFillIndex2 = true;
              }
            });
          }
        }
        //item cuối cùng
        else {
          if (_listChooseModel[index].isSelected == false &&
              _listCheckLever.length < lever) {
            setState(() {
              _textChoose3 = listChoose[index];
              if (!_listFill.contains(_textChoose3)) {
                if (_listFill.contains("")) {
                  _listFill[_listFill.indexOf("")] = _textChoose3;
                } else {
                  _listFill.add(_textChoose3);
                }
              }
              setReady();
              _listCheckLever.add(1);
              _listChooseModel[index].isSelected = true;
              _listChooseModel[index].title = _textChoose3;
              if (_textChoose1.isEmpty && _textChoose2.isEmpty) {
                isFillIndex1 = true;
                isFillIndex2 = true;
              } else {
                isFillIndex3 = true;
              }
            });
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 10),
        width: calcTextSize(listChoose[index],
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
                .width +
            20,
        height: 40,
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black45,
                width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Opacity(
              opacity: (_listChooseModel[index].isSelected == true) ? 0 : 1,
              child: Text(
                listChoose[index],
                style: TextStyle(
                    fontSize: 20,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                    fontFamily: 'Quicksand'),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// View ghi âm
  Widget _buildRecord() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: Text(
              S.of(context).dat_dien_thoai_cua_ban_o_che_do_im_lang,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontFamily: 'Quicksand'),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _buildButtomRecord()
        ],
      ),
    );
  }

  ///Buttom ghi âm
  Widget _buildButtomRecord() {
    return GestureDetector(
      onTap: () async {
        if (!_speechEnabled) {
          //check xem đã có quyền micro chưa
          var checkPermission = await recorder.hasPermission();
          if (checkPermission) {
            _initSpeech();
            _speechToText.isNotListening ? _startListening() : _stopListening();
          }
        } else {
          _speechEnabled = false;
          _stopListening();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        width: MediaQuery.of(context).size.width,
        height: 130,
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: _speechEnabled
              ? _buildListen()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mic,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(S.of(context).cham_va_noi,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            fontFamily: 'Quicksand')),
                  ],
                ),
        ),
      ),
    );
  }

  ///View hiển thị khi chờ User nói
  Widget _buildListen() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/linh_vat/linhvat2.png',
          height: 50,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          S.of(context).my_fell_dang_nghe_ban_noi,
          style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              decoration: TextDecoration.none,
              fontFamily: 'Quicksand'),
          overflow: TextOverflow.visible,
          maxLines: 2,
          textAlign: TextAlign.left,
        ),
      ],
    ));
  }
}
