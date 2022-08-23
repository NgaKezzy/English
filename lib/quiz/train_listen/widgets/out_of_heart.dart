import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/utils/config_heart_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class OutOfHeart extends StatefulWidget {
  @override
  State<OutOfHeart> createState() => _OutOfHeartState();
}

class _OutOfHeartState extends State<OutOfHeart> {
  bool _checkTap = true;
  void adsCallback(BuildContext context) async {
    printRed("CALL BACK: ");
    // int count = 3;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setInt("count_heart", count);
    // printGreen("ADDED: ");
    var heartProvider = Provider.of<CountHeartProvider>(
      context,
      listen: false,
    );
    var numberHeart = await UserAPIs().addAndDivHeart(
      username: DataCache().getUserData().username,
      uid: DataCache().getUserData().uid,
      typeAction: ConfigHeart.nhan_tim_tu_admob_cong_tim,
    );
    heartProvider.setCountHeart(numberHeart);
    setState(() {
      _checkTap = false;
    });
  }

  AdmobHelper admobHelper = AdmobHelper();

  @override
  void didChangeDependencies() async {
    await admobHelper.showRewaredGameHasCallback(adsCallback, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/quiz/diamond.svg',
            height: 100,
            width: 100,
          ),
          SizedBox(height: 5),
          Text(
            S.of(context).Youhavelostyourheart,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 300,
            child: Text(
              S.of(context).Continuetakingthequizbywatchingadstoreceivehearts,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(194, 194, 194, 1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  VipWidget.routeName,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Profile/VIP-upgrade.png',
                    height: 25,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    S.of(context).Tryusinginfinitehearts,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: TextButton(
              onPressed: () async {
                toast(S.of(context).WaitingForAds);
                admobHelper.showAdsAddDiamond(adsCallback, context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).WatchadsandgetTim,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color.fromRGBO(83, 180, 81, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
