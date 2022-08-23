import 'package:app_learn_english/Providers/check_login.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget icon;
  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
  }) : super(key: key);
  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var checkLoginProvider = context.read<CheckLogin>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white38.withOpacity(0.6),
      ),
      child: TextFormField(
        controller: widget.controller,
        onChanged: (value) {
          if (value.isNotEmpty) {
            checkLoginProvider.setCheckIp(true);
          } else {
            checkLoginProvider.setCheckIp(false);
          }
        },
        style: TextStyle(
          fontSize: 18,
        ),
        decoration: InputDecoration(
          fillColor: themeProvider.mode == ThemeMode.dark
              ? Color.fromRGBO(42, 44, 50, 1)
              : Colors.white.withOpacity(0.1),
          hintText: widget.labelText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          filled: true,
          prefixIcon: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: widget.icon,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 25),
          prefixIconConstraints: BoxConstraints(
            minHeight: 30,
          ),
        ),
        // validator: (password) => password != null && password.length > 24
        //     ? "Độ dài không được vượt quá 24 kí tự, chỉ có số và chữ!"
        //     : (RegExp(r'^[A-Za-z0-9_.]')
        //     .hasMatch(password.toString()) ==
        //     true
        //     ? null
        //     : "kiểm tra lại tên đăng nhập!"),
      ),
    );
  }
}
