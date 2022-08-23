import 'dart:math';

import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/quiz/quiz_lotti_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/quiz/train_listen/provider/quiz_video_provider.dart';
import 'package:app_learn_english/quiz/train_listen/screen/bonus_quiz.dart';
import 'package:app_learn_english/quiz/train_listen/utils/quiz_video_utils.dart';
import 'package:app_learn_english/quiz/train_listen/widgets/out_of_heart.dart';
import 'package:app_learn_english/quiz/train_listen/widgets/quiz_modal.dart';
import 'package:app_learn_english/quiz/train_listen/widgets/quiz_video_body.dart';
import 'package:app_learn_english/quiz/train_listen/widgets/quiz_video_bottom.dart';
import 'package:app_learn_english/quiz/train_listen/widgets/quiz_video_player.dart';
import 'package:app_learn_english/quiz/train_listen/widgets/quiz_video_timmer.dart';
import 'package:app_learn_english/utils/config_heart_utils.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrainListen4Star extends StatefulWidget {
  final List<TalkDetailModel> listSub;
  final DataTalk dataTalk;

  const TrainListen4Star({
    Key? key,
    required this.listSub,
    required this.dataTalk,
  }) : super(key: key);

  @override
  _TrainListen4StarState createState() => _TrainListen4StarState();
}

class _TrainListen4StarState extends State<TrainListen4Star> {
  late QuizVideoProvider quizVideoProvider;
  late YoutubePlayerController _controller;
  // late PlayerState _playerState;
  late Color? sugest;
  late CountHeartProvider heartProvider;
  int indexMap = -1;
  bool _loadingController = true;
  late AudioPlayer player;
  var random = Random();
  List<QuizLottiModel> listLottie = [];

  @override
  void initState() {
    player = AudioPlayer();
    super.initState();
  }

