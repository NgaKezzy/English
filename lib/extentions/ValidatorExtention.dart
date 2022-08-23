import 'package:app_learn_english/extentions/constants.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:flutter/cupertino.dart';

class Validator {
  static final Validator _singleton = Validator._internal();
  factory Validator() {
    return _singleton;
  }
  Validator._internal();

  bool isActivePopup = false;

  bool checkValidate(int type, BuildContext context, String dataInput) {
    bool isValidate = false;
    switch (type) {
      case Constants.TYPE_EMAIL:
        if (dataInput != null && dataInput.length < 1) {
          !isActivePopup
              ? activeDialog(
                  context, S.of(context).PleaseEnterTheCorrectEmailSyntax)
              : () {};
        } else {
          if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(dataInput.toString()) ==
              true) {
            isValidate = true;
          } else {
            !isActivePopup
                ? activeDialog(
                    context, S.of(context).PleaseEnterTheCorrectEmailSyntax)
                : {};
          }
        }

        break;
      case Constants.TYPE_PASSWORD:
        if (dataInput.isEmpty && dataInput.length < 3) {
          if (!isActivePopup)
            activeDialog(
              context,
              S
                  .of(context)
                  .PasswordMustBeAtLeast6CharactersAndContainBothLettersAndNumbers,
            );
        } else {
          isValidate = true;

          // if (RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$")
          //         .hasMatch(dataInput.toString()) ==
          //     true) {
          //   isValidate = true;
          // } else {
          //   !isActivePopup
          //       ? activeDialog(
          //           context,
          //           S
          //               .of(context)
          //               .PasswordMustBeAtLeast6CharactersAndContainBothLettersAndNumbers)
          //       : {};
          // }
        }
        break;
      case Constants.TYPE_USERNAME:
        if (dataInput.isEmpty) {
          if (!isActivePopup)
            activeDialog(
              context,
              S.of(context).LengthFrom6To24CharactersOnlyNumbersAndLetters,
            );
        } else {
          isValidate = true;
          // if (RegExp(r'^[A-Za-z0-9_.]{6,}').hasMatch(dataInput.toString()) ==
          //     true) {
          //   isValidate = true;
          // } else {
          //   if (!isActivePopup)
          //     activeDialog(
          //       context,
          //       S.of(context).PleaseDoubleCheckYourUsername,
          //     );
          // }
        }
        break;
      case Constants.TYPE_TEXT:
        if (dataInput == null) {
          !isActivePopup
              ? activeDialog(context, S.of(context).PleaseEnterFullInformation)
              : {};
        } else {
          isValidate = true;
        }
        break;
      default:
    }

    return isValidate;
  }
}
