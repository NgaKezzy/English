import 'dart:async';

import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/widgets/item_channel_fake.dart';
import 'package:app_learn_english/model_local/SettingVideoModel.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
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
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class SubListWeb extends StatefulWidget {
  final List<TalkDetailModel> listSub;
  final YoutubePlayerController controller;
  final Widget player;
  DataTalk talkData;
  VideoSetting videoSetting;
  bool isLongClick = false;
  bool isLoopSub = false;

  SubListWeb(
      {required this.controller,
      required this.listSub,
      required this.player,
      required this.videoSetting,
      required this.talkData});

  @override
  _SubListWebState createState() => _SubListWebState();
}

class _SubListWebState extends State<SubListWeb> {
  double speedRate = 1;
  CarouselController carouselController = CarouselController();
  int index = -1;
  Duration duration = Duration(seconds: 1);
  late RestartableTimer _restartTimer;
  Timer pauseTimer = Timer(Duration(milliseconds: 0), () {});
  Timer drillTimer = Timer(Duration(seconds: 0), () {});
  late RestartableTimer timerAutoPlay;
  bool isPlaying = true;
  bool isAutoPlayed = false;
  Duration? tickpause;

  @override
  void dispose() {
    super.dispose();
    AdsController().clearRoute();
    isPlaying ? _restartTimer.cancel() : {};
    drillTimer.cancel();
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

  void pause() {
    widget.controller.pause();
  }

  void play() {
    widget.controller.play();
  }

  loopSub() {
    _restartTimer.cancel();
    drillTimer.cancel();
    if (widget.isLoopSub == true) {
      widget.controller
          .seekTo(Duration(seconds: widget.listSub[index].startTime));
      drillTimer = Timer(
          Duration(
              seconds: (widget.listSub[index + 1].startTime -
                  widget.listSub[index].startTime)),
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
          .seekTo(Duration(seconds: widget.listSub[index].startTime));
      drillTimer = Timer(
          Duration(
              seconds: (widget.listSub[index + 1].startTime -
                  widget.listSub[index].startTime)),
          longClickDrill);
    } else {
      customControllerNextPage();
    }
  }

  void autoPlay() {
    if (isAutoPlayed == false) {
      timerAutoPlay = RestartableTimer(Duration(seconds: 2), updateAutoPlay);
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
    if (isPlaying) {
      index += 1;
      if (index >= widget.listSub.length) {
        index = 0;
      }
      if (index == 0) {
        duration = Duration(seconds: widget.listSub[1].startTime);
      } else if (index >= widget.listSub.length) {
        duration = Duration(seconds: widget.listSub[0].startTime);
        widget.controller.seekTo(Duration(seconds: widget.listSub[0].startTime),
            allowSeekAhead: true);
      } else {
        if (index == widget.listSub.length - 1) {
          duration = Duration(
            seconds:
                widget.listSub[index].endTime - widget.listSub[index].startTime,
          );
        } else {
          duration = Duration(
            seconds: widget.listSub[index + 1].startTime -
                widget.listSub[index].startTime,
          );
        }
      }
      _restartTimer.cancel();
      _restartTimer = RestartableTimer(duration, customControllerNextPage);
      carouselController.nextPage();
      index == 0
          ? widget.controller.seekTo(
              Duration(seconds: widget.listSub[0].startTime),
              allowSeekAhead: true)
          : widget.controller.seekTo(
              Duration(seconds: widget.listSub[index].startTime),
              allowSeekAhead: true);
    }
  }

  void prevSlide() {
    if (isPlaying) {
      index -= 1;
      if (index < 0) {
        index = widget.listSub.length - 1;
      }
      if (index == 0) {
        duration = Duration(seconds: widget.listSub[1].startTime);
      } else if (index >= widget.listSub.length) {
        duration = Duration(seconds: widget.listSub[0].startTime);
        widget.controller.seekTo(Duration(seconds: widget.listSub[0].startTime),
            allowSeekAhead: true);
      } else {
        if (index == widget.listSub.length - 1) {
          duration = Duration(
            seconds:
                widget.listSub[index].endTime - widget.listSub[index].startTime,
          );
        } else {
          duration = Duration(
            seconds: widget.listSub[index + 1].startTime -
                widget.listSub[index].startTime,
          );
        }
      }
      _restartTimer.cancel();
      _restartTimer = RestartableTimer(duration, customControllerNextPage);

      carouselController.previousPage();
      index == 0
          ? widget.controller.seekTo(
              Duration(seconds: widget.listSub[0].startTime),
              allowSeekAhead: true)
          : widget.controller.seekTo(
              Duration(seconds: widget.listSub[index].startTime),
              allowSeekAhead: true);
    }
  }

  resume() {
    pauseTimer.cancel();
    widget.controller.play();
    pauseTimer = new RestartableTimer(
        Duration(
            milliseconds:
                (Duration(seconds: widget.listSub[index + 1].startTime)
                        .inMilliseconds -
                    tickpause!.inMilliseconds)),
        customControllerNextPage);
  }

  updateAutoPlay() {
    printCyan("AUTO PLAY: " + widget.listSub[0].startTime.toString());
    setState(() {
      index != -1;
      isAutoPlayed = true;
      isPlaying = true;
      // widget.controller.play();
      widget.controller.seekTo(Duration(seconds: widget.listSub[0].startTime),
          allowSeekAhead: true);
      customControllerNextPage();
      timerAutoPlay.cancel();
    });
  }

  customControllerNextPage() {
    index != -1 ? carouselController.nextPage() : printYellow("TSART");

    index += 1;
    if (index >= widget.listSub.length) {
      if (widget.videoSetting.loop == true) {
        index = 0;
        widget.controller.seekTo(Duration(seconds: widget.listSub[0].startTime),
            allowSeekAhead: true);
      } else {
        widget.controller.seekTo(Duration(seconds: widget.listSub[0].startTime),
            allowSeekAhead: true);
        _restartTimer != null ? _restartTimer.cancel() : {};
        widget.controller.pause();
      }
    }
    if (index == 0) {
      duration = Duration(
          seconds:
              (widget.listSub[1].startTime - widget.listSub[0].startTime) + 2);
    } else {
      if (index == widget.listSub.length - 1) {
        duration = Duration(
          seconds:
              widget.listSub[index].endTime - widget.listSub[index].startTime,
        );
      } else {
        duration = Duration(
          seconds: widget.listSub[index + 1].startTime -
              widget.listSub[index].startTime,
        );
      }
    }

    _restartTimer = RestartableTimer(duration, customControllerNextPage);
  }

  Widget buildButtonControll(BuildContext context, IconData icon, int type) {
    return InkWell(
      onTap: type == 1 ? nextSlide : prevSlide,
      child: Card(
        child: Icon(
          icon,
          size: 30,
        ),
        color: Color.fromRGBO(216, 220, 227, 0.7),
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
        widget.videoSetting.autoplay == true
            ? autoPlay()
            : printYellow("Không tự động phát");
        return Consumer<MiniPLayProvider>(
            builder: (context, provider, snapshot) {
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
                                  child: isPlaying == false
                                      ? InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.play_arrow_outlined,
                                                size: 70,
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
                                              color:
                                                  Colors.black.withOpacity(0),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          onTap: () => {
                                                setState(() {
                                                  widget.controller.pause();
                                                  isPlaying = false;
                                                  tickpause = widget.controller
                                                      .value.position;
                                                  _restartTimer.cancel();
                                                  pauseTimer.cancel();
                                                })
                                              })),
                              Positioned(
                                  top: 10,
                                  left: 10,
                                  child: InkWell(
                                    onTap: () {
                                      provider.startMiniPlay(
                                          widget.talkData,
                                          widget.controller.value.position
                                              .inSeconds);
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.expand_more_sharp,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  )),
                            ],
                          )),
                        ],
                      ),
                    )),
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
                                        onPageChanged: (indexPage, reason) {
                                          setState(() {
                                            widget.isLongClick = false;
                                          });
                                        }),
                                    itemBuilder:
                                        (ctx, itemIndex, pageViewIndex) {
                                      return Stack(
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
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                              flex: 5,
                                                              child: Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              5),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .lock,
                                                                            size:
                                                                                35),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                            "Dành riêng cho hội viên Turtle VIP")
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
                                                                        child: Image
                                                                            .asset(
                                                                      'assets/icons-svg/icon_vip.png',
                                                                      width: 40,
                                                                    )),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      'Bắt đầu dùng Turtle VIP',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onPressed: () {
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
                                                      widget.isLongClick = true;
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
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () => setPlaybackRate(speedRate),
                                                                                  child: Container(
                                                                                    child: Align(
                                                                                      alignment: Alignment.center,
                                                                                      child: Text(
                                                                                        '${speedRate}x',
                                                                                        style: TextStyle(
                                                                                          fontSize: 18,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    height: 33,
                                                                                    width: 60,
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
                                                                                          height: 33,
                                                                                          width: 60,
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
                                                                                          height: 33,
                                                                                          width: 60,
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
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                35,
                                                                            child:
                                                                                SwitchDrill(
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
                                                                    flex: 3,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              ListView(
                                                                            shrinkWrap:
                                                                                true,
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
                                                                          child: Container(
                                                                              margin: EdgeInsets.only(left: 15),
                                                                              width: double.infinity,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    margin: EdgeInsets.only(left: 15),
                                                                                    width: double.infinity,
                                                                                    child: FutureBuilder(
                                                                                      future: DataCache().getListNewWordByIdInCache(widget.listSub[itemIndex].id),
                                                                                      builder: (context, AsyncSnapshot snapshot) {
                                                                                        if (snapshot.hasError) {
                                                                                          return Center(
                                                                                            child: Text(
                                                                                              S.of(context).Anerrordata,
                                                                                            ),
                                                                                          );
                                                                                        }
                                                                                        if (snapshot.hasData) {
                                                                                          snapshot.data.toJSONY();
                                                                                        }
                                                                                        return snapshot.hasData
                                                                                            ? Column(
                                                                                                children: [
                                                                                                  for (var _ in snapshot.data.getListNewWord()) Text("HAHAHAHA"),
                                                                                                ],
                                                                                              )
                                                                                            : SizedBox();
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )),
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
                                                                            Column(
                                                                              children: [
                                                                                Container(
                                                                                  margin: EdgeInsets.only(left: 15),
                                                                                  width: double.infinity,
                                                                                  child: Text(
                                                                                    '${itemIndex + 1}/${widget.listSub.length}',
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 23,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
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
                                                                                                if (value == 1) {
                                                                                                  Utils().showNotificationBottom(true, S.of(context).SuccessfullyAdded);
                                                                                                } else if (value == 0) {
                                                                                                  Utils().showNotificationBottom(false, S.of(context).AddFailedSentencePattern);
                                                                                                } else if (value == -1) {
                                                                                                  Utils().showNotificationBottom(false, S.of(context).SentencePatternAlreadyExists);
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
                                                                                              Utils().showNotificationBottom(false, S.of(context).ThisSentencePatternHasBeenAdded);
                                                                                            },
                                                                                            child: Icon(
                                                                                              Icons.check,
                                                                                              size: 25,
                                                                                            ),
                                                                                          )))
                                                                          ],
                                                                        ),
                                                                      ))
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
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                              ),
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5),
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
                                                                                            fontSize: 18,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      height: 33,
                                                                                      width: 60,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.blue),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Flexible(
                                                                              child: Container(
                                                                                width: 70,
                                                                                height: 35,
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
                                                                        flex: 3,
                                                                        child: Container(
                                                                            child: Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.coronavirus, size: 50),
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Text("Nhấn giữ để xem phụ đề")
                                                                            ],
                                                                          ),
                                                                        ))),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Container())
                                                                  ],
                                                                ),
                                                              ))),
                                                ),
                                          Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                buildButtonControll(
                                                    context,
                                                    Icons.chevron_left_outlined,
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
                                      "Không có danh sách mẫu câu!",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  )),
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
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      width: double.infinity,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ItemChannelFake(
                                          channel: Category(
                                              id: 1,
                                              name: "Danh mục tạm thời",
                                              name_vi: "Danh mục tạm thời",
                                              name_zh: "Danh mục tạm thời",
                                              name_ja: "Danh mục tạm thời",
                                              name_hi: "Danh mục tạm thời",
                                              name_es: "Danh mục tạm thời",
                                              name_ru: "Danh mục tạm thời",
                                              name_tr: "Danh mục tạm thời",
                                              name_pt: "Danh mục tạm thời",
                                              name_id: "Danh mục tạm thời",
                                              name_th: "Danh mục tạm thời",
                                              name_ms: "Danh mục tạm thời",
                                              name_ar: "Danh mục tạm thời",
                                              name_fr: "Danh mục tạm thời",
                                              name_it: "Danh mục tạm thời",
                                              name_de: "Danh mục tạm thời",
                                              name_ko: "Danh mục tạm thời",
                                              name_zh_Hant_TW:
                                                  "Danh mục tạm thời",
                                              name_sk: "Danh mục tạm thời",
                                              name_sl: "Danh mục tạm thời",
                                              description: "",
                                              description_vi: "",
                                              description_zh: "",
                                              description_ja: "",
                                              description_hi: "",
                                              description_es: "",
                                              description_ru: "",
                                              description_tr: "",
                                              description_pt: "",
                                              description_id: "",
                                              description_th: "",
                                              description_ms: "",
                                              description_ar: "",
                                              description_fr: "",
                                              description_it: "",
                                              description_de: "",
                                              description_ko: "",
                                              description_zh_Hant_TW: "",
                                              description_sk: "",
                                              description_sl: "",
                                              parentId: 0,
                                              slug: "",
                                              picture: "1631162014_392430.jpg",
                                              start: 0,
                                              totalFollow: 0,
                                              totalTalk: 0,
                                              type: 1,
                                              isActive: 1,
                                              listTalk: [],
                                              listChannel: [],
                                              listCourse: [],
                                              picLink: '')),
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
