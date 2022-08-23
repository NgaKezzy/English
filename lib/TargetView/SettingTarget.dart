import 'package:app_learn_english/Providers/TargetProvider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/TargetOffline.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingTarget extends StatefulWidget {
  static const routeName = '/change-target';

  SettingTarget({Key? key});

  @override
  _SettingTargetState createState() => _SettingTargetState();
}

class _SettingTargetState extends State<SettingTarget> {
  _SettingTargetState({Key? key});

  bool isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<TargetProvider>(
      builder: (context, targetProvider, snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(45, 48, 57, 1)
                : Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/new_ui/more/Iconly-Arrow-Left.svg',
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            title: Text(
              S.of(context).SetLearningGoals,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          body: SafeArea(
            child: Container(
              width: width,
              height: height * 1,
              decoration: BoxDecoration(
                color: themeProvider.mode == ThemeMode.dark
                    ? Color.fromRGBO(24, 26, 33, 1)
                    : Colors.white,
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     Colors.blue.shade700,
                //     Colors.tealAccent.shade400,
                //   ],
                // ),
              ),
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Image.asset(
                                  // 'assets/linh_vat/linhvat2.png',
                                  'assets/new_ui/more/ic_splash.png',
                                  width: 70,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  height: 100,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      S.of(context).WhatIsYourLearningGoal,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            themeProvider.mode == ThemeMode.dark
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      for (var itemTarget
                          in TargetOffline().getListTarget(context))
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: () => {
                              TargetAPIs()
                                  .updateTarget(
                                      uid: DataCache().getUserData().uid,
                                      targetKey: itemTarget.key)
                                  .then(
                                    (status) => {
                                      if (status)
                                        {
                                          targetProvider
                                              .setItemTarget(itemTarget)
                                              .then((value) => {
                                                    DataCache().setSetTarget(
                                                        itemTarget.key),
                                                    Navigator.pop(
                                                        context, itemTarget),
                                                  }),
                                        }
                                      else
                                        {
                                          activeDialog(context,
                                              "Cập nhật mục tiêu thất bại!")
                                        }
                                    },
                                  )
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: themeProvider.mode == ThemeMode.dark
                                      ? Color.fromRGBO(42, 44, 50, 1)
                                      : Colors.white54.withOpacity(0.1),
                                  border: Border.all(
                                    width: 0.5,
                                    color: targetProvider.itemTarget!.key ==
                                            itemTarget.key
                                        ? Color.fromRGBO(60, 146, 247, 0.8)
                                        : Colors.grey.withOpacity(0.5),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    S
                                        .of(context)
                                        .getTargetName(itemTarget.name),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          themeProvider.mode == ThemeMode.dark
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    itemTarget.timeM.toString() +
                                        ' ' +
                                        S.of(context).Minutesday,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          themeProvider.mode == ThemeMode.dark
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Center(
                    child: Text(
                      S.of(context).CompleteDailyGoalsAndCollectFriedChicken,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
