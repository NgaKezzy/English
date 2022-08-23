import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:app_learn_english/Providers/check_login.dart';
import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/home_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';
import 'package:app_learn_english/cake/screen/cake.dart';
import 'package:app_learn_english/custom_paint/button_create_room.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/homePage.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/TalkTextModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/config/config_app.dart';
import 'package:app_learn_english/models/learn_online/learn_offline.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';

import 'package:app_learn_english/presentation/learn_together/learn_together.dart';
import 'package:app_learn_english/presentation/learn_together/show_point_screen.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/review/reviewscreen.dart';

import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:app_learn_english/screens/new_play_video_screen.dart';
import 'package:app_learn_english/screens/new_play_video_screen_max.dart';
import 'package:app_learn_english/socket/models/convert_json_server.dart';
import 'package:app_learn_english/socket/models/friend_model.dart';
import 'package:app_learn_english/socket/models/invite_model.dart';

import 'package:app_learn_english/socket/models/reconnect.dart';
import 'package:app_learn_english/socket/models/table.dart' as table;
import 'package:app_learn_english/socket/provider/socket_provider.dart';

import 'package:app_learn_english/socket/utils/constant.dart';
import 'package:app_learn_english/socket/utils/emit_event.dart';
import 'package:app_learn_english/socket/utils/parser_data.dart';
import 'package:app_learn_english/socket/utils/signaling.dart';
import 'package:app_learn_english/socket/view/inside_table_screen.dart';
import 'package:app_learn_english/socket/view/widgets/item_view_user_no_data.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/config_heart_utils.dart';
import 'package:app_learn_english/utils/utils.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../speak/screen/tab_speak_parent_screen.dart';

final double playerMinHeight = 70;
ValueNotifier<double> playerExpandProgress = ValueNotifier(playerMinHeight);
bool _initialUriIsHandled = false;

class HomePage extends StatefulWidget {
  static const routeName = '/home-page';
  final int totalNotification;

  const HomePage({
    this.totalNotification = 0,
  });

  @override
  HomePageState createState() => HomePageState();
}

