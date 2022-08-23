import 'package:flutter/material.dart';

class MyInheritedWidget extends InheritedWidget {
  // 1
  MyInheritedWidget({required Widget child, required this.myData})
      : super(child: child);

  // 2
  final int myData;

  // 3
  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return myData != oldWidget.myData;
  }

  // 4
  static MyInheritedWidget? of(BuildContext context) {
    // 5
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }
}
