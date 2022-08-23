import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class CustomHeaderWidget extends StatefulWidget {
  final String title;
  final String description;
  const CustomHeaderWidget(
      {Key? key, required this.title, required this.description})
      : super(key: key);
  @override
  _HeaderWidgetState createState() =>
      _HeaderWidgetState(title: title, description: description);
}

class _HeaderWidgetState extends State<CustomHeaderWidget> {
  final String title;
  final String description;
  _HeaderWidgetState(
      {Key? key, required this.title, required this.description});
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Row(children: [
            Container(
              padding: EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              height: 60,
              width: 60,
              // decoration: BoxDecoration(
              //   shape: BoxShape.circle,
              //   color: Colors.white38.withOpacity(0.1),
              // ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  size: 30,
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 30,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          Builder(
            builder: (context) {
              return description != ""
                  ? Container(
                      child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ))
                  : Container();
            },
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
