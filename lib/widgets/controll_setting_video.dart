import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/model_local/SettingVideoModel.dart';
import 'package:app_learn_english/networks/DataOffline.dart';
import 'package:app_learn_english/widgets/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsVideo extends StatefulWidget {
  SettingsVideo({Key? key}) : super(key: key);

  // SettingsVideo({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SettingsVideoState();
  }
}

class SettingsVideoState extends State<SettingsVideo> {
  var key = 1;

  Widget buildElementSetting(BuildContext context, String text,
      VideoSetting videoSetting, String key) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: CustomSwitch(
                activeColor: Colors.pinkAccent,
                value: key == "autoplay"
                    ? videoSetting.autoplay
                    : (key == "loop"
                        ? videoSetting.loop
                        : (key == "loopMainSentence"
                            ? videoSetting.loopMainSentence
                            : false)),
                onChanged: (value) {
                  setState(() {
                    switch (key) {
                      case "autoplay":
                        videoSetting.autoplay = value;
                        break;
                      case "loop":
                        videoSetting.loop = value;
                        break;
                      case "loopMainSentence":
                        videoSetting.loopMainSentence = value;
                        break;
                      default:
                    }
                    DataOffline()
                        .saveDataOffline("video_setting", videoSetting);
                  });
                },
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<VideoSetting>(
        builder: (context, child, videoSetting) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).Setting,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      size: 40,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).subtitle,
                    style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: videoSetting.subtitle,
                            onChanged: (value) {
                              setState(() {
                                videoSetting.subtitle = 1;
                                DataOffline().saveDataOffline(
                                    "video_setting", videoSetting);
                              });
                            },
                          ),
                          Text(
                            'ALL',
                            style: TextStyle(
                              fontSize: 20,
                              // fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 2,
                            groupValue: videoSetting.subtitle,
                            onChanged: (value) {
                              setState(() {
                                videoSetting.subtitle = 2;
                                DataOffline().saveDataOffline(
                                    "video_setting", videoSetting);
                              });
                            },
                          ),
                          Text(
                            'VI',
                            style: TextStyle(
                              fontSize: 20,
                              // fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 3,
                            groupValue: videoSetting.subtitle,
                            onChanged: (value) {
                              setState(() {
                                videoSetting.subtitle = 3;
                                DataOffline().saveDataOffline(
                                    "video_setting", videoSetting);
                              });
                            },
                          ),
                          Text(
                            'EN',
                            style: TextStyle(
                              fontSize: 20,
                              // fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 0,
                            groupValue: videoSetting.subtitle,
                            onChanged: (value) {
                              setState(() {
                                videoSetting.subtitle = 0;
                                DataOffline().saveDataOffline(
                                    "video_setting", videoSetting);
                              });
                            },
                          ),
                          Text(
                            'OFF',
                            style: TextStyle(
                              fontSize: 20,
                              // fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
            ),
            buildElementSetting(
                context, S.of(context).Autoplay, videoSetting, "autoplay"),
            buildElementSetting(
                context, S.of(context).AutoRepeat, videoSetting, "loop"),
            // buildElementSetting(
            //     context,
            //     S.of(context).RepeatMainSentencePattern,
            //     videoSetting,
            //     "loopMainSentence"),
          ],
        ),
      );
    });
  }
}
