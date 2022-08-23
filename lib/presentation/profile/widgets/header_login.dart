import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class CustomHeaderLoginWidget extends StatefulWidget {
  final String title;
  final String description;
  const CustomHeaderLoginWidget(
      {Key? key, required this.title, required this.description})
      : super(key: key);
  @override
  _HeaderLoginWidgetState createState() =>
      _HeaderLoginWidgetState(title: title, description: description);
}

class _HeaderLoginWidgetState extends State<CustomHeaderLoginWidget> {
  final String title;
  final String description;
  _HeaderLoginWidgetState(
      {Key? key, required this.title, required this.description});
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: AssetImage('assets/linh_vat/linhvat2.png'),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Center(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    description,
                    style: TextStyle(
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
