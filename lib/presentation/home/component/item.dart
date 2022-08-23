import 'package:flutter/material.dart';

class Itemview extends StatefulWidget {
  const Itemview({Key? key}) : super(key: key);

  @override
  _ItemviewState createState() => _ItemviewState();
}

class _ItemviewState extends State<Itemview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      alignment: Alignment.topLeft,
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white38.withOpacity(0.1),
      ),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
