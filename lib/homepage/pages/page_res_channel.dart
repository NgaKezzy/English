import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/channel_provider.dart';
import 'package:app_learn_english/homepage/searchpage/search_widget/channel_detail.dart';
import 'package:app_learn_english/models/CategoryModel.dart';
import 'package:app_learn_english/models/UserModel.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/Session.dart';
import 'package:app_learn_english/networks/TalkAPIs.dart';
import 'package:app_learn_english/presentation/profile/changeNickName.dart';
import 'package:app_learn_english/presentation/profile/widgets/LocaleProvider.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class PageResChannel extends StatefulWidget {
  const PageResChannel({Key? key}) : super(key: key);

  @override
  State<PageResChannel> createState() => _PageResChannelState();
}

class _PageResChannelState extends State<PageResChannel> {
  final scrollController = ScrollController();
  @override
  void didChangeDependencies() async {
    var channelProvider = context.read<ChannelProvider>();
    if (channelProvider.isLoading) {
      var localeProvider = context.read<LocaleProvider>();
      var dataUser = DataCache().getUserData();
      var subChannelData = await TalkAPIs().fetchDataSubChannel(
        lang: localeProvider.locale?.languageCode ?? 'en',
        page: channelProvider.pageGetCate,
        userData: dataUser,
      );
      var cates = await TalkAPIs().getCategory(
        page: channelProvider.pageGetCate,
        lang: localeProvider.locale?.languageCode ?? 'en',
      );
      channelProvider.allCate = cates;
      channelProvider.subscribedChannel = subChannelData.listCatgoryFollow;
      channelProvider.pageGetCate += 1;
      channelProvider.isLoading = false;
      scrollController.addListener(listener);
    }
    super.didChangeDependencies();
  }

  void listener() async {
    print(
        'đây là scrollController: ${scrollController.position.maxScrollExtent}');
    if (scrollController.position.pixels >
        scrollController.position.maxScrollExtent - 100) {
      var localeProvider = context.read<LocaleProvider>();
      var channelProvider = context.read<ChannelProvider>();
      var cates = await TalkAPIs().getCategory(
        page: channelProvider.pageGetCate,
        lang: localeProvider.locale?.languageCode ?? 'en',
      );
      channelProvider.allCate.addAll(cates);
      channelProvider.pageGetCate += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    var channelProvider = context.watch<ChannelProvider>();
    var localeProvider = context.read<LocaleProvider>();
    return channelProvider.isLoading
        ? const Center(
            child: PhoLoading(),
          )
        : SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  color: const Color.fromRGBO(236, 236, 236, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        S.of(context).SubscribedChannel,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (channelProvider.subscribedChannel.isEmpty)
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              S.of(context).TheListOfRegistered,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment:
                                channelProvider.subscribedChannel.isEmpty
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.start,
                            children: [
                              for (var channel
                                  in channelProvider.subscribedChannel)
                                _buildSubscribedChannel(
                                  channelName: Utils.changeLanguageChannelName(
                                      localeProvider.locale?.languageCode ??
                                          'en',
                                      channel),
                                  channel: channel,
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    S.of(context).Channel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: channelProvider.allCate.isEmpty
                      ? const Center(
                          child: PhoLoading(),
                        )
                      : Column(
                          children: [
                            for (var i = 0;
                                i < channelProvider.allCate.length;
                                i++)
                              _buildChannel(
                                localeProvider,
                                channelProvider.allCate[i],
                                channelProvider,
                              ),
                          ],
                        ),
                )
              ],
            ),
          );
  }

  Widget _buildChannel(LocaleProvider localeProvider, Category category,
      ChannelProvider channelProvider) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChannelDetail(
              category: category,
              showSetting: () {},
            ),
          ),
        );
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: category.picLink.isNotEmpty
                    ? NetworkImage(category.picLink)
                    : NetworkImage(
                        Session().BASE_IMAGES +
                            'images/cat_avatars/' +
                            category.picture,
                      ),
                backgroundColor: Colors.white,
                onBackgroundImageError: (exception, stackTrace) =>
                    SvgPicture.asset(
                  'assets/new_ui/animation_lottie/pho_loading_green.json',
                ),
                radius: 34,
              ),
              Container(
                width: 200,
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      Utils.changeLanguageChannelName(
                        localeProvider.locale?.languageCode ?? 'en',
                        category,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Number of people registered: ' +
                          category.totalFollow.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  channelProvider.addSubscribedChannel(context, category,
                      localeProvider.locale?.languageCode ?? 'en');
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6766),
                    // color: const Color(0xFF04D076),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/new_ui/more/plus2.svg',
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribedChannel(
      {required String channelName, required Category channel}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChannelDetail(
              category: channel,
              showSetting: () {},
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundImage: channel.picLink.isNotEmpty
                  ? NetworkImage(channel.picLink)
                  : NetworkImage(
                      Session().BASE_IMAGES +
                          'images/cat_avatars/' +
                          channel.picture,
                    ),
              backgroundColor: Colors.white,
              onBackgroundImageError: (exception, stackTrace) =>
                  SvgPicture.asset(
                'assets/new_ui/animation_lottie/pho_loading_green.json',
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 70,
              child: Text(
                channelName,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromRGBO(94, 94, 94, 1),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
