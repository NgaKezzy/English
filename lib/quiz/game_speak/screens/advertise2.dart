import 'package:app_learn_english/Providers/heart_provider.dart';
import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/UserAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:app_learn_english/presentation/Vip/Vip_widget.dart';
import 'package:app_learn_english/presentation/speak/widgets/pho_loading.dart';
import 'package:app_learn_english/utils/config_heart_utils.dart';
import 'package:flutter/material.dart';
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
  void adsCallbakk(BuildContext context) async {
    printRed("CALL BACK: ");
    // var count = 3;
    // printGreen("ADDED:");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setInt("count_heart_game1", count);
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
    if (widget.checkOnce) Navigator.pop(context, numberHeart);
    Navigator.pop(context, numberHeart);
  }

  var _isLoading = true;
  @override
  void didChangeDependencies() async {
    if (_isLoading) {
      await admobHelper.showRewaredGameHasCallback(adsCallbakk, context);
    }
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: PhoLoading(),
            ),
          )
        : Scaffold(
            body: Container(
              decoration: BoxDecoration(
                color: themeProvider.mode == ThemeMode.dark
                    ? Color.fromRGBO(24, 26, 33, 1)
                    : Colors.white,
              ),
              padding: const EdgeInsets.fromLTRB(12, 42, 12, 30),
              child: Center(
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Lottie.asset(
                        'assets/new_ui/animation_lottie/diamond.json',
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      S.of(context).OutOfDiamonds,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      S.of(context).WatchAdsAndGetHearts,
                      style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      S.of(context).ToContinueTheChallenge,
                      style: TextStyle(
                        color: themeProvider.mode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 100),
                    DataCache().getUserData().isVip == 1 ||
                            DataCache().getUserData().isVip == 2
                        ? SizedBox()
                        : Container(
                            margin: EdgeInsets.only(bottom: 20),
                            height: 40,
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
                                  Color.fromRGBO(83, 180, 81, 1),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  S.of(context).VIPUpgrade,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          // AdsController().showAd();
                          admobHelper.showAdsAddDiamond(adsCallbakk, context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(83, 180, 81, 1),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).WatchAdsAndGetHearts,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
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
                            Color.fromRGBO(83, 180, 81, 1),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).EndOfQuiz,
                            style: TextStyle(fontSize: 20),
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
