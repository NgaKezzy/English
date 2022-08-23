import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
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

class ReviewQuizScreen extends StatefulWidget {
  final int leverQuiz;
  final List<TalkDetailQuizModel> listQuiz;
  final AdmobHelper admobHelper;

  const ReviewQuizScreen(
      {Key? key, required this.leverQuiz, required this.listQuiz, required this.admobHelper})
      : super(key: key);

  @override
  State<ReviewQuizScreen> createState() => _ReviewQuizScreenState();
}

class _ReviewQuizScreenState extends State<ReviewQuizScreen> {
  late AudioPlayer player;
  final _random = new Random();
  final myController = TextEditingController();
  final _key = GlobalKey();
  late List<TalkDetailQuizModel> list10Quiz;
  late List<TalkDetailQuizModel> listFirstQuiz;
  late List<ChooseModel> _listChooseModel;
  late List<ChooseModel> _listChooseTextSpanModel;
  late List<FillTextControllerModer> _listFillTextSpanModel;
  late int leverUser;

  SpeechToText _speechToText = SpeechToText();
  DataUser userData = DataCache().getUserData();

  List<String> _listFill = [];
  List<String> _listCheckQuiz = [];
  List<int> _listIndexTextChoose = [];
  List<int> _listCheckLever = [];
  List<String> _listMainResult = [];
  List<WrongSentenceModel> _listWrongSentence = [];

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
  int indexSentence = 0;

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
  bool _isClickOk = false;

