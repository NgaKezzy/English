import 'dart:io';
import 'package:app_learn_english/logError/LogCustom.dart';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoadAttempts = 3;

class AdmobHelper {
  static String get bannerID => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/6300978111';

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  RewardedAd? rewardedAd;
  bool isCheckAds = true;
  BannerAd? _bannerAd;
  BannerAd? _smallBannerAd;
  NativeAd? _nativeAd;

  static initialization() {
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();
  }

  static final AdRequest request = AdRequest();

  BannerAd? get bannerAd => _bannerAd;

  Future getBannerAd() async {
    _bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-4902285970438994/7295997864'
          : 'ca-app-pub-4902285970438994/2446425042',
      request: AdRequest(),
      size: AdSize(width: 400, height: 333),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          printRed("New banner ad loaded");
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _bannerAd = null;
          printRed("Ad error: $error");
          ad.dispose();
        },
      ),
    );

    await _bannerAd!.load();
    return _bannerAd;
  }

  Future getBannerSmall() async {
    _smallBannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-4902285970438994/7295997864'
          : 'ca-app-pub-4902285970438994/2446425042',
      request: AdRequest(),
      size: AdSize(width: 400, height: 70),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          printRed("New banner ad loaded");
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _smallBannerAd = null;
          ad.dispose();
          printRed("Ad error: $error");
        },
      ),
    );

    await _smallBannerAd!.load();

    return _smallBannerAd!;
  }

  showBannerAdSmall(BuildContext context) {
    printRed('quang cao ahahhaahahahahaha');
    return _smallBannerAd != null
        ? Container(
            alignment: Alignment.center,
            child: AdWidget(ad: _smallBannerAd!),
            width: double.infinity,
            height: _smallBannerAd!.size.height.toDouble(),
          )
        : const SizedBox();
  }

  showBannerAd(BuildContext context) {
    printRed('quang cao ahahhaahahahahaha');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            size: 30,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          'Quảng cáo này tạo điều kiện giúp Phở cung cấp nội dung học miễn phí.',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 100,
        ),
        Container(
          alignment: Alignment.center,
          child: AdWidget(ad: _bannerAd!),
          width: double.infinity,
          height: _bannerAd!.size.height.toDouble(),
        ),
      ],
    );
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-4902285970438994/1852099490'
            : 'ca-app-pub-4902285970438994/3370578180',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => {
        print('ad onAdShowedFullScreenContent.'),
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void loadRewardedAd() {
    RewardedAd.load(
      // adUnitId: 'ca-app-pub-5355351048581184/7034036469',
      // adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-4902285970438994/1852099490'
          : 'ca-app-pub-4902285970438994/3370578180',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          this.rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          printRed('RewardedAd failed to load: $error');
          loadRewardedAd();
        },
      ),
    );
  }

  Future showRewaredAd() async {
    printGreen('checkads:' + this.isCheckAds.toString());
    if (this.isCheckAds == true) {
      await RewardedAd.load(
          // adUnitId: 'ca-app-pub-5355351048581184/7034036469',
          // adUnitId: 'ca-app-pub-3940256099942544/5224354917',
          adUnitId: Platform.isAndroid
              ? 'ca-app-pub-4902285970438994/1852099490'
              : 'ca-app-pub-4902285970438994/3370578180',
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              print('$ad loaded.');
              // Keep a reference to the ad so you can show it later.
              this.rewardedAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('RewardedAd failed to load: $error');
              loadRewardedAd();
            },
          ));
      rewardedAd?.show(
          onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
        print("Adds Reward is ${rewardItem.amount}");
      });
      rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {
          this.isCheckAds = false;
          printRed('checkads:' + this.isCheckAds.toString());
          print('$ad onAdShowedFullScreenContent.');
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          print('$ad onAdDismissedFullScreenContent.');
          printBlue('tắt Ads');
          this.isCheckAds = true;
          printBlue('checkads:' + this.isCheckAds.toString());
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
        },
        onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
      );
    }
  }

  // by Sơn
  void showRewaredHasCallback(Function callback, BuildContext context) async {
    printYellow("CALL ADS");
    printGreen('checkads:' + this.isCheckAds.toString());
    if (this.isCheckAds == true) {
      await RewardedAd.load(
          // adUnitId: 'ca-app-pub-5355351048581184/7034036469',
          // adUnitId: 'ca-app-pub-3940256099942544/5224354917',
          adUnitId: Platform.isAndroid
              ? 'ca-app-pub-4902285970438994/5052977905'
              : 'ca-app-pub-4902285970438994/3179006496',
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              print('$ad loaded.');
              // Keep a reference to the ad so you can show it later.
              this.rewardedAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('RewardedAd failed to load: $error');
              loadRewardedAd();
            },
          ));
      rewardedAd?.show(
          onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
        print("Adds Reward is ${rewardItem.amount}");
      });
      rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {
          this.isCheckAds = false;
          printRed('checkads:' + this.isCheckAds.toString());
          print('$ad onAdShowedFullScreenContent.');
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          print('$ad onAdDismissedFullScreenContent.');
          printBlue('tắt Ads');
          this.isCheckAds = true;
          callback();
          printBlue('checkads:' + this.isCheckAds.toString());
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
        },
        onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
      );
    }
  }

  RewardedAd? rewardAdsDiamond;

  // Hiển làm quảng cáo và gọi hàm callback cộng tim cho trò chơi
  Future showRewaredGameHasCallback(
      Function callback, BuildContext context) async {
    printGreen('checkads:' + this.isCheckAds.toString());

    await RewardedAd.load(
      // adUnitId: 'ca-app-pub-5355351048581184/7034036469',
      // adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-4902285970438994/5052977905'
          : 'ca-app-pub-4902285970438994/3179006496',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          rewardAdsDiamond = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          showRewaredGameHasCallback(callback, context);
        },
      ),
    );
  }

   showAdsAddDiamond(callback, BuildContext context) async {
    await rewardAdsDiamond!.show(
        onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
      print("Adds Reward is ${rewardItem.amount}");
    });
    rewardAdsDiamond!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        printRed('checkads:' + this.isCheckAds.toString());
        print('$ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        printBlue('tắt Ads');

        printBlue('checkads:' + this.isCheckAds.toString());
        callback(context);
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );
  }
}
