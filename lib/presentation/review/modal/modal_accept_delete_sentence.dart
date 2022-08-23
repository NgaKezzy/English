import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/ReviewTextData.dart';
import 'package:app_learn_english/models/TextReviewModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModalAcceptDeleteSentence extends StatelessWidget {
  final TextReview textReview;
  const ModalAcceptDeleteSentence({Key? key, required this.textReview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: themeProvider.mode == ThemeMode.dark
            ? Color.fromRGBO(45, 48, 57, 1)
            : Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).DoYouWantToDelete,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.grey
                  : Colors.black26,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${textReview.content}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    var prefs = await SharedPreferences.getInstance();
                    String? pass = prefs.getString('passMd5');
                    final bool checkDelete =
                        await TalkAPIs().deleteSentenceReview(
                      DataCache().getUserData().username,
                      pass != null ? pass : '',
                      textReview.ttrid,
                      DataCache().getUserData().uid,
                    );
                    if (checkDelete) {
                      final DataTextReview? data =
                          await TalkAPIs().fetchReviewTextData(
                        userData: DataCache().getUserData(),
                      );
                      Utils().showNotificationBottom(
                        true,
                        S.of(context).SuccessfulDelete,
                      );
                      Navigator.of(context).pop(data);
                    }
                  },
                  child: Text(
                    S.of(context).dong_y,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    DataTextReview data = await DataCache().getListTextReview();
                    Navigator.of(context).pop(data);
                  },
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
