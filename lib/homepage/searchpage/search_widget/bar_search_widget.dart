import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:flutter/material.dart';
import 'package:app_learn_english/startpage/responsive_start_page.dart';

class BarSearch extends StatefulWidget {
  @override
  _BarSearch createState() => _BarSearch();
}

class _BarSearch extends State<BarSearch> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final inputSearchController = TextEditingController();

    return Container(
        height:
            ResponsiveWidget.isSmallScreen(context) ? height / 20 : height / 7,
        width:
            ResponsiveWidget.isSmallScreen(context) ? width / 1.1 : width / 1.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: TextFormField(
          onChanged: (input) {
            if (input.length % 3 == 0) {
              printYellow(input);
            }
          },
          controller: inputSearchController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            fillColor: Colors.white,
            hintText: 'TÌm kiếm',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 1, color: Colors.green),
            ),
            hintStyle: TextStyle(
              fontSize: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 1, color: Colors.green),
            ),
          ),
        ));
  }
}
