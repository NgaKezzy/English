import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TopWidget extends StatelessWidget {
  const TopWidget({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: InkWell(
                    onTap: () => {Navigator.pop(context)},
                    child: Container(
                      height: 20,
                      width: 20,
                      padding: EdgeInsets.only(left: 7),
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: SvgPicture.asset(
                          'assets/new_ui/first_screen_app/ic_arrow.svg',
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
