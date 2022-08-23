import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class ItemSubVipWidget extends StatelessWidget {
  final String subContent;
  ItemSubVipWidget({
    Key? key,
    required this.subContent,
  });
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subContent.toString(),
          style: TextStyle(
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }
}
