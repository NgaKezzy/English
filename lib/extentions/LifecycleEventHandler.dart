import 'package:app_learn_english/extentions/FunctionService.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSystemManager extends StatefulWidget {
  final Widget child;
  AppSystemManager({Key? key, required this.child}) : super(key: key);

  @override
  _AppSystemManagerState createState() => _AppSystemManagerState();
}

class _AppSystemManagerState extends State<AppSystemManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() async {
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        printYellow('inactive');
        break;
      case AppLifecycleState.paused:
        printYellow("OUT APPP");
        final prefs = await SharedPreferences.getInstance();
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyyMMdd').format(now);
        prefs.setInt("count-target", FunctionService().getProvider().count!);
        prefs.setInt("day-target", int.parse(formattedDate));
        FunctionService().isImpl = false;
        break;
      case AppLifecycleState.resumed:
        printYellow('resumed');
        break;
      case AppLifecycleState.detached:
        printYellow('detached');
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
