import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/quiz/train_listen/provider/quiz_video_provider.dart';
import 'package:app_learn_english/quiz/train_listen/screen/end_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BonusQuiz extends StatefulWidget {
  const BonusQuiz({
    Key? key,
    required this.restart,
    required this.controllerYT,
  }) : super(key: key);
  final Function restart;
  final YoutubePlayerController controllerYT;

  @override
  State<BonusQuiz> createState() => _BonusQuizState();
}

class _BonusQuizState extends State<BonusQuiz> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<QuizVideoProvider>(
            builder: (ctx, quizVideoProvider, child) {
              return Container(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                          iconSize: 35,
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      S.of(context).Congratulationsonwinning,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[700],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 35,
                      ),
                      SizedBox(width: 10),
                      Consumer<QuizVideoProvider>(
                        builder: (context, quizVideoProvider, widget) => Text(
                          '${quizVideoProvider.timeEnd}"',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 40),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        SvgPicture.asset(
                          "assets/new_ui/more/icon_ruby.svg",
                          width: 200,
                        ),
                        Container(
                          width: 200,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '+' +
                                  (Provider.of<QuizVideoProvider>(context,
                                                  listen: false)
                                              .listSub
                                              .length -
                                          1)
                                      .toString(),
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        S.of(context).Getbonushearts,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.yellow[700],
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed(
                          EndGameQuiz.routeName,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Center(
                          child: Text(
                            S.of(context).Continue,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
