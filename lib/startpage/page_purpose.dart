import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/networks/DataFirtAppLog.dart';
import 'package:app_learn_english/startpage/page_hours.dart';
import 'package:app_learn_english/startpage/widget/bar_widget.dart';
import 'package:app_learn_english/startpage/widget/center_widget.dart';

import 'package:app_learn_english/startpage/widget/utils_widget.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'responsive_start_page.dart';
import 'page_hours.dart';

class PageListPurpose extends StatefulWidget {
  @override
  _PageListPurpose createState() => _PageListPurpose();
}

class _PageListPurpose extends State<PageListPurpose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorsUtils.Color_64D4DF,
            ColorsUtils.Color_7D81ED,
          ],
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopWidget(),
            CenterWidget(
              title: S.of(context).WhatIsYourTrainingGoal,
              index: 3,
            ),
            Expanded(
              child: _BottomWidget(),
            ),
            UtilsWidget().viewBottom(
                context,
                S
                    .of(context)
                    .ThisPointHelpsMeToBetterAccompanyYouToAchieveYourGoal,
                1)
          ],
        ),
      ),
    );
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
              key_target: 1,
              minute: 10,
              title: S.of(context).Deliberately,
            ),
            _ListItemWidget(
              key_target: 2,
              minute: 15,
              title: S.of(context).basic,
            ),
            _ListItemWidget(
              key_target: 3,
              minute: 20,
              title: S.of(context).medium,
            ),
            _ListItemWidget(
              key_target: 4,
              minute: 30,
              title: S.of(context).hardWork,
            ),
            _ListItemWidget(
              key_target: 5,
              minute: 60,
              title: S.of(context).Passion,
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
    required this.key_target,
    required this.title,
    required this.minute,
  });

  final int key_target;
  final int minute;
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
            DataFirtAppLog().target_key = key_target;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageHours(
                          isFirst: true,
                        )));
          },
          child: Container(
              height: ResponsiveWidget.isSmallScreen(context)
                  ? height / 12
                  : height / 7,
              child: Container(
                child: Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    title: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${minute.abs().toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          ' ' + S.of(context).Minutesday,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
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

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => {
        DataFirtAppLog().target_key = 1,
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PageHours(
                      isFirst: true,
                    )))
      },
      child: Container(
        height: 50,
        width:
            ResponsiveWidget.isSmallScreen(context) ? width / 1.6 : width / 5,
        decoration: BoxDecoration(
          color: Color.fromRGBO(60, 146, 247, 0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).Next,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: ResponsiveWidget.isSmallScreen(context)
                    ? width / 25
                    : width / 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
