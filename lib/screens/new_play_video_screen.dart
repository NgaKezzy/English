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

class NewPlayVideoScreen extends StatefulWidget {
  final DataTalk dataTalk;
  final double percent;
  final bool isHideChanel;

  NewPlayVideoScreen({
    Key? key,
    required this.dataTalk,
    required this.percent,
    this.isHideChanel = false,
  }) : super(key: key);

  @override
  _NewPlayVideoScreenState createState() => _NewPlayVideoScreenState();
}

class _NewPlayVideoScreenState extends State<NewPlayVideoScreen> {
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
  bool _isAutoPlay = true;
  var admobHelper = AdmobHelper();

  // YoutubePlayer buildYoutubePlayer(YoutubePlayerController controller) {
  //   return YoutubePlayer(
  //     controller: controller,
  //     onReady: () {},
  //   );
  // }

  @override
  void initState() {
    super.initState();
    heartProvider = Provider.of<CountHeartProvider>(
      context,
      listen: false,
    );
    admobHelper.getBannerAd();
    // admob.createInterstitialAd();
    admob.getBannerAd();
  }

  Future<TalkCacheModel> buildTalkCache() {
    var localProvider = context.read<LocaleProvider>();
    return DataCache().getTalkDetailByIdInCache(
        widget.dataTalk.id,
        (localProvider.codeLangeSub != null)
            ? localProvider.codeLangeSub!
            : localProvider.locale!.languageCode);
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      PlyrVideoPlayer().initAdsBanner(admobHelper.bannerAd);
      heartProvider.setButtonAds(false);
      prefs.setBool('isShowAds', false);
      // admob.showInterstitialAd();
    }

    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    videoProvider = Provider.of<VideoProvider>(context);
    var localProvider = context.read<LocaleProvider>();
    if (videoProvider.val) {
      print('nhảy vào đây rồi này');
      try {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        if (_prefs.containsKey('settingVideo-autoPlay')) {
          print('Nhảy vào set autoPlay');
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
        final TalkDetailModel startTime = listSub[0];
        final TalkDetailModel endTime = listSub[listSub.length - 1];
        controllerYT = YoutubePlayerController(
          initialVideoId: widget.dataTalk.yt_id,
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
        )..listen((value) {
            if (value.isReady && !value.hasPlayed) {
              controllerYT!
                ..hidePauseOverlay()
                ..hideTopMenu();
            }
          });

        Provider.of<VideoProvider>(context, listen: false)
            .setControllerYoutube(controllerYT!);
      } catch (error) {
        controllerYT = YoutubePlayerController(
          initialVideoId: widget.dataTalk.yt_id,
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
        Provider.of<VideoProvider>(context, listen: false)
            .setControllerYoutube(controllerYT!);
      }

      playerYT = YoutubePlayerIFrame(
        controller: controllerYT,
      );

      videoProvider.setVal(false);
    }
    context.read<SocketProvider>().setIsInsideRoom(false);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    talkCacheFnc = talkCakeModel();
    return videoProvider.val
        ? Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
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
                        decoration: const BoxDecoration(
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
                  future: talkCacheFnc,
                  builder: (ctx, AsyncSnapshot talkCache) {
                    if (talkCache.hasError) {
                      videoProvider.miniplayerController.animateToHeight(
                        state: PanelState.MIN,
                      );
                      Future.delayed(Duration.zero, () {
                        videoProvider.setdataTalk(null);
                      });
                      // return Container(
                      //   child: Stack(
                      //     children: [
                      //       InkWell(
                      //         onTap: () {
                      //           videoProvider.setdataTalk(null);
                      //         },
                      //         child: Align(
                      //           alignment: Alignment.centerRight,
                      //           child: const Padding(
                      //             padding: EdgeInsets.all(8.0),
                      //             child: Icon(
                      //               Icons.clear,
                      //               size: 30,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Align(
                      //         alignment: Alignment.center,
                      //         child: Text(
                      //           S.of(context).ErrorLoadingVideo,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // );
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
                          controllerYT: controllerYT!,
                          player: playerYT!,
                          listSub: talkCache.data.getListSub(),
                          dataTalk: widget.dataTalk,
                          percent: widget.percent,
                          pop: false,
                          hideChannel: widget.isHideChanel,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          );
  }
}
