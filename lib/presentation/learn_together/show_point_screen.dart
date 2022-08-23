import 'dart:math';

import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/home_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/quiz/quiz_lotti_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/socket/models/list_point.dart';
import 'package:app_learn_english/socket/models/player.dart';
import 'package:app_learn_english/socket/provider/socket_provider.dart';

import 'package:app_learn_english/socket/utils/emit_event.dart';

import 'package:app_learn_english/socket/view/inside_table_screen.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ShowPointScreen extends StatefulWidget {
  final List<ListPoint> listPoint;
  final List<Player> players;
  const ShowPointScreen(
      {Key? key, required this.listPoint, required this.players})
      : super(key: key);

  @override
  State<ShowPointScreen> createState() => _ShowPointScreenState();
}

class _ShowPointScreenState extends State<ShowPointScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  String _baseURLAvatar = 'https://${Session().BASE_URL}/images/user_avatars/';
  double totalPoint1 = 0;
  double totalPoint2 = 0;
  var _random = Random();
  int numb = 0;
  List<QuizLottiModel> listLottie = [];
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    widget.listPoint[0].points.forEach((key, value) {
      totalPoint1 += value;
    });
    widget.listPoint[1].points.forEach((key, value) {
      totalPoint2 += value;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _buildRenderPoint(int index, int position) {
    String result = '0.0';
    if (position == 1) {
      widget.listPoint[0].points.forEach((key, value) {
        print('Đây là key: $key');
        print('Đây là index: ${index + 1}');
        if (int.parse('$key') == index + 1) {
          print('Đây là return:${widget.listPoint[0].points[key]} ');
          result = '${widget.listPoint[0].points[key]}';
        }
      });
      return result;
    } else {
      widget.listPoint[1].points.forEach((key, value) {
        if (int.parse('$key') == index + 1) {
          result = value.toString();
        }
      });
      return result;
    }
  }

  String _getUserWin() {
    if (totalPoint1 > totalPoint2) {
      return widget.players[0].name.toString() + ' won';
    } else if (totalPoint1 == totalPoint2) {
      return 'Summary';
    } else {
      return widget.players[1].name.toString() + ' won';
    }
  }

  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow[600]!,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.green,
    Colors.brown,
    Colors.grey,
    Colors.teal,
    Colors.lime,
  ];
  Random random = Random();

  Widget _buildFirstCharacter(String name) {
    return Text(
      name.isEmpty ? 'A' : name[0].toLowerCase(),
      style: TextStyle(
        fontSize: 62,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  bool _isState = true;

  Future getHeart() async {
    var countHeartProvider =
        Provider.of<CountHeartProvider>(context, listen: false);
    int _heart = await UserAPIs().getHeart(
      username: DataCache().getUserData().username,
      uid: DataCache().getUserData().uid,
    );
    countHeartProvider.setCountHeart(_heart);
  }

  @override
  void didChangeDependencies() async {
    if (_isState) {
      await getHeart();
      var socketProvider = context.read<SocketProvider>();
      var currentRoute = [...socketProvider.currentRoute];
      currentRoute.add('show-point');
      socketProvider.setCurrentRoute(currentRoute);

      setState(() {
        _isState = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (listLottie.isEmpty) {
      listLottie = Utils().setListLottieQuizRight(context);
      numb = _random.nextInt(listLottie.length);
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF15C68C),
              Color(0xFF0188C2),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Text(
                              _getUserWin(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(250, 253, 97, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                              height: 30,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundColor: colors[random
                                                  .nextInt(colors.length)],
                                              backgroundImage: NetworkImage(
                                                widget.players[0].avatar
                                                        .contains('https')
                                                    ? widget.players[0].avatar
                                                    : '$_baseURLAvatar${widget.players[0].avatar}',
                                              ),
                                              child: widget
                                                      .players[0].avatar.isEmpty
                                                  ? Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          _buildFirstCharacter(
                                                        widget.players[0].name,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                          ],
                                        ),
                                        if (totalPoint1 > totalPoint2)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Image.asset(
                                              'assets/new_ui/more/winner.png',
                                              width: 35,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      widget.players[0].name,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(height: 30),
                                    Text(
                                      'VS',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                            widget.players[1].avatar
                                                    .contains('http')
                                                ? widget.players[1].avatar
                                                : '$_baseURLAvatar${widget.players[1].avatar}',
                                          ),
                                          child:
                                              widget.players[1].avatar.isEmpty
                                                  ? _buildFirstCharacter(
                                                      widget.players[1].name)
                                                  : null,
                                        ),
                                        if (totalPoint1 < totalPoint2)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Image.asset(
                                              'assets/new_ui/more/winner.png',
                                              width: 35,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      widget.players[1].name,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 10),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     Text(
                          //       '$totalPoint1',
                          //       style: TextStyle(
                          //         fontSize: 20,
                          //         fontWeight: FontWeight.w600,
                          //         color: const Color.fromRGBO(250, 253, 97, 1),
                          //       ),
                          //     ),
                          //     Text(
                          //       'Total',
                          //       style: TextStyle(
                          //         fontSize: 20,
                          //         fontWeight: FontWeight.w600,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //     Text(
                          //       '$totalPoint2',
                          //       style: TextStyle(
                          //         fontSize: 20,
                          //         fontWeight: FontWeight.w600,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Lottie.asset(
                              '${listLottie[numb].lottie}',
                              height: 250,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Center(
                                child: Text(
                                  S.of(context).CongratulationsOnCompleting +
                                      ' +1 Exp',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            var socketProvider = context.read<SocketProvider>();
                            socketProvider.setReadyUser(false);
                            var currentRoute = [...socketProvider.currentRoute];
                            if (currentRoute.isNotEmpty) {
                              currentRoute.removeAt(currentRoute.length - 1);
                              socketProvider.setCurrentRoute(currentRoute);
                            }
                            socketProvider.setReadyUser(false);
                            Navigator.of(context).pop();
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
                              height: MediaQuery.of(context).size.width <= 375
                                  ? 60
                                  : 65,
                              alignment: Alignment.center,
                              child: Text(
                                S.of(context).Playagain,
                                style: TextStyle(
                                  fontSize: 23,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            var socketProvider = context.read<SocketProvider>();
                            var currentRoute = [...socketProvider.currentRoute];
                            if (socketProvider.currentRoute.isEmpty) {
                              currentRoute.removeAt(currentRoute.length - 1);
                              socketProvider.setCurrentRoute(currentRoute);
                              context.read<HomeProvider>().setIndex(0);
                              Navigator.of(context).pop();
                            } else {
                              if (socketProvider.currentRoute[0] ==
                                  InsideTableScreen.routeName) {
                                currentRoute.removeAt(currentRoute.length - 1);
                                socketProvider.setCurrentRoute(currentRoute);
                                context.read<HomeProvider>().setIndex(0);
                                Navigator.of(context).pop();
                                String command = EmitEvent.emitCancel(
                                    idTable: socketProvider.idTableInside);
                                socketProvider.socketChannel!.sink.add(command);
                              } else {
                                currentRoute.removeAt(currentRoute.length - 1);
                                socketProvider.setCurrentRoute(currentRoute);
                                context.read<HomeProvider>().setIndex(0);
                                Navigator.of(context).pop();
                              }
                            }
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
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFDBB644),
                                  Color(0xFFF8D056),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.width <= 375
                                  ? 60
                                  : 65,
                              alignment: Alignment.center,
                              child: Text(
                                S.of(context).BackToHome,
                                style: TextStyle(
                                  fontSize: 23,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
