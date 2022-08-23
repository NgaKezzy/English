import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:flutter/material.dart';

class BtnAcceptWidget extends StatefulWidget {
  final DataUser userData;
  final Function onAccept;
  const BtnAcceptWidget(
      {Key? key, required this.userData, required this.onAccept})
      : super(key: key);
  @override
  _BtnAcceptWidgetWidgetState createState() =>
      _BtnAcceptWidgetWidgetState(userData: userData, onAccept: onAccept);
}

class _BtnAcceptWidgetWidgetState extends State<BtnAcceptWidget> {
  final DataUser userData;
  final Function onAccept;
  _BtnAcceptWidgetWidgetState(
      {Key? key, required this.userData, required this.onAccept});
  bool valueButton = true;
  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: () => onAccept(userData, context),
        minWidth: double.infinity,
        height: 60,
        color: Color.fromRGBO(60, 146, 247, 0.8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          S.of(context).Confirm,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 26,
            color: Colors.white,
          ),
        ),
      );
}
