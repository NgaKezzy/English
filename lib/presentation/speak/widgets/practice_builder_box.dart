import 'package:app_learn_english/model_local/TalkTextCacheModel.dart';
import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/presentation/speak/widgets/practice_box_item.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PracticeBuilderBox extends StatefulWidget {
  final Function setIndexAuto;
  final List<bool> checkExactly;
  final List<bool> checkTalk;
  final TtsState ttsState;
  final int indexAuto;
  final List<List<String>> wrongWords;
  final TalkTextCacheModel talkTextFullData;
  final int index;

  PracticeBuilderBox({
    Key? key,
    required this.setIndexAuto,
    required this.checkExactly,
    required this.checkTalk,
    required this.ttsState,
    required this.indexAuto,
    required this.wrongWords,
    required this.talkTextFullData,
    required this.index,
  }) : super(key: key);

  @override
  _PracticeBuilderBoxState createState() => _PracticeBuilderBoxState();
}

class _PracticeBuilderBoxState extends State<PracticeBuilderBox> {
  late List<String> wrongWordNew = [];
  late bool checkExactlyNew = false;
  late bool checkTalkNew = false;

  Widget _buildAvatarNhanVat(String avatarPath, bool av1) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
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
                  widget.indexAuto == widget.index)
              ? Lottie.asset(
                  'assets/new_ui/animation_lottie/load_anim_tts.json',
                  height: 45,
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget _buildBoxTalk(
    String tenNhanVat,
    String mauCauChinh,
    int soThuTu,
    int key,
    String uid,
    String ttdid,
    int totalItem,
    bool isMainSentence,
  ) {
    return InkWell(
      child: Column(
        key: ValueKey(key),
        crossAxisAlignment: (soThuTu % 2 == 0)
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            tenNhanVat,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          PracticeBoxItem(
            setIndexAuto: widget.setIndexAuto,
            isMainSentence: isMainSentence,
            checkExactly: widget.checkExactly[widget.index],
            checkTalk: widget.checkTalk[widget.index],
            mauCauChinh: mauCauChinh,
            soThuTu: soThuTu,
            key: ValueKey(key),
            ttsState: widget.ttsState,
            indexNum: widget.indexAuto,
            checkIndex: key,
            uid: uid,
            ttdid: ttdid,
            totalItem: totalItem,
            wrongWords: widget.wrongWords[widget.index],
          ),
        ],
      ),
    );
  }

  Widget _buildBoxSpeak(
    String tenNhanVat,
    String mauCauText,
    String avatarPath,
    int soThuTu,
    int key,
    String uid,
    String ttdid,
    int totalItem,
    bool isMainSentence,
  ) {
    return Row(
      key: ValueKey(key),
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          (soThuTu % 2 == 0) ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        (soThuTu % 2 == 0)
            ? _buildAvatarNhanVat('assets/new_ui/more/ic_splash.png', true)
            : _buildBoxTalk(mauCauText, tenNhanVat, soThuTu, key, uid, ttdid,
                totalItem, isMainSentence),
        SizedBox(width: 10),
        (soThuTu % 2 == 0)
            ? _buildBoxTalk(mauCauText, tenNhanVat, soThuTu, key, uid, ttdid,
                totalItem, isMainSentence)
            : _buildAvatarNhanVat(avatarPath, false)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBoxSpeak(
      // listTalk[index]['content'],
      // listTalk[index]['author'],
      // 'assets/images/avatar.png',
      // index,
      // index,
      // listTalk[index]['uid'],
      // listTalk[index]['ttdid'],
      // listTalk.length,
      widget.talkTextFullData.getListSub()[widget.index].content,
      widget.talkTextFullData.getListSub()[widget.index].author,
      'assets/new_ui/more/pho.png',
      widget.index,
      widget.index,
      // talkTextFullData!.getListSub()[index]['uid'],
      // talkTextFullData!.getListSub()[index]['ttdid'],
      "0",
      "0",
      widget.talkTextFullData.getListSub().length,
      widget.talkTextFullData.getListSub()[widget.index].isMainSentence,
    );
  }
}
