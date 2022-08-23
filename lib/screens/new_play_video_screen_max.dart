import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/video_provider.dart';

import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/main.dart';
import 'package:app_learn_english/model_local/TalkCacheModel.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/socket/provider/socket_provider.dart';
import 'package:app_learn_english/widgets/new_player_video_builder.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class NewPlayVideoScreenNormal extends StatefulWidget {
  final DataTalk dataTalk;
  final double percent;
  bool hideChannel = false;
  final String ytId;
  final bool enablePop;
  final bool isCourse;

  NewPlayVideoScreenNormal(
    this.hideChannel, {
    Key? key,
    required this.dataTalk,
    required this.percent,
    required this.ytId,
    this.enablePop = false,
    this.isCourse = false,
  }) : super(key: key);

  @override
  _NewPlayVideoScreenNormalState createState() =>
      _NewPlayVideoScreenNormalState();
}

class _NewPlayVideoScreenNormalState extends State<NewPlayVideoScreenNormal> {
  // late YoutubePlayer playerYT;
  YoutubePlayerIFrame? playerYT;
  YoutubePlayerController? controllerYT;
  late Future talkCakeModelFnc;
  int startTime = 0;
  late TalkCacheModel talkCache;
  late VideoProvider videoProvider;
  late Future talkCacheFnc;
  bool checkError = false;
  AdmobHelper admob = AdmobHelper();
  late CountHeartProvider heartProvider;
  bool normalCheck = true;
  bool _isAutoPlay = true;

  // YoutubePlayer buildYoutubePlayer(YoutubePlayerController controller) {
  //   return YoutubePlayer(
  //     controller: controller,
  //     onReady: () {},
  //   );
  // }

  @override
  void initState() {
    super.initState();
    print("idCache:${widget.dataTalk.id}");
    heartProvider = Provider.of<CountHeartProvider>(
      context,
      listen: false,
    );
    // admob.createInterstitialAd();
    admob.getBannerAd();
  }

  // YoutubePlayerController buildYoutubePlayerController(
  //     int startTime, int? endTime) {
  //   return YoutubePlayerController(
  //     initialVideoId: widget.dataTalk.yt_id,
  //     flags: YoutubePlayerFlags(
  //       mute: false,
  //       autoPlay: true,
  //       hideControls: false,
  //       hideThumbnail: true,
  //       enableCaption: false,
  //       startAt: startTime,
  //       endAt: endTime,
  //     ),
  //   );
  // }

  Future<TalkCacheModel> talkCakeModel() {
    var localProvider = context.read<LocaleProvider>();
    return DataCache().getTalkDetailByIdInCache(
        widget.dataTalk.id,
        (localProvider.codeLangeSub != null)
            ? localProvider.codeLangeSub!
            : localProvider.locale!.languageCode);
  }

  @override
  void dispose() async {
    controllerYT!.close();

    if (heartProvider.buttonAds) {
      printBlue("START ADS");
      print('Đang gọi quảng cáo');
      PlyrVideoPlayer().initAdsBanner(admob.bannerAd);
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
    if (normalCheck) {
      talkCacheFnc = talkCakeModel();
      try {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        if (_prefs.containsKey('settingVideo-autoPlay')) {
          _isAutoPlay = _prefs.getBool('settingVideo-autoPlay')!;
        } else {
          _prefs.setBool('settingVideo-autoPlay', _isAutoPlay);
        }
        TalkCacheModel talkCache = await DataCache().getTalkDetailByIdInCache(
            widget.dataTalk.id,
            (localProvider.codeLangeSub != null)
                ? localProvider.codeLangeSub!
                : localProvider.locale!.languageCode);
        var listSub = talkCache.getListSub();
        TalkDetailModel startTime = listSub[0];
        TalkDetailModel endTime = listSub[listSub.length - 1];
        controllerYT = YoutubePlayerController(
          initialVideoId:
              widget.ytId.isEmpty ? widget.dataTalk.yt_id : widget.ytId,
          params: YoutubePlayerParams(
            privacyEnhanced: false,
            autoPlay: _isAutoPlay,
            endAt: Duration(milliseconds: (endTime.endTime + 2000)),
            startAt: Duration(milliseconds: startTime.startTime),
            showControls: false,
            showVideoAnnotations: false,
            enableCaption: false,
            useHybridComposition: false,
            enableKeyboard: false,
            strictRelatedVideos: false,
          ),
        );
      } catch (error) {
        controllerYT = YoutubePlayerController(
          initialVideoId:
              widget.ytId.isEmpty ? widget.dataTalk.yt_id : widget.ytId,
          params: YoutubePlayerParams(
            autoPlay: _isAutoPlay,
            enableJavaScript: false,
            endAt: Duration(milliseconds: 0),
            startAt: Duration(milliseconds: 0),
            showControls: false,
            showVideoAnnotations: false,
            enableCaption: false,
            useHybridComposition: true,
          ),
        );
      }

      playerYT = YoutubePlayerIFrame(
        controller: controllerYT,
      );
      setState(() {
        normalCheck = false;
      });
    }
    context.read<SocketProvider>().setIsInsideRoom(false);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return normalCheck
        ? Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [
                    //     Colors.blue.shade700,
                    //     Colors.tealAccent.shade400,
                    //   ],
                    // ),
                    color: Colors.white,
                  ),
                ),
                const Center(
                  // child: CircularProgressIndicator(
                  //   color: Colors.blue,
                  // ),
                  child: const PhoLoading(),
                ),
              ],
            ),
          )
        : Scaffold(
            body: Stack(
              children: [
                widget.percent < 0.2
                    ? const SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   begin: Alignment.topCenter,
                          //   end: Alignment.bottomCenter,
                          //   colors: [
                          //     Colors.blue.shade700,
                          //     Colors.tealAccent.shade400,
                          //   ],
                          // ),
                          color: Colors.white,
                        ),
                      ),
                FutureBuilder(
                  future: talkCakeModel(),
                  builder: (ctx, AsyncSnapshot talkCache) {
                    if (talkCache.hasError) {
                      videoProvider.miniplayerController.animateToHeight(
                        state: PanelState.MIN,
                      );
                      Future.delayed(Duration.zero, () {
                        videoProvider.setdataTalk(null);
                      });
                    }
                    if (talkCache.hasData) {
                      if (controllerYT == null || playerYT == null) {
                        videoProvider.miniplayerController.animateToHeight(
                          state: PanelState.MIN,
                        );
                        Future.delayed(Duration.zero, () {
                          videoProvider.setdataTalk(null);
                        });
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: NewPlayerVideoBuilder(
                          pop: true,
                          hideChannel: widget.hideChannel,
                          controllerYT: controllerYT!,
                          player: playerYT!,
                          listSub: talkCache.data.getListSub(),
                          dataTalk: widget.dataTalk,
                          percent: widget.percent,
                          enablePop: widget.enablePop,
                        ),
                      );
                    }
                    return SizedBox();
                  },
                ),
              ],
            ),
          );
  }
}
