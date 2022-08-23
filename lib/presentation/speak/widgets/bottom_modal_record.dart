import 'dart:async';

import 'package:app_learn_english/Providers/dialog_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/presentation/speak/api/speech_to_text_api.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/src/provider.dart';
import 'package:record/record.dart';

class BottomModalRecord extends StatefulWidget {
  final Function pathSave;
  final Function changeStateRecoder;

  const BottomModalRecord({
    Key? key,
    required this.pathSave,
    required this.changeStateRecoder,
  }) : super(key: key);

  @override
  State<BottomModalRecord> createState() => _BottomModalRecordState();
}

class _BottomModalRecordState extends State<BottomModalRecord> {
  AudioPlayer audioPlayer = AudioPlayer();
  late bool onListening;
  bool isCloseRecorder = false;
  String? pathRecorder = '';

  // final SoundRecoder soundRecord = SoundRecoder();
  Record recorder = Record();
  Future recordVoice() async {
    await recorder.start();
    printCyan('hell');
  }

  Future playLocal(String path) async {
    await audioPlayer.play(path, isLocal: true);
  }

  intRecorder() async {
    widget.changeStateRecoder();
  }

  @override
  void initState() {
    intRecorder();
    onListening = true;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    SpeechApi.speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dialogProvider = context.read<DialogProvider>();
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              child: InkWell(
                onTap: () async {
                  String? path = await recorder.stop();
                  widget.pathSave(path);
                  widget.changeStateRecoder();
                  // Navigator.pop(context);
                  dialogProvider.setClickItem(false);
                },
                child: const Icon(
                  Icons.close_sharp,
                  size: 30,
                ),
              ),
              alignment: Alignment.centerRight,
            ),
            Align(
              child: onListening
                  ? Text(S.of(context).Recording)
                  : Text(S.of(context).ClickTheButtonToStartRecording),
              alignment: Alignment.center,
            ),
            Expanded(
              child: Align(
                child: AvatarGlow(
                  animate: onListening,
                  duration: const Duration(milliseconds: 2000),
                  repeat: onListening,
                  glowColor: Colors.blue,
                  repeatPauseDuration: const Duration(
                    milliseconds: 100,
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (onListening) {
                        String? path = await recorder.stop();
                        pathRecorder = path;
                        widget.changeStateRecoder();
                        setState(() {
                          onListening = false;
                          isCloseRecorder = true;
                        });
                      } else {
                        setState(() {
                          onListening = true;
                          isCloseRecorder = false;
                        });
                        // widget.recoder.record('${widget.pathSave}');
                        var checkPermission = await recorder.hasPermission();
                        if (checkPermission) {
                          recordVoice();
                        }
                      }
                    },
                    child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Icon(
                          onListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  endRadius: 100,
                ),
                alignment: Alignment.center,
              ),
            ),
            isCloseRecorder
                ? Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 50,
                      child: _viewListenAudio(pathRecorder),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  ///View nghe lại ghi âm
  Widget _viewListenAudio(String? path) {
    var themeProvider = context.watch<ThemeProvider>();
    return ScaleTap(
        onPressed: () async {
          await playLocal(path!);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black26,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: SvgPicture.asset(
                'assets/new_ui/more/voice_recoder.svg',
                height: 30,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              '"${S.of(context).phat_lai_doan_ghi_am}"',
              style: TextStyle(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black26,
                  fontSize: 16,
                  fontStyle: FontStyle.italic),
            )
          ],
        ));
  }
}
