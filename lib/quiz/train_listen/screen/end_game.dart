import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/record_model.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/quiz/train_listen/provider/quiz_video_provider.dart';
import 'package:app_learn_english/quiz/train_listen/screen/quiz_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EndGameQuiz extends StatefulWidget {
  static const routeName = '/endgame-quiz-video';

  @override
  State<EndGameQuiz> createState() => _EndGameQuizState();
}

class _EndGameQuizState extends State<EndGameQuiz> {
  List<RecordModel> dataRecord = [];
  bool _loading = true;

  @override
  void didChangeDependencies() async {
    if (_loading) {
      dataRecord = await TalkAPIs().getRecord(
        vid: Provider.of<QuizVideoProvider>(
          context,
          listen: false,
        ).dataTalk!.id,
      );
      setState(() {
        _loading = false;
      });
      dataRecord.sort((a, b) => a.timequiz!.compareTo(b.timequiz!));
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<QuizVideoProvider>(context, listen: false).controller.pause();
    return Scaffold(
      body: SafeArea(
        child: Consumer<QuizVideoProvider>(
          builder: (ctx, quizVideoProvider, wid) {
            return Container(
              // padding: EdgeInsets.all(12),
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
                          size: 30,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    S.of(context).Myrecord,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(
                      Icons.access_time_outlined,
                      size: 35,
                    ),
                    const SizedBox(width: 10),
                    Consumer<QuizVideoProvider>(
                      builder: (context, quizVideoProvider, child) => Text(
                        '${quizVideoProvider.timeEnd}"',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        S.of(context).Top3records,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _loading
                      ? Center(
                          // child: CircularProgressIndicator(),
                          child: const PhoLoading(),
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // for (var item in dataRecord)
                              for (var i = 0; i < dataRecord.length; i++)
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: i == 0
                                              ? Colors.red.withOpacity(0.9)
                                              : (i == 1
                                                  ? Colors.orange
                                                      .withOpacity(0.9)
                                                  : (i == 2
                                                      ? Colors.green
                                                      : Colors.grey[300])),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${i + 1}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        dataRecord[i].username != null
                                            ? (dataRecord[i].username!.isEmpty
                                                ? 'Anonymous'
                                                : '${dataRecord[i].username}')
                                            : 'Anonymous',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                      Text(
                                        '${dataRecord[i].timequiz}s',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                  // Container(
                  //   height: 300,
                  //   padding: EdgeInsets.all(16),
                  //   child:
                  //   ListView.builder(itemBuilder: (context, index) {
                  //     return Row(
                  //       children: [
                  //         Text(
                  //           'stt',
                  //           style: TextStyle(fontSize: 22),
                  //         ),
                  //         Container(
                  //           margin: EdgeInsets.only(left: 10, right: 10),
                  //           width: 40,
                  //           height: 40,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(20),
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //         Text(
                  //           '${dataRecord[index].username!}',
                  //           style: TextStyle(fontSize: 22),
                  //         ),
                  //         Expanded(child: Container()),
                  //         Text(
                  //           '${dataRecord[index].timequiz}',
                  //           style: TextStyle(fontSize: 22),
                  //         ),
                  //       ],
                  //     );
                  //   }),
                  // ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
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
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Center(
                        child: Text(
                          S.of(context).Playagain,
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
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Center(
                        child: Text(
                          S.of(context).EndOfQuiz,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFF04D076),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
