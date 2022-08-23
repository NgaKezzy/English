import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/quiz/train_listen/provider/quiz_video_provider.dart';
import 'package:app_learn_english/quiz/train_listen/screen/quiz_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuizModal extends StatelessWidget {
  const QuizModal({
    Key? key,
    required this.svgAsset,
    required this.warning,
    required this.question,
    required this.labelButton,
    required this.labelBottom,
    required this.checkQuit,
    this.controller,
    this.restart,
  }) : super(key: key);
  final String svgAsset;
  final String warning;
  final String question;
  final String labelButton;
  final String labelBottom;
  final bool checkQuit;
  final YoutubePlayerController? controller;
  final void Function()? restart;

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 4 / 5,
        color: themeProvider.mode == ThemeMode.dark
            ? const Color.fromRGBO(42, 44, 50, 1)
            : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgAsset,
              color: const Color.fromRGBO(157, 44, 255, 1),
              height: 50,
            ),
            const SizedBox(height: 10),
            Text(
              warning,
              style: TextStyle(
                fontSize: 26,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              question,
              style: TextStyle(
                fontSize: 18,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (checkQuit) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  // restart!();
                  // controller!.play();
                  // Provider.of<QuizVideoProvider>(context, listen: false)
                  //     .controller
                  //     .restart();
                  // Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainListen4Star(
                        listSub: Provider.of<QuizVideoProvider>(
                          context,
                          listen: false,
                        ).listSub,
                        dataTalk: Provider.of<QuizVideoProvider>(
                          context,
                          listen: false,
                        ).dataTalk!,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: 200,
                child: Center(
                  child: Text(
                    labelButton,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF04D076),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () {
                if (checkQuit) {
                  Navigator.pop(context);
                  controller!.play();
                  Provider.of<QuizVideoProvider>(context, listen: false)
                      .controller
                      .resume();
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: 150,
                child: Center(
                  child: Text(
                    labelBottom,
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