  void restart(BuildContext context) {
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
          (e) => _buildElementTap(e, quizVideoProvider),
        )
        .toList());
    quizVideoProvider.setRandomStringConvert(
        quizVideoProvider.randomString.map((e) => Text('______ ')).toList());
  }

  void _listener() {
    if (quizVideoProvider.isPlayerReady && mounted) {
      // setState(() {
      //   _playerState = _controller.value.playerState;
      //   _videoMetaData = _controller.metadata;
      // });

      // printRed(_controller.value.position.inSeconds.toString());
      // printRed(Duration(
      //         milliseconds: quizVideoProvider
      //             .listSub[quizVideoProvider.index + 1].startTime)
      //     .inSeconds
      //     .toString());

      if (_controller.value.position.inSeconds ==
          Duration(
                  milliseconds: quizVideoProvider
                      .listSub[quizVideoProvider.index + 1].startTime)
              .inSeconds) {
        _controller.seekTo(Duration(
            milliseconds:
                quizVideoProvider.listSub[quizVideoProvider.index].startTime));
        _controller.removeListener(_listener);
        _controller.addListener(_listener);
      }
    }
  }

  Widget _buildElementTap(String e, QuizVideoProvider quizProvider) {
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
    printYellow('Đây là check matched' + checkMatched.toString());
    if (quizVideoProvider.filterArray[quizVideoProvider.indexMatched] ==
        quizVideoProvider.randomString[checkMatched]) {
      quizVideoProvider.setRandomStringRemove(e);
      // quizVideoProvider.removeElementFilterArray(0);
      quizVideoProvider.setElementConvert(
        quizVideoProvider.randomString.map((e) {
          return _buildElementTap(e, quizVideoProvider);
        }).toList(),
      );
      quizVideoProvider.setRandomStringConvertIndex(Text('$e '));
      quizVideoProvider.setIndexMatched(quizVideoProvider.indexMatched + 1);
      //
      printRed('hell: ${quizVideoProvider.randomString.length}');
      if (quizVideoProvider.indexMatched ==
              quizVideoProvider.filterArray.length &&
          quizVideoProvider.index == quizVideoProvider.listSub.length - 2) {
        _controller.pause();
        quizVideoProvider.controller.pause();
        quizVideoProvider.setTimeEnd(quizVideoProvider.second);
        UserAPIs().addAndDivHeart(
          username: DataCache().getUserData().username,
          uid: DataCache().getUserData().uid,
          typeAction: quizVideoProvider.listSub.length - 1 == 2
              ? ConfigHeart.quiz_video_cap_do_2
              : (quizVideoProvider.listSub.length - 1 == 3
                  ? ConfigHeart.quiz_video_cap_do_3
                  : ConfigHeart.quiz_video_cap_do_4),
          timequiz: quizVideoProvider.timeEnd.toInt(),
          vid: widget.dataTalk.id,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BonusQuiz(
              restart: () => restart(context),
              controllerYT: _controller,
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
        printRed('Đây là index mới' + quizVideoProvider.index.toString());
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
              (e) => _buildElementTap(e, quizVideoProvider),
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
              int number = random.nextInt(listLottie.length);
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
                          '${listLottie[number].lottie}',
                          height: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${listLottie[number].title}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/quiz/diamond.svg',
                                    height: 40,
                                    width: 40,
                                  ),
                                  Text(
                                    '-1',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
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
            vid: widget.dataTalk.id,
          );
          Provider.of<CountHeartProvider>(context, listen: false)
              .setCountHeart(heart);
        } else {
          _controller.pause();
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    quizVideoProvider = Provider.of<QuizVideoProvider>(
      context,
      listen: false,
    );
    Future.delayed(Duration(seconds: 0), () async {
      if (!quizVideoProvider.initialize) {
        quizVideoProvider.setDataTalk(widget.dataTalk);
        quizVideoProvider.setListSub(widget.listSub);

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
              (e) => _buildElementTap(e, quizVideoProvider),
            )
            .toList());
        quizVideoProvider.setRandomStringConvert(quizVideoProvider.randomString
            .map((e) => Text('______ '))
            .toList());

        quizVideoProvider.setInitialize(true);
      }
      if (_loadingController) {
        _controller = YoutubePlayerController(
          initialVideoId: widget.dataTalk.yt_id,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            hideControls: true,
            hideThumbnail: true,
            enableCaption: false,
            startAt:
                Duration(milliseconds: widget.listSub[0].startTime).inSeconds,
            endAt: Duration(
                    milliseconds:
                        widget.listSub[widget.listSub.length - 1].endTime)
                .inSeconds,
          ),
        );
        var heart = await UserAPIs().getHeart(
          uid: DataCache().getUserData().uid,
          username: DataCache().getUserData().username,
        );
        Provider.of<CountHeartProvider>(context, listen: false)
            .setCountHeart(heart);
        setState(() {
          _loadingController = false;
        });
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    quizVideoProvider.reset();
    super.dispose();
    player.dispose();
  }

  bool _isPop = false;

  @override
  Widget build(BuildContext context) {
    if (listLottie.isEmpty) {
      listLottie = Utils().setListLottieQuizWrong(context);
    }

    var heartCount = Provider.of<CountHeartProvider>(context).count;
    return WillPopScope(
      onWillPop: () async {
        quizVideoProvider.controller.pause();
        _controller.pause();
        showModalBottomSheet(
          context: context,
          builder: (cxt) => QuizModal(
            svgAsset: 'assets/speak/warning.svg',
            warning: S.of(context).Whatapity,
            question: S.of(context).Areyousureyouwanttoexit,
            labelButton: S.of(context).EndOfQuiz,
            labelBottom: S.of(context).Continue,
            checkQuit: true,
            controller: _controller,
          ),
        );
        return _isPop;
      },
      child: Scaffold(
        backgroundColor:
            heartCount == 0 ? const Color.fromRGBO(51, 51, 51, 1) : null,
        body: SafeArea(
          child: _loadingController
              ? const Center(
                  // child: CircularProgressIndicator(),
                  child: PhoLoading(),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      showVideoProgressIndicator: false,
                      controller: _controller..addListener(_listener),
                      onReady: () {
                        quizVideoProvider.setIsPlayerReady(true);
                      },
                    ),
                    builder: (ctx, player) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QuizVideoPlayer(
                          youtubePlayer: player,
                          controllerYoutube: _controller,
                        ),
                        if (heartCount <= 0) OutOfHeart(),
                        if (heartCount > 0)
                          QuizTimmer(
                            controllerYT: _controller,
                            videoId: widget.dataTalk.id,
                          ),
                        if (heartCount > 0) const SizedBox(height: 16),
                        if (heartCount > 0)
                          QuizVideoBody(listSub: widget.listSub),
                        if (heartCount > 0)
                          Divider(height: 1, color: Colors.black),
                        if (heartCount > 0) QuizVideoBottom(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
