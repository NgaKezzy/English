import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/quiz/game_speak/screens/advertise2.dart';
import 'package:app_learn_english/quiz/train_listen/screen/quiz_video_screen.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ItemQuizVideo extends StatelessWidget {
  const ItemQuizVideo({
    Key? key,
    required this.listSub,
    required this.controllerYT,
    required this.dataTalk,
    required this.part,
    required this.star,
  }) : super(key: key);
  final List<TalkDetailModel> listSub;
  final YoutubePlayerController controllerYT;
  final DataTalk dataTalk;
  final String part;
  final String star;

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return GestureDetector(
      onTap: () {
        controllerYT.pause();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Provider.of<CountHeartProvider>(context, listen: false)
                                .count ==
                            0
                        ? const Advertise(checkOnce: false)
                        : TrainListen4Star(
                            listSub: listSub,
                            dataTalk: dataTalk,
                          )));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 260,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeProvider.mode == ThemeMode.dark
              ? Color.fromRGBO(42, 44, 50, 1)
              : Colors.grey[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              part,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(
                  'assets/new_ui/animation_lottie/animation_kim_cuong.json',
                  height: 40,
                ),
                Text(
                  star,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                controllerYT.pause();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Provider.of<CountHeartProvider>(
                                        context,
                                        listen: false)
                                    .count ==
                                0
                            ? Advertise(checkOnce: false)
                            : TrainListen4Star(
                                listSub: listSub,
                                dataTalk: dataTalk,
                              )));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  color: Color(0xFF04D076),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    S.of(context).StartQuiz,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
