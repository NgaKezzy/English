import 'package:app_learn_english/Providers/dialog_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/ReviewTextData.dart';
import 'package:app_learn_english/models/TalkTextDetailModel.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/presentation/speak/widgets/button_icon_add_on_tap.dart';
import 'package:app_learn_english/presentation/speak/widgets/button_icon_mic.dart';
import 'package:app_learn_english/presentation/speak/widgets/button_icon_play.dart';
import 'package:app_learn_english/presentation/speak/widgets/button_item_record.dart';
import 'package:app_learn_english/presentation/speak/widgets/conversation_box.dart';
import 'package:app_learn_english/presentation/speak/widgets/conversation_box_item.dart';
import 'package:app_learn_english/presentation/speak/widgets/showMessageNotify.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ItemBuilderBox extends StatefulWidget {
  final int indexList;
  final List<TalkTextDetailModel> listTalk;
  final Function speak;
  final Function fnc;
  final ScrollController controller;
  final int indexNum;
  final TtsState ttsState;
  final int idUser;
  final Function autoPlay;
  final Function stopAuto;
  final Function stopTalking;
  final DataTextReview? dataTextReview;
  final bool checkBtnState;
  final Function setStateBtn;
  final bool isRoles;
  final Function updatePercentFnc;

  // final SoundRecoder recoder;
  // final SoundPlayer player;
  const ItemBuilderBox({
    Key? key,
    required this.indexList,
    required this.listTalk,
    required this.speak,
    required this.fnc,
    required this.controller,
    required this.indexNum,
    required this.ttsState,
    required this.idUser,
    required this.autoPlay,
    required this.stopAuto,
    required this.stopTalking,
    required this.dataTextReview,
    required this.checkBtnState,
    required this.setStateBtn,
    required this.isRoles,
    required this.updatePercentFnc,

    // required this.recoder,
    // required this.player,
  }) : super(key: key);
  @override
  _ItemBuilderBoxState createState() => _ItemBuilderBoxState();
}

class _ItemBuilderBoxState extends State<ItemBuilderBox> {
  // MẢNG CHỨA NHỮNG TỪ ĐỌC SAI
  List<String> _wrongWords = [];

  // CHECK XEM CÂU NÀY ĐÃ TỪNG NÓI HAY CHƯA NẾU NÓI RỒI SẼ TÍCH XANH Ở MIC PHẦN CÂU ĐÓ
  late bool checkTalk;

  // CHECK XEM CÂU NÀY ĐÃ NÓI CHÍNH XÁC HOÀN TOÀN HAY CHƯA
  late bool checkExactly;

  // CHECK XEM PHẦN NÀY ĐÃ ĐƯỢC GHI ÂM HAY CHƯA
  bool _isRecordedSound = true;
  final SpeechToText _speechToText = SpeechToText();

  String? path = '';

  void initSpeech() async {
    await _speechToText.initialize();
  }

  @override
  void initState() {
    checkTalk = false;
    checkExactly = false;
    // initSpeech();

    super.initState();
  }

  bool _isLoading = true;
  bool _isFirstUse = true;

