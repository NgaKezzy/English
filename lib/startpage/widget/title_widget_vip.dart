import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class TitleWidgetVip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20),
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: ResponsiveWidget.isSmallScreen(context)
                ? height / 10
                : height / 10,
          ),
          Text(
            'TURTLE VIP\n 7 ngày miễn phí!',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: ResponsiveWidget.isSmallScreen(context)
                  ? width / 15
                  : width / 45,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: ResponsiveWidget.isSmallScreen(context)
                ? height / 10
                : height / 50,
          ),
        ],
      ),
    );
  }
}
