import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';

class CheerQuiz extends StatefulWidget {
  const CheerQuiz({Key? key}) : super(key: key);

  @override
  State<CheerQuiz> createState() => _CheerQuizState();
}

class _CheerQuizState extends State<CheerQuiz> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/linh_vat/linhvat2.png'),
              //   ),
              // ),
              child: Lottie.asset(
                  'assets/new_ui/animation_lottie/achievements.json'),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              S.of(context).tuyet_voi_ban_da_hoan_thanh,
              style: TextStyle(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                  fontFamily: 'Quicksand'),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Center(
                  child: Text(
                    S.of(context).tiep_Tuc,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                        fontFamily: 'Quicksand'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
