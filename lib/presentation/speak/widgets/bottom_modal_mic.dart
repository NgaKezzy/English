import 'dart:async';

import 'package:app_learn_english/Providers/dialog_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TalkTextDetailModel.dart';
import 'package:app_learn_english/presentation/speak/api/speech_to_text_api.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:record/record.dart';

class BottomModalMic extends StatefulWidget {
  final Function stopAuto;
  final List<TalkTextDetailModel>? listTalk;
  final int indexList;
  final Function startListening;
  final Function stopListening;
  // final SoundRecoder recoder;
  final Function pathSave;
  final Function changeStateRecoder;

  const BottomModalMic({
    Key? key,
    required this.stopAuto,
    this.listTalk,
    required this.indexList,
    required this.startListening,
    required this.stopListening,
    // required this.recoder,
    required this.pathSave,
    required this.changeStateRecoder,
  }) : super(key: key);

  @override
  State<BottomModalMic> createState() => _BottomModalMicState();
}

class _BottomModalMicState extends State<BottomModalMic> {
  late bool onListening;

  // final SoundRecoder soundRecord = SoundRecoder();
  Record recorder = Record();
  Future recordVoice() async {
    await recorder.start();
    printCyan('hell');
  }

  @override
  void initState() {
    widget.startListening(context);
    onListening = true;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    // widget.stopAuto();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // SpeechApi.speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dialogProvider = context.read<DialogProvider>();
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        child: Column(
          children: [
            Align(
              child: TextButton(
                onPressed: () {
                  SpeechApi.speech.cancel();
                  dialogProvider.setClickItem(false);
                },
                child: Text(
                  S.of(context).Listening,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              alignment: Alignment.center,
            ),
            Expanded(
              child: Align(
                child: AvatarGlow(
                  animate: onListening,
                  duration: const Duration(milliseconds: 2000),
                  repeat: onListening,
                  glowColor: Colors.blue,
                  repeatPauseDuration: Duration(
                    milliseconds: 100,
                  ),
                  child: InkWell(
                    onTap: () async {
                      SpeechApi.speech.cancel();
                      dialogProvider.setClickItem(false);
                    },
                    child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: const Icon(
                          Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  endRadius: 150,
                ),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
