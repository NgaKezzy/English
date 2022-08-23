import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/HomeData.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/socket/models/table.dart' as table;
import 'package:app_learn_english/socket/provider/socket_provider.dart';

import 'package:app_learn_english/socket/utils/emit_event.dart';
import 'package:app_learn_english/socket/utils/parser_data.dart';
import 'package:app_learn_english/socket/view/inside_table_screen.dart';

import 'package:app_learn_english/utils/utils.dart';

import 'package:app_learn_english/widgets/search_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CreateRoom extends StatefulWidget {
  static const routeName = '/create-room';
  final Function runningSocket;

  const CreateRoom({Key? key, required this.runningSocket}) : super(key: key);

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  late DataHome _dataHome;
  late List<DataTalk> _listVideo;
  late List<DataTalk> _listSaveVideo;
  late List<table.Table> _lisTable;
  String langLocal = "";
  String query = '';
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey keyButtonChoseVideo = GlobalKey();
  bool _isTutorial = false;

  void searchVideo(String query) async {
    print('Đây là query: $query');
    if (query.isEmpty) {
      setState(() {
        this._listVideo = _listSaveVideo;
      });
    } else {
      var localeProvider = context.read<LocaleProvider>();
      var data = await TalkAPIs().searchAllApp(
        languageCode: localeProvider.locale!.languageCode,
        inputSearch: query,
        onlineRoom: true,
      );
      setState(() {
        this.query = query;
        this._listVideo = data;
      });
    }
  }

  ///call back ads
  void adsCallback(BuildContext context) async {
    DataUser userData = DataCache().getUserData();
    setState(() {
      userData.heart = userData.heart + 2;
    });
    Navigator.pop(context);
  }

  ///show ads
  void showAds(BuildContext context) {
    AdsController().showAdsCallback(adsCallback, context);
  }

  setFirstCreateRoom(bool isFirst) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstCreateRoom', isFirst);
  }

  Future<bool> getFirstCreateRoom() async {
    var _isFirst;
    final prefs = await SharedPreferences.getInstance();
    _isFirst = (prefs.getBool('firstCreateRoom') != null)
        ? prefs.getBool('firstCreateRoom')!
        : false;

    return _isFirst;
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "keyButtonChoseVideo",
        keyTarget: keyButtonChoseVideo,
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
                      S.of(context).PleaseChooseAVideo,
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
        print("finish");
      },
      onClickTarget: (target) {
        setFirstCreateRoom(true);
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        setFirstCreateRoom(true);
      },
      onSkip: () {
        setFirstCreateRoom(true);
      },
    )..show();
  }

  @override
  void initState() {
    _dataHome = DataCache().getDataHome()!;
    _listVideo = _dataHome.dataSugges;
    _listSaveVideo = _listVideo;
    langLocal = Provider.of<LocaleProvider>(context, listen: false)
        .locale!
        .languageCode;
    if (_isTutorial == false) {
      setState(() {
        _isTutorial = true;
      });
      // getFirstCreateRoom().then((value) => {
      //       if (value == false) {Future.delayed(Duration.zero, showTutorial)}
      //     });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var diamond = context.watch<CountHeartProvider>();
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? const Color.fromRGBO(45, 48, 57, 1)
            : Colors.white,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).tao_phong,
            style: TextStyle(
              fontSize: 20,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop("back");
          },
          icon: SvgPicture.asset(
            'assets/new_ui/more/Iconly-Arrow-Left.svg',
            height: 25,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        actions: [
          Row(
            children: [
              Text(
                diamond.countHeart.toString(),
                style: TextStyle(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 3,
              ),
              SvgPicture.asset('assets/quiz/diamond.svg'),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => VipWidget()),
              );
            },
            icon: SvgPicture.asset(
              'assets/new_ui/more/gio_hang.svg',
              height: 30,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
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
              const Divider(thickness: 1, color: Color(0xFFE4E4E4), height: 1),
              buildSearch(),
              Expanded(child: _buildListVideo()),
            ],
          ),
        ),
      ),
    );
  }

  ///View search
  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: S.of(context).SearchVideos,
        onChanged: searchVideo,
      );

  ///View list video
  Widget _buildListVideo() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      physics: const BouncingScrollPhysics(),
      itemCount: _listVideo.length,
      itemBuilder: (context, i) {
        return (i == 0)
            ? _viewItemVideo(0, _listVideo[0], keyButtonChoseVideo)
            : _viewItemVideo(i, _listVideo[i], null);
      },
    );
  }

  //diable dialog
  Future<void> _onDisableDialog() async {
    if (Provider.of<SocketProvider>(context, listen: true).listTable.length >
        0) {
      // Navigator.of(context).pop();
      final dataInsideRoom = {
        'isCreate': true,
      };
      Navigator.of(context).pushNamed(
        InsideTableScreen.routeName,
        arguments: dataInsideRoom,
      );
    }
  }

  ///View item Video
  Widget _viewItemVideo(int index, DataTalk talkData, Key? key) {
    var themeProvider = context.watch<ThemeProvider>();
    DataUser userData = DataCache().getUserData();
    return GestureDetector(
      onTap: () {
        var socketProvider = context.read<SocketProvider>();
        if (socketProvider.socketChannel == null) {
          widget.runningSocket();
          socketProvider.socketChannel!.sink.add(
            ParseDataSocket.convertSendDataParseCreateRoom(
              tableIndex: 1,
              roomId: 0,
              moneyBet: 0,
              idVideo: talkData.id,
              nameVideo: talkData.name,
            ),
          );
          socketProvider.setIsShowing(true);
          socketProvider.setOpenSocket(true);
          if (socketProvider.socketChannel != null) {
            socketProvider.setTable([]);
            String command = EmitEvent.emitJoinZone();
            socketProvider.socketChannel!.sink.add(command);
            socketProvider.socketChannel!.sink.add(
              ParseDataSocket.convertSendDataParseCreateRoom(
                tableIndex: 1,
                roomId: 0,
                moneyBet: 0,
                idVideo: talkData.id,
                nameVideo: talkData.name,
              ),
            );
          }
        } else {
          socketProvider.socketChannel!.sink.add(
            ParseDataSocket.convertSendDataParseCreateRoom(
              tableIndex: 1,
              roomId: 0,
              moneyBet: 0,
              idVideo: talkData.id,
              nameVideo: talkData.name,
            ),
          );
        }
        socketProvider.setVideoId(talkData.id);
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: _viewDialog(),
            );
          },
        );
        setState(() {
          userData.heart = userData.heart - 2;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: 290,
        child: Card(
          color: themeProvider.mode == ThemeMode.dark
              ? const Color.fromRGBO(58, 60, 66, 1)
              : Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                key: (index == 0) ? key : null,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.network(
                        talkData.picLink.isEmpty
                            ? 'https://img.youtube.com/vi/' +
                                talkData.yt_id +
                                '/maxresdefault.jpg'
                            : talkData.picLink,
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.network(
                          talkData.picLink.isEmpty
                              ? 'https://img.youtube.com/vi/' +
                                  talkData.yt_id +
                                  '/sddefault.jpg'
                              : talkData.picLink,
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: ScaleTap(
                    //     child: Container(
                    //       width: 62,
                    //       height: 62,
                    //       decoration: BoxDecoration(
                    //           color: Colors.black.withOpacity(0.65),
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(50))),
                    //       child: Center(
                    //         child: SvgPicture.asset(
                    //           'assets/new_ui/more/ic_taoban.svg',
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 70,
                        height: 35,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '-2',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SvgPicture.asset('assets/quiz/diamond.svg'),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    Utils.buildNameTalkWithRandomWord(talkData.name),
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(Utils.changeLanguageTalkName(langLocal, talkData),
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Color.fromRGBO(157, 158, 161, 1)
                          : Colors.black.withOpacity(.6),
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      var socketProvider = context.read<SocketProvider>();
                      if (socketProvider.socketChannel == null) {
                        widget.runningSocket();
                        socketProvider.socketChannel!.sink.add(
                          ParseDataSocket.convertSendDataParseCreateRoom(
                            tableIndex: 1,
                            roomId: 0,
                            moneyBet: 0,
                            idVideo: talkData.id,
                            nameVideo: talkData.name,
                          ),
                        );
                        socketProvider.setIsShowing(true);
                        socketProvider.setOpenSocket(true);
                        if (socketProvider.socketChannel != null) {
                          socketProvider.setTable([]);
                          String command = EmitEvent.emitJoinZone();
                          socketProvider.socketChannel!.sink.add(command);
                          socketProvider.socketChannel!.sink.add(
                            ParseDataSocket.convertSendDataParseCreateRoom(
                              tableIndex: 1,
                              roomId: 0,
                              moneyBet: 0,
                              idVideo: talkData.id,
                              nameVideo: talkData.name,
                            ),
                          );
                        }
                      } else {
                        socketProvider.socketChannel!.sink.add(
                          ParseDataSocket.convertSendDataParseCreateRoom(
                            tableIndex: 1,
                            roomId: 0,
                            moneyBet: 0,
                            idVideo: talkData.id,
                            nameVideo: talkData.name,
                          ),
                        );
                      }
                      socketProvider.setVideoId(talkData.id);
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: _viewDialog(),
                          );
                        },
                      );
                      setState(() {
                        userData.heart = userData.heart - 2;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF04D076),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(
                      S.of(context).tao_phong,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///View show dialog chờ tạo phòng
  Widget _viewDialog() {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: AutoSizeText(
              "Create Room. Pleas Wait!",
              style: TextStyle(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/new_ui/more/poor.png',
              //   height: 90,
              // ),
              // SizedBox(
              //   width: 5,
              // ),
              // // CircularProgressIndicator(
              // //   color: Colors.green,
              // // ),
              const PhoLoading(),
            ],
          )
        ],
      ),
    );
  }
}
