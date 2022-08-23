import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/homepage/widgets/item_channel_fake.dart';

import 'package:app_learn_english/model_local/SettingVideoModel.dart';

import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/provider/miniplay_provider.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:app_learn_english/widgets/controll_setting_video.dart';
import 'package:app_learn_english/widgets/drill_switch.dart';
import 'package:app_learn_english/widgets/list_button_social.dart';
import 'package:app_learn_english/widgets/title_config_play_video.dart';
import 'package:async/async.dart';

import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SubListMilis extends StatefulWidget {
  final List<TalkDetailModel> listSub;
  final YoutubePlayerController controller;
  final Widget player;
  DataTalk talkData;
  VideoSetting videoSetting;
  bool isLongClick = false;
  bool isLoopSub = false;

  SubListMilis({
    required this.controller,
    required this.listSub,
    required this.player,
    required this.videoSetting,
    required this.talkData,
  });

  @override
  _SubListState createState() => _SubListState();
}

class _SubListState extends State<SubListMilis> {
  double speedRate = 1;
  CarouselController carouselController = CarouselController();
  int index = -1;
  Duration duration = Duration(milliseconds: 1);
  late RestartableTimer _restartTimer;
  Timer pauseTimer = Timer(Duration(milliseconds: 0), () {});
  Timer drillTimer = Timer(Duration(milliseconds: 0), () {});
  late RestartableTimer timerAutoPlay;
  bool isPlaying = false;
  bool isAutoPlayed = false;
  bool isFirtPlay = true;
  Duration? tickpause;
  late MiniPLayProvider providerVideo;
  bool firstCheckPause = true;
  bool checkPause = true;
  Widget? itemSub;

  @override
  void dispose() {
    super.dispose();
    AdsController().clearRoute();
    if (isPlaying) _restartTimer.cancel();
    drillTimer.cancel();
    providerVideo.onCancelVideo();
  }

