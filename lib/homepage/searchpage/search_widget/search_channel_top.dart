import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';

class TopSearchChannel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SizedBox(
              height: ResponsiveWidget.isSmallScreen(context)
                  ? height / 20
                  : height / 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: ResponsiveWidget.isSmallScreen(context)
                      ? width / 40
                      : width / 40,
                ),
                InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: Container(
                    height: ResponsiveWidget.isSmallScreen(context)
                        ? height / 35
                        : height / 20,
                    width: ResponsiveWidget.isSmallScreen(context)
                        ? width / 20
                        : width / 30,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/startPage/btn_back.png'),
                            fit: BoxFit.fill)),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
