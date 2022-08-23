import 'package:app_learn_english/Providers/theme_provider.dart';

import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/history_speak_model.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';

import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';

import 'package:app_learn_english/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class HistoryReview extends StatefulWidget {
  final List<HistorySpeakModel> historyTextTalk;
  final Future<List<HistorySpeakModel>> Function() loadMoreFnc;
  const HistoryReview({
    Key? key,
    required this.historyTextTalk,
    required this.loadMoreFnc,
  }) : super(key: key);

  @override
  State<HistoryReview> createState() => _HistoryReviewState();
}

class _HistoryReviewState extends State<HistoryReview> {
  final DataUser dataUser = DataCache().getUserData();
  String? avatarURL;
  final _scollController = ScrollController();
  bool _isLoad = false;
  List<HistorySpeakModel> listHistory = [];
  DataUser dataUserCache = DataCache().getUserData();
  int index = 0;
  var formatter = new DateFormat('dd-MM-yyyy');
  late String _nameEn;

  String convertWeekDay(int numbday) {
    String weekDayString = '';
    switch (numbday) {
      case 1:
        weekDayString = S.of(context).Monday;
        break;
      case 2:
        weekDayString = S.of(context).Tuesday;
        break;
      case 3:
        weekDayString = S.of(context).Wednesday;
        break;
      case 4:
        weekDayString = S.of(context).Thursday;
        break;
      case 5:
        weekDayString = S.of(context).Friday;
        break;
      case 6:
        weekDayString = S.of(context).Saturday;
        break;
      case 7:
        weekDayString = S.of(context).Sunday;
        break;
      default:
    }
    return weekDayString;
  }

  String convertTime(int index) {
    var time = DateTime.parse(listHistory[index].textTalk.createdtime);
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    var date = formatter.format(time);
    var weekDay = convertWeekDay(time.weekday);
    return '$date ($weekDay)';
  }

  @override
  void initState() {
    listHistory = widget.historyTextTalk;

    avatarURL = DataCache().getUserData().avatar.isEmpty
        ? null
        : ('https://${Session().BASE_URL}/images/user_avatars/${dataUser.avatar}');
    _scollController.addListener(() async {
      // print(_scollController.position.extentAfter);
      if (_scollController.position.extentAfter == 0.0) {
        setState(() {
          _isLoad = true;
        });
        var tempHistory = await widget.loadMoreFnc();
        setState(() {
          listHistory.addAll(tempHistory);
        });
        setState(() {
          _isLoad = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeProvider.mode == ThemeMode.dark
            ? const Color.fromRGBO(45, 48, 57, 1)
            : Colors.white,
        title: Text(
          S.of(context).speakHistory,
          style: TextStyle(
            color: themeProvider.mode == ThemeMode.dark
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
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
      body: SafeArea(
        child: Container(
          color: themeProvider.mode == ThemeMode.dark
              ? const Color.fromRGBO(24, 26, 33, 1)
              : Colors.white,
          child: Column(
            children: [
              Divider(
                  thickness: 1,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.grey.shade700
                      : const Color(0xFFE4E4E4),
                  height: 1),
              // HeaderApp(margin: 5),
              // Row(
              //   children: [
              //     IconButton(
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //       icon: Icon(Icons.navigate_before),
              //     ),
              //     Text(
              //       'Lịch sử Speak',
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 22,
              //       ),
              //     ),
              //   ],
              // ),
              Expanded(
                child: Consumer<LocaleProvider>(
                    builder: (ctx, localeProvider, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    // margin: const EdgeInsets.only(top: 10),
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _scollController,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: GestureDetector(
                            onTap: () {
                              printGreen('đây là user id: ' +
                                  DataCache().userCache!.uid.toString());

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainSpeakScreen(
                                    dataUser: DataCache().getUserData(),
                                    title: listHistory[index].textTalk.name,
                                    id: '${listHistory[index].textTalk.id}',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.77,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Utils.changeLanguage(
                                                          localeProvider.locale!
                                                              .languageCode,
                                                          index,
                                                          widget
                                                              .historyTextTalk) ==
                                                      ''
                                                  ? ''
                                                  : Utils.changeLanguage(
                                                      localeProvider
                                                          .locale!.languageCode,
                                                      index,
                                                      widget.historyTextTalk),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              Utils.buildNameTalkWithRandomWord(
                                                listHistory[index]
                                                    .textTalk
                                                    .name,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: themeProvider.mode ==
                                                        ThemeMode.dark
                                                    ? const Color.fromRGBO(
                                                        92, 94, 99, 1)
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              convertTime(index),
                                              style: TextStyle(
                                                color: themeProvider.mode ==
                                                        ThemeMode.dark
                                                    ? const Color.fromRGBO(
                                                        92, 94, 99, 1)
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      IconButton(
                                        onPressed: () {
                                          printGreen('đây là id speak: ' +
                                              listHistory[index].id.toString());
                                          showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter mystate) {
                                                  return Container(
                                                    height: 150,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                                child:
                                                                    SizedBox()),
                                                            IconButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                  Icons.close),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 12),
                                                        Text(S
                                                            .of(context)
                                                            .DoYouWantToDeleteTheSelectedItem),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 12),
                                                          height: 40,
                                                          width: 200,
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              bool removeSpeak =
                                                                  await TalkAPIs()
                                                                      .removeSpeak(
                                                                DataCache()
                                                                    .userCache!
                                                                    .uid
                                                                    .toString(),
                                                                listHistory[
                                                                        index]
                                                                    .sid
                                                                    .toString(),
                                                              );
                                                              if (removeSpeak) {
                                                                var tempHistory =
                                                                    [
                                                                  ...listHistory
                                                                ];
                                                                tempHistory
                                                                    .removeAt(
                                                                        index);
                                                                setState(() {
                                                                  listHistory =
                                                                      tempHistory;
                                                                });
                                                                Fluttertoast.showToast(
                                                                    msg: S
                                                                        .of(context)
                                                                        .Successful);
                                                              } else {
                                                                Fluttertoast.showToast(
                                                                    msg: S
                                                                        .of(context)
                                                                        .Failure);
                                                              }
                                                              Future.delayed(
                                                                  Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  () {
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            child: Center(
                                                              child: Text(
                                                                S
                                                                    .of(context)
                                                                    .deleteVideoHistory,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      Colors
                                                                          .red),
                                                              shape: MaterialStateProperty
                                                                  .all<
                                                                      RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/new_ui/more/Delete.svg',
                                          color: themeProvider.mode ==
                                                  ThemeMode.dark
                                              ? const Color.fromRGBO(
                                                  140, 141, 144, 1)
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 14, bottom: 14),
                                    height: 0.5,
                                    color: Colors.grey,
                                  ),
                                  if (_isLoad == true)
                                    if (index == listHistory.length - 1)
                                      const Center(
                                        child: PhoLoading(),
                                      ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: listHistory.length,
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
