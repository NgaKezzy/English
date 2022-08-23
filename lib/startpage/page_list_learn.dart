import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/networks/DataFirtAppLog.dart';
import 'package:app_learn_english/startpage/page_level.dart';
import 'package:app_learn_english/startpage/widget/bar_widget.dart';
import 'package:app_learn_english/startpage/widget/center_widget.dart';

import 'package:app_learn_english/startpage/widget/utils_widget.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'responsive_start_page.dart';

class PageListLearn extends StatefulWidget {
  static const routeName = '/list-learn';
  @override
  _PageListLearnState createState() => _PageListLearnState();
}

class _PageListLearnState extends State<PageListLearn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          ColorsUtils.Color_BE92F5,
          ColorsUtils.Color_975AE4,
        ],
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopWidget(),
          CenterWidget(
            title: S.of(context).WhydoyouwanttopracticeEnglish,
            index: 2,
          ),
          Expanded(
            child: Container(
              child: _BottomWidget(),
            ),
          ),
          UtilsWidget().viewBottom(context,
              S.of(context).Thishelpsmetailorthethemestosuityourneeds, 0.3)
        ],
      ),
    ));
  }
}

class _BottomWidget extends StatelessWidget {
  const _BottomWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("StringLang:${S.of(context).Travel}");
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ListItemWidget(
              icon: 'assets/new_ui/first_screen_app/dulich.png',
              title: S.of(context).Travel,
              isEnd: false,
            ),
            _ListItemWidget(
              icon: 'assets/new_ui/first_screen_app/nghenghiep.png',
              title: S.of(context).CareerOpportunities,
              isEnd: false,
            ),
            _ListItemWidget(
              icon: 'assets/new_ui/first_screen_app/giaoduc.png',
              title: S.of(context).Education,
              isEnd: false,
            ),
            _ListItemWidget(
              icon: 'assets/new_ui/first_screen_app/cuocsong.png',
              title: S.of(context).LiveAndWorkAbroad,
              isEnd: false,
            ),
            _ListItemWidget(
              icon: 'assets/new_ui/first_screen_app/ic_giaitri.png',
              title: S.of(context).CultureEntertainment,
              isEnd: false,
            ),
            _ListItemWidget(
              icon: 'assets/new_ui/first_screen_app/ic_more.png',
              title: S.of(context).IsDifferent,
              isEnd: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ListItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final bool isEnd;

  const _ListItemWidget(
      {Key? key, required this.icon, required this.title, required this.isEnd});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
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
              DataFirtAppLog().learn = title;
              print(DataFirtAppLog().learn);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PageListLevel()));
            },
            child: Container(
              height: ResponsiveWidget.isSmallScreen(context)
                  ? height / 12
                  : height / 7,
              child: Align(
                alignment: Alignment.center,
                child: ListTile(
                  leading: Image.asset(
                    icon,
                    scale: 1.3,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
        isEnd
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  thickness: 2,
                  color: Colors.white.withOpacity(0.2),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