  String _textChoose1 = "";
  String _textChoose2 = "";
  String _textChoose3 = "";
  String _stringRecord = "";
  String _stringTitle = "";
  String _stringFileLottie = "";


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
      title = S
          .of(context)
          .noi_cau_duoi_day;
    } else {
      if (this.leverUser == 1 && this.progress < 0.5) {
        title = S
            .of(context)
            .xem_cau_truc_va_y_nghia;
      } else {
        title = S
            .of(context)
            .hoan_thanh_cau_sau;
      }
    }
    return title;
  }

  /// fun show Hint
  void showMoreText(String text) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: text,
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Quicksand'),
        height: 150,
        width: MediaQuery
            .of(context)
            .size
            .width - 50,
        backgroundColor: Colors.green[300],
        padding:
        const EdgeInsets.only(top: 8.0, left: 10, right: 30, bottom: 5),
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
          int i = (count >= listQuiz.length - 2) ? 1 : count + 1;
          var _listRandom = [
            'gotta ',
            'mistakes',
            'different ',
            'sleepy',
            'master',
            'stable'
          ];

          var element = _listRandom[_random.nextInt(_listRandom.length)];

          //Check xem cuối main có dấu ',' hay không
          if (listQuiz[count]
              .mainSentence![listQuiz[count].mainSentence!.length - 1] == ",") {
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
              this._textMainSentence = this._textMainSentence
                  .substring(0, this._textMainSentence.length - 1);
            }
          }

          if (this._textMainSentence
              .split(",")
              .length < 3) {
            var textMain2 = listQuiz[i].mainSentence;
            //nếu không đủ từ main thì dừng lại bài học,nếu đủ main thì tiếp tục học
            if (textMain2!.length > 0) {
              if (textMain2[textMain2.length - 1] == ",") {
                textMain2 = textMain2.substring(0, textMain2.length - 1);
              }
              var _listRandom2 = [
                'dance ',
                'there’s ',
                'watching ',
                'people ',
                'same',
                'forget'
              ];
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
          this._textLanguageEnglish
              .split(" ")
              .length,
              (index) => ChooseModel(""));

      //tạo một mảng chứa các string  khi  người dùng điền từ vào ô trống
      _listFillTextSpanModel = List.generate(
          this._textLanguageEnglish
              .split(" ")
              .length,
              (index) =>
              FillTextControllerModer("", index, TextEditingController()));
      this.isReady = false;
      this.count++;
      if (count == listQuiz.length) {
        this.count = 1;
      }
    }
  }

  /// tính kích thước with height của một chuỗi String.
  Size calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance!.window.textScaleFactor,
    )
      ..layout();
    return textPainter.size;
  }

  /// tăng progress khi hoàn thành một câu trong bài ôn tập
  void setProgress() {
    setState(() {
      this.progress =
          double.parse((progress + unitProgress).toStringAsFixed(2));
      print('Progress:${progress}');
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
            Provider
                .of<DialogProvider>(context, listen: false)
                .isRight;
        if (this.isRight) {
          if (this.leverUser == 1) {
            this.countCenter++;
            setProgress();
          } else if (this.leverUser == 2) {
            _isClickOk = true;
            getRandomLottieQuizRight();
            setProgress();
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
          setState(() {
            _isClickOk = true;
            getRandomLottieQuizWrong();
          });
          if (!_listWrongSentence.contains(WrongSentenceModel(
              this._textLanguageEnglish, this._textMainSentence))) {
            _listWrongSentence.add(WrongSentenceModel(
                this._textLanguageEnglish, this._textMainSentence));
          }
          player.setAsset('assets/audio/tlsai.mp3');
          player.play();
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
            Provider
                .of<DialogProvider>(context, listen: false)
                .isRight;
        this.indexSentence = this.indexSentence++;
        if (this.isRight) {
          this.countCenter++;
          _isClickOk = true;
          getRandomLottieQuizRight();
          setProgress();
          player.setAsset('assets/audio/dung.mp3');
          player.play();
        } else {
          _isClickOk = true;
          getRandomLottieQuizWrong();
          player.setAsset('assets/audio/tlsai.mp3');
          player.play();
          // if (userData.isVip == 3 || userData.isVip == 0) {
          //   if (_heart > 0) {
          //     _heart = _heart - 1;
          //   }
          //   context.read<CountHeartProvider>().setCountHeart(_heart);
          //   //trừ đá khi sai
          //   plusMinusHeart(ConfigHeart.quiz_video_tru_tim);
          // }
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
  String? changeLanguage(String languageCode, int index,
      List<TalkDetailQuizModel> listQuiz) {
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
  List<TextSpan> createTextSpans(String texEnglish, String mainSentence,
      int lever) {
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
      bool check = Provider
          .of<DialogProvider>(context, listen: false)
          .isCheck;

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
                        fontSize: 16,
                        fontWeight: FontWeight.w600))
                    .width +
                    16,
                height: 40,
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: (_listChooseTextSpanModel[index].isSelected ==
                        true)
                        ? Colors.green
                        : Colors.white,
                    border: Border.all(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : ColorsUtils.Color_64D4DF,
                        width: 1),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _listChooseTextSpanModel[index].title,
                      style: const TextStyle(
                          fontSize: 16,
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
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                text,
                style: TextStyle(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                    fontFamily: 'Roboto'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const TextSpan(text: " ")
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
  List<TextSpan> createTextSpansFill(String texEnglish, String mainSentence,
      int lever) {
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
      bool check = Provider
          .of<DialogProvider>(context, listen: false)
          .isCheck;
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
                      const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700))
                      .width +
                      30,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : ColorsUtils.Color_64D4DF,
                          width: 1),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(15))),
                  child: Container(
                    child: TextField(
                        controller:
                        _listFillTextSpanModel[index].textController,
                        onChanged: (value) =>
                        {
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
              padding: const EdgeInsets.only(bottom: 15),
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
          const TextSpan(text: " ")
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
  List<TextSpan> createTextSpansResult(String texEnglish, String mainSentence,
      List<String> arrayMainSentence) {
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

      bool check = Provider
          .of<DialogProvider>(context, listen: false)
          .isCheck;

      Provider.of<DialogProvider>(context, listen: false)
          .checkResultError(textLanguage, textCheck);

      bool checkResult =
          Provider
              .of<DialogProvider>(context, listen: false)
              .isResult;

      final span = _isOpenRecord
          ? TextSpan(
        text: "",
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
                color: checkResult ? Colors.black : Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                fontFamily: 'Quicksand'),
          ),
          const TextSpan(text: " ")
        ],
      )
          : TextSpan(
        text: "",
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
                color: check ? Colors.blue : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                fontFamily: 'Quicksand'),
          ),
          const TextSpan(text: " ")
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

  ///Api call add thêm kim cương
  plusMinusHeart(int typeAction) async {
    await UserAPIs().addAndDivHeart(
      username: DataCache()
          .getUserData()
          .username,
      uid: DataCache()
          .getUserData()
          .uid,
      typeAction: typeAction,
    );
  }

  ///call back ads
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
      username: DataCache()
          .getUserData()
          .username,
      uid: DataCache()
          .getUserData()
          .uid,
      typeAction: ConfigHeart.nhan_tim_tu_admob_cong_tim,
    );
    heartProvider.setCountHeart(numberHeart);
    // Navigator.pop(context, numberHeart);
  }

  ///show ads
  void showAds(BuildContext context) {
    AdsController().showAdsCallback(adsCallback, context);
  }


  ///Show dialog hỏi ý kiến khi hết tim
  void showBottomDialog() {
    showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 420,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Lottie.asset(
                          'assets/new_ui/animation_lottie/diamond.json',
                          height: 150,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      S
                          .of(context)
                          .OutOfDiamonds + ' !',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
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
                                  const Spacer(),
                                  Container(
                                      child: Image.asset(
                                        'assets/quiz/icon_ad.png',
                                      )),
                                  const Spacer(),
                                  Text(
                                    S
                                        .of(context)
                                        .Watchadstogetmorehearts,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            _isClickAds
                                ? const Center(
                              // child: CircularProgressIndicator(),
                              child: PhoLoading(),
                            )
                                : const SizedBox()
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
                        primary: const Color.fromRGBO(83, 180, 81, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Container(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text(
                              S
                                  .of(context)
                                  .Tryusinginfinitehearts,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
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
                        primary: const Color.fromRGBO(83, 180, 81, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        closeQuiz(context);
                      },
                      child: Text(
                        S
                            .of(context)
                            .EndOfQuiz,
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
        }).then((value) =>
        setState(() {
          _isClickAds = false;
        }));
  }


  setListQuiz() {
    if (listFirstQuiz.length >= 6 && list10Quiz.length == 3) {
      list10Quiz = listFirstQuiz.take(6).toList();
    } else if (listFirstQuiz.length == 9 && list10Quiz.length == 6) {
      list10Quiz = listFirstQuiz.take(9).toList();
    } else if (listFirstQuiz.length == 9 && list10Quiz.length == 9) {
      list10Quiz = listFirstQuiz.take(9).toList();
    }
    unitProgress = double.parse((0.5 / (list10Quiz.length)).toStringAsFixed(2));
  }

  String setStringButtomQuiz() {
    String name = '';
    if (listFirstQuiz.length >= 6 && list10Quiz.length == 3) {
      name = 'Quiz level 2';
    } else if (listFirstQuiz.length == 9 && list10Quiz.length == 6) {
      name = 'Quiz level 3';
    } else if (listFirstQuiz.length == 9 && list10Quiz.length == 9) {
      name = 'Quiz level 3';
    } else {
      name = S
          .of(context)
          .quiz_lai;
    }

    return name;
  }

  getRandomLottieQuizRight() {
    var listLottie = Utils().setListLottieQuizRight(context);
    var element = listLottie[_random.nextInt(listLottie.length)];
    _stringFileLottie = element.lottie;
    _stringTitle = element.title;
  }

  getRandomLottieQuizWrong() {
    var listLottie = Utils().setListLottieQuizWrong(context);
    var element = listLottie[_random.nextInt(listLottie.length)];
    _stringFileLottie = element.lottie;
    _stringTitle = element.title;
  }

  ///Check các câu phải có 2 từ trở lên thì mới cho
  List<TalkDetailQuizModel> setListEnglish(List<TalkDetailQuizModel> listQuiz) {
    List<TalkDetailQuizModel> listNew = [];
    List<TalkDetailQuizModel> listNewCheckLevel = [];

    for (var item in listQuiz) {
      if (item.content!.split(' ').length >= 2) {
        if (item.mainSentence!.isNotEmpty) {
          listNew.add(item);
        }
      }
    }
    var length = listNew.length;
    if (length >= 9) {
      listNewCheckLevel = listNew.take(9).toList();
    } else if (length >= 6 && length <= 8) {
      listNewCheckLevel = listNew.take(6).toList();
    } else if (length >= 3 && length <= 5) {
      listNewCheckLevel = listNew.take(3).toList();
    }
    return listNewCheckLevel;
  }

  @override
  void initState() {
    _listFill.clear();
    this.leverUser = widget.leverQuiz;
    _heart = Provider
        .of<CountHeartProvider>(context, listen: false)
        .count;
    listFirstQuiz = setListEnglish(widget.listQuiz);
    list10Quiz = listFirstQuiz.take(3).toList();
    unitProgress =
        double.parse((0.5 / (list10Quiz.length * 2)).toStringAsFixed(2));

    this.isCenterProgress = false;
    var lang = Provider
        .of<LocaleProvider>(context, listen: false)
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
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: themeProvider.mode == ThemeMode.dark
                ? const Color.fromRGBO(24, 26, 33, 1)
                : Colors.white,
            child: (_isFirstOpenCheer == false)
                ? (this._textMainSentence.isNotEmpty)
                ? Column(
              children: [
                _buildTopScreens(),
                _buildCenterScreens(this.leverUser),
                _buildBottomScreen(this.leverUser, lang)
              ],
            )
                : _buildNotLeaning()
                : _buildDoneQuiz(),
          ));
    });
  }

  ///View show khi quiz xong
  Widget _buildDoneQuiz() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S
                .of(context)
                .ban_da_dat_dc,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontFamily: 'Roboto'),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '${((progress * 100).ceil() > 100) ? 100 : ((progress * 100)
                .ceil())}%',
            style: const TextStyle(
                color: ColorsUtils.Color_7D81ED,
                fontSize: 30,
                fontFamily: 'Roboto'),
          ),
          Container(
            width: 200,
            height: 200,
            child: Lottie.asset(
                'assets/new_ui/animation_lottie/end_quiz.json'),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                setListQuiz();
                progress = 0;
                _isFirstOpenCheer = false;
              });
            },
            child: Container(
                width: 200,
                height: 40,
                decoration: const BoxDecoration(
                    color: ColorsUtils.Color_7D81ED,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                    child: Text(
                      setStringButtomQuiz(),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ))),
          )
        ],
      ),
    );
  }

  ///View không có bài học nào
  Widget _buildNotLeaning() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const PhoLoading(),
          Text(
            S
                .of(context)
                .ThereAreCurrentlyNo,
            style: const TextStyle(color: Colors.black, fontFamily: 'Roboto'),
          )
        ],
      ),
    );
  }

  /// View tính điểm Tim ,progress , hiển thị nghĩa từ của câu , view hướng dẫn.
  Widget _buildTopScreens() {
    return Align(
      alignment: Alignment.topCenter,
      child: Center(child: _buildTranslateLanguage()),
    );
  }

  /// View Center các loại hình thức học, như ghi âm , điền từ , viết câu v.v.v...
  Widget _buildCenterScreens(int leverQuiz) {
    return Expanded(
        child: Stack(children: [
          _checkWidgetLeverQuiz(leverQuiz),
          (_isClickOk == true)
              ? Align(
            alignment: Alignment.bottomRight,
            child: _buildLoteAnimation(),
          )
              : const SizedBox()
        ]));
  }

  Widget _buildLoteAnimation() {
    return Container(
      width: 200,
      height: 200,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Lottie.asset(
            _stringFileLottie,
          ),
        ),
      ),
    );
  }

  ///check xem đang là lever bao nhiêu , để thực hiện bài học theo lever đó
  Widget _checkWidgetLeverQuiz(int leverQuiz) {
    switch (leverQuiz) {
      case 1:
        return _quizLever1Screen();
      case 2:
        return _quizLever2Screen();
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
      child: (this.indexSentence < list10Quiz.length)
          ? _buildChooseTheWord(1)
          : _buildFillTheWord(2),
    );
  }


  /// View Bottom trả kết quả của quá trình làm bài , đúng hay sai.
  Widget _buildBottomScreen(int leverQuiz, String lang) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.18,
        child: Stack(
          children: [
            isRefresh
                ? isRight
                ? Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius:
                  const BorderRadius.all(Radius.circular(8))),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 5.0, left: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: Lottie.asset(
                                    'assets/new_ui/animation_lottie/tick_done.json',
                                    height: 40,
                                    repeat: false),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              _stringTitle,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
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
              decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius:
                  const BorderRadius.all(Radius.circular(8))),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 5.0, left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              _stringTitle,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Quicksand'),
                            ),
                            const SizedBox(
                              height: 5,
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
                : Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _viewRead(),
                  _buildHint()
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isRecord ? _buildNotRecord() : const SizedBox(),
                      const SizedBox(
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
    return GestureDetector(
      onTap: () {
        if (leverQuiz == 2) {
          //10 câu đầu là chọn từ vào chỗ trống
          if (this.indexSentence < list10Quiz.length) {
            checkTheAnswer(leverQuiz);
          }
          if (this.indexSentence >= list10Quiz.length) {
            //check kết quả điền từ vào ô trống
            checkResultFill();
          }
        }
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 50,
        decoration: BoxDecoration(
          color: isReady
              ? Colors.indigoAccent
              : const Color.fromRGBO(255, 255, 255, 0),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color:
            isReady ? const Color.fromRGBO(255, 255, 255, 1) : Colors.grey,
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
        // khi chưa hoàn thành được hết số câu hỏi
        if (this.indexSentence < (list10Quiz.length * 2) - 1) {
          for (var item in _listFillTextSpanModel) {
            item.textController.clear();
          }
          this.indexSentence = this.indexSentence + 1;
          _isClickOk = false;
          myController.clear();
          _listMainResult.clear();
          _listCheckLever.clear();
          _listFill.clear();
          this.isRight = false;
          this.isRefresh = false;
          textChooseTheWord(list10Quiz, lang);
          setState(() {});
        } else {
          //khi trả lời đúng hết số câu hỏi
          _listFill.clear();
          _isClickOk = false;
          isRefresh = false;
          isReady = false;
          indexSentence = 0;
          count = 0;
          widget.admobHelper.showAdsAddDiamond(adsCallback, context);
          widget.admobHelper.showRewaredGameHasCallback(adsCallback, context);
          printBlue('show ads');
          setState(() {
            _isFirstOpenCheer = true;
          });
        }
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 50,
        decoration: BoxDecoration(
            color: this.isRight ? Colors.green : Colors.red,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            S
                .of(context)
                .tiep_Theo,
            style: const TextStyle(
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
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 40,
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Text(S
                .of(context)
                .hien_khong_noi_duoc,
                style: const TextStyle(
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

  ///View dịch câu tiếng anh sang tiếng local
  Widget _buildTranslateLanguage() {
    var themeProvider = context.watch<ThemeProvider>();
    var localProvider = context.watch<LocaleProvider>();
    return Container(
      key: _key,
      constraints: BoxConstraints(maxWidth: MediaQuery
          .of(context)
          .size
          .width * 0.85),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: (localProvider.locale!.languageCode == 'en')
              ? const PhoLoading()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.65,
                    height: 8,
                    child: ClipRRect(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: progress,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.indigoAccent),
                        backgroundColor: const Color(0xffD6D6D6),
                      ),
                    ),
                  ),
                  _viewDiamond()

                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                this.isRecord
                    ? this._textLanguageEnglish
                    : this._textLanguageLocal,
                style: TextStyle(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                    fontFamily: 'Quicksand'),
                textAlign: TextAlign.center,
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///View kim cương
  Widget _viewDiamond() {
    return Row(
      children: [
        Consumer<CountHeartProvider>(
            builder: (context, countHeartProvider, child) {
              return Text(
                '+${countHeartProvider.count}', style: TextStyle(color: Colors.black, fontSize: 14),);
            }),
        SizedBox(width: 5,),
        SvgPicture.asset('assets/quiz/diamond.svg'),
      ],
    );
  }

  Widget _viewRead() {
    return Align(
      alignment: Alignment.topLeft,
      child: ScaleTap(
        onPressed: () {
          setState(() {
            _isFinishedReading = true;
          });
          readEnglish(this._textLanguageEnglish);
        },
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: _isFinishedReading
              ? Lottie.asset(
            'assets/new_ui/animation_lottie/anim_loa.json',
            height: 20,
          )
              : const Icon(
            Icons.volume_up,
            color: Colors.green,
            size: 20,
          ),
        ),
      ),
    );
  }

  /// View gợi ý câu trả lời
  Widget _buildHint() {
    return GestureDetector(
      onTap: () {
        showMoreText(setTextHint());
      },
      child: Container(
          width: 35,
          height: 35,
          child: SvgPicture.asset(
            'assets/new_ui/more/goi_y.svg',
            height: 35,
          )),
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
          const SizedBox(
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
                  : const Icon(
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
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: RichText(
              text: TextSpan(
                  children: createTextSpans(this._textLanguageEnglish,
                      this._textMainSentence, lever)),
            ),
          ),
          const SizedBox(
            height: 30,
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
        height: 40,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _listChooseModel.length,
            itemBuilder: (BuildContext context, int index) {
              var listRandomChoose =
                  context
                      .watch<DialogProvider>()
                      .listRandomChoose;

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
            Provider.of<DialogProvider>(context, listen: false)
                .setIndexFill(index);
            setState(() {
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
            Provider.of<DialogProvider>(context, listen: false)
                .setIndexFill(index);

            setState(() {
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
        margin: const EdgeInsets.only(left: 10),
        width: calcTextSize(listChoose[index],
            TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
            .width +
            20,
        height: 30,
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : ColorsUtils.Color_64D4DF,
                width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Opacity(
              opacity: (_listChooseModel[index].isSelected == true) ? 0 : 1,
              child: Text(
                listChoose[index],
                style: TextStyle(
                    fontSize: 16,
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


}
