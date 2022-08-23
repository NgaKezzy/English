import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';

class NoticeWidget extends StatelessWidget {
  const NoticeWidget({
    Key? key,
    required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: ResponsiveWidget.isSmallScreen(context)
                ? height / 13
                : height / 13,
            width: ResponsiveWidget.isSmallScreen(context)
                ? width / 1.1
                : width / 1.1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/new_ui/first_screen_app/ic_notice.png'),
                          fit: BoxFit.fill)),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Container(
                  width: ResponsiveWidget.isSmallScreen(context)
                      ? width / 2
                      : width / 1.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${title.toString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
