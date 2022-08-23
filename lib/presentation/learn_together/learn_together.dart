import 'dart:math';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/learn_together/create_room.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/screens/login_account_screen.dart';
import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:app_learn_english/socket/models/table.dart' as table;
import 'package:app_learn_english/socket/utils/emit_event.dart';
import 'package:app_learn_english/socket/utils/parser_data.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:app_learn_english/widgets/search_room.dart';

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class LearnTogether extends StatefulWidget {
  final Function runningSocket;

  const LearnTogether({Key? key, required this.runningSocket})
      : super(key: key);

  @override
  State<LearnTogether> createState() => _LearnTogetherState();
}

class _LearnTogetherState extends State<LearnTogether> {
  double secondTop = 0;
  String textNhapIdPhong = '';
  String textNhapTenPhong = '';
  final _random = new Random();
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey keyButtonCreateRoom = GlobalKey();
  GlobalKey keyButtonSearch = GlobalKey();
  GlobalKey keyButtonReload = GlobalKey();
  bool _isShowTutorial = false;

  ///click vào create room để tạo phòng
  void startCreateRoom(BuildContext context) async {
    String callback = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateRoom(
                runningSocket: widget.runningSocket,
              )),
    );
  }

  setFirstListRoom(bool isFirst) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstListRoom', isFirst);
  }

  Future<bool> getFirstListRoom() async {
    var _isFirst;
    final prefs = await SharedPreferences.getInstance();
    _isFirst = (prefs.getBool('firstListRoom') != null)
        ? prefs.getBool('firstListRoom')!
        : false;

    return _isFirst;
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "keyButtonCreateRoom",
        keyTarget: keyButtonCreateRoom,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).ClickHereToCreate,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyButtonSearch",
        keyTarget: keyButtonSearch,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).ClickHereToSearch,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyButtonReload",
        keyTarget: keyButtonReload,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).ClickHereToRefresh,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
  }

  void showTutorial() {
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.black.withOpacity(0.5),
      textSkip: S.of(context).skip,
      hideSkip: true,
      paddingFocus: 10,
      alignSkip: Alignment.topLeft,
      opacityShadow: 0.8,
      onFinish: () {
        setFirstListRoom(true);
      },
      onClickTarget: (target) {
        if (target.keyTarget == keyButtonReload) {
          setFirstListRoom(true);
        }
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        setFirstListRoom(true);
      },
      onSkip: () {
        setFirstListRoom(true);
      },
    )..show();
  }

  @override
  void didChangeDependencies() async {
    var socketProvider = context.read<SocketProvider>();
    if (mounted) {
      Future.delayed(Duration.zero, () async {
        if (DataCache().getUserData().uid != 0) {
          if (socketProvider.socketChannel == null) {
            print('Đây là gọi socket bên learn together');
            widget.runningSocket();
            socketProvider.setIsShowing(true);
            socketProvider.setOpenSocket(true);
          }

          if (socketProvider.socketChannel != null) {
            socketProvider.setTable([]);
            String command = EmitEvent.emitJoinZone();
            socketProvider.socketChannel!.sink.add(command);
          }
          if (_isShowTutorial == false) {
            _isShowTutorial = true;
            getFirstListRoom().then((value) => {
                  if (value == false)
                    {Future.delayed(Duration.zero, showTutorial)}
                });
          }
        } else {
          if (!socketProvider.isShowLogin) {
            if (DataCache().tempPassWord.isEmpty) {
              _showPopupError();
            } else {
              _showPopupLogin();
            }
            socketProvider.setIsShowLogin(true);
          }
        }
      });
    }

    secondTop = -(MediaQuery.of(context).size.height * 0.3125);
    super.didChangeDependencies();
  }

  void setAnimationViewSearch(double top) {
    setState(
      () {
        if (secondTop == 0) {
          secondTop = -top;
        } else {
          secondTop = 0;
        }
      },
    );
  }

  void searchIdPhong(String query) {
    setState(() {
      this.textNhapIdPhong = query;
    });
  }

  void searchTenPhong(String query) {
    setState(() {
      this.textNhapTenPhong = query;
    });
  }

  void checkResultSearchRoom(BuildContext context) {
    var socketProvider = Provider.of<SocketProvider>(context, listen: false);
    List<table.Table> _tables = [];
    for (var item in socketProvider.listTable) {
      if (item.name!.toLowerCase() == textNhapTenPhong.toLowerCase() ||
          item.phongId.toString() == textNhapIdPhong) {
        _tables.insert(0, item);
      }
      _tables.add(item);
    }
    Provider.of<SocketProvider>(context, listen: false).setTable(_tables);
    print(
        "LengPhaantu:${_tables.length}, sockert:${socketProvider.listTable.length}");
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeProvider.mode == ThemeMode.dark
              ? const Color.fromRGBO(45, 48, 57, 1)
              : Colors.white,
          title: Row(
            children: [
              Text(
                S.of(context).OnlineClassrooms,
                style: TextStyle(
                  fontSize: 20,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              Text(
                ' ( Beta *)',
                style: TextStyle(
                  fontSize: 20,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              key: keyButtonReload,
              icon: SvgPicture.asset(
                'assets/new_ui/more/refesh.svg',
                height: 25,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () {
                var socketProvider = context.read<SocketProvider>();
                if (socketProvider.socketChannel == null) {
                  widget.runningSocket();
                  socketProvider.setIsShowing(true);
                  socketProvider.setOpenSocket(true);
                  socketProvider.setTable([]);
                  String command = EmitEvent.emitJoinZone();
                  socketProvider.socketChannel!.sink.add(command);
                } else {
                  socketProvider.setTable([]);
                  String command = EmitEvent.emitJoinZone();
                  socketProvider.socketChannel!.sink.add(command);
                }
              },
            ),
            IconButton(
              key: keyButtonSearch,
              icon: SvgPicture.asset(
                (secondTop == 0)
                    ? 'assets/new_ui/first_screen_app/ic_x.svg'
                    : 'assets/new_ui/home/ic_Search.svg',
                height: (secondTop == 0) ? 20 : 25,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () {
                setAnimationViewSearch(
                    MediaQuery.of(context).size.height * 0.3125);
              },
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: themeProvider.mode == ThemeMode.dark
                    ? Color.fromRGBO(24, 26, 33, 1)
                    : Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  thickness: 1,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.grey.shade700
                      : const Color(0xFFE4E4E4),
                  height: 1,
                ),
                Expanded(
                  child: Container(
                    child: Stack(
                      children: [
                        // AnimatedPositioned(
                        //   key: keyButtonCreateRoom,
                        //   duration: const Duration(milliseconds: 500),
                        //   child: _viewCreateRoom(context),
                        // ),
                        Column(
                          children: [
                            Expanded(child: _buildListRoom()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: S.of(context).GetBetterAt),
                                    TextSpan(
                                      text: ' Peer to Peer ',
                                      style: TextStyle(
                                        color: Colors.purple[400],
                                      ),
                                    ),
                                    TextSpan(
                                        text: S
                                            .of(context)
                                            .CommunicateWithSomeone),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ScaleTap(
                              onPressed: () {
                                if (DataCache().getUserData().uid != 0) {
                                  startCreateRoom(context);
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const LoginAccountScreen(),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 32),
                                height: 60,
                                decoration: BoxDecoration(
                                  color: ColorsUtils.Color_04D076,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    S.of(context).tao_phong,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 500),
                          top: secondTop,
                          left: 0,
                          child: _viewSearchRoom(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  //Show dialog có đăng nhập hay không
  Future _showPopupLogin() async {
    return await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).ToUseThisFeature,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LoginAccountScreen(),
                          ),
                        );
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
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     Color.fromRGBO(108, 168, 67, 1),
                          //     Color.fromRGBO(179, 220, 115, 1),
                          //   ],
                          // ),
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
                            S.of(context).Login,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
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
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     Color.fromRGBO(108, 168, 67, 1),
                          //     Color.fromRGBO(179, 220, 115, 1),
                          //   ],
                          // ),
                          color: Color(0xFFE9C145),

                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width <= 375
                              ? 60
                              : 65,
                          alignment: Alignment.center,
                          child: Text(
                            S.of(context).cancel,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Show dialog tài khoản vẫn đăng nhập vào nhưng không có mật khẩu datacache
  Future _showPopupError() async {
    return await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).AnErrorOccurredWhile,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
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
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(108, 168, 67, 1),
                              Color.fromRGBO(179, 220, 115, 1),
                            ],
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
                            'Đóng',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///View Search phòng
  Widget _viewSearchRoom() {
    return Consumer<SocketProvider>(builder: (context, socketProvider, child) {
      var themeProvider = context.watch<ThemeProvider>();
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3125,
        decoration: BoxDecoration(
            color: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(42, 44, 50, 1)
                : ColorsUtils.Color_E6E6E6,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10))),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            _viewSearchIdPhong(),
            SizedBox(
              height: 16,
            ),
            _viewSearchTenPhong(),
            SizedBox(
              height: 24,
            ),
            ScaleTap(
              onPressed: () {
                if (socketProvider.listTable.length > 0) {
                  checkResultSearchRoom(context);
                } else {
                  Utils().showNotificationBottom(
                      false, 'Hiện không có phòng học nào !');
                }
                FocusScope.of(context).unfocus();
                setAnimationViewSearch(
                    MediaQuery.of(context).size.height * 0.3125);
                printBlue(
                    "TitleIP:$textNhapIdPhong , TitleTen:$textNhapTenPhong");
              },
              child: Container(
                width: 130,
                height: 40,
                decoration: BoxDecoration(
                    color: ColorsUtils.Color_04D076,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text(
                    S.of(context).Search,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  ///View item tạo phòng
  Widget _viewCreateRoom(BuildContext context) {
    return ScaleTap(
      onPressed: () {
        //click create room
        if (DataCache().getUserData().uid != 0) {
          startCreateRoom(context);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const LoginAccountScreen(),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 12),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 730 / 1348,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15, bottom: 10),
              child: Image.asset(
                'assets/new_ui/more/banner_taophong.png',
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 650 / 1348,
            ),
            Container(
              padding: const EdgeInsets.only(left: 5),
              child: Lottie.asset(
                'assets/new_ui/animation_lottie/load_create_room.json',
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: SvgPicture.asset(
                    'assets/new_ui/home/ic_taophong2.svg',
                    height: 60,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///List các phòng
  Widget _buildListRoom() {
    return Consumer<SocketProvider>(builder: (context, socketProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: socketProvider.listTable.length > 0
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          (socketProvider.listTable.length > 0)
              ? const SizedBox()
              : _buildLoadNotRoom(),
          if (socketProvider.listTable.length > 0)
            for (int i = 0; i < socketProvider.listTable.length; i++)
              _viewItemRoom(i, socketProvider.listTable[i].isFull!),
        ],
      );
    });
  }

  ///View item room
  Widget _viewItemRoom(int index, bool isFull) {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<SocketProvider>(builder: (context, socketProvider, child) {
      return GestureDetector(
        onTap: () {
          // if (socketProvider.socketChannel!.) {

          // }
          if (isFull == false) {
            socketProvider.setVideoId(socketProvider.listTable[index].idVideo!);
            var data = {
              'idTable': socketProvider.listTable[index].matchId.toString(),
            };
            var command = ParseDataSocket.requestDataParse(1105, data);
            socketProvider.socketChannel!.sink.add(command);

            //show dialog chờ để nhận dữ liệu của phòng từ server trả về
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: _viewDialog(),
                );
              },
            );
          } else {
            Fluttertoast.showToast(
                msg: S.of(context).ThisRoomIsAlreadyFullOfLearners);
          }
        },
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child:
                              (socketProvider.listTable[index].players.length >
                                      1)
                                  ? _viewAvatarUser(
                                      socketProvider
                                          .listTable[index].players[1].avatar,
                                      socketProvider
                                          .listTable[index].players[1].name)
                                  : _buildNoUserClient(),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            child: _viewAvatarUser(
                                socketProvider
                                    .listTable[index].players[0].avatar,
                                socketProvider
                                    .listTable[index].players[0].name)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              socketProvider.listTable[index].name!,
                              style: TextStyle(
                                fontSize: 20,
                                color: themeProvider.mode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'ID:${socketProvider.listTable[index].matchId}',
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorsUtils.Color_555555,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: _viewFirmJoinOrFull(
                        socketProvider.listTable[index].isFull!),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Divider(
                color: const Color.fromRGBO(230, 230, 230, 1),
                thickness: 1,
              ),
            ),
          ],
        ),
      );
    });
  }

  ///View xác định join and full
  Widget _viewFirmJoinOrFull(bool isFull) {
    return Container(
      decoration: BoxDecoration(
        color: isFull
            ? const Color.fromRGBO(237, 113, 107, 1)
            : const Color.fromRGBO(109, 177, 93, 1),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Center(
        child: Text(
          isFull ? "Full" : "Join",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  /// View không có phòng
  Widget _buildLoadNotRoom() {
    return Center(
      child: Lottie.asset(
        'assets/new_ui/animation_lottie/shiba.json',
        height: 160,
      ),
    );
  }

  ///View show dialog chờ vào phòng
  Widget _viewDialog() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Join Room. Please Wait!",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/new_ui/more/poor.png',
              //   height: 90,
              // ),
              // const SizedBox(
              //   width: 5,
              // ),
              const PhoLoading(),
            ],
          )
        ],
      ),
    );
  }

  /// View avatar user
  Widget _viewAvatarUser(String linkAvatar, String name) {
    return Container(
      width: 50,
      height: 50,
      child: (linkAvatar.isNotEmpty)
          ? CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                linkAvatar.contains('http')
                    ? linkAvatar
                    : '${Session().BASE_IMAGES}/images/user_avatars/$linkAvatar',
              ),
            )
          : _viewAvatarNotImage(name),
    );
  }

  ///View avata user nếu user ko có avata
  List<Color> listRandomColor = [
    ColorsUtils.Color_555555,
    ColorsUtils.Color_975AE4,
    ColorsUtils.Color_EB5695,
    ColorsUtils.Color_45B649,
    ColorsUtils.Color_F3606A
  ];
  Widget _viewAvatarNotImage(String name) {
    print("Name:$name");
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: listRandomColor[_random.nextInt(listRandomColor.length)],
          borderRadius: BorderRadius.all(Radius.circular(45))),
      child: Center(
        child: Text(
          (name.isEmpty) ? 'A' : '${name[0].toUpperCase()}',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  ///View search id phòng
  Widget _viewSearchIdPhong() => SearchRoom(
        text: textNhapIdPhong,
        hintText: S.of(context).EnterRoomId,
        onChanged: searchIdPhong,
      );

  ///View search tên phòng
  Widget _viewSearchTenPhong() => SearchRoom(
        text: textNhapTenPhong,
        hintText: S.of(context).EnterName,
        onChanged: searchTenPhong,
      );

  ///View không có user khách
  Widget _buildNoUserClient() {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black26),
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Icon(
        Icons.add,
        color: Colors.green,
        size: 30,
      ),
    );
  }
}
