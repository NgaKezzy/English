import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../responsive_start_page.dart';
import 'notice_widget.dart';

class UtilsWidget {
  ///View bottom của các màn hình setup lần đầu dùng app
  Widget viewBottom(BuildContext context, String title, double bar) {
    return Column(
      children: [
        NoticeWidget(
          title: title,
        ),
        _viewProgress(context, bar)
      ],
    );
  }

  ///View Bottom
  Widget _viewProgress(BuildContext context, double bar) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 30,
      child: Row(
        children: [
          Spacer(),
          LinearPercentIndicator(
            width: ResponsiveWidget.isSmallScreen(context)
                ? width / 1.3
                : width / 1.3,
            animation: true,
            lineHeight: 10.0,
            animationDuration: 500,
            percent: bar,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Colors.white,
          ),
          Spacer(),
        ],
      ),
    );
  }

  ///View upgrade VIP
  Widget viewVipUpgradeVip(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VipWidget(),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.width * 0.9 * 320 / 1312,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/new_ui/more/upgrade_vip.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 35, bottom: 5),
              width: calcTextSize(S.of(context).upgrade_now,
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  .width,
              height: 23,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                  child: Text(
                S.of(context).upgrade_now,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
      ),
    );
  }

  Size calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance!.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }
}
