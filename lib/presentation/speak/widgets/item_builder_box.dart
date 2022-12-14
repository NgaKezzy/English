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
  // M???NG CH???A NH???NG T??? ?????C SAI
  List<String> _wrongWords = [];

  // CHECK XEM C??U N??Y ???? T???NG N??I HAY CH??A N???U N??I R???I S??? T??CH XANH ??? MIC PH???N C??U ????
  late bool checkTalk;

  // CHECK XEM C??U N??Y ???? N??I CH??NH X??C HO??N TO??N HAY CH??A
  late bool checkExactly;

  // CHECK XEM PH???N N??Y ???? ???????C GHI ??M HAY CH??A
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

  // H??M B???T CH???C N??NG NH???N DI???N GI???NG N??I
  void _startListening(BuildContext context) async {
    _speechToText.listen(
        onResult: (SpeechRecognitionResult result) => {
              _onSpeechResult(result, context),
            },
        listenFor: Duration(seconds: 30));
  }

  // T???T NH???N DI???N GI???NG N??I
  void _stopListening() async {
    await _speechToText.stop();
  }

  // H??M TR??? V??? K???T QU??? KHI PH???N VOICE RECOGNIZED NH???N DI???N GI???NG N??I TH??NH C??NG S??? NH???Y V??O ????Y
  void _onSpeechResult(
      SpeechRecognitionResult result, BuildContext context) async {
    List<String> convertTextApi = widget
        .listTalk[widget.indexList].content // M???U C??U CH??NH C???N SO S??NH
        .replaceAll(new RegExp(r'[!\?\.\,]+'),
            '') // REGULAR EXPRESSION L???C C??C K?? T??? ?????C BI???T TRONG C??U
        .toLowerCase()
        .trim()
        .split(' ');
    List<String> convertRecogizeWords = result
        .recognizedWords // C??U ???????C NH???N DI???N
        .toLowerCase()
        .replaceAll(new RegExp(r'[!\?\.\,]+'),
            '') // REGULAR EXPRESSION L???C C??C K?? T??? ?????C BI???T TRONG C??U
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

    // SO S??NH T??? T??? TRONG C??U ??????C NH???N DI???N V???I M???U C??U CH??NH C???N SO S??NH N???U TRUNG TH?? S??? LO???I B??? T??? ???? RA KH???I M???U C??U CH??NH NH???NG T??? C??N S??T L???I L?? NH???NG T??? ?????C CH??A ????NG
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
          convertTextApi; // C??C T??? C??N S??T L???I L?? NH???NG T??? ?????C CH??A ????NG HO???C CH??A ?????C
    });
    if (convertTextApi.length == 0) {
      // N???U M???NG CH???A C??C T??? C??N S??T L???I C?? ????? D??I B???NG 0 TH?? C??U N??Y HO??N TO??N N??I ????NG
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

  // H??M RENDER AVATAR NH??N V???T: N???U ROLES = 1 TH?? L?? PH???N PRACTICE C??N ROLES = 2 L?? PH???N H???I THO???I CH??NH
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

  // H??M RENDER 1 BOX H???I THO???I G???M C??: T??N NH??N V???T, M???U C??U CH??NH, SUB, V?? C??C BUTTON MIC, NGHE V?? TH??M M???U C??U V??O PH???N ??N T???P
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

  // H??M RENDER BAO G???M AVATAR NH??N V???T, BOX CH???A M???U C??U CH??NH V?? C??C N??T D???A V??O ROLES V?? S?? TH??? T??? C???A NG?????I N??I ????? RENDER RA GIAO DI???N C???A BOX N??I THEO ????NG H?????NG
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

  // H??M S??? D???NG ????? CHECK KHI B???M V??O N??T GHI ??M TH?? SAU KHI GHI XONG S??? HI???N TH??? N??T L???NG NGHE
  void changeStateRecoder() {
    setState(() {
      _isRecordedSound = false;
    });
  }

  // SAU KHI THO??T KH???I M??N H??NH PH???N N??Y C???N CLEAR PH???N RECODER V?? PLAYER PH???N GHI ??M ????? TR??NH B??? TR??N
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
            print('????y l?? lang: $lang');
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
