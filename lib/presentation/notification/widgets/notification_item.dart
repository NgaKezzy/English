import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/notification/models/notifications.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/screen/main_speak_screen.dart';
import 'package:app_learn_english/screens/new_play_video_screen_max.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class NotificationItem extends StatelessWidget {
  final List<Notifications> listNotify;
  final DataUser dataUser;

  const NotificationItem({
    Key? key,
    required this.listNotify,
    required this.dataUser,
  }) : super(key: key);

  setClickNotifi(BuildContext context) async {
    await TalkAPIs().setClickNotifi(context, userId: dataUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    var localeProvider = context.read<LocaleProvider>();
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (ctx, index) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: (listNotify[index].type == 1)
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return NewPlayVideoScreenNormal(
                              false,
                              dataTalk: listNotify[index].listTalk!,
                              percent: 1,
                              enablePop: true,
                              ytId: '',
                            );
                          },
                        ),
                      );
                      setClickNotifi(context);
                    }
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainSpeakScreen(
                            id: '${listNotify[index].listTalkText!.id}',
                            title: listNotify[index].listTalkText!.name,
                            dataUser: dataUser,
                          ),
                        ),
                      );
                      setClickNotifi(context);
                    },
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SvgPicture.asset(
                          listNotify[index].type == 1
                              ? 'assets/new_ui/more/turn-on-cam.svg'
                              : 'assets/new_ui/more/ic_luyendoc.svg',
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (listNotify[index].type == 1)
                                  ? Utils.changeLanguageTalkName(
                                      localeProvider.locale?.languageCode ??
                                          'en',
                                      listNotify[index].listTalk!)
                                  : listNotify[index].listTalkText!.name,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              (listNotify[index].type == 1)
                                  ? Utils.buildNameTalkWithRandomWord(
                                      listNotify[index].listTalk!.name)
                                  : listNotify[index].listTalkText!.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            (listNotify[index].type == 3)
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text('Thử quiz trong 3 phút'),
                                  )
                                : const SizedBox(),
                            if (listNotify[index].updatedTime != null)
                              const SizedBox(
                                height: 5,
                              ),
                            if (listNotify[index].updatedTime != null)
                              Text(
                                listNotify[index].updatedTime ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.withOpacity(0.7),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: listNotify.length,
    );
  }
}
