import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/model_local/SettingModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/provider/all_list_talk_course.dart';
import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailCourseListItem extends StatefulWidget {
  final List<dynamic> listTalk;
  final DataUser dataUser;
  final int indexList;

  const DetailCourseListItem({
    Key? key,
    required this.listTalk,
    required this.dataUser,
    required this.indexList,
  }) : super(key: key);

  @override
  State<DetailCourseListItem> createState() => _DetailCourseListItemState();
}

class _DetailCourseListItemState extends State<DetailCourseListItem> {
  late double updatePercentCourse;
  late DataUser dataUser;
  late SettingOffline settingUser;
  bool _isLoading = true;

  @override
  void didChangeDependencies() async {
    if (_isLoading) {
      settingUser = DataCache().getSettingData();
      dataUser = DataCache().userCache!;
      updatePercentCourse = await AllListTalkCourse().getPercentSpeak(
        dataUser.uid,
        int.parse('${widget.listTalk[widget.indexList]['id']}'),
      );
      printCyan(dataUser.isVip.toString());
      printCyan(widget.listTalk.toString());
    }
    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      String lang = provider.locale!.languageCode;
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0, left: 0),
            child: InkWell(
              onTap: (widget.listTalk[widget.indexList]['isVip']) &&
                      (dataUser.isVip == 0 || dataUser.isVip == 3)
                  ? () {
                      Navigator.pushNamed(context, VipWidget.routeName);
                    }
                  : () async {
                      AdsController().setRoute(MainSpeakScreen.routeName);
                      StaticsticalProvider staticsticalProvider =
                          Provider.of<StaticsticalProvider>(
                        context,
                        listen: false,
                      );
                      int checkSpeak = await TargetAPIs().updateWatchedSpeak(
                        uid: DataCache().getUserData().uid,
                        speakId: widget.listTalk[widget.indexList]['id'],
                        username: DataCache().getUserData().username,
                      );
                      if (checkSpeak != 0) {
                        staticsticalProvider.updateTotalTalk(checkSpeak);
                      }
                      final pushScreen = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return MainSpeakScreen(
                              dataUser: dataUser,
                              id: '${widget.listTalk[widget.indexList]['id']}',
                              title: (lang == 'en')
                                  ? widget.listTalk[widget.indexList]['name']
                                  : widget.listTalk[widget.indexList]
                                      ['name_${lang}'],
                            );
                          },
                        ),
                      );

                      await Provider.of<AllListTalkCourse>(context,
                              listen: false)
                          .updatePercentSpeak(
                        dataUser.uid,
                        int.parse('${widget.listTalk[widget.indexList]['id']}'),
                        double.parse(pushScreen.toString()),
                      );
                      setState(() {
                        updatePercentCourse =
                            double.parse(pushScreen.toString());
                      });
                    },
              child: SizedBox(
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 15, right: 10),
                  leading: (widget.listTalk[widget.indexList]['isVip']) &&
                          (dataUser.isVip == 0 || dataUser.isVip == 3)
                      ? Container(
                    width: 50,
                        height: 50,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: CachedNetworkImage(
                                imageUrl:Session().BASE_IMAGES +
                                    'images/talk_text_avatars/${widget.listTalk[widget.indexList]['picture']}',
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/linh_vat/dau-linh-vat.png'),
                                  radius: 25,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.lock_outline,
                                size: 25,
                                color: Colors.grey[600],
                              ),
                            ),
                            ],
                        ),
                      )
                      : widget.listTalk[widget.indexList]['picture'].isEmpty
                          ? const CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/linh_vat/linhvat2.png'),
                              radius: 25,
                            )
                          : CachedNetworkImage(
                    imageUrl:Session().BASE_IMAGES +
                        'images/talk_text_avatars/${widget.listTalk[widget.indexList]['picture']}',
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/linh_vat/linhvat2.png'),
                      radius: 25,
                    ),
                  ),


                  title: Text(
                    (lang == 'en')
                        ? widget.listTalk[widget.indexList]['name']
                        : widget.listTalk[widget.indexList]['name_$lang'],
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      // color: (widget.listTalk[widget.indexList]['isVip']) &&
                      //         (dataUser.isVip == 0 || dataUser.isVip == 3)
                      //     ? Colors.grey
                      //     : Colors.black,
                      color: themeProvider.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: _isLoading
                      ? const SizedBox()
                      : ((widget.listTalk[widget.indexList]['isVip']) &&
                              (dataUser.isVip == 0 || dataUser.isVip == 3)
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 1,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.lock,
                                    size: 12,
                                    color: Colors.yellow[700]!.withOpacity(0.7),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    updatePercentCourse == 0
                                        ? S.of(context).NotStudied
                                        : '${S.of(context).Learned} ${NumberFormat("###.0#", "en_US").format(updatePercentCourse)}%',
                                    style: TextStyle(
                                      color:
                                          Colors.yellow[700]!.withOpacity(0.7),
                                      fontSize: 13,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              updatePercentCourse == 0
                                  ? S.of(context).NotStudied
                                  : '${S.of(context).Learned} ${NumberFormat("###.0#", "en_US").format(updatePercentCourse)}%',
                              style: TextStyle(
                                color: updatePercentCourse == 0
                                    ? Colors.grey
                                    : Colors.purple,
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                  trailing: (widget.listTalk[widget.indexList]['isVip'])
                      ? (dataUser.isVip == 0 || dataUser.isVip == 3)
                          ? Card(
                              color: ColorsUtils.Color_FF6E41,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              elevation: 10,
                              child: SizedBox(
                                width: 93,
                                height: 40,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/new_ui/more/ic_vip_speak.svg',
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'VIP',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Card(
                              color: ColorsUtils.Color_04D076,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              elevation: 10,
                              child: const SizedBox(
                                width: 93,
                                height: 40,
                                child: Center(
                                  child: const Text(
                                    'Free',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                      : Card(
                          color: ColorsUtils.Color_04D076,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          elevation: 10,
                          child: const SizedBox(
                            width: 93,
                            height: 40,
                            child: Center(
                              child: Text(
                                'Free',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 1,
            color: ColorsUtils.Color_333745.withOpacity(0.2),
          )
        ],
      );
    });
  }
}
