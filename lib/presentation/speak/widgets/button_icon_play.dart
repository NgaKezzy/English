import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonIconPlay extends StatefulWidget {
  // final SoundPlayer player;
  final String? pathSave;
  final Function stopAuto;
  final Function stopTalking;
  final bool isRecorder;

  ButtonIconPlay({
    Key? key,
    // required this.player,
    required this.pathSave,
    required this.stopAuto,
    required this.stopTalking,
    required this.isRecorder,
  }) : super(key: key);

  @override
  _ButtonIconPlayState createState() => _ButtonIconPlayState();
}

class _ButtonIconPlayState extends State<ButtonIconPlay> {
  AudioPlayer audioPlayer = AudioPlayer();

  Future playLocal() async {
    await audioPlayer.play(widget.pathSave!, isLocal: true);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: () async {
            widget.stopAuto();
            widget.stopTalking();
            // await widget.player.togglePlaying(
            //     whenFinished: () {}, pathToReadAudio: '${widget.pathSave}');
            await playLocal();
          },
          child: widget.isRecorder
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(3),
                  child: SvgPicture.asset(
                    'assets/speak/play.svg',
                    height: 20,
                  ),
                ),
        ),
      ),
    );
  }
}
