import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:app_learn_english/startpage/widget/center_button_widegt_vip.dart';
import 'package:app_learn_english/startpage/widget/title_widget_vip.dart';
import 'package:flutter/material.dart';

class PageVip extends StatefulWidget {
  @override
  _PageVip createState() => _PageVip();
}

class _PageVip extends State<PageVip> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
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
                        // image: DecorationImage(
                        //     image: AssetImage('assets/images/background.png'),
                        //     fit: BoxFit.fill),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.shade700,
                            Colors.tealAccent.shade400,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          TitleWidgetVip(),
                          CenterWidgetVip(),
                          SizedBox(
                            height: ResponsiveWidget.isSmallScreen(context)
                                ? height / 10
                                : height / 50,
                          ),
                          // TextWidgetVip(),
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

class CenterWidgetVip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 0.1),
        duration: const Duration(milliseconds: 100),
        builder: (context, value, _) {
          return Container(
              padding: EdgeInsets.only(bottom: 18),
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Transform.translate(
                      offset: Offset(0.0, height / 3.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                CenterButtonWidgetVipOn(
                                  title: '100.000??/th??ng',
                                );
                              },
                              child: CenterButtonWidgetVipOff(
                                  title: '100.000??/th??ng'))
                        ],
                      )),
                  Transform.translate(
                      offset: Offset(0.0, height / 50),
                      child: Container(
                          height: ResponsiveWidget.isSmallScreen(context)
                              ? height / 5
                              : height / 5,
                          width: ResponsiveWidget.isSmallScreen(context)
                              ? width / 1.2
                              : width / 1.9,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/startVip/body.png'),
                                  fit: BoxFit.fill)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      Text(
                                        '1600+ b??i h???c v???i nhi???u ch??? ?????\nH???c 1 k??m 1 v???i Alan\nB???ng t???ng k???t cu???i ng??y',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize:
                                              ResponsiveWidget.isSmallScreen(
                                                      context)
                                                  ? width / 22
                                                  : width / 45,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ]))),
                  Transform.translate(
                      offset: Offset(0.0, -height / 3.3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: CenterButtonWidgetVipOn(
                              title: '569.000??/n??m',
                            ),
                          )
                        ],
                      )),
                ],
              ));
        });
  }
}