activeMiniPlayer(Widget view) {
  return view;
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool isTouch = false;
  double size = 250 * 0.3;
  int selectedIndex = 0;
  bool checkClose = true;
  late double playerMaxHeight;
  AdmobHelper admob = AdmobHelper();
  bool hasInternet = true;
  bool _isLoadingTheme = true;
  bool isLogGG = false;

  int retryLimit = 100;

  DataTalk? talkData;

  late Timer timerGetHeart;

  late List<Widget> widgetOptions;

  StreamSubscription? _sub;
  String socialId = '';

  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;
  DataTalk? dataTalk;
  DataTalkText? dataTalkText;
  bool _isClickAds = false;
  bool _isSetConfigApp = true;
  final _random = new math.Random();

  AdmobHelper admobHelper = AdmobHelper();
  bool _isHoldButton = true;
  ScrollController _scrollListUserOffLineController = ScrollController();
  int pageNumber = 0;
  late DataUser dataUser;
  late int idVideoOff;
  late int videoId;
  final inputSearchController = TextEditingController();
  var inputCache = "";
  late String? token;

  void adsCallbakk(BuildContext context) async {
    printRed("CALL BACK: ");
    // var count = 3;
    // printGreen("ADDED:");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setInt("count_heart_game1", count);
    var heartProvider = Provider.of<CountHeartProvider>(
      context,
      listen: false,
    );
    var numberHeart = await UserAPIs().addAndDivHeart(
      username: DataCache().getUserData().username,
      uid: DataCache().getUserData().uid,
      typeAction: ConfigHeart.nhan_tim_tu_admob_cong_tim,
    );
    heartProvider.setCountHeart(numberHeart);
    Navigator.pop(context, numberHeart);
  }

  void showAds(BuildContext context) {
    printBlue("START ADS");
    admobHelper.showRewaredGameHasCallback(adsCallbakk, context);
  }

  void _handleIncomingLinks() {
    print("_handleIncomingLinks");
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) async {
        if (!mounted) return;
        print('got uri: $uri');
        if (typeConversation(uri.toString()) == 'video') {
          // dataTalk = await TalkAPIs()
          //     .getVideoTalkById(categoryId: convertId(uri.toString()));
          dataTalk = await TalkAPIs().getVideoTalkById(
              categoryId: convertIdByDeppLink(uri.toString()));
          if (uri != null) {
            if (dataTalk != null)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewPlayVideoScreenNormal(
                    false,
                    dataTalk: dataTalk!,
                    percent: 1,
                    ytId: '',
                    enablePop: true,
                  ),
                ),
              );
          }
        } else {
          dataTalkText = await TalkAPIs()
              .getTalkTextById(categoryId: convertId(uri.toString()));
        }
        setState(() {
          _latestUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  Future<void> _handleInitialUri() async {
    print("_handleInitialUri:");
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;

      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
          if (typeConversation(uri.toString()) == 'video') {
            // dataTalk = await TalkAPIs()
            //     .getVideoTalkById(categoryId: convertId(uri.toString()));
            //edit by Dzungle
            dataTalk = await TalkAPIs().getVideoTalkById(
                categoryId: convertIdByDeppLink(uri.toString()));

            if (dataTalk != null)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewPlayVideoScreenNormal(
                    false,
                    dataTalk: dataTalk!,
                    percent: 1,
                    ytId: '',
                    enablePop: true,
                  ),
                ),
              );
          } else {
            dataTalkText = await TalkAPIs()
                .getTalkTextById(categoryId: convertId(uri.toString()));
          }
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
        setState(() => _err = err);
      }
    }
  }

  void startInsideTable(int id) async {
    final dataInsideRoom = {
      'isCreate': true,
    };

    var result = await Navigator.of(context).pushNamed(
      InsideTableScreen.routeName,
      arguments: dataInsideRoom,
    );
    if (mounted) {
      if (result == true) {
        print('có nhảy vào đây');
        String command = EmitEvent.emitJoinZone();
        context.read<SocketProvider>().socketChannel!.sink.add(command);
      }
    }
  }

  void _initSpeech() async {
    // await _speechToText.initialize(
    //   onError: (_) {
    //     showMaterialModalBottomSheet(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(10),
    //           topRight: Radius.circular(10),
    //         ),
    //       ),
    //       elevation: 10,
    //       backgroundColor: Colors.white,
    //       context: context,
    //       builder: (BuildContext ctx) => ShowMessageNotify(
    //         message: S.of(context).VoiceNotRecognizedPleaseTryAgain,
    //         stateVoice: CheckVoiceState.NotRecognized,
    //         speechToText: _speechToText,
    //       ),
    //     );
    //   },
    // );
    // setState(() {});
  }

  void getInternet(BuildContext context) {
    Provider.of<CheckLogin>(context, listen: false)
        .setCheckInternet(hasInternet);
  }

  String typeConversation(String url) {
    List<String> uriArr = url.toString().trim().split("/");
    print(uriArr.toString());
    return uriArr[4];
  }

  //Dialog show popup reconnect
  Future _showReconnect() async {
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
                S.of(context).TableHasBeenCanceled,
                style: const TextStyle(
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
                        runningSocket();
                        String command = EmitEvent.emitJoinZone();
                        var socketProvider = context.read<SocketProvider>();
                        socketProvider.socketChannel!.sink.add(command);
                        // socketProvider.setIsShowing(false);
                        socketProvider.setOpenSocket(true);
                        socketProvider.setIsShowing(true);

                        Navigator.of(context).pop(true);
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
                          color: const Color(0xFF04D076),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width <= 375
                              ? 60
                              : 65,
                          alignment: Alignment.center,
                          child: Text(
                            S.of(context).Reconnect,
                            style: const TextStyle(
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
                        var socketProvider = context.read<SocketProvider>();
                        socketProvider.setIsShowing(false);
                        socketProvider.setSocketChanel(null);
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
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     Color.fromRGBO(108, 168, 67, 1),
                          //     Color.fromRGBO(179, 220, 115, 1),
                          //   ],
                          // ),
                          color: const Color(0xFFE9C145),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width <= 375
                              ? 60
                              : 65,
                          alignment: Alignment.center,
                          child: Text(
                            S.of(context).Escape,
                            style: const TextStyle(
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

  ///View dialog click đá
  Widget _viewDialogHetDa(String error) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 160,
                  child: Center(
                    child: Lottie.asset(
                      'assets/new_ui/animation_lottie/anim_het_da.json',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ScaleTap(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset(
                      'assets/new_ui/more/close_square.svg',
                      height: 42,
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              S.of(context).ban_khong_du_tien,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: 16),
            color: ColorsUtils.Color_E4E4E4,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: 50,
                child: Stack(
                  children: [
                    ScaleTap(
                      onPressed: () {
                        showAds(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: ColorsUtils.Color_E9C145,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).WatchAds,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('+2',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                const SizedBox(
                                  width: 3,
                                ),
                                SvgPicture.asset(
                                  'assets/quiz/diamond.svg',
                                  height: 20,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ScaleTap(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VipWidget(),
                    ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: ColorsUtils.Color_04D076,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )),
                    child: Center(
                      child: Text(
                        S.of(context).Shop,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  //Khi lắng nghe mà trả về dữ liệu sẽ theo code từng loại mà nhảy vào hàm tương ứng
  void configureSocket(int codeSocket, String dataResponseFromSocket) {
    print('nhảy vào');
    SocketProvider socketProvider =
        Provider.of<SocketProvider>(context, listen: false);
    print('Đây là code khi nhảy vào hàm configure $codeSocket');
    log('Đây là data response $dataResponseFromSocket');
    switch (codeSocket) {
      case ConstantsCodeSocket.login:
        List<String> listLogin =
            ParseDataSocket.responseDataParserLogin(dataResponseFromSocket);
        if (int.parse('${listLogin[15]}') != 0) {
          context
              .read<SocketProvider>()
              .setLastRoom(int.parse('${listLogin[15]}'));
        }
        context
            .read<CountHeartProvider>()
            .setCountHeart(int.parse('${listLogin[1]}'));
        socketProvider.setStateLogin(true);
        break;
      case ConstantsCodeSocket.loginSocial:
        List<String> listLogin =
            ParseDataSocket.responseDataParserLogin(dataResponseFromSocket);
        if (int.parse('${listLogin[16]}') != 0) {
          context
              .read<SocketProvider>()
              .setLastRoom(int.parse('${listLogin[16]}'));
        }
        context
            .read<CountHeartProvider>()
            .setCountHeart(int.parse('${listLogin[1]}'));
        socketProvider.setStateLogin(true);
        break;
      case ConstantsCodeSocket.joinZone:
        List<table.Table> tables = ParseDataSocket.responseDataParseJoinZone(
          dataResponseFromSocket,
          codeSocket,
        );

        if (tables.isNotEmpty) {
          socketProvider.setTable(tables);
          if (socketProvider.lastRoom != null) {
            print('bị nhảy vào đây');
            socketProvider.setIdTableInside(socketProvider.lastRoom!);
            var data = {
              'idTable': socketProvider.lastRoom.toString(),
            };
            socketProvider.setLastRoom(null);
            var command = ParseDataSocket.requestDataParse(1105, data);
            print('đay là command: $command');
            socketProvider.socketChannel!.sink.add(command);
          }
        } else {
          print('Không có table nè');
        }

        socketProvider.setStateZone(true);
        break;
      case ConstantsCodeSocket.createRoom:
        dynamic data = ParseDataSocket.responseDataParseCreateRoom(
          dataResponseFromSocket,
          codeSocket,
        );
        if (data.runtimeType == String) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: _viewDialogHetDa(data),
              );
            },
          );
        } else {
          if (data != null) {
            socketProvider.setIdTableInside(data.matchId!);
            List<table.Table> listTable = [...socketProvider.listTable];
            listTable.add(data);
            socketProvider.setTable(listTable);

            if (listTable.length > 0) {
              Navigator.of(context).pop();
              print("data.matchId:${data.matchId}");
              startInsideTable(data.matchId!);
            }
          }
          socketProvider.setStateRoom(true);
        }

        break;
      case ConstantsCodeSocket.acceptJoin:
        dynamic data = ParseDataSocket.responseDataParseJoinRoom(
          dataResponseFromSocket,
          codeSocket,
          socketProvider.listTable,
        );

        if (data.runtimeType == String) {
          Navigator.of(context).pop();
        } else {
          if (data != null) {
            var index = socketProvider.listTable
                .indexWhere((element) => element.matchId == data.matchId);
            var listTable = socketProvider.listTable;
            listTable[index] = data;

            if (listTable.length > 0) {
              Navigator.of(context).pop();
              final dataInsideRoom = {
                'isCreate': false,
              };

              Navigator.of(context).pushNamed(
                InsideTableScreen.routeName,
                arguments: dataInsideRoom,
              );
            }
            socketProvider.setIdTableInside(data.matchId!);
            socketProvider.setTable(listTable);
          }
          socketProvider.setStateRoomExist(true);
        }

        break;
      case ConstantsCodeSocket.insideRoom:
        table.Table? tables = ParseDataSocket.responseDataParseNewJoin(
          dataResponseFromSocket,
          codeSocket,
          socketProvider.listTable,
          socketProvider.idTableInside,
        );
        if (tables != null) {
          var indexTable = socketProvider.listTable.indexWhere(
            (element) => element.matchId == socketProvider.idTableInside,
          );
          var mirrorListTable = [...socketProvider.listTable];
          mirrorListTable[indexTable] = tables;
          socketProvider.setTable(mirrorListTable);
        }

        break;
      case ConstantsCodeSocket.ready:
        table.Table? newDataTableResponse =
            ParseDataSocket.responseDataParseReady(
          dataResponseFromSocket,
          codeSocket,
          socketProvider.listTable,
          socketProvider.idTableInside,
        );

        if (newDataTableResponse != null) {
          var player = newDataTableResponse.players.firstWhere(
              (element) => element.id == DataCache().getUserData().uid);
          if (player.isReady) {
            print('Nhảy vào ready user true');
            socketProvider.setReadyUser(true);
          } else {
            print('Nhảy vào ready user false');
            socketProvider.setReadyUser(false);
          }
          var indexTable = socketProvider.listTable.indexWhere(
            (element) => element.matchId == socketProvider.idTableInside,
          );
          var mirrorListTable = [...socketProvider.listTable];
          mirrorListTable[indexTable] = newDataTableResponse;
          socketProvider.setTable(mirrorListTable);
          socketProvider.setIndexTurn(0);
        }
        break;

      case ConstantsCodeSocket.end:
        table.Table? newTable = ParseDataSocket.responseDataParseEnd(
          dataResponseFromSocket,
          codeSocket,
          socketProvider.listTable,
          socketProvider.idTableInside,
        );

        if (newTable != null) {
          var indexTable = socketProvider.listTable.indexWhere(
            (element) => element.matchId == socketProvider.idTableInside,
          );
          var mirrorListTable = [...socketProvider.listTable];
          mirrorListTable[indexTable] = newTable;
          socketProvider.setTable(mirrorListTable);
          socketProvider.setIndexTurn(0);
          socketProvider.setReadyUser(false);
          if (newTable.listPoint != null) {
            if (newTable.listPoint!.isNotEmpty) {
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ShowPointScreen(
                    listPoint: newTable.listPoint!,
                    players: newTable.players,
                  ),
                ));
              });
            }
          }
        }
        socketProvider.setStateReady(false);
        break;
      case ConstantsCodeSocket.cancel:
        table.Table? tables = ParseDataSocket.responseDataParseCancel(
          dataResponseFromSocket,
          codeSocket,
          socketProvider.listTable,
          socketProvider.idTableInside,
        );
        print('Đây là table');
        print(tables);
        if (tables != null) {
          var indexTable = socketProvider.listTable.indexWhere(
            (element) => element.matchId == socketProvider.idTableInside,
          );
          var mirrorListTable = [...socketProvider.listTable];
          if (mirrorListTable.length == 1) {
            print('Đây là trên $tables');
            mirrorListTable[0] = tables;
            print('Đây là dưới mirror');
          } else {
            mirrorListTable[indexTable] = tables;
          }

          print('Đây là current ở cancel: ${socketProvider.currentRoute}');

          if (tables.players.isNotEmpty) {
            bool flag = false;
            for (var i = 0; i < tables.players.length; i++) {
              if (tables.players[i].id == DataCache().getUserData().uid) {
                flag = true;
              }
            }
            if (!flag) {
              if (tables.isStatusCancel == 0) {
                socketProvider.setTable(mirrorListTable);
                Fluttertoast.showToast(msg: S.of(context).ExitedFromTheStart);
                socketProvider.setReadyUser(false);
                print('Đụ má vào đây luôn');
                if (socketProvider.currentRoute.isNotEmpty) {
                  Navigator.of(context).pop();
                }
                socketProvider.setTable(mirrorListTable);
                socketProvider.setCurrentRoute([]);
                socketProvider.reset();
                String command = EmitEvent.emitJoinZone();
                print('Đây là data $command');
                socketProvider.socketChannel!.sink.add(command);
                socketProvider.setStateReady(false);
                socketProvider.setIndexTurn(0);
              } else if (tables.isStatusCancel == 1) {
                print('Đã nhảy vào đây');
                socketProvider.setCancelTableStatus(1);
              } else if (tables.isStatusCancel == 2) {
                print('Đã nhảy vào đây');
                socketProvider.setCancelTableStatus(2);
              }
            } else {
              if (tables.isStatusCancel == 1) {
                Fluttertoast.showToast(msg: S.of(context).DkyThoat);
              } else if (tables.isStatusCancel == 2) {
                Fluttertoast.showToast(msg: S.of(context).huythoat);
              } else {
                socketProvider.setTable(mirrorListTable);
                socketProvider.setStateReady(false);
                socketProvider.setIndexTurn(0);
              }
            }
          } else {
            if (tables.isStatusCancel == 0) {
              socketProvider.setTable(mirrorListTable);
              if (socketProvider.currentRoute.isNotEmpty) {
                if (socketProvider.currentRoute.length >= 2) {
                  print('Đây 2 pop');
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else {
                  print('Đây 1 pop');

                  Navigator.of(context).pop();
                }
              }
              Fluttertoast.showToast(msg: S.of(context).ExitedFromTheStart);
              socketProvider.reset();
              socketProvider.setReadyUser(false);
              String command = EmitEvent.emitJoinZone();
              socketProvider.socketChannel!.sink.add(command);
              socketProvider.setIndexTurn(0);
            } else if (tables.isStatusCancel == 1) {
              socketProvider.setCancelTableStatus(1);
              Fluttertoast.showToast(msg: S.of(context).DkyThoat);
            } else if (tables.isStatusCancel == 2) {
              socketProvider.setCancelTableStatus(2);
              Fluttertoast.showToast(msg: S.of(context).huythoat);
            }
          }
        } else {
          if (socketProvider.currentRoute.isNotEmpty) {
            socketProvider.currentRoute.forEach((element) {
              print('Đây 1 pop pop');

              Navigator.of(context).pop();
              socketProvider.setCurrentRoute([]);
            });
          }
        }

        break;
      case ConstantsCodeSocket.start:
        table.Table? newDataTableResponse =
            ParseDataSocket.responseDataParseStart(
          dataResponseFromSocket,
          codeSocket,
          socketProvider.listTable,
          socketProvider.idTableInside,
        );
        if (newDataTableResponse != null) {
          var indexTable = socketProvider.listTable.indexWhere(
            (element) => element.matchId == socketProvider.idTableInside,
          );
          var mirrorListTable = [...socketProvider.listTable];
          mirrorListTable[indexTable] = newDataTableResponse;
          socketProvider.setTable(mirrorListTable);
        }
        socketProvider.setStateReady(true);
        socketProvider.setStateTurnOwn(true);
        break;

      case ConstantsCodeSocket.reject:
        table.Table? newDataTableResponse =
            ParseDataSocket.responseDataParseReject(
          dataResponseFromSocket,
          codeSocket,
          socketProvider.listTable,
          socketProvider.idTableInside,
        );
        if (newDataTableResponse != null) {
          var indexTable = socketProvider.listTable.indexWhere(
            (element) => element.matchId == socketProvider.idTableInside,
          );
          var mirrorListTable = [...socketProvider.listTable];
          mirrorListTable[indexTable] = newDataTableResponse;
          socketProvider.setTable(mirrorListTable);
          bool flag = false;
          for (var i = 0; i < newDataTableResponse.players.length; i++) {
            if (newDataTableResponse.players[i].id ==
                DataCache().getUserData().uid) {
              flag = true;
            }
          }
          if (!flag) {
            Fluttertoast.showToast(
              msg: 'Quá thời gian bấm sẵn sàng, bạn bị chủ phòng đẩy ra',
            );
            print("Đây là current route ${socketProvider.currentRoute}");
            if (socketProvider.currentRoute.isNotEmpty) {
              if (socketProvider.currentRoute.length > 1) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop();
              }
            }
            socketProvider.setCurrentRoute([]);
            socketProvider.setIsShowTurn(false);
            socketProvider.setReadyUser(false);
            context.read<HomeProvider>().setIndex(0);
          }
        }
        socketProvider.setStateReady(false);
        socketProvider.setIndexTurn(0);
        break;
      case ConstantsCodeSocket.turn:
        print('Có nhảy vào đây ');
        table.Table? newDataTableResponse =
            ParseDataSocket.responseDataParseTurn(
          dataResponseFromSocket,
          codeSocket,
          socketProvider.listTable,
          socketProvider.idTableInside,
        );

        print('Đây là table inside: ${socketProvider.idTableInside}');

        if (newDataTableResponse != null) {
          var indexTable = socketProvider.listTable.indexWhere(
            (element) => element.matchId == socketProvider.idTableInside,
          );
          if (newDataTableResponse.nextTurn !=
              socketProvider.listTable[indexTable].nextTurn) {
            if (newDataTableResponse.nextTurn ==
                newDataTableResponse.players[0].id) {
              socketProvider.setStateTurnClient(false);
              socketProvider.setStateTurnOwn(true);
            } else {
              socketProvider.setStateTurnClient(true);
              socketProvider.setStateTurnOwn(false);
            }
            print('Đổi lượt ${newDataTableResponse.nextTurn}');
            var mirrorListTable = [...socketProvider.listTable];
            mirrorListTable[indexTable] = newDataTableResponse;
            socketProvider.setTable(mirrorListTable);
            socketProvider.setIndexTurn(socketProvider.idxTurn + 1);
            print('Đây là xử lý phần index sub ${socketProvider.idxTurn}');
          }
        }
        socketProvider
            .setStateTurnOwn((socketProvider.isTurnOwn == true) ? false : true);
        socketProvider.setStateTurnClient(
            (socketProvider.isTurnClient == true) ? false : true);
        break;

      case ConstantsCodeSocket.getListFrient:
        List<FriendModel> listFriend = [];

        ConvertJsonToServer user =
            ConvertJsonToServer.fromJson(jsonDecode(dataResponseFromSocket));
        var listUser1 = user.r![0].v!.split("\u0004")..removeAt(0);
        if (listUser1[0].isNotEmpty) {
          var listUser2 = listUser1[0].split("\u0002");
          for (var item in listUser2) {
            var listTem = item.split("\u0001");
            listFriend.add(FriendModel(
                listTem[0], listTem[1], listTem[2], listTem[3], false));
          }
        }
        socketProvider.setListFriend(listFriend);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  //this right here
                  child: _viewListUserOnline());
            });

        break;
      case ConstantsCodeSocket.invite:
        String command = EmitEvent.emitJoinZone();
        context.read<SocketProvider>().socketChannel!.sink.add(command);
        InviteModel? newInviteModel =
            ParseDataSocket.responseDataParseInvite(dataResponseFromSocket);
        ParseDataSocket()
            .getDataVideoInvite(newInviteModel!.vId)
            .then((dataTalk) => {
                  showDialog(
                      context: context,
                      builder: (_) => Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: _viewDialogInvite(newInviteModel, dataTalk!),
                          ))
                });

        break;
      case ConstantsCodeSocket.expired_session:
        socketProvider.socketChannel!.sink.close();
        break;
      case ConstantsCodeSocket.reconnect: //process reconnect to table
        Reconnect? dataReconnect = ParseDataSocket.parseReconnect(
          dataResponseFromSocket,
          codeSocket,
          socketProvider.listTable,
        );

        if (dataReconnect != null) {
          socketProvider.setIdTableInside(dataReconnect.tableId);
          socketProvider.setVideoId(dataReconnect.videoId);
          table.Table filterTable = socketProvider.listTable.firstWhere(
            (table) => table.matchId == dataReconnect.tableId,
          );
          int indexFilterTable = socketProvider.listTable.indexWhere(
            (table) => table.matchId == dataReconnect.tableId,
          );
          table.Table newTable = table.Table(
            idVideo: dataReconnect.videoId,
            isPlaying: 1,
            matchId: dataReconnect.tableId,
            name: filterTable.name,
            players: dataReconnect.listPlayers,
            nextTurn: filterTable.nextTurn,
          );
          List<table.Table> listTable = [...socketProvider.listTable];
          listTable[indexFilterTable] = newTable;
          socketProvider.setTable(listTable);
          Navigator.of(context).pushNamed(
            InsideTableScreen.routeName,
            arguments: {
              'isCreate': false,
            },
          );
        }
        break;
      default:
    }
  }

  listenSocket() {
    var socketService = context.read<SocketProvider>().socketChannel;
    if (socketService != null) {
      if (socialId.isEmpty) {
        if (DataCache().tempPassWord.isNotEmpty) {
          print('Đây là pass ${DataCache().tempPassWord}');
          Map<String, dynamic> data = {
            'username': DataCache().getUserData().username,
            'password': DataCache().tempPassWord,
            'version': 2,
            'device': (Platform.isAndroid) ? 'android' : 'ios',
            'deviceId': '3312k31kl23jlk12',
          };
          String command = ParseDataSocket.requestDataParse(
            ConstantsCodeSocket.login,
            data,
          );
          print('Đây là command "$command"');
          context.read<SocketProvider>().socketChannel!.sink.add(command);
        }
      } else {
        String command = ParseDataSocket.convertSendDataParserLoginFb(
          socialId: '$socialId',
          token: '${DataCache().getUserData().username}',
          version: 2,
          device: (Platform.isAndroid) ? 'android' : 'ios',
          deviceID: '3312k31kl23jlk12',
        );
        print('Đây là command "$command"');
        context.read<SocketProvider>().socketChannel!.sink.add(command);
      }

      //Lắng nghe sự kiện qua socket trả về dữ liệu
      context
          .read<SocketProvider>()
          .socketChannel!
          .stream
          .asBroadcastStream()
          .listen(
        (event) {
          print("event Request:$event");
          // Utils().showNotificationBottom(true, 'Vao roi dm:$event');

          if (event.runtimeType == String) {
            if (event.contains('${ConstantsCodeSocket.end}')) {
              configureSocket(
                ConstantsCodeSocket.end,
                event,
              );
            }
            print(
                'Code Response String:  ${ParseDataSocket.responseDataParseCode(event)}');
            configureSocket(
              ParseDataSocket.responseDataParseCode(event),
              event,
            );
          } else {
            String response;
            try {
              response = utf8.decode(event);
            } catch (e) {
              response = String.fromCharCodes(event);
            }
            if (!kDebugMode) {
              print(
                  'Code Response Int:  ${ParseDataSocket.responseDataParseCode(response)}');
            }

            if (event.contains('${ConstantsCodeSocket.end}')) {
              configureSocket(
                ConstantsCodeSocket.end,
                event,
              );
            }

            configureSocket(
              int.parse('${ParseDataSocket.responseDataParseCode(response)}'),
              response,
            );
          }
        },
        onDone: () async {
          print('Đã done');
          var socketProvider = context.read<SocketProvider>();
          socketProvider.setOpenSocket(false);
          socketProvider.setSocketChanel(null);
          socketProvider.setIsShowTurn(false);
          socketProvider.setTable([]);
          socketProvider.setReadyUser(false);
          if (socketProvider.isLogoutCheck) {
            if (socketProvider.isShow) {
              print('Đây là current: ${socketProvider.currentRoute}');
              if (socketProvider.currentRoute.isNotEmpty) {
                if (socketProvider.currentRoute.length >= 2) {
                  print('Đây nhảy vào đây leng 2');

                  print('Đây nhảy vào đây leng 2 deep');

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  socketProvider.reset();
                } else {
                  print('Đây nhảy vào đây leng 1');
                  Navigator.of(context).pop();
                  socketProvider.reset();
                }
                context.read<HomeProvider>().setIndex(0);
                context.read<SocketProvider>().setIsInsideRoom(false);
              }
              if (socketProvider.isInsideLearnRoom) {
                print('nhảy vào đây learn room');
                // _showReconnect();
              }
              socketProvider.setIsShowing(false);
            }
          }
        },
        onError: (e) {
          // print('Đã bị đóng $e');
          // if (retryLimit > 0) {
          //   retryLimit--;
          //   runningSocket();
          // }
        },
      );
    }
  }

  setLangSub() async {
    var localProvider = context.read<LocaleProvider>();
    final prefs = await SharedPreferences.getInstance();
    var lange = prefs.getString('codeLangSub');

    localProvider.setCodeLangeSub((lange != null)
        ? lange
        : (localProvider.locale != null
            ? localProvider.locale!.languageCode
            : "en"));

    await TalkAPIs().getListUserOffline(context,
        page: 0,
        uid: dataUser.uid,
        lang: localProvider.locale != null
            ? localProvider.locale!.languageCode
            : "en");
  }

  initScrollController() {
    var socketProvider = context.read<SocketProvider>();
    var localProvider = context.read<LocaleProvider>();
    _scrollListUserOffLineController.addListener(() {
      if (_scrollListUserOffLineController.position.pixels ==
          _scrollListUserOffLineController.position.maxScrollExtent) {
        pageNumber++;
        socketProvider.setPage(pageNumber);
        TalkAPIs().getListUserOffline(context,
            page: pageNumber,
            uid: dataUser.uid,
            lang: localProvider.locale!.languageCode);

        socketProvider.setLoadMore(true);
      } else {
        socketProvider.setLoadMore(false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    DataCache().getListTextReview();
    _handleInitialUri();
    _handleIncomingLinks();
    initScrollController();

    InternetConnectionChecker().onStatusChange.listen((status) {
      bool checkInternet = status == InternetConnectionStatus.connected;
      setState(() {
        hasInternet = checkInternet;
      });
      getInternet(context);
    });
    dataUser = DataCache().getUserData();
    _initSpeech();
    setLangSub();

    widgetOptions = [
      HomeScreen(totalNotification: widget.totalNotification),
      const Cake(),
      LearnTogether(
        runningSocket: runningSocket,
      ),
      // ShowPointScreen(listPoint: []),
      TabScreenParentSpeak(),
      ReviewScreen(),
    ];
    inputSearchController.text = inputCache;
    inputSearchController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: inputSearchController.text.length,
      ),
    );
  }

  @override
  void dispose() async {
    _sub!.cancel();
    if (DataCache().getUserData() != null) {
      if (DataCache().getUserData().uid != 0) {
        if (context.read<SocketProvider>().socketChannel != null) {
          context.read<SocketProvider>().socketChannel!.sink.close();
        }
      }
    }

    timerGetHeart.cancel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Last_Time', DateTime.now().toString());
    super.dispose();
  }

  String getLang() {
    return Platform.localeName.split('_')[0];
  }

  int convertId(String url) {
    List<String> uriArr = url.toString().trim().split("\/");
    var arrayId = uriArr[5].split('-');
    var id = int.parse(
        '${arrayId[arrayId.length - 1].replaceAll(new RegExp(r'[^0-9]'), '')}');
    return id;
  }

  int convertIdByDeppLink(String url) {
    final uri = Uri.parse(url);
    Map<String, String> parames = uri.queryParameters;
    var id = int.parse(parames['vid']!);
    if (id <= 0) {
      id = this.convertId(url);
    }

    return id;
  }

  void runningSocket() {
    print('Nhảy vào running');
    WebSocketChannel _channel = IOWebSocketChannel.connect(
      // 'ws://192.168.1.208:9090/websocket',
      'ws://${ConfigSocket.domainSocket}:${ConfigSocket.port}/websocket',
    );

    context.read<SocketProvider>().setSocketChanel(_channel);
    listenSocket();
  }

  startRoomUserOff(int idTable) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var socketProvider = context.read<SocketProvider>();

    String commandZone = EmitEvent.emitJoinZone();
    context.read<SocketProvider>().socketChannel!.sink.add(commandZone);

    var data = {
      'idTable': idTable.toString(),
    };
    socketProvider.setIdTableInside(idTable);
    if (prefs.containsKey('videoId')) {
      videoId = prefs.getInt('videoId')!;
    } else {
      videoId = 1;
    }

    socketProvider.setVideoId(videoId);

    print('đây là list table: ${socketProvider.listTable}');

    var command = ParseDataSocket.requestDataParse(1105, data);
    context.read<SocketProvider>().socketChannel!.sink.add(command);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: _viewDialog(),
        );
      },
    );
    prefs.remove('videoOffline');
  }

  //Show dialog có đăng nhập hay không
  Future _showPopupUpdate(String url) async {
    return await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height / 2.5,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).NewVersion,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  launch(url);
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
                    color: const Color(0xFF04D076),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width <= 375 ? 60 : 65,
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context).Accept,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('isShowUpdate', false);
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
                    color: const Color(0xFFE9C145),

                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width <= 375 ? 60 : 65,
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context).NotShowingAgain,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('Đây là state nè $state');
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_isSetConfigApp) {
      setState(() {
        _isSetConfigApp = false;
      });
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      ConfigApp? configApp = await UserAPIs().configApp();
      String version = packageInfo.version;
      var homeProvider = context.read<HomeProvider>();
      homeProvider.setConfigApp(configApp);
      bool isShowUpdate = true;
      if (prefs.containsKey('isShowUpdate')) {
        isShowUpdate = prefs.getBool('isShowUpdate')!;
      }
      Future.delayed(Duration.zero, () {
        if (Platform.isAndroid) {
          if (configApp != null) {
            if (int.parse(configApp.vAndroid!.replaceAll('.', '')) >
                int.parse(version.replaceAll('.', ''))) {
              if (homeProvider.isShow == true && isShowUpdate == true) {
                print('Nhảy vào chỗ config này');
                _showPopupUpdate(configApp.linkUpdate!);
                homeProvider.setIsShow(false);
              }
            }
          }
        } else {
          if (configApp != null) {
            if (int.parse(configApp.vIos!.replaceAll('.', '')) >
                int.parse(version.replaceAll('.', ''))) {
              if (homeProvider.isShow == true && isShowUpdate == true) {
                print('Nhảy vào chỗ config này');
                _showPopupUpdate(configApp.linkUpdate!);
                homeProvider.setIsShow(false);
              }
            }
          }
        }
      });
      String? token = await FirebaseMessaging.instance.getToken();
      prefs.setString('tokenFCM', token ?? '');
      print(token);
      printRed(getLang());
      if (DataCache().getUserData() != null) {
        await UserAPIs().saveTokenFCM(
          token: token!,
          uid: DataCache().getUserData().uid.toString(),
          username: DataCache().getUserData().username,
          lang: getLang(),
        );
      }
      print('Bị nhảy');
    }

    if (isLogGG == false) {
      if (prefs.containsKey('login')) {
        socialId = prefs.getString('login')!;
        printBlue("LoginSocial:$socialId");
        setState(() {
          isLogGG = true;
        });
      }
    }
    idVideoOff =
        prefs.containsKey('videoOffline') ? prefs.getInt('videoOffline')! : 0;
    print('Đây là id mời: $idVideoOff');

    Future.delayed(Duration.zero, () {
      var socketProvider = context.read<SocketProvider>();
      if (DataCache().getUserData() != null) {
        if (DataCache().getUserData().uid != 0) {
          if (socketProvider.socketChannel == null) {
            runningSocket();

            if (idVideoOff != 0) {
              startRoomUserOff(idVideoOff);
            }
            socketProvider.setIsShowing(true);
            socketProvider.setOpenSocket(true);
          }
        }
      }
    });

    if (_isLoadingTheme) {
      Future.delayed(Duration.zero, () {
        bool isDarkMode = false;
        if (prefs.containsKey('isDarkMode')) {
          isDarkMode = prefs.getBool('isDarkMode')!;
        }
        context
            .read<ThemeProvider>()
            .setMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
      });
      setState(() {
        _isLoadingTheme = false;
      });
    }

    final heartProvider = Provider.of<CountHeartProvider>(
      context,
      listen: false,
    );
    // print(prefs.containsKey('Heart_Global'));
    // if (!prefs.containsKey('Heart_Global')) {
    //   prefs.setInt('Heart_Global', 7);
    //   heartProvider.setCountHeart(7);
    // }
    if (!prefs.containsKey('isShowAds')) {
      prefs.setBool('isShowAds', false);
    }
    // var initialHeartFromLocal = prefs.getInt("Heart_Global");
    if (DataCache().getUserData() != null) {
      var initialCheck = prefs.getBool("isShowAds");
      var initialHeart = await UserAPIs().getHeart(
        username: DataCache().getUserData().username,
        uid: DataCache().getUserData().uid,
      );
      heartProvider.setCountHeart(initialHeart);
      heartProvider.setButtonAds(initialCheck!);
      const timeDuration = const Duration(seconds: 1);
      var countSecond = 0;
      // print('Cái này là số tim lúc mới vào: ${heartProvider.count}');

      timerGetHeart = Timer.periodic(timeDuration, (Timer timer) {
        countSecond++;

        //   if (heartProvider.count < 7) {
        //     if (heartProvider.setFirstTime) {
        //       heartProvider.setCountSecond(countSecond);
        //       print('Đây là số giây ${heartProvider.countSecond}');
        //       heartProvider.setFirstTimeStart(false);
        //     }
        //     if (countSecond == heartProvider.countSecond + 1800) {
        //       var heart = heartProvider.count + 1;
        //       heartProvider.setCountHeart(heart);
        //       prefs.setInt('Heart_Global', heart);
        //       print('đụ đây là số tim ${heartProvider.count}');
        //       heartProvider.setFirstTimeStart(true);
        //     }
        //   }
        if (heartProvider.btnAds == false) {
          if (heartProvider.checkOpenAdsBtn) {
            heartProvider.setCountSecondAds(countSecond);
            heartProvider.setCheckOpenAds(false);
          }
          if (countSecond == heartProvider.countSecAds + 900) {
            prefs.setBool('isShowAds', true);
            heartProvider.setButtonAds(true);
            heartProvider.setCheckOpenAds(true);
          }
        }
      });
    }
  }

  double percentageFromValueInRange({required final double min, max, value}) {
    return (value - min) / (max - min);
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var homeProvider = context.watch<HomeProvider>();
    final videoProvider = Provider.of<VideoProvider>(context);
    final talkData = videoProvider.getdataTalk();
    final controller = videoProvider.miniplayerController;

    playerMaxHeight = MediaQuery.of(context).size.height;

    return MiniplayerWillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            ScopedModelDescendant<DataUser>(
              builder: (context, child, userData) {
                return Center(
                  child: ScopedModel<DataUser>(
                    model: userData,
                    child: widgetOptions.elementAt(homeProvider.index),
                  ),
                );
              },
            ),
            Offstage(
              offstage: talkData == null,
              child: Miniplayer(
                controller: controller,
                valueNotifier: playerExpandProgress,
                minHeight: playerMinHeight,
                maxHeight: playerMaxHeight,
                builder: (height, percentage) {
                  if (videoProvider.getdataTalk() == null) {
                    return const SizedBox.shrink();
                  } else {
                    return NewPlayVideoScreen(
                      dataTalk: talkData!,
                      percent: percentage,
                    );
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          child: ValueListenableBuilder(
            valueListenable: playerExpandProgress,
            builder: (BuildContext context, double height, Widget? child) {
              final value = percentageFromValueInRange(
                min: playerMinHeight,
                max: playerMaxHeight,
                value: height,
              );

              var opacity = 1 - value;
              if (opacity < 0) opacity = 0;
              if (opacity > 1) opacity = 1;

              return SizedBox(
                height: kBottomNavigationBarHeight -
                    kBottomNavigationBarHeight * value,
                child: Transform.translate(
                  offset: Offset(0.0, kBottomNavigationBarHeight * value * 0.5),
                  child: Opacity(
                    opacity: opacity,
                    child: OverflowBox(
                      maxHeight: kBottomNavigationBarHeight,
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: BottomNavigationBar(
              unselectedFontSize: 13,
              selectedFontSize: 13,
              iconSize: 24,
              unselectedLabelStyle: TextStyle(
                height: 1.4,
                fontWeight: FontWeight.normal,
              ),
              selectedLabelStyle: TextStyle(
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
              type: BottomNavigationBarType.fixed,
              fixedColor: const Color.fromRGBO(4, 208, 118, 1),
              unselectedItemColor: themeProvider.mode == ThemeMode.dark
                  ? Color.fromRGBO(97, 100, 106, 1)
                  : Colors.black,
              backgroundColor: themeProvider.mode == ThemeMode.dark
                  ? const Color.fromRGBO(45, 48, 57, 1)
                  : Colors.white,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: homeProvider.index == 0
                      ? SvgPicture.asset(
                          'assets/new_ui/home/ic_home_chon.svg',
                          width: 24,
                          color: const Color.fromRGBO(4, 208, 118, 1),
                        )
                      : SvgPicture.asset(
                          'assets/new_ui/home/ic_home.svg',
                          width: 24,
                          color: themeProvider.mode == ThemeMode.dark
                              ? const Color.fromRGBO(97, 100, 106, 1)
                              : Colors.black,
                        ),
                  label: S.of(context).HomePage,
                ),
                BottomNavigationBarItem(
                  icon: homeProvider.index == 1
                      ? SvgPicture.asset(
                          'assets/new_ui/home/ic_khoahoc_chon.svg',
                          width: 24,
                          color: const Color.fromRGBO(4, 208, 118, 1),
                        )
                      : SvgPicture.asset(
                          'assets/new_ui/home/ic_khoahoc.svg',
                          width: 24,
                          color: themeProvider.mode == ThemeMode.dark
                              ? const Color.fromRGBO(97, 100, 106, 1)
                              : Colors.black,
                        ),
                  label: S.of(context).Course,
                ),
                BottomNavigationBarItem(
                    icon: homeProvider.index == 2
                        ? SvgPicture.asset(
                            'assets/new_ui/home/camera1.svg',
                            width: 24,
                            color: const Color.fromRGBO(4, 208, 118, 1),
                          )
                        : SvgPicture.asset(
                            'assets/new_ui/home/camera2.svg',
                            width: 24,
                            color: themeProvider.mode == ThemeMode.dark
                                ? const Color.fromRGBO(97, 100, 106, 1)
                                : Colors.black,
                          ),
                    label: "Online"),
                BottomNavigationBarItem(
                  icon: homeProvider.index == 3
                      ? SvgPicture.asset(
                          'assets/new_ui/home/ic_luyendoc_chon.svg',
                          width: 24,
                          color: const Color.fromRGBO(4, 208, 118, 1),
                        )
                      : SvgPicture.asset(
                          'assets/new_ui/home/ic_luyendoc.svg',
                          width: 24,
                          color: themeProvider.mode == ThemeMode.dark
                              ? const Color.fromRGBO(97, 100, 106, 1)
                              : Colors.black,
                        ),
                  label: S.of(context).Speak,
                ),
                BottomNavigationBarItem(
                  icon: homeProvider.index == 4
                      ? SvgPicture.asset(
                          'assets/new_ui/home/ic_ontap_chon.svg',
                          width: 24,
                          color: const Color.fromRGBO(4, 208, 118, 1),
                        )
                      : SvgPicture.asset(
                          'assets/new_ui/home/ic_ontap.svg',
                          width: 24,
                          color: themeProvider.mode == ThemeMode.dark
                              ? const Color.fromRGBO(97, 100, 106, 1)
                              : Colors.black,
                        ),
                  label: S.of(context).Review,
                ),
              ],
              currentIndex: homeProvider.index,
              onTap: (index) {
                homeProvider.setIndex(index);
                var socketProvider = context.read<SocketProvider>();
                if (index == 2) {
                  socketProvider.setIsInsideRoom(true);
                } else {
                  if (socketProvider.isInsideLearnRoom) {
                    socketProvider.setIsInsideRoom(false);
                  }
                }
              },
            ),
          ),
        ),
        // floatingActionButton: Visibility(
        //   visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        //   child: ValueListenableBuilder(
        //     valueListenable: playerExpandProgress,
        //     builder: (ctx, height, child) {
        //       final value = percentageFromValueInRange(
        //         min: playerMinHeight,
        //         max: playerMaxHeight,
        //         value: height,
        //       );

        //       var opacity = 1 - value;
        //       if (opacity < 0) opacity = 0;
        //       if (opacity > 1) opacity = 1;
        //       return Opacity(
        //         opacity: opacity,
        //         child: FloatingActionButton(
        //           elevation: 10,
        //           child: CustomPaint(
        //             painter: ButtonCreateRoom(),
        //             size: Size(20, 20),
        //             child: Container(
        //               child: Center(
        //                 child: SvgPicture.asset(
        //                   'assets/new_ui/more/btn_taophong.svg',
        //                   color: Colors.white,
        //                   height: 24,
        //                 ),
        //               ),
        //             ),
        //           ),
        //           onPressed: () {
        //             homeProvider.setIndex(2);
        //             context.read<SocketProvider>().setIsInsideRoom(true);
        //           },
        //         ),
        //       );
        //     },
        //   ),
        // ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }

  ///View dialog mời chơi
  Widget _viewDialogInvite(InviteModel newInviteModel, DataTalk dataTalk) {
    var themeProvider = context.watch<ThemeProvider>();
    {
      return Container(
        height: 420,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    newInviteModel.userNameInvite,
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).HasInvitedyouToVideoLearning,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Colors.black12,
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  dataTalk.picLink.isEmpty
                      ? 'https://img.youtube.com/vi/' +
                          dataTalk.yt_id +
                          '/maxresdefault.jpg'
                      : dataTalk.picLink,
                  height: 180.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataTalk.name_vi,
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataTalk.name,
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.grey
                    : Colors.black12,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _viewButtomCancel(),
                  const SizedBox(width: 10),
                  _viewButtomYes(newInviteModel.roomId)
                ],
              )
            ],
          ),
        ),
      );
    }
  }

  //View Buttom đồng ý
  Widget _viewButtomYes(String idTable) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          var socketProvider = context.read<SocketProvider>();
          if (socketProvider.listTable.isEmpty) {
            String command = EmitEvent.emitJoinZone();
            context.read<SocketProvider>().socketChannel!.sink.add(command);
          }
          var data = {
            'idTable': idTable,
          };
          var command = ParseDataSocket.requestDataParse(1105, data);
          context.read<SocketProvider>().socketChannel!.sink.add(command);
          table.Table filterTable = socketProvider.listTable
              .firstWhere((element) => element.matchId == int.parse(idTable));
          socketProvider.setVideoId(filterTable.idVideo);
          Navigator.of(context).pop();
          //show dialog chờ để nhận dữ liệu của phòng từ server trả về
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: _viewDialog());
              });
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
                Color(0xFF56AB2F),
                Color(0xFF56AB2F),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width <= 375 ? 60 : 60,
            alignment: Alignment.center,
            child: Text(
              S.of(context).Accept,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///View Buttom từ chối
  Widget _viewButtomCancel() {
    return Expanded(
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
                Color(0xFFDBB644),
                Color(0xFFF8D056),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width <= 375 ? 60 : 60,
            alignment: Alignment.center,
            child: Text(
              S.of(context).Decline,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
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
              S.of(context).JoinRoomPleasWait,
              style: const TextStyle(
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
              Image.asset(
                'assets/linh_vat/linhvat2.png',
                height: 90,
              ),
              const SizedBox(
                width: 5,
              ),
              const PhoLoading(),
            ],
          )
        ],
      ),
    );
  }

  ///View list user online
  Widget _viewListUserOnline() {
    return Consumer<SocketProvider>(builder: (context, socketProvider, child) {
      var themeProvider = context.watch<ThemeProvider>();

      return Container(
        height: MediaQuery.of(context).size.height * 0.95,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Text(
                        S.of(context).InviteOnlineUser,
                        style: TextStyle(
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0, top: 12),
                        child: ScaleTap(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.clear,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black12,
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _viewTabListUserOnlineAndOffline(),
                      Expanded(
                          child: TabBarView(
                        children: [
                          (socketProvider.listFriend.length > 0)
                              ? Column(
                                  children: [
                                    for (int i = 0;
                                        i < socketProvider.listFriend.length;
                                        i++)
                                      _viewItemUser(
                                          socketProvider.listFriend[i],
                                          socketProvider.idTableInside)
                                  ],
                                )
                              : _buildNoUser(),
                          _buildListUserOffline(
                            socketProvider.idTableInside,
                          )
                        ],
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  ///View item user online
  Widget _viewItemUser(FriendModel friendModel, int idTable) {
    var themeProvider = context.watch<ThemeProvider>();
    var avatarURL = 'https://api.myfeel.me/' +
        "images/user_avatars/" +
        friendModel.linkAvatar;
    return Container(
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: (friendModel.linkAvatar.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: avatarURL,
                            placeholder: (context, url) => const PhoLoading(),
                            errorWidget: (context, url, error) =>
                                ItemViewUserNoData(
                              name: friendModel.nameUser,
                            ),
                            height: 40,
                          )
                        : ItemViewUserNoData(
                            name: friendModel.nameUser,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friendModel.nameUser,
                        style: TextStyle(
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/quiz/diamond.svg',
                            height: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            (friendModel.money.isNotEmpty)
                                ? friendModel.money
                                : "0",
                            style: TextStyle(
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (friendModel.isInvite == false) {
                      Provider.of<SocketProvider>(context, listen: false)
                          .setStateOpenPop(true);
                      context.read<SocketProvider>().socketChannel!.sink.add(
                            ParseDataSocket.convertSendDataParseInvite(
                              destUid: int.parse(friendModel.ui),
                              roomID: int.parse("$idTable"),
                            ),
                          );
                      setState(() {
                        friendModel.isInvite = true;
                      });
                    }
                  },
                  child: (friendModel.isInvite == false)
                      ? SvgPicture.asset(
                          'assets/new_ui/more/add_border.svg',
                          height: 60,
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Lottie.asset(
                                'assets/new_ui/animation_lottie/tick_done.json',
                                height: 50,
                                repeat: false),
                          ),
                        ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black12,
          ),
        ],
      ),
    );
  }

  Widget _viewItemUserOffline(ListUser listUserOff, int idTable, int vid) {
    var themeProvider = context.watch<ThemeProvider>();
    var localProvider = context.watch<LocaleProvider>();
    return Container(
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: ItemViewUserNoData(
                      name: listUserOff.username!,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listUserOff.username!,
                        style: TextStyle(
                          color: themeProvider.mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/quiz/diamond.svg',
                            height: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            (listUserOff.heart.toString().isNotEmpty)
                                ? listUserOff.heart.toString()
                                : "0",
                            style: TextStyle(
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (listUserOff.isInvite == false) {
                      Provider.of<SocketProvider>(context, listen: false)
                          .setStateOpenPop(true);
                      listUserOff.isInvite = true;

                      TalkAPIs().pushNotificationServer(
                        vid: vid.toString(),
                        uid: dataUser.uid.toString(),
                        username: dataUser.username,
                        fullname: dataUser.fullname,
                        username_invited: listUserOff.username!,
                        fullname_invited: listUserOff.fullname!,
                        uid_invited: listUserOff.uid.toString(),
                        lang: localProvider.locale!.languageCode,
                        roomid: idTable.toString(),
                      );
                    }
                  },
                  child: (listUserOff.isInvite == false)
                      ? SvgPicture.asset(
                          'assets/new_ui/more/add_border.svg',
                          height: 60,
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Lottie.asset(
                                'assets/new_ui/animation_lottie/tick_done.json',
                                height: 50,
                                repeat: false),
                          ),
                        ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black12,
          ),
        ],
      ),
    );
  }

  ///View list user đang offline
  Widget _buildListUserOffline(int idTable) {
    return Consumer<SocketProvider>(builder: (context, soketprovider, child) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            _viewSearchListOffline(),
            Expanded(
                child: (soketprovider.listUserOffline.length > 0)
                    ? ListView.builder(
                        controller: _scrollListUserOffLineController,
                        itemCount: soketprovider.listUserOffline.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == soketprovider.listUserOffline.length) {
                            if (soketprovider.loadMore == true) {
                              return Align(
                                child: new Container(
                                  width: 50.0,
                                  height: 50.0,
                                  color: Colors.yellow,
                                  child: new Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                                alignment: Alignment.bottomCenter,
                              );
                            } else {
                              return const SizedBox();
                            }
                          }
                          return _viewItemUserOffline(
                              soketprovider.listUserOffline[index],
                              idTable,
                              (soketprovider.videoId != null)
                                  ? soketprovider.videoId!
                                  : 0);
                        })
                    : _buildNoUser())
          ],
        ),
      );
    });
  }

  ///View chưa có user nào
  Widget _buildNoUser() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Lottie.asset(
            'assets/new_ui/animation_lottie/shiba.json',
            height: 90,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            S.of(context).ThereAreNoUsersOnline,
          ),
        ],
      ),
    );
  }

  ///View tab listUser
  Widget _viewTabListUserOnlineAndOffline() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 40,
      decoration: BoxDecoration(
          color: ColorsUtils.Color_888888.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: TabBar(
        // give the indicator a decoration (color and border radius)
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
            25.0,
          ),
          color: Colors.green,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(
            text: 'Online',
          ),
          Tab(
            text: 'Offline',
          ),
        ],
      ),
    );
  }

  /// ViewSearchListUser Offline
  Widget _viewSearchListOffline() {
    var themeProvider = context.watch<ThemeProvider>();
    var localProvider = context.read<LocaleProvider>();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: TextFormField(
        onFieldSubmitted: (input) {
          TalkAPIs()
              .searchListUserOffline(context,
                  lang: localProvider.locale!.languageCode, input: input)
              .then((value) {});
        },
        controller: inputSearchController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 5),
          prefixIcon: Icon(Icons.search,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black),
          fillColor: Colors.grey.withOpacity(0.2),
          filled: true,
          hintText: S.of(context).Search,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintStyle: const TextStyle(
            fontSize: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
