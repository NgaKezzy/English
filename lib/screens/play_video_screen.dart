import 'dart:convert';
import 'dart:async' show Future;
import 'dart:io';

import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/main.dart';
import 'package:app_learn_english/model_local/SettingVideoModel.dart';
import 'package:app_learn_english/model_local/TalkCacheModel.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/provider/miniplay_provider.dart';
import 'package:app_learn_english/widgets/sub_list_milis.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../widgets/settings_video.dart';

class PlayVideo extends StatefulWidget {
  static const routeName = '/play-videos';
  final DataTalk talkData;
  PlayVideo({required this.talkData});
  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  String filter = 'All';
  bool checkStop = true;
  Future<String> loadingSubtitle() async {
    return await rootBundle.loadString('assets/subtitle/sub.json');
  }

  Future<List<dynamic>> decodeSub() async {
    return json.decode(await loadingSubtitle());
  }

  late List<dynamic> subData;
  late List<TalkDetailModel> listSub;
  late YoutubePlayerController controller;
  late PlayerState _playerState;
  bool _isPlayerReady = false;
  bool _isPlaying = false;
  bool _awaitSub = true;
  TalkCacheModel? talkCache;
  AdmobHelper admob = AdmobHelper();
  late CountHeartProvider heartProvider;

  @override
  void initState() {
    DataCache().getListTextReview();
    _playerState = PlayerState.unknown;
    heartProvider = Provider.of<CountHeartProvider>(
      context,
      listen: false,
    );
    // admob.createInterstitialAd();
    admob.getBannerAd();
    super.initState();
  }

  @override
  void dispose() async {
    if (heartProvider.buttonAds) {
      printBlue("START ADS");
      print('Đang gọi quảng cáo');
      SharedPreferences prefs = await SharedPreferences.getInstance();

      heartProvider.setButtonAds(false);
      prefs.setBool('isShowAds', false);
      // admob.showInterstitialAd();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    var localProvider = context.read<LocaleProvider>();
    if (_awaitSub) {
      try {
        talkCache = await DataCache().getTalkDetailByIdInCache(
            widget.talkData.id,
            (localProvider.codeLangeSub != null)
                ? localProvider.codeLangeSub!
                : localProvider.locale!.languageCode);
        TalkDetailModel startTime = talkCache!.getListSub()[0];
        controller = YoutubePlayerController(
          initialVideoId: widget.talkData.yt_id,
          flags: YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            hideControls: true,
            hideThumbnail: true,
            enableCaption: false,
            startAt: Duration(milliseconds: startTime.startTime).inSeconds,
          ),
        )..addListener(listener);
      } catch (e) {
        controller = YoutubePlayerController(
          initialVideoId: widget.talkData.yt_id,
          flags: YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            hideControls: true,
            hideThumbnail: true,
            enableCaption: false,
            startAt: Duration(milliseconds: 0).inSeconds,
          ),
        );
      }
    }
    setState(() {
      _awaitSub = false;
    });

    super.didChangeDependencies();
  }

  void filterSet() {}

  void showSettings(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return SettingsVideo();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );
  }

  void listener() {
    if (_isPlayerReady && mounted && !controller.value.isFullScreen) {
      printYellow("vao onReady controller");
      setState(() {
        _playerState = controller.value.playerState;
        _isPlaying = controller.value.isPlaying;
      });

      // printYellow("vao _playerState:"+_playerState.hasPlayed);
      debugPrint('_isPlaying status: $_playerState');
      debugPrint('_isPlaying::: $_isPlaying');
      if (_playerState == PlayerState.playing) {
        // if (checkStop) {
        Future.delayed(Duration(microseconds: 0), () async {
          MiniPLayProvider videoStatusProvider =
              Provider.of<MiniPLayProvider>(context, listen: false);
          await videoStatusProvider.onReady();
        });
        // }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var localProvider = context.watch<LocaleProvider>();
    return _awaitSub
        ? Container()
        : ScopedModelDescendant<DataUser>(
            builder: (context, child, userData) {
              return YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: controller,
                  showVideoProgressIndicator: true,
                  controlsTimeOut: Duration(milliseconds: 0),
                  progressColors: ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amberAccent,
                  ),

                  onReady: () async {
                    printYellow("vao onReady");
// MiniPLayProvider videoStatusProvider =
//                     Provider.of<MiniPLayProvider>(context, listen: false);
//                 videoStatusProvider.onReady();
                    _isPlayerReady = true;
                  },

                  // onEnded: (metaData) {
                  //   showSimpleNotification(Text(metaData.toString()));
                  // },
                ),
                builder: (context, player) => Scaffold(
                  body: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          // image: DecorationImage(
                          //   image: AssetImage('assets/images/background.png'),
                          //   fit: BoxFit.cover,
                          // ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.blue.shade700,
                              Colors.tealAccent.shade400,
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: FutureBuilder(
                          future:
                              // TalkAPIs().getListSubVideo(widget.talkData.id),
                              DataCache().getTalkDetailByIdInCache(
                                  widget.talkData.id,
                                  (localProvider.codeLangeSub != null)
                                      ? localProvider.codeLangeSub!
                                      : localProvider.locale!.languageCode),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasError) {
                              return activeDialog(
                                  context, S.of(context).ErrorLoadData);
                            }
                            if (snapshot.hasData) {
                              (context as Element).markNeedsBuild();
                              return FutureBuilder(
                                future: DataOffline()
                                    .getDataLocal(keyData: "video_setting"),
                                builder: (context, AsyncSnapshot settingData) {
                                  if (settingData.hasError) {
                                    printYellow("Chưa có data");
                                    VideoSetting viSetting = new VideoSetting(
                                      subtitle: 1,
                                      autoplay: true,
                                      loop: false,
                                      loopMainSentence: false,
                                      isDrill: false,
                                    );
                                    DataOffline().saveDataOffline(
                                        "video_setting", viSetting);
                                    return ScopedModel(
                                        model: userData,
                                        child: SubListMilis(
                                          listSub: snapshot.data.getListSub(),
                                          controller: controller,
                                          player: player,
                                          talkData: widget.talkData,
                                          videoSetting: viSetting,
                                        ));
                                  }
                                  if (settingData.hasData) {
                                    return ScopedModel(
                                        model: userData,
                                        child: SubListMilis(
                                          listSub: snapshot.data.getListSub(),
                                          controller: controller,
                                          player: player,
                                          talkData: widget.talkData,
                                          videoSetting: VideoSetting.fromJson(
                                              settingData.data),
                                        ));
                                  } else {
                                    return Center(
                                      child: Platform.isAndroid
                                          ? CircularProgressIndicator()
                                          : CupertinoActivityIndicator(),
                                    );
                                  }
                                },
                              );
                            } else {
                              return Center(
                                child: Platform.isAndroid
                                    ? CircularProgressIndicator()
                                    : CupertinoActivityIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
