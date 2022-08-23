import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/networks/DataFirtAppLog.dart';
import 'package:app_learn_english/startpage/widget/bar_widget.dart';
import 'package:app_learn_english/startpage/widget/center_widget.dart';

import 'package:app_learn_english/startpage/widget/utils_widget.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'page_purpose.dart';
import 'responsive_start_page.dart';

class PageListLevel extends StatefulWidget {
  @override
  _PageListLevel createState() => _PageListLevel();
}

class _PageListLevel extends State<PageListLevel> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      ColorsUtils.Color_F68DB9,
                      ColorsUtils.Color_EB5695,
                    ],
                  )),
                  child: Column(
                    children: [
                      TopWidget(),
                      CenterWidget(
                        title: S.of(context).WhatIsYourCurrentLevelOfEnglish,
                        index: 3,
                      ),
                      SizedBox(
                        height: ResponsiveWidget.isSmallScreen(context)
                            ? height / 100
                            : height / 100,
                      ),
                      Expanded(child: _BottomWidget()),
                      UtilsWidget().viewBottom(
                          context,
                          S
                              .of(context)
                              .ThisHelpsMeAdjustTheLessonContentToSuitMyAbility,
                          0.6)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class _BottomWidget extends StatelessWidget {
  const _BottomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _ListItemWidget(
              icon: 'assets/new_ui/first_screen_app/coban.png',
              title: S.of(context).basic,
            ),
            _ListItemWidget(
              icon: 'assets/new_ui/first_screen_app/trungbinh.png',
              title: S.of(context).medium,
            ),
            _ListItemWidget(
              icon: 'assets/new_ui/first_screen_app/nangcao.png',
              title: S.of(context).Advanced,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                thickness: 2,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListItemWidget extends StatelessWidget {
  const _ListItemWidget({
    Key? key,
    required this.icon,
    required this.title,
  });

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(
            thickness: 2,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        InkWell(
          onTap: () {
            DataFirtAppLog().level = title;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PageListPurpose()));
          },
          child: Container(
              height: ResponsiveWidget.isSmallScreen(context)
                  ? height / 12
                  : height / 7,
              child: Container(
                child: Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: Image.asset(
                      icon,
                      scale: 1.3,
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/new_ui/first_screen_app/ic_arrow.svg',
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
