import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/ReviewTextData.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';

import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/screens/login_account_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class ButtonIconAdd extends StatefulWidget {
  final int uid;
  final String ttdid;
  final Function stopAuto;
  final DataTextReview? dataTextReview;

  const ButtonIconAdd({
    Key? key,
    required this.uid,
    required this.ttdid,
    required this.stopAuto,
    required this.dataTextReview,
  }) : super(key: key);
  @override
  _ButtonIconAddState createState() => _ButtonIconAddState();
}

class _ButtonIconAddState extends State<ButtonIconAdd> {
  bool stateBtn = false;
  bool isCheck = true;

  // HÀM NÀY GỌI NGAY SAU INIT ĐỂ CHECK XEM LÀ MẪU CÂU NÀY ĐÃ CÓ TRONG DANH SÁCH ÔN TẬP HAY CHƯA
  @override
  void didChangeDependencies() async {
    if (widget.dataTextReview != null) {
      for (var i = 0; i < widget.dataTextReview!.textReview.length; i++) {
        if (widget.dataTextReview!.textReview[i].uid == widget.uid &&
            widget.dataTextReview!.textReview[i].ttdid ==
                int.parse(widget.ttdid)) {
          setState(() {
            stateBtn = true;
          });
          print('co roi');
        }
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<LocaleProvider>(
      builder: (context, provider, snapshot) {
        String lang = provider.locale!.languageCode;
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: DataCache().getUserData().uid != 0
              ? InkWell(
                  onTap: stateBtn
                      ? () {
                          // toast(S.of(context).ThisSentencePatternHasBeenAdded,
                          //     duration: Duration(seconds: 1));
                        }
                      : () {
                          TalkAPIs()
                              .addItemCourse(
                                  '${widget.uid}', widget.ttdid, 2, lang)
                              .then((value) {
                            printYellow('${widget.uid}');
                            if (value == 1) {
                              // toast(S.of(context).SuccessfullyAdded,
                              //     duration: Duration(seconds: 1));
                              print('đã thêm mẫu câu thành công');
                              setState(() {
                                stateBtn = true;
                              });
                            } else if (value == 0) {
                              toast(S.of(context).AddFailedSentencePattern,
                                  duration: Duration(seconds: 1));
                            } else if (value == -1) {
                              toast(
                                S.of(context).SentencePatternAlreadyExists,
                                duration: Duration(seconds: 1),
                              );
                            }
                          });
                        },
                  child: stateBtn
                      ? Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            (Icons.done),
                            size: 37,
                            color: Colors.white,
                          ),
                          color: Colors.green,
                        )
                      : Container(
                          height: 45,
                          width: 45,
                          child: Card(
                            elevation: 10,
                            child: SvgPicture.asset(
                              'assets/speak/plus.svg',
                              height: 30,
                              color: themeProvider.mode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                              fit: BoxFit.scaleDown,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                )
              : InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (contextVip) => LoginAccountScreen()),
                    );
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    child: Card(
                      elevation: 10,
                      child: SvgPicture.asset(
                        'assets/speak/plus.svg',
                        height: 30,
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fit: BoxFit.scaleDown,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Colors.white,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
