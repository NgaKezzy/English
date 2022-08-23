import 'package:app_learn_english/models/TalkModel.dart';
import 'package:flutter/material.dart';

class VideoInheritedWidget extends InheritedWidget {
  VideoInheritedWidget({required Widget child, required this.myData})
      : super(child: child);

  final DataTalk? myData;

  @override
  bool updateShouldNotify(VideoInheritedWidget oldWidget) {
    return false;
  }

  static VideoInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoInheritedWidget>()!;
  }
}
