import 'dart:convert';

import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/models/group_mode.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogReportLanguage extends StatefulWidget {
  final bool isEnglish;
  int _value2 = 0;
  int currentPageIndex = 0;
  bool selectErrorReason = false;
  final List<TalkDetailModel> listSub;
  final DataTalk dataTalk;
  DataUser userData = DataCache().getUserData();
  List<GroupModel> listViewPage = [];
  List<GroupModel> _group = [
    GroupModel(text: "", index: 1, selected: false),
    GroupModel(text: "", index: 2, selected: false),
    GroupModel(text: "", index: 3, selected: false),
  ];

  // các biến cần chuyền vào khi báo lỗi email.
  String emailReceived = "myfeelglobal@gmail.com";
  String subjectEmail = "Report Error Subtitles";

  //các biến chuyền vào khi báo lỗi sever
  String keyMd5 = r'0x55a5x2!23$%^@#%^&@$#%$';
  int subid = 0;
  int reason = 0;

  DialogReportLanguage(
      {Key? key,
      required this.isEnglish,
      required this.listSub,
      required this.dataTalk})
      : super(key: key);

  @override
  State<DialogReportLanguage> createState() => _DialogReportLanguageState();
}

class _DialogReportLanguageState extends State<DialogReportLanguage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Material(
        child: Column(
          children: [
            _buildWidgetTile(context, widget.isEnglish),
            const SizedBox(height: 10),
            _buildWidgetSelectSubtitles(context),
            const SizedBox(height: 10),
            widget.isEnglish
                ? _buildReportErrorWithEnglish(context)
                : _buildReportErrorWithMachineLanguage(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetTile(BuildContext context, bool isEnglish) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                isEnglish
                    ? S.of(context).reportEnglish
                    : S.of(context).reportSubtitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              InkWell(
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          )),
    );
  }

  Widget _buildWidgetSelectSubtitles(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            S.of(context).chooseSubtitles,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        _buildPageView(context),
      ],
    );
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Widget _buildReportErrorWithEnglish(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            S.of(context).chooseReason,
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Column(
          children: <Widget>[makeRadioTileList(context)],
        ),
        InkWell(
          onTap: () {
            TalkAPIs()
                .reportErrorVideoCourse(
              uid: widget.userData.uid.toString(),
              vid: widget.dataTalk.id.toString(),
              subid: widget.listSub[widget.subid].id.toString(),
              reasonid: widget.listViewPage[widget.reason - 1].index.toString(),
              reason: widget.listViewPage[widget.reason - 1].text,
              sign: generateMd5(
                  "${widget.userData.uid}${widget.userData.username}${widget.keyMd5}"),
            )
                .then((result) {
              if (result) {
                Fluttertoast.showToast(
                  msg: "Report Success! ",
                );
              } else {
                Fluttertoast.showToast(
                  msg: "Report Failed! ",
                );
              }
            }).catchError((error) {
              print("Error!");
            });
            Future.delayed(Duration(milliseconds: 1500), () {
              Navigator.pop(context);
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: widget.selectErrorReason ? Colors.green : Colors.black12,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  S.of(context).sendError,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget makeRadioTileList(BuildContext context) {
    widget.listViewPage = [
      GroupModel(text: S.of(context).errorOne, index: 1, selected: false),
      GroupModel(text: S.of(context).errorTwo, index: 2, selected: false),
      GroupModel(text: S.of(context).errorThree, index: 3, selected: false),
    ];
    List<Widget> list = [];
    for (int i = 0; i < widget.listViewPage.length; i++) {
      list.add(RadioListTile<int>(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        value: widget.listViewPage[i].index,
        groupValue: widget._value2,
        selected: widget.listViewPage[i].selected,
        onChanged: (val) {
          setState(() {
            for (int i = 0; i < widget.listViewPage.length; i++) {
              widget.listViewPage[i].selected = false;
              widget._group[i].selected = false;
            }
            widget._value2 = val!;
            widget.listViewPage[i].selected = true;
            widget._group[i].selected = true;
            widget.reason = val;
            widget.selectErrorReason = true;
          });
        },
        activeColor: Colors.green,
        title: Text(
          ' ${widget.listViewPage[i].text}',
          style: TextStyle(
              color: widget._group[i].selected ? Colors.green : Colors.grey,
              fontWeight: widget.listViewPage[i].selected
                  ? FontWeight.bold
                  : FontWeight.normal),
        ),
      ));
    }
    Column column = new Column(
      children: list,
    );
    return column;
  }

  Widget _buildReportErrorWithMachineLanguage() {
    return InkWell(
      onTap: () {
        launch(
            'mailto:${widget.emailReceived}.com?subject=${widget.subjectEmail}&body=- Account: ${DataCache().getUserData().username}\n - VideoID: ${widget.dataTalk.id}\n - Language: vi\n - SubID: ${widget.listSub[widget.subid].id}\n --------------------------------------- \n\n ${widget.listSub[widget.subid].content}\n\n Thanks!!!');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              S.of(context).sendErrorWithEmail,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 25),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageView(BuildContext context) {
    final controller = PageController(viewportFraction: 0.9, keepPage: true);
    final pages = List.generate(
        widget.listSub.length, (index) => _buildItemViewPage(context, index));

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: controller,
              itemCount: widget.listSub.length,
              onPageChanged: (int index) {
                setState(() {
                  widget.subid = index;
                  widget.currentPageIndex = (index % pages.length);
                });
              },
              itemBuilder: (_, index) {
                return pages[index % pages.length];
              },
            ),
          ),
          SizedBox(height: 5),
          SmoothPageIndicator(
            controller: controller,
            count: pages.length,
            effect: WormEffect(
              dotHeight: 5,
              dotWidth: 5,
              dotColor: Colors.black12,
              activeDotColor: Colors.black38,
              type: WormType.thin,
              // strokeWidth: 5,
            ),
          ),
        ],
      ),
    );
  }

  String getLanguage(BuildContext context, int index) {
    Locale myLocale = Localizations.localeOf(context);
    String textSub = '';
    switch (myLocale.toString()) {
      case 'ja':
        {
          textSub = widget.listSub[index].content_ja;
          break;
        }
      case 'zh_TW':
        {
          textSub = widget.listSub[index].content_zh_Hant_TW;
          break;
        }
      case 'ko':
        {
          textSub = widget.listSub[index].content_ko;
          break;
        }
      case 'zh':
        {
          textSub = widget.listSub[index].content_zh;
          break;
        }
      case 'es':
        {
          textSub = widget.listSub[index].content_es;
          break;
        }
      case 'ru':
        {
          textSub = widget.listSub[index].content_ru;
          break;
        }
      case 'tr':
        {
          textSub = widget.listSub[index].content_tr;
          break;
        }

      case 'th':
        {
          textSub = widget.listSub[index].content_th;
          break;
        }
      case 'hi':
        {
          textSub = widget.listSub[index].content_hi;
          break;
        }
      default:
        {
          textSub = widget.listSub[index].content_vi;
          break;
        }
    }

    return textSub;
  }

  Widget _buildItemViewPage(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: index == widget.currentPageIndex
              ? Border.all(color: Colors.lightGreen)
              : Border.all(color: Colors.black38)),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Container(
        height: 200,
        child: Center(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${index + 1}",
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: Colors.lightGreen[900]),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text("${widget.listSub[index].content}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  getLanguage(context, index),
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
