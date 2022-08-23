import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/Ads/AdsController.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/utils/color_utils.dart';
import 'package:app_learn_english/utils/config_heart_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Advertise extends StatefulWidget {
  final bool checkOnce;
  const Advertise({Key? key, required this.checkOnce}) : super(key: key);

  @override
  _AdvertiseState createState() => _AdvertiseState();
}

class _AdvertiseState extends State<Advertise> {
  AdmobHelper admobHelper = AdmobHelper();
  bool _isHoldButton = true;
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
    Navigator.pop(context, numberHeart);
  }

  bool _isLoading = true;

  @override
  void didChangeDependencies() async {
    if (_isLoading) {
      await admobHelper.showRewaredGameHasCallback(adsCallback, context);
    }
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: PhoLoading(),
            ),
          )
        : Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade700,
                    Colors.tealAccent.shade400,
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(12, 42, 12, 30),
              child: Center(
                child: Column(
                  children: [
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Lottie.asset(
                        'assets/new_ui/animation_lottie/quiz_sai_1.json',
                      ),
                    ),
                    Text(
                      S.of(context).OutOfDiamonds,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      S.of(context).WatchAdsAndGetHearts,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      S.of(context).ToContinueTheChallenge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 50),
                    DataCache().getUserData().isVip == 1 ||
                            DataCache().getUserData().isVip == 2
                        ? SizedBox()
                        : Container(
                            margin: const EdgeInsets.only(
                                bottom: 20, left: 16, right: 16),
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VipWidget(),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorsUtils.Color_E9C145),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ))),
                              child: Center(
                                child: Text(S.of(context).VIPUpgrade,
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, left: 16, right: 16),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          admobHelper.showAdsAddDiamond(adsCallback, context);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorsUtils.Color_04D076),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ))),
                        child: Center(
                          child: Text(S.of(context).WatchAdsAndGetHearts,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, left: 16, right: 16),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.checkOnce) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else
                            Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorsUtils.Color_333745),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ))),
                        child: Center(
                          child: Text(
                            S.of(context).EndOfQuiz,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
