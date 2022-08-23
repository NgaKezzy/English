import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/presentation/speak/provider/all_list_talk_course.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../screen/chuyen_mon_screen/chuyenmmuc_screen.dart';

class TabChuyenMucScreen extends StatefulWidget {
  final bool isLoadingCourse;

  TabChuyenMucScreen({
    Key? key,
    required this.isLoadingCourse,
  }) : super(key: key);

  @override
  _TabChuyenMucScreenState createState() => _TabChuyenMucScreenState();
}

class _TabChuyenMucScreenState extends State<TabChuyenMucScreen> {
  // Widget _buildTab(String title) {
  //   return Tab(
  //     child: Container(
  //       height: 30,
  //       padding: EdgeInsets.symmetric(
  //         horizontal: 10,
  //         vertical: 0,
  //       ),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(5),
  //         color: Color.fromRGBO(235, 235, 235, 0.5),
  //       ),
  //       child: Align(
  //         alignment: Alignment.center,
  //         child: Text(title),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildTab(String title) {
    var themeProvider = context.watch<ThemeProvider>();
    return Tab(
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: 0.5,
            style: BorderStyle.solid,
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.grey.withOpacity(1),
          ),
        ),
        child: Align(
          child: Text(
            title,
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    // final infoCourse = dataCourse.items;
    var infoCourse = context.watch<AllListTalkCourse>().items;
    final List<Widget> tab = [
      Tab(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 0.5,
                style: BorderStyle.solid,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.grey.withOpacity(1),
              ),
            ),
            child: Align(
              child: Text(
                S.of(context).All,
              ),
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    ];
    final List<Widget> tabScreen = [
      ChuyenMucScreen(
        isLoadingCourse: widget.isLoadingCourse,
        listCourse: DataCache().getTrinhDoCourse(),
        check: true,
      ),
    ];
    for (var i = 0; i < infoCourse.length; i++) {
      tab.add(_buildTab(infoCourse[i]!.name));
      tabScreen.add(
        ChuyenMucScreen(
          isLoadingCourse: widget.isLoadingCourse,
          listCourse: infoCourse[i]!.listCourse,
          check: false,
        ),
      );
    }
    return DefaultTabController(
      length: tab.length,
      initialIndex: 0,
      child: Column(
        children: [
          Container(
            height: 36,
            child: TabBar(
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              indicatorColor: Colors.black,
              isScrollable: true,

              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Colors.blue.shade700,
                //     Colors.tealAccent.shade400,
                //   ],
                // ),
                color: const Color.fromRGBO(109, 177, 93, 1),
              ),
              tabs: tab,

              labelColor: Colors.white,
              // unselectedLabelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          Expanded(
            child: TabBarView(children: tabScreen),
          )
        ],
      ),
    );
  }
}
