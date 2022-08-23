import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';

class CenterSearchTopic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        padding: EdgeInsets.only(right: 5, left: 5, top: 5),
        height: ResponsiveWidget.isSmallScreen(context)
            ? height / 1.6
            : height / 1.5,
        width:
            ResponsiveWidget.isSmallScreen(context) ? width / 1.1 : width / 1.1,
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.white,
            ),
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Text(
                'Video chủ đề',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: ResponsiveWidget.isSmallScreen(context)
                      ? width / 22
                      : width / 45,
                ),
              ),
              trailing: Text(
                'Đã xem 0/4',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: ResponsiveWidget.isSmallScreen(context)
                      ? width / 22
                      : width / 45,
                ),
              ),
            ),
            Container(
              height: ResponsiveWidget.isSmallScreen(context)
                  ? height / 1.9
                  : height / 2,
              width: ResponsiveWidget.isSmallScreen(context)
                  ? width / 1.2
                  : width / 1.1,
              child: ListView(
                children: [
                  _ListItemWidget(
                    title: 'Phim',
                  ),
                  _ListItemWidget(
                    title: 'Du lịch',
                  ),
                  _ListItemWidget(
                    title: 'Du lịch',
                  ),
                  _ListItemWidget(
                    title: 'Du lịch',
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class _ListItemWidget extends StatelessWidget {
  const _ListItemWidget({
    Key? key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            height: ResponsiveWidget.isSmallScreen(context)
                ? height / 4
                : height / 2,
            width: ResponsiveWidget.isSmallScreen(context)
                ? width / 1.3
                : width / 1.1,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/monster.png',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveWidget.isSmallScreen(context)
              ? height / 50
              : height / 50,
        ),
      ],
    );
  }
}