  @override
  void didChangeDependencies() async {
    if (_isLoading) {
      initSpeech();
      var prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('isFirstUseSpeak')) {
        _isFirstUse = prefs.getBool('isFirstUseSpeak')!;
      } else {
        prefs.setBool('isFirstUseSpeak', _isFirstUse);
      }
      if (_isFirstUse) {
        Future.delayed(const Duration(seconds: 2), () {
          _tooltipController.showTooltip(immediately: false, autoClose: true);
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  // HÀM BẬT CHỨC NĂNG NHẬN DIỆN GIỌNG NÓI
  void _startListening(BuildContext context) async {
    _speechToText.listen(
        onResult: (SpeechRecognitionResult result) => {
              _onSpeechResult(result, context),
            },
        listenFor: Duration(seconds: 30));
  }

  // TẮT NHẬN DIỆN GIỌNG NÓI
  void _stopListening() async {
    await _speechToText.stop();
  }

  // HÀM TRẢ VỀ KẾT QUẢ KHI PHẦN VOICE RECOGNIZED NHẬN DIỆN GIỌNG NÓI THÀNH CÔNG SẼ NHẢY VÀO ĐÂY
  void _onSpeechResult(
      SpeechRecognitionResult result, BuildContext context) async {
    List<String> convertTextApi = widget
        .listTalk[widget.indexList].content // MẪU CÂU CHÍNH CẦN SO SÁNH
        .replaceAll(new RegExp(r'[!\?\.\,]+'),
            '') // REGULAR EXPRESSION LỌC CÁC KÝ TỰ ĐẶC BIỆT TRONG CÂU
        .toLowerCase()
        .trim()
        .split(' ');
    List<String> convertRecogizeWords = result
        .recognizedWords // CÂU ĐƯỢC NHẬN DIỆN
        .toLowerCase()
        .replaceAll(new RegExp(r'[!\?\.\,]+'),
            '') // REGULAR EXPRESSION LỌC CÁC KÝ TỰ ĐẶC BIỆT TRONG CÂU
        .trim()
        .split(' ');
    printRed(widget.listTalk[widget.indexList].content
        .replaceAll(new RegExp(r'[!\?\.\,]+'), '')
        .toLowerCase()
        .trim());
    printRed(result.recognizedWords
        .toLowerCase()
        .replaceAll(new RegExp(r'[!\?\.\,]+'), '')
        .trim());

    // SO SÁNH TỪ TỪ TRONG CÂU ĐƯƠC NHẬN DIỆN VỚI MẪU CÂU CHÍNH CẦN SO SÁNH NẾU TRUNG THÌ SẼ LOẠI BỎ TỪ ĐÓ RA KHỎI MẪU CÂU CHÍNH NHỮNG TỪ CÒN SÓT LẠI LÀ NHỮNG TỪ ĐỌC CHƯA ĐÚNG
    for (var i = 0; i < convertRecogizeWords.length; i++) {
      for (var j = 0; j < convertTextApi.length; j++) {
        if (convertRecogizeWords[i].compareTo(convertTextApi[j]) == 0) {
          convertTextApi.remove(convertRecogizeWords[i]);
          printCyan(convertTextApi.toString());
        }
      }
    }

    setState(() {
      _wrongWords =
          convertTextApi; // CÁC TỪ CÒN SÓT LẠI LÀ NHỮNG TỪ ĐỌC CHƯA ĐÚNG HOẶC CHƯA ĐỌC
    });
    if (convertTextApi.length == 0) {
      // NẾU MẢNG CHỨA CÁC TỪ CÒN SÓT LẠI CÓ ĐỘ DÀI BẰNG 0 THÌ CÂU NÀY HOÀN TOÀN NÓI ĐÚNG
      if (_speechToText.isNotListening) {
        // Navigator.pop(context);
        // var dialogProvider = context.read<DialogProvider>();
        // dialogProvider.setClickItem(false);
      }
      setState(() {
        checkExactly = true;
      });
    } else {
      if (_speechToText.isNotListening) {
        // var dialogProvider = context.read<DialogProvider>();
        // dialogProvider.setClickItem(false);
      }
    }

    setState(() {
      checkTalk = true;
    });
  }

  void setPath(String? pathCheck) {
    setState(() {
      path = pathCheck;
    });
  }

  // HÀM RENDER AVATAR NHÂN VẬT: NẾU ROLES = 1 THÌ LÀ PHẦN PRACTICE CÒN ROLES = 2 LÀ PHẦN HỘI THOẠI CHÍNH
  Widget _buildAvatarNhanVat(String avatarPath, int roles) {
    return Container(
      height: 45,
      width: 45,
      decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Stack(
        children: [
          Image.asset(
            avatarPath,
            width: 45,
            height: 45,
          ),
          (widget.ttsState == TtsState.playing &&
                  widget.indexNum == widget.indexList)
              ? Lottie.asset(
                  'assets/new_ui/animation_lottie/load_anim_tts.json',
                  height: 45,
                )
              : const SizedBox()
        ],
      ),
    );
  }

  // HÀM RENDER 1 BOX HỘI THOẠI GỒM CÓ: TÊN NHÂN VẬT, MẤU CÂU CHÍNH, SUB, VÀ CÁC BUTTON MIC, NGHE VÀ THÊM MẪU CÂU VÀO PHẦN ÔN TẬP
  Widget _buildBoxTalk(
    String tenNhanVat,
    String mauCauChinh,
    Widget iconAdd,
    Widget iconMic,
    int soThuTu,
    String subtitle,
    int key,
    String uid,
    String ttdid,
    int totalItem,
    int roles,
    Widget iconPlay,
    Widget iconRecord,
  ) {
    return Column(
      key: ValueKey(key),
      crossAxisAlignment: (roles == 1)
          ? (CrossAxisAlignment.start)
          : ((soThuTu % 2 == 0)
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end),
      children: [
        // Text(
        //   tenNhanVat,
        //   style:const TextStyle(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),

        ConversationBoxItem(
          listTalk: widget.listTalk,
          indexList: widget.indexList,
          wrongWords: _wrongWords,
          checkExactly: checkExactly,
          checkTalk: checkTalk,
          fnc: widget.fnc,
          controller: widget.controller,
          speak: widget.speak,
          mauCauChinh: mauCauChinh,
          soThuTu: soThuTu,
          subtitle: subtitle,
          key: ValueKey(key),
          ttsState: widget.ttsState,
          indexNum: widget.indexNum,
          checkIndex: key,
          uid: uid,
          ttdid: ttdid,
          totalItem: totalItem,
          stopAuto: widget.stopAuto,
          stopTalking: widget.stopTalking,
        ),
        Row(
          children: [
            iconAdd,
            iconMic,
            iconRecord,
            // iconPlay,
          ],
        ),
      ],
    );
  }

  // HÀM RENDER BAO GỒM AVATAR NHÂN VẬT, BOX CHỨA MẪU CÂU CHÍNH VÀ CÁC NÚT DỰA VÀO ROLES VÀ SÓ THỨ TỰ CỦA NGƯỜI NÓI ĐỂ RENDER RA GIAO DIỆN CỦA BOX NÓI THEO ĐÚNG HƯỚNG
  Widget _buildBoxSpeak(
    String tenNhanVat,
    String mauCauText,
    String avatarPath,
    Widget iconAdd,
    Widget iconMic,
    int soThuTu,
    String subtitle,
    int key,
    String uid,
    String ttdid,
    int totalItem,
    int roles,
    Widget iconPlay,
    Widget iconRecord,
  ) {
    return (roles == 1)
        ? Column(children: [
            Row(
              key: ValueKey(key),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildAvatarNhanVat(avatarPath, roles),
                _buildBoxTalk(
                  'Practice',
                  tenNhanVat,
                  iconAdd,
                  iconMic,
                  soThuTu,
                  subtitle,
                  key,
                  uid,
                  ttdid,
                  totalItem,
                  roles,
                  iconPlay,
                  iconRecord,
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
          ])
        : Column(children: [
            Row(
              key: ValueKey(key),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: (soThuTu % 2 == 0)
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                (soThuTu % 2 == 0)
                    ? _buildAvatarNhanVat(
                        'assets/new_ui/more/ic_splash.png', roles)
                    : _buildBoxTalk(
                        mauCauText,
                        tenNhanVat,
                        iconAdd,
                        iconMic,
                        soThuTu,
                        subtitle,
                        key,
                        uid,
                        ttdid,
                        totalItem,
                        roles,
                        iconPlay,
                        iconRecord,
                      ),
                const SizedBox(width: 10),
                (soThuTu % 2 == 0)
                    ? _buildBoxTalk(
                        mauCauText,
                        tenNhanVat,
                        iconAdd,
                        iconMic,
                        soThuTu,
                        subtitle,
                        key,
                        uid,
                        ttdid,
                        totalItem,
                        roles,
                        iconPlay,
                        iconRecord,
                      )
                    : _buildAvatarNhanVat(avatarPath, roles)
              ],
            ),
          ]);
  }

  // HÀM SỬ DỤNG ĐỂ CHECK KHI BẤM VÀO NÚT GHI ÂM THÌ SAU KHI GHI XONG SẼ HIỂN THỊ NÚT LẮNG NGHE
  void changeStateRecoder() {
    setState(() {
      _isRecordedSound = false;
    });
  }

  // SAU KHI THOÁT KHỎI MÀN HÌNH PHẦN NÀY CẦN CLEAR PHẦN RECODER VÀ PLAYER PHẦN GHI ÂM ĐỂ TRÁNH BỊ TRÀN
  @override
  void dispose() {
    super.dispose();
  }

  GlobalKey key = GlobalKey();
  final _tooltipController = JustTheController();

  Widget _buildToolTips() {
    if (_isFirstUse) {
      return widget.indexList == 0
          ? JustTheTooltip(
              controller: _tooltipController,
              showDuration: const Duration(seconds: 15),
              onDismiss: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('isFirstUseSpeak', false);
                setState(() {
                  _isFirstUse = false;
                });
              },
              child: ButtonIconAdd(
                // key: key,
                ttdid: widget.listTalk[widget.indexList].id.toString(),
                uid: widget.idUser,
                stopAuto: widget.stopAuto,
                dataTextReview: widget.dataTextReview,
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  S.of(context).ClickHereToAddSampleSentencesToTheReviewSection,
                ),
              ),
            )
          : ButtonIconAdd(
              // key: key,
              ttdid: widget.listTalk[widget.indexList].id.toString(),
              uid: widget.idUser,
              stopAuto: widget.stopAuto,
              dataTextReview: widget.dataTextReview,
            );
    }
    return ButtonIconAdd(
      // key: key,
      ttdid: widget.listTalk[widget.indexList].id.toString(),
      uid: widget.idUser,
      stopAuto: widget.stopAuto,
      dataTextReview: widget.dataTextReview,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const SizedBox()
        : Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
            String lang =
                provider.codeLangeSub ?? provider.locale!.languageCode;
            print('Đây là lang: $lang');
            return _buildBoxSpeak(
              widget.listTalk[widget.indexList].content,
              widget.listTalk[widget.indexList].author,
              'assets/new_ui/more/pho.png',
              _buildToolTips(),
              ButtonIconMic(
                speechToText: _speechToText,
                updatePercentFnc: widget.updatePercentFnc,
                changeStateRecoder: changeStateRecoder,
                pathSave: setPath,
                startListening: _startListening,
                stopListening: _stopListening,
                setStateBtn: widget.setStateBtn,
                checkBtnState: widget.checkBtnState,
                stopTalking: widget.stopTalking,
                stopAuto: widget.stopAuto,
                checkTalk: checkTalk,
                ctx: context,
                textApi: widget.listTalk[widget.indexList].content,
                listTalk: widget.listTalk,
                indexList: widget.indexList,
                titleSub:
                    Utils.checkSubSpeak(lang, widget.listTalk[widget.indexList])
                            .isEmpty
                        ? ''
                        : Utils.checkSubSpeak(
                            lang, widget.listTalk[widget.indexList]),
                titleContent: widget.listTalk[widget.indexList].content,

                // recoder: widget.recoder,
              ),
              widget.indexList,
              Utils.checkSubSpeak(lang, widget.listTalk[widget.indexList])
                      .isEmpty
                  ? ''
                  : Utils.checkSubSpeak(
                      lang, widget.listTalk[widget.indexList]),
              widget.indexList,
              // widget.listTalk![widget.indexList]['uid'],
              // widget.listTalk![widget.indexList]['ttdid'],
              "0",
              "0",
              widget.listTalk.length,
              widget.listTalk[widget.indexList].roles,
              ButtonIconPlay(
                isRecorder: _isRecordedSound,
                pathSave: path,
                // player: widget.player,
                stopAuto: widget.stopAuto,
                stopTalking: widget.stopTalking,
              ),
              ButtonItemRecord(
                changeStateRecorder: changeStateRecoder,
                setPath: setPath,
                stopAuto: widget.stopAuto,
                stopTalking: widget.stopTalking,
                titleSub:
                    Utils.checkSubSpeak(lang, widget.listTalk[widget.indexList])
                            .isEmpty
                        ? ''
                        : Utils.checkSubSpeak(
                            lang, widget.listTalk[widget.indexList]),
                titleContent: widget.listTalk[widget.indexList].content,
              ),
            );
          });
  }
}
