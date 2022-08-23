import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';

class CenterButtonWidgetVipOn extends StatelessWidget {
  const CenterButtonWidgetVipOn({
    Key? key,
    required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        height:
            ResponsiveWidget.isSmallScreen(context) ? height / 7 : height / 7,
        width:
            ResponsiveWidget.isSmallScreen(context) ? width / 1.3 : width / 2,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/startVip/card_on.png'),
                fit: BoxFit.fill)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontSize: ResponsiveWidget.isSmallScreen(context)
                  ? width / 17
                  : width / 45,
            ),
            textAlign: TextAlign.center,
          ),
        ]));
  }
}

class CenterButtonWidgetVipOff extends StatelessWidget {
  const CenterButtonWidgetVipOff({
    Key? key,
    required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        height:
            ResponsiveWidget.isSmallScreen(context) ? height / 9 : height / 9,
        width:
            ResponsiveWidget.isSmallScreen(context) ? width / 1.5 : width / 2.1,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/startVip/card_off.png'),
                fit: BoxFit.fill)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontSize: ResponsiveWidget.isSmallScreen(context)
                  ? width / 17
                  : width / 45,
            ),
            textAlign: TextAlign.center,
          ),
        ]));
  }
}
