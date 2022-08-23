import 'package:app_learn_english/generated/l10n.dart';
import 'package:flutter/material.dart';

void printYellow(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printRed(String text) {
  print('\x1B[31m$text\x1B[0m');
}

void printGreen(String text) {
  print('\x1B[32m$text\x1B[0m');
}

void printBlue(String text) {
  print('\x1B[34m$text\x1B[0m');
}

void printCyan(String text) {
  print('\x1B[36m$text\x1B[0m');
}

String capitalize(String str) {
  return "${str[0].toUpperCase()}${str.substring(1)}";
}

activeDialog(BuildContext context, String content) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(S.of(context).Notify),
          content: new Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child:
                  Text(S.of(context).Confirm, style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      });
}
