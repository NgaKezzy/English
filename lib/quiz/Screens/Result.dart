import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/question_item.dart';
import 'package:app_learn_english/quiz/Screens/advertise.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Result extends StatefulWidget {
  final List<Map<String, dynamic>> listQTrue;
  final List<QuestionItem> data;
  final Function filterTopicChoose10;
  final int idChoose;
  const Result({
    Key? key,
    required this.listQTrue,
    required this.data,
    required this.filterTopicChoose10,
    required this.idChoose,
  }) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  int totalTrue = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var item in widget.listQTrue) {
      if (int.parse('${item["right"]}') == 1) {
        totalTrue++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color.fromRGBO(83, 180, 81, 1),
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      totalTrue < 3
                          ? S.of(context).YouNeedToTryHarder
                          : S.of(context).YouDidAGreatJob,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Divider(
                    height: 2,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      totalTrue / 10 >= 0.3
                          ? Container(
                              child: Image.asset(
                              'assets/quiz/icon_star_active.png',
                              height: 40,
                            ))
                          : Container(
                              child: Image.asset(
                              'assets/quiz/sao_bonus_deactive.png',
                              height: 30,
                            )),
                      SizedBox(
                        width: 5,
                      ),
                      totalTrue / 10 >= 0.6
                          ? Container(
                              child: Image.asset(
                              'assets/quiz/icon_star_active.png',
                              height: 40,
                            ))
                          : Container(
                              child: Image.asset(
                              'assets/quiz/sao_bonus_deactive.png',
                              height: 40,
                            )),
                      SizedBox(
                        width: 5,
                      ),
                      totalTrue / 10 >= 0.9
                          ? Container(
                              child: Image.asset(
                              'assets/quiz/icon_star_active.png',
                              height: 40,
                            ))
                          : Container(
                              child: Image.asset(
                              'assets/quiz/sao_bonus_deactive.png',
                              height: 40,
                            )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      S.of(context).NumberOfCorrectAnswers + '$totalTrue/10',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Container(
              color: themeProvider.mode == ThemeMode.dark
                  ? Color.fromRGBO(24, 26, 33, 1)
                  : Colors.white,
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 8, right: 12, top: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).ContentReport,
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // 'Câu trả lời:  ${widget.listQTrue[index]['right'] == 1 ? widget.listQTrue[index]['questionObject'].true_answer : (widget.listQTrue[index]['questionObject'].true_answer == widget.listQTrue[index]['questionObject'].answer_one ? widget.listQTrue[index]['questionObject'].answer_two : widget.listQTrue[index]['questionObject'].answer_one)} ',
                                S.of(context).Answer +
                                    ' ${widget.listQTrue[index]['answer']}',
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 6),
                                height: 0.5,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          title: Text(
                            widget.listQTrue[index]['questionObject'].question,
                          ),
                          trailing: Icon(
                            widget.listQTrue[index]['right'] == 1
                                ? Icons.check
                                : Icons.close,
                            color: widget.listQTrue[index]['right'] == 1
                                ? Colors.green
                                : Colors.red,
                          ),
                        );
                      },
                      itemCount: widget.listQTrue.length,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50,
                          width: 50,
                          child:
                              Image.asset('assets/quiz/button_lead_board.png'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => PlayGame(
                          //       data: widget.data,
                          //     ),
                          //   ),
                          // );
                          var heartProvider = Provider.of<CountHeartProvider>(
                            context,
                            listen: false,
                          );

                          if (heartProvider.countHeart > 0) {
                            var data =
                                widget.filterTopicChoose10(widget.idChoose);
                            Navigator.pop(context, data);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Advertise(
                                  checkOnce: false,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/quiz/button_repeat.png'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Image.asset(
                              'assets/quiz/button_play_selected.png'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
