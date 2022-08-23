import 'dart:math';

import 'package:app_learn_english/utils/color_utils.dart';
import 'package:flutter/material.dart';

class ItemViewUserNoData extends StatefulWidget {
  final String name;
  const ItemViewUserNoData({Key? key, required this.name}) : super(key: key);

  @override
  State<ItemViewUserNoData> createState() => _ItemViewUserNoDataState();
}

class _ItemViewUserNoDataState extends State<ItemViewUserNoData> {
  final _random = new Random();
  late Color _color;

  ///View avata user nếu user ko có avata
  final List<Color> listRandomColor = [
    ColorsUtils.Color_555555,
    ColorsUtils.Color_975AE4,
    ColorsUtils.Color_EB5695,
    ColorsUtils.Color_45B649,
    ColorsUtils.Color_F3606A
  ];

  @override
  void initState() {
    _color=listRandomColor[_random.nextInt(listRandomColor.length)];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color:_color,
          // listRandomColor[_random.nextInt(listRandomColor.length)],
          borderRadius: const BorderRadius.all(Radius.circular(40))),
      child: Center(
        child: Text(
          (widget.name.isEmpty) ? 'A' : '${widget.name[0].toUpperCase()}',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
