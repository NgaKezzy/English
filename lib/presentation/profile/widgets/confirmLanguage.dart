import 'package:flutter/material.dart';

class ConfirmLanguage extends StatefulWidget {
  @override
  _ConfirmLanguageState createState() => _ConfirmLanguageState();
}

@override
class _ConfirmLanguageState extends State<ConfirmLanguage> {
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bạn chắc chắn muốn chọn ngôn ngữ này'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: new Text('OK')),
      ],
    );
  }
}
