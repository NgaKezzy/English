import 'package:app_learn_english/homepage/searchpage/search_widget/bar_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BackSearch extends StatefulWidget {
  @override
  _BackSearch createState() => _BackSearch();
}

class _BackSearch extends State<BackSearch> {
  final userNameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Row(
              children: [
                // InkWell(
                //   onTap: () => {Navigator.pop(context)},
                //   child: Container(
                //     height: ResponsiveWidget.isSmallScreen(context)
                //         ? height / 35
                //         : height / 20,
                //     width: ResponsiveWidget.isSmallScreen(context)
                //         ? width / 20
                //         : width / 30,
                //     decoration: BoxDecoration(
                //         image: DecorationImage(
                //             image: AssetImage('assets/startPage/btn_back.png'),
                //             fit: BoxFit.fill)),
                //   ),
                // ),
                // SizedBox(
                //   width: ResponsiveWidget.isSmallScreen(context)
                //       ? width / 20
                //       : width / 30,
                // ),
                BarSearch(),
              ],
            )
          ],
        ));
  }
}
