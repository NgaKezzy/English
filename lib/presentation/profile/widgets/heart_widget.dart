import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeartWidget extends StatefulWidget {
  const HeartWidget({Key? key}) : super(key: key);

  @override
  State<HeartWidget> createState() => _HeartWidgetState();
}

class _HeartWidgetState extends State<HeartWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var hearProvider = Provider.of<CountHeartProvider>(context, listen: true);

    return InkWell(
      onTap: () async {
        var prefs = await SharedPreferences.getInstance();
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (ctx, innerState) {
                var heartProvider =
                    Provider.of<CountHeartProvider>(context, listen: true);
                void adsCallback(BuildContext context) async {
                  var numberHeart = heartProvider.countHeart + 1;
                  heartProvider.setCountHeart(numberHeart);
                  prefs.setInt('Heart_Global', numberHeart);
                  Navigator.pop(context);
                }

                void showAds(BuildContext context) {
                  AdsController().showAdsCallback(adsCallback, context);
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height / 2.7,
                  color: themeProvider.mode == ThemeMode.dark
                      ? Color.fromRGBO(42, 44, 50, 1)
                      : Colors.grey[100],
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: 25,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons-svg/icon_ruby.svg',
                            height: 40,
                          ),
                          Text(
                            DataCache().getUserData() == null
                                ? ''
                                :'${heartProvider.countHeart}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          S.of(context).NumberOfDiamondsOwned,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      heartProvider.countHeart == 7
                          ? Align(
                              alignment: Alignment.center,
                              child: Text(S.of(context).Youhaveofhearts),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: Text(
                                S.of(context).Heartwillberestoredafter1hour,
                              ),
                            ),
                      const SizedBox(height: 10),
                      heartProvider.countHeart == 7
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                showAds(ctx);
                              },
                              child: Text(
                                S.of(context).Watchadstogetmorehearts,
                              ),
                            )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons-svg/icon_ruby.svg',
              height: 40,
            ),
            Text(
              DataCache().getUserData() == null
                  ? ''
                  : (DataCache().getUserData().isVip == 1 ||
                          DataCache().getUserData().isVip == 2)
                      ? 'VIP'
                      : '${hearProvider.countHeart}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
