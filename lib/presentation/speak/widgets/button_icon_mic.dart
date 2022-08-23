import 'package:app_learn_english/Providers/dialog_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TalkTextDetailModel.dart';
import 'package:app_learn_english/presentation/speak/widgets/bottom_modal_mic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ButtonIconMic extends StatefulWidget {
  final BuildContext ctx;
  final String textApi;
  final bool checkTalk;
  final Function stopAuto;
  final Function stopTalking;
  final bool checkBtnState;
  final Function setStateBtn;
  final List<TalkTextDetailModel>? listTalk;
  final int indexList;
  final Function startListening;
  final Function stopListening;
  // final SoundRecoder recoder;
  final Function pathSave;
  final Function changeStateRecoder;
  final Function updatePercentFnc;
  final SpeechToText speechToText;
  final String titleContent;
  final String titleSub;
  const ButtonIconMic({
    Key? key,
    required this.ctx,
    required this.textApi,
    required this.checkTalk,
    required this.stopAuto,
    required this.stopTalking,
    required this.checkBtnState,
    required this.setStateBtn,
    required this.listTalk,
    required this.indexList,
    required this.startListening,
    required this.stopListening,
    // required this.recoder,
    required this.pathSave,
    required this.changeStateRecoder,
    required this.updatePercentFnc,
    required this.speechToText, required this.titleContent, required this.titleSub,
  }) : super(key: key);
  @override
  _ButtonIconMicState createState() => _ButtonIconMicState();
}

class _ButtonIconMicState extends State<ButtonIconMic> {
  bool checkSpeaking = false;

  bool stateBtn = false;
  bool setStatePercent = true;
  Record recorder = Record();

  @override
  void initState() {
    super.initState();
  }

  void showModal() async {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      elevation: 10,
      context: context,
      builder: (context) =>
          BottomModalMic(
        changeStateRecoder: widget.changeStateRecoder,
        pathSave: widget.pathSave,
        // recoder: widget.recoder,
        startListening: widget.startListening,
        stopListening: widget.stopListening,
        indexList: widget.indexList,
        stopAuto: widget.stopAuto,
        listTalk: widget.listTalk,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var dialogProvider = context.read<DialogProvider>();
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () async {
          var checkPermission = await recorder.hasPermission();
          if (checkPermission) {
            dialogProvider.setClickItem(true);
            widget.stopAuto();
            widget.stopTalking();
            if (setStatePercent) {
              widget.updatePercentFnc(
                percent: (1 / widget.listTalk!.length) * 100,
              );
              setState(() {
                setStatePercent = false;
              });
          }
          }
          printCyan(widget.listTalk!.length.toString());
          dialogProvider.setWidgetRecorder(
            BottomModalMic(
            changeStateRecoder: widget.changeStateRecoder,
            pathSave: widget.pathSave,
            // recoder: widget.recoder,
            startListening: widget.startListening,
            stopListening: widget.stopListening,
            indexList: widget.indexList,
            stopAuto: widget.stopAuto,
            listTalk: widget.listTalk,
          ),);

          dialogProvider.setTitleContentAndSub(widget.titleContent, widget.titleSub);
          // showModal();
        },
        child: Container(
                height: 45,
                width: 45,
                child: Card(
                  elevation: 10,
                  child: SvgPicture.asset(
                    'assets/speak/mic.svg',
                    height: 30,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fit: BoxFit.scaleDown,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: Colors.white,
                      width: 0.5,
                    ),
                  ),
                ),
              )

      ),
    );
  }
}
