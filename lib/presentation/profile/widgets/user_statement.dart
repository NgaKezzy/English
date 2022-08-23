import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class UserStatementWidget extends StatefulWidget {
  DataUser userData;
  UserStatementWidget({Key? key, required this.userData}) : super(key: key);
  @override
  _UserStatementWidgetState createState() =>
      _UserStatementWidgetState(userData: userData);
}

class _UserStatementWidgetState extends State<UserStatementWidget> {
  DataUser userData;
  DateTime now = DateTime.now();
  _UserStatementWidgetState({Key? key, required this.userData});

  List<String> result = [];
  List<String> nameResult = [];
  late StaticsticalProvider staticsticalProvider;
  bool isCheck = true;
  bool isLoading = true;

  @override
  void didChangeDependencies() async {
    staticsticalProvider = Provider.of<StaticsticalProvider>(
      context,
      listen: false,
    );
    if (staticsticalProvider.isLoading) {
      var userData = await UserAPIs().getInfoData();
      staticsticalProvider.updateTotalTalk(userData?.totalVideoComplete ?? 0);
      staticsticalProvider.updateTotalVideosVip(userData?.totalVideoPlus ?? 0);

      result = [
        userData?.totalExp.toString() ?? '0',
        userData?.totalNewWord.toString() ?? '0',
        staticsticalProvider.totalTalkMonth.toString(),
        staticsticalProvider.totalVideosWatchedVip.toString(),
        staticsticalProvider.totalVideosWatched.toString(),
        staticsticalProvider.totalTalk.toString(),
      ];
      nameResult = [
        S.of(context).TotalExperience,
        S.of(context).LearnedVocabulary,
        '${S.of(context).MonthlyGoal} ${now.month.toString()}',
        S.of(context).VideoVip,
        S.of(context).VideosWatched,
        S.of(context).DialogueLearned,
      ];
    } else {
      result = [
        userData.totalExp.toString(),
        userData.totalNewWord.toString(),
        staticsticalProvider.totalTalkMonth.toString(),
        staticsticalProvider.totalVideosWatchedVip.toString(),
        staticsticalProvider.totalVideosWatched.toString(),
        staticsticalProvider.totalTalk.toString(),
      ];
      nameResult = [
        S.of(context).TotalExperience,
        S.of(context).LearnedVocabulary,
        '${S.of(context).MonthlyGoal} ${now.month.toString()}',
        S.of(context).VideoVip,
        S.of(context).VideosWatched,
        S.of(context).DialogueLearned,
      ];
    }
    staticsticalProvider.isLoading = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var staticsticalProvider = context.watch<StaticsticalProvider>();
    double width = MediaQuery.of(context).size.width;

    return staticsticalProvider.isLoading
        ? const SizedBox()
        : Container(
            decoration: BoxDecoration(
              color: themeProvider.mode == ThemeMode.dark
                  ? Color.fromRGBO(42, 44, 50, 1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).Statistical,
                  style: TextStyle(
                    fontSize: 20,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: width,
                  height: width > 1023 ? 300 : 120,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 3,
                    children: [
                      for (int i = 0; i < 4; i++)
                        Container(
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width <= 375
                                    ? 40
                                    : 42,
                                height: MediaQuery.of(context).size.width <= 375
                                    ? 40
                                    : 42,
                                child: Center(
                                  child: AutoSizeText(
                                    result[i],
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width <=
                                                  375
                                              ? 16
                                              : 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(83, 180, 81, 1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  i == 0
                                      ? S.of(context).TotalExperience
                                      : i == 1
                                          ? S.of(context).VideoVip
                                          : i == 2
                                              ? S.of(context).VideosWatched
                                              : S.of(context).DialogueLearned,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width <= 375
                                            ? 11
                                            : 13,
                                    color: themeProvider.mode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
