import 'dart:io';

import 'package:app_learn_english/Providers/theme_provider.dart';
import 'package:app_learn_english/generated/l10n.dart';

import 'package:app_learn_english/presentation/Ads/AdmobHelper.dart';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'AdsController.dart';

class AdsBanner extends StatefulWidget {
  BannerAd bannerAd;
  AdsBanner({Key? key, required this.bannerAd}) : super(key: key);
  @override
  _AdsBanner createState() => _AdsBanner(bannerAd: bannerAd);
}

class _AdsBanner extends State<AdsBanner> with TickerProviderStateMixin {
  AdmobHelper admob = AdmobHelper();
  bool _isShow = false;
  BannerAd bannerAd;
  _AdsBanner({Key? key, required this.bannerAd});

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    AdsController().clearRoute();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(context);
              },
              icon: Icon(
                Icons.close,
                size: 30,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              S.of(context).ThisLOVEPHOfreelearningcontent,
              style: TextStyle(
                color: themeProvider.mode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              child: AdWidget(ad: bannerAd),
              width: double.infinity,
              height: bannerAd.size.height.toDouble(),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  },
                  child: Text(
                    'No, Thanks!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
