import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/profile/widgets/header_login.dart';
import 'package:app_learn_english/presentation/profile/widgets/text_field_icon.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';

class ForgotAccountScreen extends StatefulWidget {
  static const routeName = '/forgot-account';

  @override
  State<ForgotAccountScreen> createState() => _ForgotAccountScreenState();
}

class _ForgotAccountScreenState extends State<ForgotAccountScreen> {
  final userNameCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool checkSending = false;

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            S.of(context).ForgotPassword,
            style: TextStyle(
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          backgroundColor: themeProvider.mode == ThemeMode.dark
              ? Color.fromRGBO(45, 48, 57, 1)
              : Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/new_ui/more/Iconly-Arrow-Left.svg',
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            Divider(
                thickness: 1,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.grey.shade700
                    : Color(0xFFE4E4E4),
                height: 1),
            Expanded(
              child: Stack(
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     // image: DecorationImage(
                  //     //   image: AssetImage('assets/images/background.png'),
                  //     //   fit: BoxFit.cover,
                  //     // ),
                  //     color: Colors.white,
                  //   ),
                  // ),
                  Container(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Color.fromRGBO(24, 26, 33, 1)
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Color.fromRGBO(24, 26, 33, 1)
                            : Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            CustomHeaderLoginWidget(
                              title: "",
                              description: S
                                  .of(context)
                                  .EnterYourEmailAddressToRecoverYourPassword,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: Form(
                                key: formKey,
                                child: TextFieldWidget(
                                  controller: userNameCtrl,
                                  labelText: "Email",
                                  icon: Icon(
                                    Icons.account_circle_outlined,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: checkSending
                                  ? Center(
                                      // child: CircularProgressIndicator(),
                                      child: const PhoLoading(),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (userNameCtrl.text.isNotEmpty) {
                                          setState(() {
                                            checkSending = true;
                                          });
                                          var check = await UserAPIs()
                                              .forgotPassword2(
                                                  userNameCtrl.text);
                                          if (check) {
                                            activeDialog(
                                              context,
                                              S
                                                  .of(context)
                                                  .PasswordInformationHasBeenSent,
                                            );
                                            setState(() {
                                              checkSending = false;
                                            });
                                          } else {
                                            activeDialog(
                                              context,
                                              S
                                                  .of(context)
                                                  .AnErrorOccurredWhileSending,
                                            );

                                            setState(() {
                                              checkSending = false;
                                            });
                                          }
                                        } else {
                                          activeDialog(
                                            context,
                                            S
                                                .of(context)
                                                .PleaseEnterTheCorrectEmailSyntax,
                                          );
                                        }
                                      },
                                      child: Text(
                                        S.of(context).ToSend,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        primary:
                                            Color.fromRGBO(60, 146, 247, 0.8),
                                        elevation: 20,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
