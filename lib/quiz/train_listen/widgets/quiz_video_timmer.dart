import 'dart:math' as math;
import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/quiz/quiz_lotti_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/quiz/train_listen/provider/quiz_video_provider.dart';
import 'package:app_learn_english/quiz/train_listen/screen/bonus_quiz.dart';
import 'package:app_learn_english/quiz/train_listen/utils/quiz_video_utils.dart';
import 'package:app_learn_english/quiz/train_listen/widgets/quiz_modal.dart';
import 'package:app_learn_english/utils/config_heart_utils.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuizTimmer extends StatefulWidget {
  final YoutubePlayerController controllerYT;
  final int videoId;

  QuizTimmer({required this.controllerYT, required this.videoId});
  @override
  State<QuizTimmer> createState() => _QuizTimmerState();
}

class _QuizTimmerState extends State<QuizTimmer>
    with SingleTickerProviderStateMixin {
  var random = math.Random();
  late AudioPlayer player;
  late double width;
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(seconds: 1))
        ..repeat();
  List<QuizLottiModel> listLottie = [];

  @override
  void initState() {
    player = AudioPlayer();
    super.initState();
  }

  Widget _buildElementTap(String e, QuizVideoProvider quizProvider) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, child) => Transform.rotate(
        angle: _controller.value * 2 * math.pi,
        child: child,
      ),
      child: InkWell(
        onTap: () => checkMatched(e, quizProvider),
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 1,
              color: Colors.green,
            ),
          ),
          child: Text(e),
        ),
      ),
    );
  }

  void restart(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    var quizVideoProvider =
        Provider.of<QuizVideoProvider>(context, listen: false);
    quizVideoProvider.setIndex(0);
    quizVideoProvider.setIndexMatched(0);
    quizVideoProvider.setPreGesture(-1);
    quizVideoProvider.setGesture(-1);
    quizVideoProvider.setPoint(150);
    quizVideoProvider.setSecondCheck(0);
    quizVideoProvider.setFilterArray(
      QuizVideoUtils.renderFilterArray(
        quizVideoProvider.listSub[quizVideoProvider.index].content.trim(),
      ),
    );
    quizVideoProvider.setRandomString(
      QuizVideoUtils.renderRandomString(
        quizVideoProvider.filterArray,
      ),
    );

    quizVideoProvider.setElementConvert(quizVideoProvider.randomString
        .map(
          (e) => _buildElementTapNormal(e, quizVideoProvider),
        )
        .toList());
    quizVideoProvider.setRandomStringConvert(
        quizVideoProvider.randomString.map((e) => Text('______ ')).toList());
  }

  Widget _buildElementTapNormal(String e, QuizVideoProvider quizProvider) {
    return InkWell(
      onTap: () => checkMatched(e, quizProvider),
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 0.5,
            color: Colors.grey,
          ),
        ),
        child: Text(e),
      ),
    );
  }

  void checkMatched(String e, QuizVideoProvider quizVideoProvider) async {
    // xóa phần tử và push lên trên khi nhấn nếu đúng
    quizVideoProvider.setPoint(quizVideoProvider.second);
    quizVideoProvider.setGesture(1);
    int checkMatched = quizVideoProvider.randomString.indexWhere(
      (element) => element == e,
    );
    printYellow('đây là check matched:' + checkMatched.toString());
    if (quizVideoProvider.filterArray[quizVideoProvider.indexMatched] ==
        quizVideoProvider.randomString[checkMatched]) {
      quizVideoProvider.setRandomStringRemove(e);
      // quizVideoProvider.removeElementFilterArray(0);
      quizVideoProvider.setElementConvert(
        quizVideoProvider.randomString.map((e) {
          return _buildElementTapNormal(e, quizVideoProvider);
        }).toList(),
      );
      quizVideoProvider.setRandomStringConvertIndex(Text('$e '));
      quizVideoProvider.setIndexMatched(quizVideoProvider.indexMatched + 1);
      //
      print('hell: ${quizVideoProvider.randomString.length}');
      if (quizVideoProvider.indexMatched ==
              quizVideoProvider.filterArray.length &&
          quizVideoProvider.index == quizVideoProvider.listSub.length - 2) {
        quizVideoProvider.setTimeEnd(quizVideoProvider.second);
        quizVideoProvider.controller.pause();
        widget.controllerYT.pause();
        UserAPIs().addAndDivHeart(
          username: DataCache().getUserData().username,
          uid: DataCache().getUserData().uid,
          typeAction: quizVideoProvider.type,
          timequiz: quizVideoProvider.timeEnd.toInt(),
          vid: widget.videoId,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BonusQuiz(
              restart: () => restart(context),
              controllerYT: widget.controllerYT,
            ),
          ),
        );
      }
      if (quizVideoProvider.randomString.length == 0) {
        print(quizVideoProvider.randomString);
        print(quizVideoProvider.filterArray);
        print(quizVideoProvider.index);
        print(quizVideoProvider.indexMatched);
        quizVideoProvider.setIndexMatched(0);
        quizVideoProvider.setIndex(quizVideoProvider.index + 1);
        quizVideoProvider.setFilterArray(
          QuizVideoUtils.renderFilterArray(
            quizVideoProvider.listSub[quizVideoProvider.index].content.trim(),
          ),
        );
        quizVideoProvider.setRandomString(
          QuizVideoUtils.renderRandomString(
            quizVideoProvider.filterArray,
          ),
        );

        quizVideoProvider.setElementConvert(quizVideoProvider.randomString
            .map(
              (e) => _buildElementTapNormal(e, quizVideoProvider),
            )
            .toList());
        quizVideoProvider.setRandomStringConvert(quizVideoProvider.randomString
            .map((e) => Text('______ '))
            .toList());
      }
    } else {
      if (DataCache().getUserData().isVip == 3 ||
          DataCache().getUserData().isVip == 0) {
        if (Provider.of<CountHeartProvider>(context, listen: false).count !=
            0) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.black12.withOpacity(0.5),
            builder: (BuildContext context) {
              int num = random.nextInt(listLottie.length);

              return Container(
                height: MediaQuery.of(context).size.height,
                child: Countdown(
                  controller: CountdownController(
                    autoStart: true,
                  ),
                  seconds: 1,
                  build: (BuildContext context, double time) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          '${listLottie[num].lottie}',
                          height: 200,
                        ),
                        Text(
                          '${listLottie[num].title}',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                  onFinished: () {
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
          await player.setAsset('assets/audio/hettim.mp3');
          var heart = await UserAPIs().addAndDivHeart(
            username: DataCache().getUserData().username,
            uid: DataCache().getUserData().uid,
            typeAction: ConfigHeart.quiz_video_tru_tim,
          );
          Provider.of<CountHeartProvider>(
            context,
            listen: false,
          ).setCountHeart(heart);
        } else {
          widget.controllerYT.pause();
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    width = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (listLottie.isEmpty) {
      listLottie = Utils().setListLottieQuizWrong(context);
    }
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          color: const Color.fromRGBO(91, 91, 91, 1),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.bounceOut,
          width: width,
          height: 60,
          color: const Color.fromRGBO(157, 44, 255, 1),
        ),
        Container(
          padding: const EdgeInsets.only(top: 14),
          child: Consumer<QuizVideoProvider>(
            builder: (ctx, quizVideoProvider, child) => Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: !quizVideoProvider.isPlayerReady
                      ? const SizedBox()
                      : Countdown(
                          controller: quizVideoProvider.controller,
                          seconds: quizVideoProvider.currentTime,
                          build: (
                            BuildContext context,
                            double time,
                          ) {
                            Future.delayed(Duration(seconds: 0), () async {
                              quizVideoProvider.setSecond(time);

                              printRed(quizVideoProvider.point.toString());
                              printRed(quizVideoProvider.second.toString());
                              if (quizVideoProvider.point - 1 == time) {
                                quizVideoProvider.setPreGesture(
                                  quizVideoProvider.gesture,
                                );
                                quizVideoProvider.setGesture(-1);
                              }
                              int indexMatchRandom =
                                  quizVideoProvider.randomString.indexWhere(
                                (element) =>
                                    element ==
                                    quizVideoProvider.filterArray[
                                        quizVideoProvider.indexMatched],
                              );
                              if (quizVideoProvider.point - 10 == time) {
                                if (quizVideoProvider.preGesture == -1) {
                                  quizVideoProvider.setElementConvertE(
                                    _buildElementTap(
                                        quizVideoProvider
                                            .randomString[indexMatchRandom],
                                        quizVideoProvider),
                                    indexMatchRandom,
                                  );
                                }
                              }
                              if (quizVideoProvider.point - 11 == time) {
                                if (quizVideoProvider.preGesture == -1) {
                                  quizVideoProvider.setElementConvertE(
                                    _buildElementTapNormal(
                                        quizVideoProvider
                                            .randomString[indexMatchRandom],
                                        quizVideoProvider),
                                    indexMatchRandom,
                                  );
                                }
                                quizVideoProvider.setPoint(time);
                              }
                              if (quizVideoProvider.secondCheck != time) {
                                setState(
                                  () {
                                    width -= MediaQuery.of(context).size.width /
                                        quizVideoProvider.currentTime;
                                  },
                                );
                                if (width < 1) {
                                  setState(() {
                                    width = 0;
                                  });
                                }
                                quizVideoProvider.setSecondCheck(time);
                              }
                            });

                            return Text(
                              time.toString() + '"',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            );
                          },
                          interval: const Duration(milliseconds: 1000),
                          onFinished: () async {
                            await player.setAsset('assets/audio/thuagame.mp3');
                            player.play();
                            widget.controllerYT.pause();
                            quizVideoProvider.controller.pause();
                            showModalBottomSheet(
                              isDismissible: false,
                              context: ctx,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext modalContext) {
                                return QuizModal(
                                  svgAsset: 'assets/speak/hourglass.svg',
                                  warning: S.of(context).Overtime,
                                  question: S.of(context).Doyouwanttotryagain,
                                  labelButton: S.of(context).Retry,
                                  labelBottom: S.of(context).EndOfQuiz,
                                  checkQuit: false,
                                  controller: widget.controllerYT,
                                  restart: () => restart(context),
                                );
                              },
                            );
                          },
                        ),
                ),
                const Expanded(child: SizedBox()),
                Consumer<CountHeartProvider>(
                  builder: (context, countHeartProvider, child) => Text(
                    (DataCache().getUserData().isVip == 1 ||
                            DataCache().getUserData().isVip == 1)
                        ? 'VIP'
                        : countHeartProvider.count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.favorite, size: 25, color: Colors.white),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
