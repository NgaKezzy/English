import 'dart:async';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/user_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/profile/widgets/user_statement.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/socket/models/table.dart' as table;
import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:app_learn_english/socket/utils/constant.dart';
import 'package:app_learn_english/socket/utils/emit_event.dart';
import 'package:app_learn_english/socket/utils/parser_data.dart';
import 'package:app_learn_english/socket/utils/signaling.dart';
import 'package:app_learn_english/socket/view/widgets/record_chat_item.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InsideTableScreen extends StatefulWidget {
  static const routeName = '/inside-table';

  @override
  State<InsideTableScreen> createState() => _InsideTableScreenState();
}

class _InsideTableScreenState extends State<InsideTableScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late YoutubePlayerController _controllerYoutube;
  late table.Table tableInfo;
  late List<TalkDetailModel> listTalk;

  final secs = Duration(seconds: 1);

  int _start = 15;
  double _progressCountDownOwn = 1;
  double _progressCountDownClient = 1;
  List<double> _count = [15, 15];
  bool _endTurn = false;
  int _turn = 5;
  int _countScreen = 0;
  int index = 0;
  int indextLanguage = 0;
  CountdownController _ctroller = CountdownController(autoStart: true);
  CountdownController _ctrollerCount = CountdownController(autoStart: true);
  CountdownController _ctrollerHide = CountdownController(autoStart: true);
  Signaling signaling = Signaling();
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _onConnectStream = true;
  bool _hideAnimation = false;
  bool _autoStart = true;
  String _baseURLAvatar =
      'https://${Session().BASE_IMAGES}/images/user_avatars/';
  late int idTable;
  bool _isPlaying = false;
  final carouselController = CarouselController();
  int _indexTab = 0;
  List<String> language = [];
  bool isOff = false;
  bool _isOpenCamera = false;

  double _countNum = 10;

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey keyButtonInvite = GlobalKey();
  GlobalKey keyButtonOpenCamera = GlobalKey();
  GlobalKey keyButtonExit = GlobalKey();
  bool _isTutorial = false;

  //index test sub
  int idx = 0;
  late Timer _timeCount;

  void _countDownTurn() {
    _timeCount = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countNum < 0) {
        timer.cancel();
        setState(() {
          _countNum = 10;
        });
      } else {
        setState(() {
          _countNum--;
        });
      }
    });
  }

  setFirstJoinRoom(bool isFirst) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstJoinRoom', isFirst);
  }

  Future<bool> getFirstJoinRoom() async {
    var _isFirst;
    final prefs = await SharedPreferences.getInstance();
    _isFirst = (prefs.getBool('firstJoinRoom') != null)
        ? prefs.getBool('firstJoinRoom')!
        : false;

    return _isFirst;
  }

  void _listener() {
    var socketProvider = context.read<SocketProvider>();
    if (_isPlaying && mounted) {
      // print('Đù má đây là state:  ${_controllerYoutube.value.playerState}');
      if (_controllerYoutube.value.playerState == PlayerState.buffering) {
        _controllerYoutube.play();
      }
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
      if (_indexTab == 0) {
        carouselController.jumpToPage(socketProvider.idxTurn);
      }
      if (socketProvider.idxTurn + 1 == listTalk.length) {
        if (_controllerYoutube.value.position.inSeconds ==
            Duration(milliseconds: listTalk[socketProvider.idxTurn].endTime)
                .inSeconds) {
          _controllerYoutube.seekTo(Duration(
              milliseconds: listTalk[socketProvider.idxTurn].startTime));
          _controllerYoutube.removeListener(_listener);
          _controllerYoutube.addListener(_listener);
        }
      } else {
        if (_controllerYoutube.value.position.inSeconds ==
            Duration(
                    milliseconds:
                        listTalk[socketProvider.idxTurn + 1].startTime)
                .inSeconds) {
          print('Đây là indexTurn: ${socketProvider.idxTurn}');
          try {
            print(
                'Đây là thời gian: ${listTalk[socketProvider.idxTurn].startTime}');
            _controllerYoutube.removeListener(_listener);
            _controllerYoutube.seekTo(Duration(
                seconds: Duration(
                        milliseconds:
                            listTalk[socketProvider.idxTurn].startTime)
                    .inSeconds));
            _controllerYoutube.addListener(_listener);
          } catch (e) {
            print(e);
          }
          ;
        }
      }
    }
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "keyButtonInvite",
        keyTarget: keyButtonInvite,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).ClickHereToInviteYour,
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
        shape: ShapeLightFocus.Circle,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyButtonOpenCamera",
        keyTarget: keyButtonOpenCamera,
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
                      S.of(context).ClickHereVideoCall,
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
        shape: ShapeLightFocus.Circle,
        radius: 5,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyButtonExit",
        keyTarget: keyButtonExit,
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
                      S.of(context).ClickHereToEscape,
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
        shape: ShapeLightFocus.Circle,
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
        print("finish");
      },
      onClickTarget: (target) {
        if (target.keyTarget == keyButtonExit) {
          setFirstJoinRoom(true);
        }
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        setFirstJoinRoom(true);
      },
      onSkip: () {
        setFirstJoinRoom(true);
      },
    )..show();
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    print('Biến thiên');
    if (_onConnectStream) {
      var socketProvider = context.read<SocketProvider>();
      var localProvider = context.read<LocaleProvider>();
      // socketProvider.setSignaling(signaling);
      // socketProvider.setLocalVideo(_localRenderer);
      idTable = socketProvider.idTableInside;
      await signaling.openUserMedia(localRenderer, _remoteRenderer);
      final dataReceiver =
          ModalRoute.of(context)!.settings.arguments as Map<String, bool>;
      print('Đây là data Receiver $dataReceiver');
      if (dataReceiver['isCreate'] == true) {
        await signaling.createRoom(_remoteRenderer, idTable.toString());
      } else {
        await signaling.joinRoom(idTable.toString(), _remoteRenderer);
      }

      DataTalk? dataTalk =
          await TalkAPIs().detailVideo(id: socketProvider.videoId!.toString());
      print('Đây là video id ${socketProvider.videoId!}');
      listTalk = await TalkAPIs().getListSubVideo(
          socketProvider.videoId!, localProvider.codeLangeSub ?? 'en');
      _controllerYoutube = YoutubePlayerController(
        initialVideoId: dataTalk!.yt_id,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          hideControls: true,
          hideThumbnail: true,
          enableCaption: false,
          mute: true,
          startAt: Duration(milliseconds: listTalk[0].startTime).inSeconds,
          endAt: Duration(milliseconds: listTalk[listTalk.length - 1].endTime)
                  .inSeconds +
              10,
        ),
      );

      var mirrorCurrentRoute = [...socketProvider.currentRoute];
      if (mirrorCurrentRoute.length >= 2) {
        mirrorCurrentRoute = [];
      }
      mirrorCurrentRoute.add(InsideTableScreen.routeName);
      socketProvider.setCurrentRoute(mirrorCurrentRoute);
      _controller.addListener(() {
        if (_controller.isCompleted) {
          setState(() {
            _hideAnimation = true;
          });
          // if (_autoStart) {
          //   context.read<SocketProvider>().socketChannel!.sink.add(
          //           ParseDataSocket.requestDataParse(
          //               ConstantsCodeSocket.ready, {
          //         'idTable': tableInfo.phongId,
          //       }));

          //   context.read<SocketProvider>().socketChannel!.sink.add(
          //           ParseDataSocket.requestDataParse(
          //               ConstantsCodeSocket.start, {
          //         'idTable': tableInfo.phongId,
          //       }));
          // }
        }
      });
      var localeProvider = context.read<LocaleProvider>();
      language = [
        'ALL',
        'EN',
        localeProvider.locale!.languageCode.toUpperCase(),
        'OFF'
      ];

      setState(() {
        _onConnectStream = false;
      });
    }
    if (_isTutorial == false) {
      _isTutorial = true;
      getFirstJoinRoom().then((value) => {
            if (value == false) {Future.delayed(Duration.zero, showTutorial)}
          });
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    print('nhảy vào huỷ inside table');
    signaling.hangUp(localRenderer, idTable.toString());
    localRenderer.dispose();
    _remoteRenderer.dispose();
    _controller.dispose();
    _controllerYoutube.dispose();
    _timeCount.cancel();
  }

  Color _buildColor(int idx) {
    if (tableInfo.players.length > 1) {
      if (tableInfo.nextTurn == DataCache().getUserData().uid &&
          context.read<SocketProvider>().idxTurn == idx) {
        return Colors.green;
      } else if (tableInfo.nextTurn == tableInfo.players[1].id &&
          context.read<SocketProvider>().idxTurn == idx) {
        return Colors.red;
      } else {
        return const Color.fromRGBO(230, 230, 230, 1);
      }
    } else {
      return const Color.fromRGBO(230, 230, 230, 1);
    }
  }

  Widget _buildItemSlider(int index, table.Table table) {
    return Consumer<LocaleProvider>(
      builder: (_, localeProvider, child) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _buildColor(index),
            width: 1.2,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            isOff
                ? Container(
                    child: Text(
                      '[${S.of(context).SubtitlesAreHiding}]',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      indextLanguage == 2
                          ? const SizedBox()
                          : Text(
                              listTalk[index].content,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                      const SizedBox(
                        height: 30,
                      ),
                      if (localeProvider.locale!.languageCode.toUpperCase() ==
                              'EN' &&
                          indextLanguage == 2)
                        Container(
                          child: Text(
                            '[${S.of(context).SubtitlesAreHiding}]',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      if (localeProvider.locale!.languageCode.toUpperCase() !=
                              'EN' &&
                          indextLanguage != 2)
                        indextLanguage == 1
                            ? const SizedBox()
                            : Text(
                                Utils.changeLanguageTalkShowModel(
                                    localeProvider.locale!.languageCode,
                                    index,
                                    listTalk),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: const Color.fromRGBO(109, 106, 106, 1),
                                ),
                              ),
                    ],
                  ),
            const Expanded(
              child: SizedBox(),
            ),
            Row(
              children: [
                Text(
                  '${index + 1}/',
                  style: const TextStyle(
                    fontSize: 18,
                    color: const Color.fromRGBO(109, 106, 106, 1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${listTalk.length}',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromRGBO(109, 106, 106, 1),
                  ),
                ),
                // InkWell(
                //   child: SvgPicture.asset(
                //     'assets/new_ui/more/+.svg',
                //     height: 40,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _exitRoom() {
    var socketProvider = context.read<SocketProvider>();
    if (socketProvider.socketChannel != null) {
      if (socketProvider.listTable.isEmpty) {
        Navigator.of(context).pop();
        print('Thử vào đây');
      } else {
        String exit = EmitEvent.emitCancel(
          idTable: context.read<SocketProvider>().idTableInside,
        );
        socketProvider.socketChannel!.sink.add(exit);
        print('đù má vào');
      }
      Navigator.of(context).pop();
      print('Đây đây đây');
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  Widget _buildSlider(table.Table table) {
    return CarouselSlider.builder(
      carouselController: carouselController,
      itemCount: listTalk.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          _buildItemSlider(itemIndex, table),
      options: CarouselOptions(
        height: 240,
        viewportFraction: 0.95,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        scrollPhysics: const BouncingScrollPhysics(),
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
    );
  }

  Future _buildDialog() async {
    return await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height / 3,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).ban_co_muon_thoat_ban,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _exitRoom,
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
                        height:
                            MediaQuery.of(context).size.width <= 375 ? 60 : 65,
                        alignment: Alignment.center,
                        child: Text(
                          S.of(context).dong_y,
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
                      Navigator.of(context).pop(false);
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
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: double.infinity,
                        height:
                            MediaQuery.of(context).size.width <= 375 ? 60 : 65,
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
    );
  }

  void _callReady(int isReady) {
    String command = EmitEvent.emitReady(
        idTable:
            tableInfo.matchId ?? context.read<SocketProvider>().idTableInside,
        isReady: isReady);
    print('Đây là command ready: ' + command);
    context.read<SocketProvider>().socketChannel!.sink.add(command);
  }

  Widget _buildNextTurn() {
    return Container(
      width: 120,
      child: ElevatedButton(
        onPressed: () async {
          var socketProvider = context.read<SocketProvider>();
          // Bắn turn lên server
          String command = EmitEvent.emitTurn(
            idTable: socketProvider.idTableInside,
            zoneId: ConfigSocket.zoneId,
            score: 20,
            subId: listTalk[socketProvider.idxTurn].id,
            vid: socketProvider.videoId!,
            voiceConvert: listTalk[socketProvider.idxTurn].content,
          );
          print(command);
          socketProvider.socketChannel!.sink.add(command);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFF04D076),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width <= 375 ? 50 : 45,
            alignment: Alignment.center,
            child: Text(
              S.of(context).Next,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.read<ThemeProvider>();
    var socketProvider = context.watch<SocketProvider>();
    if (socketProvider.listTable.isNotEmpty) {
      tableInfo = socketProvider.listTable.firstWhere(
        (element) => element.matchId == socketProvider.idTableInside,
      );
    }
    if (tableInfo.isPlaying == 1) {
      if (tableInfo.nextTurn == DataCache().getUserData().uid) {
        Fluttertoast.showToast(msg: S.of(context).dlcb);
        _ctrollerHide = CountdownController(autoStart: true);
        // _ctrollerCount = CountdownController(autoStart: true);
        _ctrollerCount.restart();
        _ctroller = CountdownController(autoStart: true);
        signaling.openMicro(localRenderer, _remoteRenderer);
      } else {
        _ctrollerHide = CountdownController(autoStart: true);
        // _ctrollerCount = CountdownController(autoStart: true);
        _ctrollerCount.restart();
        _ctroller = CountdownController(autoStart: true);
        Fluttertoast.showToast(msg: S.of(context).dldt);
        signaling.muteMicro(localRenderer, _remoteRenderer);
      }
    }

    return _onConnectStream
        ? Scaffold(
            body: Center(
              child: const PhoLoading(),
            ),
          )
        : Stack(
            children: [
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  onReady: () {
                    _isPlaying = true;
                  },
                  controller: _controllerYoutube..addListener(_listener),
                  topActions: [
                    InkWell(
                      onTap: () async {
                        _buildDialog();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                builder: (contextPlayer, player) => WillPopScope(
                  onWillPop: () async {
                    _buildDialog();
                    return false;
                  },
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Scaffold(
                      backgroundColor: themeProvider.mode == ThemeMode.dark
                          ? Colors.grey[850]
                          : Colors.grey[100],
                      body: SafeArea(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            child: Column(
                              children: [
                                _isOpenCamera
                                    ? Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: RTCVideoView(
                                                _remoteRenderer,
                                              ),
                                            ),
                                            Expanded(
                                              child: RTCVideoView(
                                                localRenderer,
                                                mirror: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : player,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            color: themeProvider.mode ==
                                                    ThemeMode.dark
                                                ? Colors.grey[850]
                                                : Colors.grey[100],
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: TabBar(
                                                  indicatorSize:
                                                      TabBarIndicatorSize.label,
                                                  onTap: (indx) {
                                                    setState(() {
                                                      _indexTab = indx;
                                                    });
                                                  },
                                                  labelPadding: EdgeInsets.only(
                                                      bottom: 10),
                                                  indicatorColor: Colors.green,
                                                  labelColor: Colors.green,
                                                  labelStyle: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width <=
                                                                375
                                                            ? 15
                                                            : 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  unselectedLabelColor:
                                                      themeProvider.mode ==
                                                              ThemeMode.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                  tabs: [
                                                    AutoSizeText(
                                                      S
                                                          .of(context)
                                                          .SampleSentences,
                                                      maxLines: 1,
                                                    ),
                                                    AutoSizeText(
                                                      S
                                                          .of(context)
                                                          .Conversation,
                                                      maxLines: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              ScaleTap(
                                                onPressed: () {
                                                  _buildDialog();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: SvgPicture.asset(
                                                    'assets/new_ui/more/out-room.svg',
                                                    color: themeProvider.mode ==
                                                            ThemeMode.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                              ScaleTap(
                                                onPressed: () {
                                                  Future.delayed(
                                                      Duration(seconds: 1), () {
                                                    _controllerYoutube.play();
                                                    _controllerYoutube.mute();
                                                  });
                                                  setState(() {
                                                    _isOpenCamera =
                                                        !_isOpenCamera;
                                                  });
                                                  //       });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: SvgPicture.asset(
                                                    !_isOpenCamera
                                                        ? 'assets/new_ui/more/turn-on-cam.svg'
                                                        : 'assets/new_ui/more/turn-off-cam.svg',
                                                    color: themeProvider.mode ==
                                                            ThemeMode.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                              ScaleTap(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return _viewDialogSetting();
                                                      });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: SvgPicture.asset(
                                                    'assets/new_ui/more/Iconly-Light-Setting.svg',
                                                    color: themeProvider.mode ==
                                                            ThemeMode.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                        color: ColorsUtils.Color_62646B
                                            .withOpacity(0.5),
                                        height: 1,
                                      ),
                                      Expanded(
                                          child: TabBarView(children: [
                                        SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              _buildSlider(tableInfo),
                                              const SizedBox(height: 30),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: context
                                                      .read<ThemeProvider>()
                                                      .mode ==
                                                  ThemeMode.dark
                                              ? Colors.grey[850]
                                              : Colors.grey[100],
                                          child: Center(
                                            child: tableInfo.players.length >= 2
                                                ? _viewListConversation()
                                                : Center(
                                                    child: Text(
                                                      S.of(context).waiting,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                          ),
                                        )
                                      ])),
                                      _viewBottomAvatarUser()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // tableInfo.players.length > 1 && _hideAnimation == false
                  //     ? Lottie.asset(
                  //         'assets/new_ui/animation_lottie/count_down.json',
                  //         controller: _controller,
                  //         onLoaded: (composition) {
                  //           // Configure the AnimationController with the duration of the
                  //           // Lottie file and start the animation.
                  //           _controller..duration = composition.duration;
                  //           Future.delayed(Duration(seconds: 2), () {
                  //             _controller.forward();
                  //           });
                  //         },
                  //       )
                  //     : const SizedBox(),
                ),
              ),
              // Positioned(
              //   right: 30,
              //   top: MediaQuery.of(context).size.height / 1.3,
              //   child: FloatingActionButton(
              //     key: keyButtonExit,
              //     onPressed: () async {
              //       _buildDialog();
              //     },
              //     child: SvgPicture.asset(
              //       'assets/new_ui/more/btn_exit.svg',
              //       width: 70,
              //     ),
              //   ),
              // ),
              // Positioned(
              //   right: MediaQuery.of(context).size.width / 2.35,
              //   top: MediaQuery.of(context).size.height / 1.3,
              //   child: FloatingActionButton(
              //     onPressed: () async {
              //       _buildDialog();
              //     },
              //     child: SvgPicture.asset(
              //       'assets/new_ui/more/btn_rec.svg',
              //       width: 70,
              //     ),
              //   ),
              // ),
              // Positioned(
              //   left: 30,
              //   top: MediaQuery.of(context).size.height / 1.3,
              //   child: FloatingActionButton(
              //     key: keyButtonOpenCamera,
              //     onPressed: () async {
              //       Future.delayed(Duration(seconds: 1), () {
              //         _controllerYoutube.play();
              //         _controllerYoutube.mute();
              //       });
              //       setState(() {
              //         _isOpenCamera = !_isOpenCamera;
              //       });
              //     },
              //     child: !_isOpenCamera
              //         ? SvgPicture.asset(
              //             'assets/new_ui/more/btn_camera_on.svg',
              //             height: 60,
              //           )
              //         : SvgPicture.asset(
              //             'assets/new_ui/more/btn_camera_off.svg',
              //             height: 60,
              //           ),
              //   ),
              // ),
            ],
          );
  }

  ///View list hội thoại
  Widget _viewListConversation() {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: context.read<ThemeProvider>().mode == ThemeMode.dark
            ? Colors.grey[850]
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(5),
      ),
      child: SingleChildScrollView(
        child: (tableInfo.messages.length > 0)
            ? Column(
                children: [
                  for (int i = 0; i < tableInfo.messages.length; i++)
                    RecordChatItem(
                      textRecord: tableInfo.messages[i].message == 'null'
                          ? listTalk[i].content
                          : tableInfo.messages[i].message,
                      isOwnerRoom: i % 2 == 0 ? true : false,
                      linkAvatar: i % 2 == 0
                          ? tableInfo.players[0].avatar
                          : tableInfo.players[1].avatar,
                      name: i % 2 == 0
                          ? tableInfo.players[0].name
                          : tableInfo.players[1].name,
                      color: i % 2 == 0 ? Colors.purple : Colors.orange,
                    ),
                ],
              )
            : _viewNoChat(),
      ),
    );
  }

  ///View Bottom avata
  Widget _viewBottomAvatarUser() {
    return Consumer<SocketProvider>(
      builder: (context, socketProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (tableInfo.players.length > 0)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: _viewShowDialogInfoUser(
                                    tableInfo.players[0].id.toString()));
                          });
                    },
                    child: _buildUICount(
                        _count[0],
                        tableInfo.players[0].name,
                        tableInfo.players[0].avatar,
                        tableInfo.isPlaying == 1 ? true : false,
                        tableInfo.nextTurn!,
                        tableInfo.players[0].id,
                        true,
                        tableInfo.players[0].isReady),
                  ),
                ),
              tableInfo.players.length > 1
                  ? _buildVideoActionStart(tableInfo.isPlaying, socketProvider)
                  : const SizedBox(),
              (tableInfo.players.length > 1)
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: _viewShowDialogInfoUser(
                                        tableInfo.players[1].id.toString()));
                              });
                        },
                        child: _buildUICount(
                          _count[1],
                          tableInfo.players[1].name,
                          tableInfo.players[1].avatar,
                          tableInfo.isPlaying == 1 ? true : false,
                          tableInfo.nextTurn!,
                          tableInfo.players[1].id,
                          false,
                          tableInfo.players[1].isReady,
                        ),
                      ),
                    )
                  : InkWell(
                      key: keyButtonInvite,
                      onTap: () {
                        Map<String, dynamic> dataGetFriend = {'countFriend': 0};
                        String commandGetFriend =
                            ParseDataSocket.requestDataParse(
                          ConstantsCodeSocket.getListFrient,
                          dataGetFriend,
                        );
                        var socketProvider = context.read<SocketProvider>();
                        socketProvider.socketChannel!.sink
                            .add(commandGetFriend);
                        socketProvider.setPage(0);
                      },
                      child: _buildNoUserClient(),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBtnCancel(SocketProvider socketProvider) {
    return Container(
      width: 120,
      child: ElevatedButton(
        onPressed: () async {
          socketProvider.isReadyUser ? _callReady(0) : _callReady(1);
          _controllerYoutube
              .seekTo(Duration(milliseconds: listTalk[0].startTime));
          _ctrollerCount = CountdownController(autoStart: true);
          _ctroller = CountdownController(autoStart: true);
          _ctrollerHide = CountdownController(autoStart: true);
          _ctrollerHide = CountdownController(autoStart: true);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: socketProvider.isReadyUser
                ? const Color(0xFFE74C3C)
                : const Color(0xFF04D076),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width <= 375 ? 50 : 45,
            alignment: Alignment.center,
            child: Text(
              socketProvider.isReadyUser
                  ? S.of(context).bo_san_sang
                  : S.of(context).san_sang,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///View show không có hội thoại
  Widget _viewNoChat() {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: context.read<ThemeProvider>().mode == ThemeMode.dark
                ? Colors.grey[850]
                : Colors.grey[100],
            child: Center(child: const PhoLoading()),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            S.of(context).hien_chua_co_hoi_thoai_nao,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget _buildBtnStart(SocketProvider socketProvider, bool isStart) {
    return Container(
      width: 120,
      child: ElevatedButton(
        onPressed: () {
          if (isStart) {
            String commandReady =
                EmitEvent.emitReady(idTable: tableInfo.phongId!, isReady: 1);
            context
                .read<SocketProvider>()
                .socketChannel!
                .sink
                .add(commandReady);

            String command = EmitEvent.emitStart(idTable: tableInfo.phongId!);
            context.read<SocketProvider>().socketChannel!.sink.add(command);
            _ctrollerCount = CountdownController(autoStart: true);
            _ctroller = CountdownController(autoStart: true);
            _ctrollerHide = CountdownController(autoStart: true);
            _controllerYoutube
                .seekTo(Duration(milliseconds: listTalk[0].startTime));
          } else {
            Fluttertoast.showToast(
                msg: S.of(context).dang_cho_nguoi_khac_de_bat_dau);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: socketProvider.isReadyUser
                ? const Color(0xFFE74C3C)
                : const Color(0xFF04D076),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width <= 375 ? 50 : 45,
            alignment: Alignment.center,
            child: Text(
              S.of(context).bat_dau,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///View action start
  Widget _buildVideoActionStart(int isPlaying, SocketProvider socketProvider) {
    if (isPlaying == 0) {
      if (tableInfo.players[0].id == DataCache().getUserData().uid) {
        if (tableInfo.players[1].isReady) {
          return _buildBtnStart(socketProvider, true);
        } else {
          return _buildBtnStart(socketProvider, false);
        }
      }
      return _buildBtnCancel(socketProvider);
    } else {
      return Column(
        children: [
          _viewShowTextVS(),
          DataCache().getUserData().uid == tableInfo.nextTurn
              ? Countdown(
                  seconds: 15,
                  controller: _ctrollerHide,
                  onFinished: () {
                    _ctrollerHide.restart();
                  },
                  build: (_, second) {
                    if (second < 10) {
                      return _buildNextTurn();
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              : const SizedBox(),
        ],
      );
    }
  }

  Widget _viewShowTextVS() {
    return Countdown(
      seconds: 15,
      controller: _ctrollerCount,
      onFinished: () {
        _ctrollerCount.restart();
      },
      build: (_, timer) => Center(
        child: Text(
          "${timer.toInt().toString()}s",
          style: TextStyle(
            color: const Color.fromRGBO(237, 110, 105, 1),
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

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

  ///View hiển thị avatar user
  Widget _builAvatarCircle(String imageUrl, bool isOwn, String name) {
    var userProfile = context.read<UserProvider>();
    return Container(
      height: 45,
      width: 45,
      child: imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: CachedNetworkImage(
                imageUrl: userProfile.avatarUser!,
                width: 45,
                height: 45,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: const PhoLoading(),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/linh_vat/linhvat2.png',
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsUtils.Color_975AE4,
              ),
              child: Center(
                child: Text(
                  name.isEmpty
                      ? '${'A'.toUpperCase()}'
                      : '${name[0].toUpperCase()}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
    );
  }

  Widget _buildCircleCountTime() {
    return Countdown(
      seconds: 15,
      onFinished: () {
        var socketProvider = context.read<SocketProvider>();
        var dataUser = DataCache().getUserData();
        if (dataUser.uid == tableInfo.players[0].id &&
            tableInfo.nextTurn == dataUser.uid) {
          // Bắn turn lên server
          String command = EmitEvent.emitTurn(
            idTable: socketProvider.idTableInside,
            zoneId: ConfigSocket.zoneId,
            score: 20,
            subId: listTalk[socketProvider.idxTurn].id,
            vid: socketProvider.videoId!,
            voiceConvert: listTalk[socketProvider.idxTurn].content,
          );
          print(command);
          socketProvider.socketChannel!.sink.add(command);

          print('Có bắn nhé');
        } else if (dataUser.uid == tableInfo.players[1].id &&
            tableInfo.nextTurn == dataUser.uid) {
          // Bắn turn lên server
          String command = EmitEvent.emitTurn(
            idTable: socketProvider.idTableInside,
            zoneId: ConfigSocket.zoneId,
            score: 20,
            subId: listTalk[socketProvider.idxTurn].id,
            vid: socketProvider.videoId!,
            voiceConvert: listTalk[socketProvider.idxTurn].content,
          );
          print(command);
          socketProvider.socketChannel!.sink.add(command);
          print('Lại bắn');
        }
        idx++;
        if (socketProvider.isReady) {
          _ctroller.restart();
        } else {
          _ctroller.pause();
        }
      },
      controller: _ctroller,
      build: (ctx, second) {
        return Container(
          height: 50,
          width: 50,
          child: SfRadialGauge(
            axes: [
              RadialAxis(
                minimum: 0,
                maximum: 15,
                showLabels: false,
                showTicks: false,
                startAngle: 270,
                endAngle: 270,
                axisLineStyle: AxisLineStyle(
                  thickness: 0.1,
                  color: Colors.grey,
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: second,
                    width: 0.1,
                    sizeUnit: GaugeSizeUnit.factor,
                    cornerStyle: CornerStyle.startCurve,
                    color: Colors.green,
                  ),
                  MarkerPointer(
                    value: second,
                    markerType: MarkerType.circle,
                    color: Colors.green,
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _builTimerCount(
      double seconds,
      String imageUrl,
      bool isPlaying,
      int currentTurnId,
      int playerId,
      bool isOwn,
      bool isReadyUser,
      String name) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _builAvatarCircle(imageUrl, isOwn, name),
        isPlaying
            ? (currentTurnId == playerId
                ? _buildCircleCountTime()
                : const SizedBox())
            : const SizedBox(),
        !isPlaying
            ? (isReadyUser
                ? const Icon(
                    Icons.check,
                    size: 50,
                    color: Colors.green,
                  )
                : const SizedBox())
            : const SizedBox(),
      ],
    );
  }

  ///View hiển thị user
  Widget _buildUICount(
      double seconds,
      String name,
      String imageUrl,
      bool isPlaying,
      int currentTurnId,
      int playerId,
      bool isMaster,
      bool isReadyUser) {
    return Container(
      child: Row(
        mainAxisAlignment:
            isMaster ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (isMaster == false)
              ? Expanded(
                  child: _viewInfoUserClient(
                      name, isMaster, currentTurnId, playerId, isPlaying),
                )
              : _builTimerCount(seconds, imageUrl, isPlaying, currentTurnId,
                  playerId, isMaster, isReadyUser, name),
          const SizedBox(
            width: 5,
          ),
          (isMaster == true)
              ? Expanded(
                  child: _viewInfoUser(
                      name, isMaster, currentTurnId, playerId, isPlaying),
                )
              : _builTimerCount(seconds, imageUrl, isPlaying, currentTurnId,
                  playerId, isMaster, isReadyUser, name),
        ],
      ),
    );
  }

  ///Widget thông tin user chủ phòng
  Widget _viewInfoUser(String name, bool isOwn, int currentTurnId, int playerId,
      bool isPlaying) {
    return Consumer<SocketProvider>(builder: (context, socketProvider, child) {
      var themeProvider = context.watch<ThemeProvider>();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$name',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              // context.read<SocketProvider>().socketChannel!.sink.add(
              //   ParseDataSocket.convertSendDataParseTurn(
              //     idTable: widget.idTable,
              //     zoneId: 81,
              //     vid: 192,
              //     subId: listTalk[index].id,
              //     voiceConvert: listTalk[index].content,
              //     score: 50,
              //   ),
              // );
            },
            child: isPlaying
                ? (currentTurnId == playerId
                    ? InkWell(
                        child: SvgPicture.asset(
                          'assets/new_ui/more/Iconly-Light-Voice.svg',
                          height: 25,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Center(
                                child: AvatarGlow(
                                  animate: true,
                                  glowColor: Theme.of(context).primaryColor,
                                  endRadius: 75.0,
                                  duration: const Duration(milliseconds: 2000),
                                  repeatPauseDuration:
                                      const Duration(milliseconds: 100),
                                  repeat: true,
                                  child: FloatingActionButton(
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.mic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : SvgPicture.asset(
                        'assets/new_ui/more/Voice_dis.svg',
                        height: 25,
                      ))
                : SvgPicture.asset(
                    'assets/new_ui/more/Voice_dis.svg',
                    height: 25,
                  ),
          )
        ],
      );
    });
  }

  ///Widget thông tin user khách
  Widget _viewInfoUserClient(String name, bool isOwn, int currentTurnId,
      int playerId, bool isPlaying) {
    return Consumer<SocketProvider>(builder: (context, socketProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$name',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                overflow: TextOverflow.ellipsis),
          ),
          GestureDetector(
            onTap: () {
              // context.read<SocketProvider>().socketChannel!.sink.add(
              //   ParseDataSocket.convertSendDataParseTurn(
              //     idTable: widget.idTable,
              //     zoneId: 81,
              //     vid: 192,
              //     subId: listTalk[index].id,
              //     voiceConvert: listTalk[index].content,
              //     score: 50,
              //   ),
              // );
            },
            child: isPlaying
                ? (currentTurnId == playerId
                    ? SvgPicture.asset(
                        'assets/new_ui/more/Iconly-Light-Voice.svg',
                        height: 25,
                      )
                    : SvgPicture.asset(
                        'assets/new_ui/more/Voice_dis.svg',
                        height: 25,
                      ))
                : SvgPicture.asset(
                    'assets/new_ui/more/Voice_dis.svg',
                    height: 25,
                  ),
          )
        ],
      );
    });
  }

  ///View show dialog info user
  Widget _viewShowDialogInfoUser(String uId) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              S.of(context).thong_tin,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 1,
            color: ColorsUtils.Color_555555,
          ),
          FutureBuilder(
            future: UserAPIs().fetchDataUser(uId),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text('call data failed');
              }
              return snapshot.hasData
                  ? _viewProfileUser(snapshot.data)
                  : Center(
                      child: const PhoLoading(),
                    );
            },
          ),
        ],
      ),
    );
  }

  ///View profile của user
  Widget _viewProfileUser(DataUser dataUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 16),
          child: Row(
            children: [
              (dataUser.avatar.isEmpty)
                  ? ClipRRect(
                      child: Container(
                        child: Image.asset(
                          'assets/new_ui/more/poor.png',
                          fit: BoxFit.cover,
                          height: 70,
                          width: 70,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(50),
                    )
                  : ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: dataUser.avatar.contains('http')
                            ? dataUser.avatar
                            : 'https://${Session().BASE_URL}/images/user_avatars/${dataUser.avatar}',
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/linh_vat/linhvat2.png',
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(50)),
              const SizedBox(
                width: 10,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Text(
                      dataUser.username,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  S.of(context).JoinedSince + ":" + dataUser.level.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ColorsUtils.Color_555555,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/quiz/diamond.svg'),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${dataUser.heart}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )
                  ],
                )
              ])
            ],
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        UserStatementWidget(userData: dataUser),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          height: 1,
          color: ColorsUtils.Color_555555,
        ),
        const SizedBox(
          height: 15,
        ),
        ScaleTap(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 130,
            height: 50,
            decoration: BoxDecoration(
              color: ColorsUtils.Color_E9C145,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                S.of(context).Close,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///View dialog setting
  Widget _viewDialogSetting() {
    var themeProvider = context.watch<ThemeProvider>();
    var localeProvider = context.watch<LocaleProvider>();
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter mystate) {
      return Container(
        height: 300,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                Text(S.of(context).Setting, style: TextStyle(fontSize: 22)),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ]),
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(S.of(context).subtitle),
                  const Expanded(child: SizedBox()),
                  Radio(
                    value: 0,
                    groupValue: indextLanguage,
                    onChanged: (val) {
                      mystate(() {
                        setState(() {
                          indextLanguage = 0;
                          isOff = false;
                        });
                      });
                    },
                  ),
                  Text(
                    language[0],
                  ),
                  Radio(
                    value: 1,
                    groupValue: indextLanguage,
                    onChanged: (val) {
                      mystate(() {
                        setState(() {
                          indextLanguage = 1;
                          isOff = false;
                        });
                      });
                    },
                  ),
                  Text(
                    language[1],
                  ),
                  Radio(
                    value: 2,
                    groupValue: indextLanguage,
                    onChanged: (val) {
                      mystate(() {
                        setState(() {
                          indextLanguage = 2;
                          isOff = false;
                        });
                      });
                    },
                  ),
                  localeProvider.locale!.languageCode.toUpperCase() == 'EN'
                      ? const SizedBox()
                      : Row(
                          children: [
                            Text(
                              language[2],
                            ),
                            Radio(
                              value: 3,
                              groupValue: indextLanguage,
                              onChanged: (val) {
                                mystate(() {
                                  setState(() {
                                    indextLanguage = 3;
                                    isOff = true;
                                  });
                                });
                              },
                            )
                          ],
                        ),
                  Text(
                    language[3],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ScaleTap(
                onPressed: () {
                  Utils().showNotificationBottom(true,
                      S.of(context).chung_toi_dang_phat_trien_tinh_nang_nay);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.2),
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFF6E41),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      S.of(context).cham_diem,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            ScaleTap(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: _viewDialogTutorial());
                      });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.2),
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color(0xFF04D076),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      S.of(context).huong_dan,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ))
          ],
        ),
      );
    });
  }

  ///View diaLog tutorial
  Widget _viewDialogTutorial() {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      height: 250,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
              Text(S.of(context).title_huong_dan_hoc_online,
                  style: TextStyle(fontSize: 18)),
              const Expanded(child: SizedBox()),
              GestureDetector(
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ]),
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(S.of(context).string_huong_dan_hoc_online),
            ),
          ))
        ],
      ),
    );
  }
}
