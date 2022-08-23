import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/model_local/SettingModel.dart';
import 'package:app_learn_english/networks/DataOffline.dart';

import 'package:app_learn_english/startpage/page_hours.dart';
import 'package:flutter/material.dart';

import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toggle_switch/toggle_switch.dart';

class NotificatonScreen extends StatefulWidget {
  @override
  _NotificatonScreen createState() => _NotificatonScreen();
}

class _NotificatonScreen extends State<NotificatonScreen> {
  List<List<String>> _checkList = [[], [], [], []];

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SettingOffline>(
        builder: (context, child, settingData) {
      return Column(children: [
        buildSettingTimeNotification(context),
        // buildElementSetting(context, S.of(context).UsefulSentencePatterns,
        //     settingData, "switchMCHD", 0),
        // buildElementSetting(
        //     context, S.of(context).StudyGuide, settingData, "switchHDOT", 1),
        // buildElementSetting(context, S.of(context).TournamentInformation,
        //     settingData, "switchTTGD", 2),
        // buildElementSetting(context, S.of(context).NotificationLearn,
        //     settingData, "switchTBH", 3),
        // _buildChangeBackground()

        // buildElementSetting(context, S.of(context).InformationEvents,
        //     settingData, "switchTTSK"),
        // buildElementSetting(context, S.of(context).FriedChickenWarning,
        //     settingData, "switchCBHGR"),
        // buildElementSetting(context, S.of(context).NewContentOnSubscribeChannel,
        //     settingData, "switchNDMTKDK"),
      ]);
    });
  }

  bool getStatusSettingElement(SettingOffline settingData, String key) {
    bool status = false;
    switch (key) {
      case "switchMCHD":
        status = settingData.switchMCHD;
        break;
      case "switchHDOT":
        status = settingData.switchHDOT;
        break;
      case "switchTTGD":
        status = settingData.switchTTGD;
        break;
      case "switchTBH":
        status = settingData.switchTBH;
        break;
      case "switchTTSK":
        status = settingData.switchTTSK;
        break;
      case "switchCBHGR":
        status = settingData.switchCBHGR;
        break;
      case "switchNDMTKDK":
        status = settingData.switchNDMTKDK;
        break;
    }
    return status;
  }

  void setStatusSettingElement(
      SettingOffline settingData, String key, bool newStatus) {
    setState(() {
      switch (key) {
        case "switchMCHD":
          settingData.switchMCHD = newStatus;
          break;
        case "switchHDOT":
          settingData.switchHDOT = newStatus;
          break;
        case "switchTTGD":
          settingData.switchTTGD = newStatus;
          break;
        case "switchTBH":
          settingData.switchTBH = newStatus;
          break;
        case "switchTTSK":
          settingData.switchTTSK = newStatus;
          break;
        case "switchCBHGR":
          settingData.switchCBHGR = newStatus;
          break;
        case "switchNDMTKDK":
          settingData.switchNDMTKDK = newStatus;
          break;
      }

      DataOffline().saveDataOffline("MainSetting", settingData);
    });
  }

  Widget buildSettingTimeNotification(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      color: themeProvider.mode == ThemeMode.dark
          ? Color.fromRGBO(24, 26, 33, 1)
          : Color.fromRGBO(236, 236, 236, 1),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PageHours(
                isFirst: false,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xFFE9C145)),
          child: Container(
            width: double.infinity,
            height: 65,
            alignment: Alignment.center,
            child: Text(
              S.of(context).TimeSetting,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildElementSetting(BuildContext context, String text,
      SettingOffline settingData, String key, int index) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: width,
      height: 70,
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          ToggleSwitch(
            cornerRadius: 20.0,
            activeBgColors: [
              [const Color.fromRGBO(193, 189, 198, 1)],
              [const Color.fromRGBO(83, 180, 81, 1)]
            ],
            fontSize: 11,
            minHeight: 35,
            minWidth: 40,
            animate: true,
            activeFgColor: Colors.white,
            inactiveBgColor: themeProvider.mode == ThemeMode.dark
                ? const Color.fromRGBO(24, 26, 33, 1)
                : const Color.fromRGBO(226, 226, 226, 1),
            inactiveFgColor: Colors.white,
            initialLabelIndex:
                getStatusSettingElement(settingData, key) ? 1 : 0,
            totalSwitches: 2,
            labels: getStatusSettingElement(settingData, key)
                ? ['', 'ON']
                : ['OFF', ''],
            radiusStyle: true,
            onToggle: (index) {
              print('switched to: $index');
              if (index == 0) {
                setStatusSettingElement(settingData, key, false);
              } else {
                setStatusSettingElement(settingData, key, true);
              }
            },
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.6),
            width: 0.5,
          ),
        ),
      ),
    );
  }

  ///View change background
  // Widget _buildChangeBackground() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 16.0),
  //         child: Text(
  //           'Change theme background',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.normal,
  //           ),
  //         ),
  //       ),
  //       ModeToggleButton(),
  //     ],
  //   );
  // }
}
