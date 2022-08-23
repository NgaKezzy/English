import 'dart:io';

import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/model_local/TalkTextCacheModel.dart';
import 'package:app_learn_english/models/ReviewTextData.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/speak/widgets/item_builder_box.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:flutter/material.dart';

import '../screen/main_speak_screen.dart';
import '../widgets/loading_circle.dart';

enum CheckVoiceState {
  Right,
  Wrong,
  NotRecognized,
}

class ConversationBox extends StatefulWidget {
  final TtsState ttsState;
  final Function speak;
  final Function autoPlay;
  final String idTalkText;
  final int indexNum;
  final BuildContext ctx;
  final Function fnc;
  final BtnState stateBtn;
  final Function stopAuto;
  final Function stopTalking;
  final BtnState repeatBtn;
  final Function repeatSentence;
  final DataUser dataUser;
  final BuildContext context;
  final Function updatePercentFnc;

  ConversationBox({
    Key? key,
    required this.ttsState,
    required this.speak,
    required this.autoPlay,
    required this.idTalkText,
    required this.indexNum,
    required this.ctx,
    required this.fnc,
    required this.stateBtn,
    required this.stopAuto,
    required this.stopTalking,
    required this.dataUser,
    required this.repeatBtn,
    required this.repeatSentence,
    required this.context,
    required this.updatePercentFnc,
  }) : super(key: key);

  @override
  _ConversationBoxState createState() => _ConversationBoxState();
}

class _ConversationBoxState extends State<ConversationBox> {
  bool isLoadingData = true;
  bool addBtnState = false;
  bool checkStateBtn = false;
  var _controller = ScrollController();
  bool checkRoles = true;

  // var listTalk;
  TalkTextCacheModel? talkTextFullData;
  late DataTextReview? dataTextReview;

  late bool _speechEnabled;

  // final SpeechToText _speechToText = SpeechToText();

  // KHỞI TẠO PHẦN GHI ÂM
  // SoundRecoder recoder = SoundRecoder();

  // KHỞI TẠO PHẦN PLAYER KHI ĐÃ GHI ÂM XONG
  // SoundPlayer player = SoundPlayer();

  // void runSpeech() async {
  //   _speechEnabled = await _speechToText.initialize();
  //     onError: (_) {
  //   print("Chạy từ đây vào này");
  //   showModalBottomSheet(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(10),
  //         topRight: Radius.circular(10),
  //       ),
  //     ),
  //     elevation: 10,
  //     context: context,
  //     builder: (context) => ShowMessageNotify(
  //       message: S.of(context).VoiceNotRecognizedPleaseTryAgain,
  //       stateVoice: CheckVoiceState.NotRecognized,
  //       speechToText: _speechToText,
  //     ),
  //   );
  // });
  // }

  @override
  void initState() {
    // runSpeech();
    // player.init();
    // recoder.init();
    super.initState();
  }

  void changeBtnStateFnc(bool stateBtn) {
    setState(() {
      checkStateBtn = stateBtn;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isLoadingData) {
      // listTalk = await TextTalkDetail().getTalkTextId(widget.idTalkText);
      talkTextFullData =
          await DataCache().getTalkTextDetailByIdInCache(widget.idTalkText);

      dataTextReview =
          await TalkAPIs().fetchReviewTextData(userData: widget.dataUser);
      setState(() {
        isLoadingData = false;
      });
    }
  }

  @override
  void dispose() {
    // player.dispose();
    // recoder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        Duration(
          seconds: 0,
        ), () {
      if (!isLoadingData && widget.stateBtn == BtnState.play) {
        widget.autoPlay(talkTextFullData!.getListSub());
        if (widget.indexNum >= 4 && widget.indexNum % 4 == 0)
          widget.fnc(widget.indexNum, _controller);
      }
      if (!isLoadingData && widget.repeatBtn == BtnState.play) {
        widget.repeatSentence();
      }
    });
    return isLoadingData
        ? const Center(child: PhoLoading())
        : (talkTextFullData!.getListSub().length > 0)
            ? ListView.builder(
                controller: _controller,
                itemBuilder: (ctx, index) {
                  return ItemBuilderBox(
                    // player: player,
                    // recoder: recoder,
                    // speechToText: _speechToText,
                    isRoles: checkRoles,
                    setStateBtn: changeBtnStateFnc,
                    checkBtnState: checkStateBtn,
                    stopTalking: widget.stopTalking,
                    stopAuto: widget.stopAuto,
                    listTalk: talkTextFullData!.getListSub(),
                    indexList: index,
                    speak: widget.speak,
                    fnc: widget.fnc,
                    controller: _controller,
                    indexNum: widget.indexNum,
                    ttsState: widget.ttsState,
                    idUser: widget.dataUser.uid,
                    autoPlay: widget.autoPlay,
                    dataTextReview: dataTextReview,
                    updatePercentFnc: widget.updatePercentFnc,
                  );
                },
                itemCount: talkTextFullData!.getListSub().length,
              )
            : Center(
                child: Column(
                  children: [
                    const PhoLoading(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).hien_chua_co_hoi_thoai_nao,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontSize: 20),
                    )
                  ],
                ),
              );
  }
}
