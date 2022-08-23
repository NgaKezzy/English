import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/quiz/train_listen/provider/quiz_video_provider.dart';
import 'package:app_learn_english/quiz/train_listen/widgets/quiz_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuizVideoPlayer extends StatefulWidget {
  const QuizVideoPlayer({
    Key? key,
    required this.youtubePlayer,
    required this.controllerYoutube,
  }) : super(key: key);

  final Widget youtubePlayer;
  final YoutubePlayerController controllerYoutube;

  @override
  State<QuizVideoPlayer> createState() => _QuizVideoPlayerState();
}

class _QuizVideoPlayerState extends State<QuizVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        child: Stack(
          children: [
            widget.youtubePlayer,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Provider.of<QuizVideoProvider>(context, listen: false)
                        .controller
                        .pause();
                    widget.controllerYoutube.pause();
                    showModalBottomSheet(
                      context: context,
                      builder: (cxt) => QuizModal(
                        svgAsset: 'assets/speak/warning.svg',
                        warning: S.of(context).Whatapity,
                        question: S.of(context).Areyousureyouwanttoexit,
                        labelButton: S.of(context).EndOfQuiz,
                        labelBottom: S.of(context).Continue,
                        checkQuit: true,
                        controller: widget.controllerYoutube,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.close,
                  ),
                  color: Colors.white,
                  iconSize: 35,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
