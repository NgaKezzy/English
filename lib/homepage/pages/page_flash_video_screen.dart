import 'dart:io';

import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/widgets/showmodel_video_flash.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FlashVideoScreen extends StatefulWidget {
  final DataTalk dataTalk;
  FlashVideoScreen({Key? key, required this.dataTalk}) : super(key: key);

  @override
  State<FlashVideoScreen> createState() => _FlashVideoScreenState();
}

class _FlashVideoScreenState extends State<FlashVideoScreen>
    with SingleTickerProviderStateMixin {
  late YoutubePlayerController _controllerYt;
  List<TalkDetailModel> listSub = [];
  bool _isLiked = false;
  bool _isInitController = true;
  int pos = 0;
  bool checkEndVideo = true;

  GlobalKey key = GlobalKey();
  bool _hideToolTips = true;

  @override
  void didChangeDependencies() async {
    var localProvider= context.watch<LocaleProvider>();
    listSub = await TalkAPIs().getListSubVideo(widget.dataTalk.id,localProvider.locale!.languageCode);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    DataCache()
        .getTalkLikeStatus(DataCache().userCache!.uid, widget.dataTalk.id)
        .then((value) {
      setState(() {
        _isLiked = value;
      });
    });
    var localProvider= context.watch<LocaleProvider>();
    TalkAPIs().getListSubVideo(widget.dataTalk.id,localProvider.locale!.languageCode).then((value) {
      if (value.length > 0) {
        setState(() {
          listSub = value;
          _controllerYt = YoutubePlayerController(
            initialVideoId: widget.dataTalk.yt_id,
            flags: YoutubePlayerFlags(
              autoPlay: true,
              hideControls: true,
              enableCaption: false,
              startAt: Duration(milliseconds: listSub[0].startTime).inSeconds,
              endAt: Duration(milliseconds: listSub[listSub.length - 1].endTime)
                  .inSeconds,
            ),
          )..addListener(listener);
          SharedPreferences.getInstance().then((value) {
            if (value.containsKey('isFirstUseFlash')) {
              _hideToolTips = value.getBool('isFirstUseFlash')!;
            } else {
              value.setBool('isFirstUseFlash', _hideToolTips);
            }
            _isInitController = false;
          });
        });
      }
    });
  }

  int cutNumber(int num) {
    String numString = '$num';
    if (numString.length == 1) {
      return 0;
    }

    int newNum = int.parse(
      numString.substring(0, (numString.length - 2)),
    );
    return newNum;
  }

  void listener() {
    for (var i = 0; i < listSub.length; i++) {
      if (cutNumber(
              Duration(milliseconds: listSub[i].startTime).inMilliseconds) ==
          cutNumber(_controllerYt.value.position.inMilliseconds)) {
        setState(() {
          pos = i;
        });
        print('đây là index $pos');
      }
    }
    if (_controllerYt.value.playerState == PlayerState.paused &&
        checkEndVideo == false) {
      _controllerYt.play();
      setState(() {
        checkEndVideo = true;
      });
    }

    if (_controllerYt.value.playerState == PlayerState.ended &&
        checkEndVideo == true) {
      if (checkEndVideo) {
        print('kết thúc');
        setState(() {
          checkEndVideo = false;
        });
        _controllerYt.seekTo(Duration(milliseconds: (listSub[0].startTime)));
        _controllerYt.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = context.watch<LocaleProvider>().locale!.languageCode;
    return _isInitController
        ? Center(
            child:
                Platform.isAndroid ? null : const CupertinoActivityIndicator(),
          )
        : YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controllerYt,
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
              progressIndicatorColor: Colors.transparent,
              thumbnail: Platform.isAndroid
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const CupertinoActivityIndicator(),
            ),
            builder: (contextYt, player) => SafeArea(
              child: Center(
                child: Stack(
                  children: [
                    player,
                    Container(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (lang != 'en')
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 120),
                                  child: Text(
                                    listSub[pos].content,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            const Expanded(child: SizedBox()),

                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: Text(
                                  Utils.changeLanguageVideo(lang, pos, listSub),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    widget.dataTalk.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    DataCache().getUserData().uid != 0
                                        ? InkWell(
                                            onTap: () {
                                              _isLiked
                                                  ? TalkAPIs()
                                                      .unLikeTalk(
                                                      uid: DataCache()
                                                          .userCache!
                                                          .uid,
                                                      talkId:
                                                          widget.dataTalk.id,
                                                      languageCode: lang,
                                                    )
                                                      .then((value) {
                                                      if (value == 1) {
                                                        setState(() {
                                                          Utils().showNotificationBottom(
                                                              false,
                                                              S
                                                                      .of(
                                                                          context)
                                                                      .Disliked +
                                                                  widget
                                                                      .dataTalk
                                                                      .name);

                                                          widget.dataTalk
                                                              .totalLike--;
                                                          widget.dataTalk
                                                                      .totalLike <
                                                                  0
                                                              ? widget.dataTalk
                                                                  .totalLike = 0
                                                              : {};
                                                          _isLiked = false;
                                                        });
                                                      }
                                                    })
                                                  : TalkAPIs()
                                                      .likeTalk(
                                                      uid: DataCache()
                                                          .userCache!
                                                          .uid,
                                                      talkId:
                                                          widget.dataTalk.id,
                                                      languageCode: lang,
                                                    )
                                                      .then((value) {
                                                      if (value == 1) {
                                                        setState(() {
                                                          Utils().showNotificationBottom(
                                                              true,
                                                              S
                                                                      .of(
                                                                          context)
                                                                      .Youlikedtheconversation +
                                                                  widget
                                                                      .dataTalk
                                                                      .name);
                                                          widget.dataTalk
                                                              .totalLike++;
                                                          _isLiked = true;
                                                        });
                                                      }
                                                    });
                                            },
                                            child: Icon(
                                              Icons.thumb_up_alt,
                                              color: _isLiked
                                                  ? Colors.blue
                                                  : Colors.white,
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          VipWidget()));
                                            },
                                            child: Icon(
                                              Icons.thumb_up_alt,
                                              color: Colors.white,
                                            ),
                                          ),
                                    Text(
                                      '${widget.dataTalk.totalLike + 100}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      isDismissible: false,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter mystate) {
                                          return ShowmodelVideoFlash(
                                            dataTalk: widget.dataTalk,
                                            listSub: listSub,
                                          );
                                        });
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.list,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            //                     // Row(
                            //                     //   children: [
                            //                     //     SizedBox(
                            //                     //       width: MediaQuery.of(context).size.width / 1.4,
                            //                     //       child: Text(
                            //                     //         widget.dataTalk.name,
                            //                     //         style: const TextStyle(
                            //                     //           color: Colors.white,
                            //                     //           overflow: TextOverflow.ellipsis,
                            //                     //           fontSize: 16,
                            //                     //         ),
                            //                     //       ),
                            //                     //     ),
                            //                     //     const Expanded(child: SizedBox()),
                            //                     //   ],
                            //                     // ),
                          ],
                        )),
                    if (_hideToolTips)
                      InkWell(
                        onTap: () async {
                          setState(() {
                            _hideToolTips = false;
                          });
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setBool('isFirstUseFlash', false);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Color.fromRGBO(0, 0, 0, .6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/arrow.png',
                                height: 250,
                              ),
                              Text(
                                'Vuốt lên để xem video tiếp theo',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}
