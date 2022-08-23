import 'dart:convert';
import 'dart:async' show Future;
import 'dart:io';

import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/SettingVideoModel.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/widgets/sub_list_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../widgets/settings_video.dart';
import 'package:flutter/services.dart';

class PlayVideoWeb extends StatefulWidget {
  static const routeName = '/play-videos-web';
  final DataTalk talkData;
  PlayVideoWeb({required this.talkData});
  @override
  _PlayVideoWebState createState() => _PlayVideoWebState();
}

class _PlayVideoWebState extends State<PlayVideoWeb> {
  late YoutubePlayerController controller;
  String filter = 'All';
  Future<String> loadingSubtitle() async {
    return await rootBundle.loadString('assets/subtitle/sub.json');
  }

  Future<List<dynamic>> decodeSub() async {
    return json.decode(await loadingSubtitle());
  }

  late List<dynamic> subData;
  late List<TalkDetailModel> listSub;

  @override
  void initState() {
    DataCache().getListTextReview();
    super.initState();
    controller = YoutubePlayerController(
      initialVideoId: widget.talkData.yt_id,
      params: const YoutubePlayerParams(
        autoPlay: true,
        showControls: false,
        showFullscreenButton: false,
      ),
    );
    controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      printCyan('Entered Fullscreen');
    };
    controller.onExitFullscreen = () {
      printRed('Exited Fullscreen');
    };
  }

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

  @override
  Widget build(BuildContext context) {
    var localProvider = context.watch<LocaleProvider>();
    const player = YoutubePlayerIFrame();
    return ScopedModelDescendant<DataUser>(builder: (context, child, userData) {
      return YoutubePlayerControllerProvider(
        controller: controller,
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) => Scaffold(
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
                            DataCache()
                                .getTalkDetailByIdInCache(widget.talkData.id,(localProvider.codeLangeSub!=null)?localProvider.codeLangeSub!:localProvider.locale!.languageCode),
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
                                      isDrill: false);
                                  DataOffline().saveDataOffline(
                                      "video_setting", viSetting);
                                  return ScopedModel(
                                      model: userData,
                                      child: SubListWeb(
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
                                      child: SubListWeb(
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
                      ))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
