import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/extentions/ValidatorExtention.dart';
import 'package:app_learn_english/extentions/constants.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/btn_accept.dart';
import 'package:app_learn_english/presentation/profile/widgets/email_field_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/src/provider.dart';

class confirmEmail extends StatefulWidget {
  static const routeName = '/confirm-mail';

  @override
  _confirmEmailState createState() => _confirmEmailState();
}

@override
class _confirmEmailState extends State<StatefulWidget> {
  final confirmEmailTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _firstClick = true;

  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
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
                  SizedBox(
                    height: 32,
                  ),
                  Row(children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 16),
                      alignment: Alignment.center,
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            size: 30,
                          ),
                        
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    S.of(context).ConfirmEmail,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(children: [
                        EmailFieldWidget(
                          controller: confirmEmailTextController,
                          labelText: DataCache().getUserData().email,
                          icon: Icon(Icons.account_circle_outlined),
                          isActive: true,
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        BtnAcceptWidget(
                            userData: DataCache().getUserData(),
                            onAccept: onAccept),
                      ]),
                    ),
                  ))
                ])));
  }

  onAccept(DataUser userData, BuildContext context) {
    if (_firstClick) {
      setState(() {
        _firstClick = false;
      });
      if (formKey.currentState!.validate()) {
        if (Validator().checkValidate(
            Constants.TYPE_EMAIL, context, confirmEmailTextController.text)) {
          UserAPIs()
              .confirmEmailAPI(confirmEmailTextController.text)
              .then((value) => {
                    if (value == 1)
                      {activeDialog(context, S.of(context).RequestConfirmMail)}
                    else
                      {activeDialog(context, S.of(context).DontConfirmMail)}
                  });
        }
      }
    }
  }
}
