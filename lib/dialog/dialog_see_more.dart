import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/models/TalkDetailModel.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dialog_report_language.dart';

class DialogSeeMore extends StatelessWidget {
  final List<TalkDetailModel> listSub;
  final DataTalk dataTalk;

  const DialogSeeMore({Key? key, required this.listSub, required this.dataTalk})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
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
              _buildWidgetSeeMore(context),
              const SizedBox(height: 8),
              _buildDivider(),
              const SizedBox(height: 20),
              _buildWatchVideoYoutube(context),
              const SizedBox(height: 20),
              _buildDivider(),
              const SizedBox(height: 20),
              _buildReportErrorWithEnglish(context, this.listSub),
              const SizedBox(height: 20),
              _buildDivider(),
              const SizedBox(height: 20),
              _buildReportErrorWithMachineLanguage(context, this.listSub),
              const SizedBox(height: 20),
              _buildDivider(),
              const SizedBox(height: 20),
              // Divider(height: 1, color: Colors.black,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: Colors.black12,
    );
  }

  Widget _buildWidgetSeeMore(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                S.of(context).seeMore,
                style: TextStyle(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              InkWell(
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  })
            ],
          )),
    );
  }

  Future openBrowserURLYoutube(String url, {bool inApp = false}) async {
    if (await canLaunch(url)) {
      await launch(url,
          forceWebView: inApp, forceSafariVC: inApp, enableJavaScript: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildWatchVideoYoutube(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          openBrowserURLYoutube('${dataTalk.link_origin}', inApp: true);
        },
        child: Row(
          children: [
            Text(
              S.of(context).seeVideoYoutube,
              style: TextStyle(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Icon(
              Icons.tab_outlined,
              color: themeProvider.mode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black26,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReportErrorWithEnglish(
      BuildContext context, List<TalkDetailModel> listSub) {
    var themeProvider = context.watch<ThemeProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          showModalBottomSheet<void>(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              context: context,
              builder: (BuildContext context) {
                return FractionallySizedBox(
                  heightFactor: 0.9,
                  child: DialogReportLanguage(
                    isEnglish: true,
                    listSub: listSub,
                    dataTalk: dataTalk,
                  ),
                );
              });
        },
        child: Row(
          children: [
            Text(
              S.of(context).reportEnglish,
              style: TextStyle(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black12,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(200))),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black38,
                size: 15,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReportErrorWithMachineLanguage(
      BuildContext context, List<TalkDetailModel> listSub) {
    var themeProvider = context.watch<ThemeProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          showModalBottomSheet<void>(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              context: context,
              builder: (BuildContext context) {
                return FractionallySizedBox(
                    heightFactor: 0.6,
                    child: DialogReportLanguage(
                      isEnglish: false,
                      listSub: listSub,
                      dataTalk: dataTalk,
                    ));
              });
        },
        child: Row(
          children: [
            Text(
              S.of(context).reportSubtitle,
              style: TextStyle(
                  color: themeProvider.mode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: themeProvider.mode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black12,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(200))),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black38,
                size: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
