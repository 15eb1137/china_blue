import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8835706365570627~1210084557";
      // } else if (Platform.isIOS) {
      //   return "<YOUR_IOS_ADMOB_APP_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8835706365570627/8627934793";
      // return "ca-app-pub-3940256099942544/6300978111"; // test
      // } else if (Platform.isIOS) {
      //   return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

Container bottomBarAdInit() {
  BannerAd _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener());

  _bannerAd.load();

  return Container(
    alignment: Alignment.center,
    child: AdWidget(ad: _bannerAd),
    width: _bannerAd.size.width.toDouble(),
    height: _bannerAd.size.height.toDouble(),
  );
}
