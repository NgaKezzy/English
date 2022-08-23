import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/extentions/ValidatorExtention.dart';
import 'package:app_learn_english/extentions/constants.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/btn_accept.dart';
import 'package:app_learn_english/presentation/profile/widgets/header_form.dart';
import 'package:app_learn_english/presentation/profile/widgets/text_field_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class changeName extends StatefulWidget {
  static const routeName = '/change-name';

  @override
  _changeNameState createState() => _changeNameState();
}

class _changeNameState extends State<changeName> {
  final TextEditingController _changeNickNameCtrl = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  // @override
  // void initState() {
  //   super.initState();
  //   _changeNickNameCtrl.addListener(() {
  //     final String text = _changeNickNameCtrl.text.toLowerCase();
  //     _changeNickNameCtrl.value = _changeNickNameCtrl.value.copyWith(
  //       text: text,
  //       selection:
  //           TextSelection(baseOffset: text.length, extentOffset: text.length),
  //       composing: TextRange.empty,
  //     );
  //   });
  // }

  @override
  void dispose() {
    printYellow('xxxx');
    _changeNickNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(body: ScopedModelDescendant<DataUser>(
      builder: (context, child, userData) {
        return Container(
            height: height * 1,
            width: width,
            decoration: BoxDecoration(
              // image: DecorationImage(
              //     image: AssetImage('assets/images/background.png'),
              //     fit: BoxFit.fill)
              color: themeProvider.mode == ThemeMode.dark
                  ? Color.fromRGBO(42, 44, 50, 1)
                  : Colors.white,
            ),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                Container(
                  child: CustomHeaderWidget(
                    title: S.of(context).Account,
                    description: S.of(context).YouCanChangeItToAnotherName,
                  ),
                ),
                Container(
                    child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        TextFieldWidget(
                          controller: _changeNickNameCtrl
                            ..text = userData.username,
                          labelText: userData.username,
                          icon: Icon(Icons.account_circle_outlined),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        BtnAcceptWidget(userData: userData, onAccept: onAccept)
                      ],
                    ),
                  ),
                )),
              ],
            ));
      },
    ));
  }

  onAccept(DataUser userData, BuildContext context) {
    if (formKey.currentState!.validate()) {
      if (Validator().checkValidate(
          Constants.TYPE_USERNAME, context, _changeNickNameCtrl.text)) {
        UserAPIs()
            .changeUserNickName(_changeNickNameCtrl.text, userData)
            .then((value) => {
                  if (value == 1)
                    {Navigator.pop(context, userData)}
                  else
                    {
                      activeDialog(
                          context, S.of(context).UnableToUpdateFullName)
                    }
                });
      }
    }
  }
}
