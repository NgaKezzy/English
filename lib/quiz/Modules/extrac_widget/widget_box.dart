import 'package:flutter/material.dart';

class box extends StatelessWidget {
  final bool checkColor;
  final bool onClicked;

  const box({Key? key, required this.checkColor, required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      width: 25,
      decoration: BoxDecoration(
        color: onClicked
            ? ((checkColor ? Colors.green : Colors.red))
            : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
