import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/TalkTextDetailModel.dart';
import 'package:provider/src/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../screen/main_speak_screen.dart';
import 'package:flutter/material.dart';

class ConversationBoxItem extends StatefulWidget {
  final String mauCauChinh;
  final int soThuTu;
  final String subtitle;
  final TtsState ttsState;
  final Function speak;
  final int indexNum;
  final int checkIndex;
  final ScrollController controller;
  final String uid;
  final String ttdid;
  final int totalItem;
  final Function fnc;
  final bool checkTalk;
  final bool checkExactly;
  final List<String> wrongWords;
  final List<TalkTextDetailModel> listTalk;
  final int indexList;
  final Function stopAuto;
  final Function stopTalking;
  const ConversationBoxItem({
    Key? key,
    required this.mauCauChinh,
    required this.soThuTu,
    required this.subtitle,
    required this.ttsState,
    required this.speak,
    required this.indexNum,
    required this.checkIndex,
    required this.controller,
    required this.uid,
    required this.ttdid,
    required this.totalItem,
    required this.fnc,
    required this.checkTalk,
    required this.checkExactly,
    required this.wrongWords,
    required this.listTalk,
    required this.indexList,
    required this.stopAuto,
    required this.stopTalking,
  }) : super(key: key);

  @override
  _ConversationBoxItemState createState() => _ConversationBoxItemState();
}

class _ConversationBoxItemState extends State<ConversationBoxItem> {
  bool btnState = false;
  void autoScrollIndex(
    ScrollController controller,
  ) {
    if (widget.ttsState == TtsState.playing && widget.indexNum != 1) {
      controller.animateTo((130.0) * widget.indexNum,
          duration: Duration(seconds: 1), curve: Curves.easeInQuad);
    } else {}
  }

  void scrollTo(int indexNum, ScrollController controller) {
    controller.animateTo((130.0) * indexNum,
        duration: Duration(seconds: 1), curve: Curves.easeInQuad);
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    // autoScrollIndex(widget.controller);
    return InkWell(
      key: widget.key,
      onTap: () {
        widget.stopAuto();
        widget.stopTalking();
        widget.speak(
          widget.mauCauChinh,
          widget.soThuTu,
          (widget.soThuTu >= 4 && widget.soThuTu % 4 == 0)
              ? () {}
              : widget.fnc(widget.soThuTu, widget.controller),
        );
        setState(() {
          btnState = true;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.35,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: (widget.ttsState == TtsState.playing &&
                      widget.indexNum == widget.checkIndex)
                  ? Colors.green
                  : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.listTalk[widget.indexList].isMainSentence
                    ? Text(
                        '${S.of(context).SampleMainSentence} ${widget.checkTalk ? (widget.checkExactly ? "(Đã nói đúng)" : "(Chưa nói chính xác)") : ""}',
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.checkTalk
                              ? (widget.checkExactly
                                  ? Colors.blue
                                  : Colors.orange)
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const SizedBox(),
                widget.listTalk[widget.indexList].isMainSentence
                    ? const SizedBox(
                        height: 15,
                      )
                    : const SizedBox(
                        height: 5,
                      ),
                widget.checkTalk
                    ? SubstringHighlight(
                        text: '${widget.mauCauChinh}',
                        terms: [...widget.wrongWords],
                        textStyle: TextStyle(
                          // non-highlight style
                          color: Colors.green[300],
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                        ),
                        textStyleHighlight: const TextStyle(
                          // highlight style
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                        ),
                        words: true,
                      )
                    : Text(
                        '${widget.mauCauChinh}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.checkTalk
                              ? (widget.checkExactly
                                  ? Colors.blue
                                  : Colors.orange)
                              : ((widget.ttsState == TtsState.playing &&
                                      widget.indexNum == widget.checkIndex)
                                  ? Colors.green
                                  : themeProvider.mode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black),
                        ),
                      ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
