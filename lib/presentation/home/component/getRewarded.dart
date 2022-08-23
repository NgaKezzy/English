import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_learn_english/Providers/TargetProvider.dart';
import 'package:app_learn_english/generated/l10n.dart';
import 'package:app_learn_english/homepage/provider/statistical_provider.dart';
import 'package:app_learn_english/networks/DataCache.dart';
import 'package:app_learn_english/networks/TargetAPIs.dart';
import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class GetRewarded extends StatefulWidget {
  const GetRewarded({Key? key}) : super(key: key);

  @override
  _GetRewardedState createState() => _GetRewardedState();
}

class _GetRewardedState extends State<GetRewarded>
    with TickerProviderStateMixin {
  AdmobHelper admob = AdmobHelper();
  bool _isShow = false;

  @override
  void initState() {
    admob.createInterstitialAd();
    super.initState();
    _controller = GifController(vsync: this);

    _controller.repeat(min: 0, max: 40, period: Duration(milliseconds: 900));
    Future.delayed(Duration(milliseconds: 2100), () async {
      _controller.stop();
    });
    Future.delayed(Duration(milliseconds: 2000), () async {
      setState(() {
        _isShow = true;
      });
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    TargetProvider targetProvider = Provider.of<TargetProvider>(
      context,
      listen: false,
    );
    StaticsticalProvider staticsticalProvider =
        Provider.of<StaticsticalProvider>(
      context,
      listen: false,
    );
    int total = await TargetAPIs().updateCompleteTarget(
      uid: DataCache().getUserData().uid,
      target: targetProvider.itemTarget!.timeM,
      username: DataCache().getUserData().username,
      isCompleted: 1,
    );
    staticsticalProvider.updateTotalMonth(total);
  }

  late GifController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 50),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                if (!_isShow)
                  AnimatedTextKit(
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                    animatedTexts: [
                      ScaleAnimatedText(
                        // '+10 ${S.of(context).Gold}',
                        S.of(context).GoalAccomplished,
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent[700]),
                      ),
                    ],
                    repeatForever: false,
                    totalRepeatCount: 1,
                  ),
                if (_isShow)
                  Text(
                    S.of(context).GoalAccomplished,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent[700],
                    ),
                  ),
                Center(
                  child:
                      Lottie.asset('assets/new_ui/animation_lottie/rocket.json'),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (!_isShow)
                            AnimatedTextKit(
                              animatedTexts: [
                                ScaleAnimatedText(
                                  // '+10 ${S.of(context).Gold}',
                                  S.of(context).CongratulationsYouGot10Diamonds,
                                  textAlign: TextAlign.center,
                                  textStyle: TextStyle(
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.greenAccent[700]),
                                ),
                              ],
                              repeatForever: false,
                              totalRepeatCount: 1,
                            ),
                          if (_isShow)
                            Text(
                              S.of(context).CongratulationsYouGot10Diamonds,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent[700],
                              ),
                            ),
                        ]),
                  ),
                ),
                Center(
                  child: Container(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // nhớ xóa đi :))
                        await admob.showRewaredAd();
                      },
                      child: Text(
                        S.of(context).GetRewarded,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(4, 175, 56, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        elevation: 20,
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
