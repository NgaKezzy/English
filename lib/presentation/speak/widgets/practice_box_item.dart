import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:provider/src/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../screen/main_speak_screen.dart';
import 'package:flutter/material.dart';

class PracticeBoxItem extends StatefulWidget {
  final String mauCauChinh;
  final int soThuTu;
  // final TtsState ttsState;
  final int indexNum;
  final int checkIndex;
  final String uid;
  final String ttdid;
  final int totalItem;
  final TtsState ttsState;
  final List<String> wrongWords;
  final bool checkTalk;
  final bool checkExactly;
  final Function setIndexAuto;
  final bool isMainSentence;
  const PracticeBoxItem({
    Key? key,
    required this.mauCauChinh,
    required this.soThuTu,
    // required this.ttsState,
    required this.indexNum,
    required this.checkIndex,
    required this.uid,
    required this.ttdid,
    required this.totalItem,
    required this.ttsState,
    required this.wrongWords,
    required this.checkTalk,
    required this.checkExactly,
    required this.isMainSentence,
    required this.setIndexAuto,
  }) : super(key: key);

  @override
  _PracticeBoxItemState createState() => _PracticeBoxItemState();
}

class _PracticeBoxItemState extends State<PracticeBoxItem> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return InkWell(
      onTap: () {
        widget.setIndexAuto(widget.soThuTu);
      },
      key: widget.key,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        width: MediaQuery.of(context).size.width / 1.5,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color:
                  (widget.soThuTu == widget.indexNum && widget.soThuTu % 2 != 0)
                      ? (widget.checkTalk
                          ? (widget.checkExactly ? Colors.green : Colors.red)
                          : Colors.green)
                      : (widget.ttsState == TtsState.playing &&
                              widget.indexNum == widget.soThuTu)
                          ? Colors.green
                          : Colors.grey,
              width: 0.5,
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
                widget.isMainSentence
                    ? Text(
                        S.of(context).SampleSentences,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                widget.soThuTu % 2 != 0
                    ? ((widget.checkTalk)
                        ? SubstringHighlight(
                            text: '${widget.mauCauChinh}',
                            terms: [...widget.wrongWords],
                            textStyle: TextStyle(
                              // non-highlight style
                              color: Colors.green[300],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textStyleHighlight: TextStyle(
                              // highlight style
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            words: true,
                          )
                        : Text(
                            '${widget.mauCauChinh}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: (widget.soThuTu == widget.indexNum &&
                                      widget.soThuTu % 2 != 0)
                                  ? (widget.checkTalk
                                      ? (widget.checkExactly
                                          ? Colors.green
                                          : Colors.red)
                                      : Colors.green)
                                  : (widget.ttsState == TtsState.playing &&
                                          widget.indexNum == widget.soThuTu)
                                      ? Colors.green
                                      : themeProvider.mode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                            ),
                          ))
                    : Text(
                        '${widget.mauCauChinh}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (widget.ttsState == TtsState.playing &&
                                  widget.indexNum == widget.soThuTu)
                              ? Colors.green
                              : themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
