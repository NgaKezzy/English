import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';

class BottomSearchTopic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        padding: EdgeInsets.only(right: 10, left: 10, top: 5),
        height:
            ResponsiveWidget.isSmallScreen(context) ? height / 4 : height / 1.5,
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
            Text(
              'Các kênh có chủ đề này',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: ResponsiveWidget.isSmallScreen(context)
                    ? width / 18
                    : width / 45,
              ),
            ),
            Container(
              height: ResponsiveWidget.isSmallScreen(context)
                  ? height / 5
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
                ? height / 10
                : height / 7,
            width: ResponsiveWidget.isSmallScreen(context)
                ? width / 1.1
                : width / 1.1,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/startPage/avatat2.png',
                  scale: 2,
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tên kênh',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Số người đăng ký',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              trailing: TextButton(
                child: Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.orange,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveWidget.isSmallScreen(context)
              ? height / 50
              : height / 10,
        ),
      ],
    );
  }
}