  void showSettings(BuildContext ctx) async {
    var a = await showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return ScopedModel(model: widget.videoSetting, child: SettingsVideo());
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );
    (context as Element).markNeedsBuild();
  }

  loopSub() {
    _restartTimer.cancel();
    drillTimer.cancel();
    if (widget.isLoopSub == true) {
      widget.controller.seekTo(speedRate != 1
          ? Duration(milliseconds: widget.listSub[index].startTime ~/ speedRate)
          : Duration(milliseconds: widget.listSub[index].startTime));
      drillTimer = Timer(
          speedRate != 1
              ? Duration(
                  milliseconds: (widget.listSub[index + 1].startTime -
                          widget.listSub[index].startTime) ~/
                      speedRate)
              : Duration(
                  milliseconds: widget.listSub[index + 1].startTime -
                      widget.listSub[index].startTime),
          loopSub);
    } else {
      customControllerNextPage();
    }
  }

  longClickDrill() {
    _restartTimer.cancel();
    drillTimer.cancel();
    if (widget.isLongClick == true) {
      widget.controller
          .seekTo(Duration(milliseconds: widget.listSub[index].startTime));
      drillTimer = Timer(
          Duration(
              milliseconds: (widget.listSub[index + 1].startTime -
                  widget.listSub[index].startTime)),
          longClickDrill);
    } else {
      customControllerNextPage();
    }
  }

  void autoPlay() {
    if (isAutoPlayed == false) {
      isFirtPlay = false;
      updateAutoPlay();
      // timerAutoPlay =
      //     RestartableTimer(Duration(milliseconds: 2000), updateAutoPlay);
    }
  }

  void setPlaybackRate(double rate) {
    if (rate == 0.5) {
      widget.controller.setPlaybackRate(1);
      setState(() {
        speedRate = 1;
      });
    } else {
      widget.controller.setPlaybackRate(rate - 0.25);
      setState(() {
        speedRate = rate - 0.25;
      });
    }
  }

  void nextSlide() {
    if (providerVideo.isReady == true) {
      if (isPlaying == false) {
        setState(() {
          isPlaying = true;
          pauseTimer.cancel();
        });
      }
      index += 1;
      if (index >= widget.listSub.length) {
        index = 0;
      }
      if (index == 0) {
        duration = Duration(
            milliseconds:
                widget.listSub[1].startTime - widget.listSub[0].startTime);
      } else if (index >= widget.listSub.length) {
        duration = Duration(milliseconds: widget.listSub[0].startTime);
        widget.controller.seekTo(
            Duration(milliseconds: widget.listSub[0].startTime),
            allowSeekAhead: true);
      } else {
        if (index == widget.listSub.length - 1) {
          duration = Duration(
            milliseconds:
                widget.listSub[index].endTime - widget.listSub[index].startTime,
          );
        } else {
          duration = Duration(
            milliseconds: widget.listSub[index + 1].startTime -
                widget.listSub[index].startTime,
          );
        }
      }
      _restartTimer.cancel();
      _restartTimer = RestartableTimer(duration, customControllerNextPage);
      // carouselController.nextPage();
      carouselController.jumpToPage(index);
      index == 0
          ? widget.controller.seekTo(
              Duration(milliseconds: widget.listSub[0].startTime),
              allowSeekAhead: true,
            )
          : widget.controller.seekTo(
              Duration(milliseconds: widget.listSub[index].startTime),
              allowSeekAhead: true,
            );
    }
  }

  void prevSlide() {
    if (providerVideo.isReady == true) {
      if (isPlaying == false) {
        setState(() {
          isPlaying = true;
          pauseTimer.cancel();
        });
      }
      index -= 1;
      if (index < 0) {
        index = widget.listSub.length - 1;
      }
      if (index == 0) {
        duration = Duration(
            milliseconds:
                widget.listSub[1].startTime - widget.listSub[0].startTime);
      } else if (index >= widget.listSub.length) {
        duration = Duration(milliseconds: widget.listSub[0].startTime);
        widget.controller.seekTo(
          Duration(milliseconds: widget.listSub[0].startTime),
          allowSeekAhead: true,
        );
      } else {
        if (index == widget.listSub.length - 1) {
          duration = Duration(
            milliseconds:
                widget.listSub[index].endTime - widget.listSub[index].startTime,
          );
        } else {
          duration = Duration(
            milliseconds: widget.listSub[index + 1].startTime -
                widget.listSub[index].startTime,
          );
        }
      }
      _restartTimer.cancel();
      _restartTimer = RestartableTimer(duration, customControllerNextPage);

      // carouselController.previousPage();
      carouselController.jumpToPage(index);
      index == 0
          ? widget.controller.seekTo(
              Duration(milliseconds: widget.listSub[0].startTime),
              allowSeekAhead: true)
          : widget.controller.seekTo(
              Duration(milliseconds: widget.listSub[index].startTime),
              allowSeekAhead: true);
    }
  }

  pause() {
    setState(() {
      widget.controller.pause();
      isPlaying = false;
      tickpause = widget.controller.value.position;

      if (widget.listSub.length > 0) _restartTimer.cancel();
      pauseTimer.cancel();
    });
  }

  resume() {
    if (isFirtPlay) {
      printCyan("VAO DAY ");
      isFirtPlay = false;
      if (widget.listSub.length > 0) {
        setState(() {
          isAutoPlayed = true;
          isPlaying = true;
          // widget.controller.play();
          widget.controller.seekTo(
              Duration(milliseconds: widget.listSub[0].startTime),
              allowSeekAhead: true);
          tickpause = widget.controller.value.position;
          customControllerNextPage();
        });
      } else {
        setState(() {
          isAutoPlayed = true;
          isPlaying = true;
          widget.controller
              .seekTo(Duration(milliseconds: 0), allowSeekAhead: true);
          tickpause = widget.controller.value.position;
        });
      }
    } else {
      printCyan("HAY VAO DAY ");
      if (widget.listSub.length > 0) {
        if (index >= widget.listSub.length) {
          index = 0;
        }
        isPlaying = true;
        pauseTimer.cancel();
        widget.controller.play();
        pauseTimer = new RestartableTimer(
            Duration(
                milliseconds: widget.listSub[index + 1].startTime -
                    tickpause!.inMilliseconds),
            customControllerNextPage);
      } else {
        widget.controller.seekTo(
            Duration(milliseconds: tickpause!.inMilliseconds ~/ speedRate),
            allowSeekAhead: true);
      }
    }
  }

  updateAutoPlay() {
    if (widget.listSub.length > 0) {
      setState(() {
        isAutoPlayed = true;
        isPlaying = true;
        // widget.controller.play();
        // widget.controller.seekTo(
        //     Duration(milliseconds: widget.listSub[0].startTime),
        //     allowSeekAhead: true);
        tickpause = widget.controller.value.position;
        // timerAutoPlay.cancel();
      });
      Future.delayed(Duration.zero, () async {
        customControllerNextPage();
      });
    } else {
      setState(() {
        isAutoPlayed = true;
        isPlaying = true;
        widget.controller
            .seekTo(Duration(milliseconds: 0), allowSeekAhead: true);
        tickpause = widget.controller.value.position;
        // timerAutoPlay.cancel();
      });
    }
  }

  customControllerNextPage() {
    index += 1;
    index != -1 ? carouselController.jumpToPage(index) : printYellow("TSART");
    if (index >= widget.listSub.length) {
      if (widget.videoSetting.loop == true) {
        index = 0;
        carouselController.jumpToPage(index);
        widget.controller.seekTo(
            Duration(milliseconds: widget.listSub[0].startTime),
            allowSeekAhead: true);
      } else {
        setState(() {
          isPlaying = false;
          carouselController.jumpToPage(index);
          widget.controller.seekTo(
            Duration(milliseconds: widget.listSub[0].startTime),
            allowSeekAhead: true,
          );
          _restartTimer.cancel();
          widget.controller.pause();
          pauseTimer.cancel();
          tickpause = Duration(milliseconds: widget.listSub[0].startTime);
        });
      }
      duration = speedRate != 1
          ? Duration(
              milliseconds: Duration(
                          milliseconds: (widget.listSub[1].startTime -
                              widget.listSub[0].startTime))
                      .inMilliseconds ~/
                  speedRate)
          : Duration(
              milliseconds:
                  widget.listSub[1].startTime - widget.listSub[0].startTime);
    } else if (index == 0) {
      duration = speedRate != 1
          ? Duration(
              milliseconds: Duration(
                          milliseconds: (widget.listSub[1].startTime -
                              widget.listSub[0].startTime))
                      .inMilliseconds ~/
                  speedRate)
          : Duration(
              milliseconds:
                  (widget.listSub[1].startTime - widget.listSub[0].startTime));
    } else {
      if (index == widget.listSub.length - 1) {
        duration = Duration(
          milliseconds:
              (widget.listSub[index].endTime - widget.listSub[index].startTime),
        );
      } else {
        duration = speedRate != 1
            ? Duration(
                milliseconds: Duration(
                      milliseconds: (widget.listSub[index + 1].startTime -
                          widget.listSub[index].startTime),
                    ).inMilliseconds ~/
                    speedRate,
              )
            : Duration(
                milliseconds: (widget.listSub[index + 1].startTime -
                    widget.listSub[index].startTime),
              );
      }
    }
    if (widget.videoSetting.loop == true ||
        (widget.videoSetting.loop == false && index < widget.listSub.length)) {
      _restartTimer = RestartableTimer(duration, customControllerNextPage);
    }
  }

  Widget buildButtonControll(BuildContext context, IconData icon, int type) {
    return InkWell(
      onTap: type == 1 ? nextSlide : prevSlide,
      child: Card(
        child: Icon(
          icon,
          size: 30,
        ),
        color: Color.fromRGBO(216, 220, 227, 1),
        shape: type == 1
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              )
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return Consumer<MiniPLayProvider>(
            builder: (context, provider, snapshot) {
          Future.delayed(Duration.zero, () async {
            providerVideo = provider;

            provider.isReady == true
                ? widget.videoSetting.autoplay == true
                    ? autoPlay()
                    : printYellow("Không tự động phát")
                : printRed("Đang chờ load video");
          });

          // Future.delayed(Duration.zero, () async {
          //   providerVideo = provider;
          //   if (provider.isReady == true) {
          //     if (widget.videoSetting.autoplay == true) {
          //       autoPlay();
          //       if (firstCheckPause) {
          //         pause();
          //         resume();
          //         firstCheckPause = false;
          //       }
          //     } else {
          //       printYellow("Không tự động phát");
          //     }
          //   } else {
          //     printRed("Đang chờ load video");
          //   }
          // });
          return ScopedModelDescendant<DataUser>(
              builder: (context, child, userData) {
            return SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 81,
                  child: Container(
                    child: Stack(
                      children: [
                        widget.player,
                        Positioned.fill(
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: provider.isReady == true
                                      ? (isPlaying == false
                                          ? InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons
                                                        .play_circle_fill_outlined,
                                                    size: 50,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              onTap: () => {
                                                    setState(() {
                                                      widget.controller.play();
                                                      isPlaying = true;
                                                      // customControllerNextPage();
                                                      resume();
                                                    })
                                                  })
                                          : InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                              onTap: () => {
                                                    setState(() {
                                                      widget.controller.pause();
                                                      isPlaying = false;
                                                      tickpause = widget
                                                          .controller
                                                          .value
                                                          .position;

                                                      widget.listSub.length > 0
                                                          ? _restartTimer
                                                              .cancel()
                                                          : null;
                                                      pauseTimer.cancel();
                                                    })
                                                  }))
                                      : InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              // child: Platform.isAndroid
                                              //     ? CircularProgressIndicator()
                                              //     : CupertinoActivityIndicator(),
                                            ),
                                          ),
                                          onTap: () => {})),
                              Positioned(
                                top: 20,
                                left: 5,
                                child: InkWell(
                                  onTap: () {
                                    provider.startMiniPlay(
                                        widget.talkData,
                                        widget.controller.value.position
                                            .inMilliseconds);
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 256,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          widget.listSub.isNotEmpty
                              ? Expanded(
                                  flex: 3,
                                  child: CarouselSlider.builder(
                                    carouselController: carouselController,
                                    options: CarouselOptions(
                                        height: double.infinity,
                                        viewportFraction: 1,
                                        autoPlay: false,
                                        scrollPhysics:
                                            new NeverScrollableScrollPhysics(),
                                        onPageChanged: (indexPage, reason) {
                                          setState(() {
                                            widget.isLongClick = false;
                                          });
                                        }),
                                    itemBuilder:
                                        (ctx, itemIndex, pageViewIndex) {
                                      return SwipeTo(
                                        // Swiping in right direction.
                                        onLeftSwipe: () {
                                          nextSlide();
                                        },

                                        // Swiping in left direction.
                                        onRightSwipe: () {
                                          prevSlide();
                                        },
                                        offsetDx: 0,

                                        child: Stack(
                                          children: [
                                            widget.talkData.isVip == true &&
                                                    (userData.isVip == 0 ||
                                                        userData.isVip == 3)
                                                ? Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                                flex: 5,
                                                                child:
                                                                    Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                5),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.lock, size: 35),
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Text(
                                                                                S.of(context).ExclusivelyForTurtleVIPMembers,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ))),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                width: 350,
                                                                height: 20,
                                                                child:
                                                                    ElevatedButton(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                          child:
                                                                              Image.asset(
                                                                        'assets/icons-svg/icon_vip.png',
                                                                        width:
                                                                            40,
                                                                      )),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        S
                                                                            .of(context)
                                                                            .StartUsingVIP,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (_) {
                                                                          return VipWidget();
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            )
                                                          ],
                                                        )))
                                                : GestureDetector(
                                                    onLongPress: () {
                                                      setState(() {
                                                        widget.isLongClick =
                                                            true;
                                                        longClickDrill();
                                                      });
                                                    },
                                                    onLongPressUp: () {
                                                      setState(() {
                                                        widget.isLongClick =
                                                            false;
                                                      });
                                                    },
                                                    child: (widget.isLongClick ==
                                                                    true &&
                                                                widget.videoSetting
                                                                        .isDrill ==
                                                                    true) ||
                                                            widget.videoSetting
                                                                    .isDrill ==
                                                                false
                                                        ? Container(
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            child: Card(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                              ),
                                                              child: Container(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Flexible(
                                                                              child: Row(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: widget.controller.value.isPlaying ? () => setPlaybackRate(speedRate) : () {},
                                                                                    child: Container(
                                                                                      child: Align(
                                                                                        alignment: Alignment.center,
                                                                                        child: Text(
                                                                                          '${speedRate}x',
                                                                                          style: TextStyle(
                                                                                            fontSize: 15,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      height: 30,
                                                                                      width: 55,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.blue),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        widget.isLoopSub = !widget.isLoopSub;
                                                                                        if (widget.isLoopSub == true) {
                                                                                          loopSub();
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    child: widget.isLoopSub == true
                                                                                        ? Container(
                                                                                            child: Align(
                                                                                              alignment: Alignment.center,
                                                                                              child: Icon(
                                                                                                Icons.repeat_outlined,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                            height: 30,
                                                                                            width: 55,
                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.blue),
                                                                                          )
                                                                                        : Container(
                                                                                            child: Align(
                                                                                              alignment: Alignment.center,
                                                                                              child: Icon(
                                                                                                Icons.repeat_outlined,
                                                                                                color: Colors.blue,
                                                                                              ),
                                                                                            ),
                                                                                            height: 30,
                                                                                            width: 55,
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(30),
                                                                                              border: Border.all(
                                                                                                width: 0.5,
                                                                                                color: Colors.blue,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Flexible(
                                                                                child: Container(
                                                                              width: 65,
                                                                              height: 33,
                                                                              child: SwitchDrill(
                                                                                value: widget.videoSetting.isDrill,
                                                                                onChanged: (changed) {
                                                                                  DataOffline().saveDataOffline("video_setting", widget.videoSetting);
                                                                                  setState(() {
                                                                                    if (widget.isLoopSub == true) {
                                                                                      widget.isLoopSub = false;
                                                                                    }
                                                                                    widget.videoSetting.isDrill = changed;
                                                                                  });
                                                                                },
                                                                              ),
                                                                            )),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 4,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                5,
                                                                            child:
                                                                                ListView(
                                                                              shrinkWrap: true,
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.symmetric(
                                                                                    horizontal: 10,
                                                                                  ),
                                                                                  child: widget.videoSetting.subtitle != 0
                                                                                      ? widget.videoSetting.subtitle == 1
                                                                                          ? ListTile(
                                                                                              title: Text(widget.listSub[itemIndex].content, style: TextStyle(fontSize: 20)),
                                                                                              subtitle: Container(
                                                                                                margin: EdgeInsets.only(top: 10),
                                                                                                child: Text(widget.listSub[itemIndex].content_vi, style: TextStyle(fontSize: 16)),
                                                                                              ),
                                                                                            )
                                                                                          : (widget.videoSetting.subtitle == 2
                                                                                              ? ListTile(
                                                                                                  title: Text(widget.listSub[itemIndex].content_vi, style: TextStyle(fontSize: 20)),
                                                                                                )
                                                                                              : ListTile(
                                                                                                  title: Text(widget.listSub[itemIndex].content, style: TextStyle(fontSize: 20)),
                                                                                                ))
                                                                                      : SizedBox(),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                                                              margin: EdgeInsets.only(left: 15),
                                                                              width: double.infinity,
                                                                              height: double.infinity,
                                                                              child: FutureBuilder(
                                                                                future: DataCache().getListNewWordByIdInCache(widget.listSub[itemIndex].id),
                                                                                builder: (context, AsyncSnapshot snapshot) {
                                                                                  if (snapshot.hasError) {
                                                                                    Future.delayed(Duration.zero, () async {
                                                                                      if (checkPause) {
                                                                                        pause();
                                                                                        setState(() {
                                                                                          checkPause = false;
                                                                                        });
                                                                                      }
                                                                                    });
                                                                                    return SizedBox();
                                                                                  }
                                                                                  return snapshot.hasData
                                                                                      ? ListView(
                                                                                          children: [
                                                                                            for (var newWord in snapshot.data!.getListNewWord())
                                                                                              Row(
                                                                                                children: [
                                                                                                  Text(capitalize(newWord.content.toLowerCase())),
                                                                                                  Text(": "),
                                                                                                  Text(capitalize(newWord.content_vi.toLowerCase())),
                                                                                                ],
                                                                                              )
                                                                                          ],
                                                                                        )
                                                                                      : SizedBox();
                                                                                },
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                10),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.center,
                                                                              child: Container(
                                                                                margin: EdgeInsets.only(left: 15),
                                                                                width: double.infinity,
                                                                                child: Text(
                                                                                  '${itemIndex + 1}/${widget.listSub.length}',
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 20,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              right: 16,
                                                                              top: 5,
                                                                              child: Container(
                                                                                width: 30,
                                                                                height: 30,
                                                                                decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                      width: 0.5,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(50)),
                                                                                child: DataCache().checkSentenceVideo(widget.listSub[itemIndex], 1) == false
                                                                                    ? InkWell(
                                                                                        onTap: () {
                                                                                          TalkAPIs().addItemCourse('${userData.uid}', widget.listSub[itemIndex].id.toString(), 1, lang).then((value) {
                                                                                            (context as Element).markNeedsBuild();
                                                                                            if (value == 1) {
                                                                                              Utils().showNotificationBottom(true, S.of(context).AddedSuccess);
                                                                                            } else if (value == 0) {
                                                                                              Utils().showNotificationBottom(false, S.of(context).AddFailedSentence);
                                                                                            } else if (value == -1) {
                                                                                              Utils().showNotificationBottom(false, S.of(context).SentencePatternAlready);
                                                                                            }
                                                                                          });
                                                                                        },
                                                                                        child: Icon(
                                                                                          Icons.add,
                                                                                          size: 25,
                                                                                        ),
                                                                                      )
                                                                                    : InkWell(
                                                                                        onTap: () {
                                                                                          Utils().showNotificationBottom(false, S.of(context).SentencePatternAlready);
                                                                                        },
                                                                                        child: Icon(
                                                                                          Icons.check,
                                                                                          size: 25,
                                                                                        ),
                                                                                      ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            child: Card(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                    10,
                                                                  ),
                                                                ),
                                                              ),
                                                              child: Container(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 16),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Flexible(
                                                                              child: Row(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () => setPlaybackRate(speedRate),
                                                                                    child: Container(
                                                                                      child: Align(
                                                                                        alignment: Alignment.center,
                                                                                        child: Text(
                                                                                          '${speedRate}x',
                                                                                          style: TextStyle(
                                                                                            fontSize: 15,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      height: 30,
                                                                                      width: 55,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.blue),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Flexible(
                                                                              child: Container(
                                                                                width: 65,
                                                                                height: 33,
                                                                                child: SwitchDrill(
                                                                                  value: widget.videoSetting.isDrill,
                                                                                  onChanged: (changed) {
                                                                                    DataOffline().saveDataOffline("video_setting", widget.videoSetting);

                                                                                    setState(() {
                                                                                      if (widget.isLoopSub == true) {
                                                                                        widget.isLoopSub = false;
                                                                                      }
                                                                                      widget.videoSetting.isDrill = changed;
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 4,
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.touch_app_outlined, size: 40),
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Text(S.of(context).LongPressToSeeSubtitles)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  buildButtonControll(
                                                      context,
                                                      Icons
                                                          .chevron_left_outlined,
                                                      -1),
                                                  buildButtonControll(
                                                      context,
                                                      Icons
                                                          .chevron_right_outlined,
                                                      1),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: widget.listSub.length,
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(left: 16, right: 16),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 50,
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      S.of(context).ThereIsNoSampleSentenceList,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                          Expanded(
                              flex: 2,
                              child: Container(
                                child: Column(
                                  children: [
                                    TitleConfigVideo(
                                      title: widget.talkData.name,
                                      showSetting: showSettings,
                                    ),
                                    ListButtonSocial(
                                      talkData: widget.talkData,
                                    ),
                                    FutureBuilder(
                                      future: TalkAPIs().getCategoryById(
                                        categoryId: widget.talkData.catId,
                                      ),
                                      builder: (context,
                                          AsyncSnapshot cetegoryData) {
                                        if (cetegoryData.hasData) {
                                          itemSub = Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            width: double.infinity,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: ItemChannelFake(
                                              channel: cetegoryData.data,
                                            ),
                                          );
                                          return itemSub!;
                                        } else {
                                          return itemSub != null
                                              ? itemSub!
                                              : Center(
                                                  // child: Platform.isAndroid
                                                  //     ? CircularProgressIndicator()
                                                  //     : CupertinoActivityIndicator(),
                                                  );
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ))
              ],
            ));
          });
        });
      },
    );
  }
}
