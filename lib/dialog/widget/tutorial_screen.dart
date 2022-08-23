import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
        width: double.maxFinite,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(42, 44, 50, 1)
                : Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.arrow_drop_down_circle_outlined),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Center(
                  child: Text(
                    S.of(context).oneDay,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                S.of(context).tutorial1,
                style: TextStyle(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ));
  }
}
