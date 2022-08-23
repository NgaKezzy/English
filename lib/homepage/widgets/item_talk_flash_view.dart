import 'package:app_learn_english/homepage/pages/page_flash_view.dart';
import 'package:app_learn_english/models/TalkModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ItemFlashView extends StatelessWidget {
  final List<DataTalk> flashViewTalk;
  final int idx;
  final DataTalk talk;
  final DataUser userData;
  final int currentPage;
  ItemFlashView({
    Key? key,
    required this.idx,
    required this.talk,
    required this.userData,
    required this.flashViewTalk,
    required this.currentPage,
  });
  final URL_AVATAR_VIDEO = Session().BASE_IMAGES + "images/talk_avatars/";

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LocaleProvider>(context).locale!.languageCode;
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageFlashView(
              data: flashViewTalk,
              idx: idx,
              currentPage: currentPage,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        height: 230,
        margin: const EdgeInsets.only(left: 0, right: 15),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: talk.picLink.isEmpty
                    ? (talk.link_origin.isEmpty
                        ? URL_AVATAR_VIDEO + talk.picture
                        : "https://img.youtube.com/vi/" +
                            talk.yt_id +
                            "/maxresdefault.jpg")
                    : talk.picLink,
                width: 150,
                height: 230,
                fit: BoxFit.cover,
                errorWidget: (context, url, stackTrace) => CachedNetworkImage(
                  imageUrl: 'https://img.youtube.com/vi/' +
                      talk.yt_id +
                      '/mqdefault.jpg',
                  width: 150,
                  height: 230,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.6,
                child: SvgPicture.asset(
                  'assets/new_ui/home/play_ic_play.svg',
                  height: 60,
                ),
              ),
            ),
            Column(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    Utils.changeLanguageTalkName(lang, talk),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
