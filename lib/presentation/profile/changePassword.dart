import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/extentions/ValidatorExtention.dart';
import 'package:app_learn_english/extentions/constants.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/header_form.dart';
import 'package:app_learn_english/presentation/profile/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class changePassword extends StatefulWidget {
  static const routeName = '/change-pass';

  @override
  _changePasswordState createState() => _changePasswordState();
}

@override
class _changePasswordState extends State<StatefulWidget> {
  final oldPass = TextEditingController();
  final nPass = TextEditingController();
  final nPassConfirm = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool valueButton = true;

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
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                  child: CustomHeaderWidget(
                    title: S.of(context).ChangePassword,
                    description: "",
                  ),
                ),
                Container(
                    child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        PasswordFieldWidget(
                          controller: oldPass,
                          labelText: S.of(context).CurrentPassword,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        PasswordFieldWidget(
                          controller: nPass,
                          labelText: S.of(context).ANewPassword,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        PasswordFieldWidget(
                          controller: nPassConfirm,
                          labelText: S.of(context).ConfirmNewPassword,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (nPass.text.isEmpty ||
                            oldPass.text.isEmpty ||
                            nPassConfirm.text.isEmpty) ...[
                          MaterialButton(
                            onPressed: () => onAccept(userData, context),
                            minWidth: double.infinity,
                            height: 60,
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              S.of(context).Confirm,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 26,
                                  color: Colors.white),
                            ),
                          ),
                        ] else ...[
                          MaterialButton(
                            onPressed: () => onAccept(userData, context),
                            minWidth: double.infinity,
                            height: 60,
                            color: Color.fromRGBO(60, 146, 247, 0.8),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              S.of(context).Confirm,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 26,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        );
      },
    ));
  }

  onAccept(DataUser userData, BuildContext context) {
    if (formKey.currentState!.validate()) {
      if (nPass.text == nPassConfirm.text) {
        if (Validator()
            .checkValidate(Constants.TYPE_PASSWORD, context, nPass.text)) {
          UserAPIs()
              .changeUserPassword(nPass.text, oldPass.text, userData)
              .then((value) => {
                    if (value == 1)
                      {Navigator.pop(context, userData)}
                    else
                      {
                        activeDialog(context,
                            S.of(context).TheCurrentPasswordEnteredIsNotCorrect)
                      }
                  });
        }
      } else {
        activeDialog(context, S.of(context).PasswordNoMatch);
      }
    }
  }
}
