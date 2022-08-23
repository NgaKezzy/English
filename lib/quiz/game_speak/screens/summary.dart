import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/listen_item.dart';
import 'package:app_learn_english/quiz/game_speak/screens/advertise2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Summary extends StatefulWidget {
  const Summary({
    Key? key,
    required this.listQTrue,
    required this.data,
    required this.filterTopicChoose10,
    required this.idChoose,
  }) : super(key: key);
  final List<Map<String, dynamic>> listQTrue;
  final List<ListenItem> data;
  final Function filterTopicChoose10;
  final int idChoose;

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  int totalTrue = 0;

  @override
  void didChangeDependencies() {
    for (var item in widget.listQTrue) {
      if (int.parse('${item["right"]}') == 1) {
        totalTrue++;
      }
    }
    super.didChangeDependencies();
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
              padding: const EdgeInsets.only(top: 36),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      totalTrue < 3
                          ? S.of(context).YouNeedToTryHarder
                          : S.of(context).YouDidAGreatJob,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Divider(
                    height: 2,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                      itemCount: widget.listQTrue.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).Answer +
                                    '${widget.listQTrue[index]['answer']}',
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 6),
                                height: 0.5,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          title: Text(
                            widget.listQTrue[index]['questionObject']
                                .two_question,
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
                          //       builder: (context) =>
                          //           Playing(data: widget.data)),
                          // );
                          // SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();

                          // var count = prefs.getInt("count_heart_game1");
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => WaitScreen(),
                          //   ),
                          // );
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
