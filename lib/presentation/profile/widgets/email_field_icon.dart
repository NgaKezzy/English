import 'package:app_learn_english/Providers/check_login.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class EmailFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget icon;
  final bool isActive;
  const EmailFieldWidget(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.isActive,
      required this.icon})
      : super(key: key);
  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState(
      controller: controller, labelText: labelText, icon: icon);
}

class _TextFieldWidgetState extends State<EmailFieldWidget> {
  final TextEditingController controller;
  final String labelText;
  final Widget icon;
  _TextFieldWidgetState(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.icon});
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var checkRegisterProvider = context.read<CheckLogin>();

    widget.isActive == true ? controller.text = labelText : {};
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white38.withOpacity(0.6),
        ),
        child: TextFormField(
          onChanged: (value) {
            if (value.isNotEmpty) {
              checkRegisterProvider.setCheckIpRGT(true);
            } else {
              checkRegisterProvider.setCheckIpRGT(false);
            }
          },
          style: TextStyle(
            fontSize: 18,
          ),
          autofocus: true,
          controller: widget.controller,
          decoration: InputDecoration(
            fillColor: themeProvider.mode == ThemeMode.dark
                ? Color.fromRGBO(42, 44, 50, 1)
                : Colors.white.withOpacity(1),
            filled: true,
            hintText: labelText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(.3),
              ),
            ),
            prefixIcon: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: widget.icon,
            ),
            prefixIconConstraints: BoxConstraints(
              minHeight: 30,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 25),
          ),
          // validator: (password) => password != null && password.length < 1
          //     ? "Vui lòng nhập đầy đủ thông tin!"
          //     : (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          //                 .hasMatch(password.toString()) ==
          //             true
          //         ? null
          //         : "Vui lòng kiểm tra lại email của bạn!"),
        ));
  }
}
