import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:app_review/app_review.dart';

// Page (App screen state)
enum Pages { RealTimeGauge, Settings }

final pageProvider =
    StateProvider.autoDispose<Pages>((ref) => Pages.RealTimeGauge);

// Theme (light mode / dark mode)
final themeModeProvider =
    StateProvider.autoDispose<ThemeMode>((ref) => ThemeMode.dark);

final uiUpdateSpeedProvider = StateProvider.autoDispose<int>((ref) => 3);

// Wifi Infomation (SSID: name, RSSI: signal strength)
final ssidProvider = FutureProvider.autoDispose<String>(
    (ref) async => await WiFiForIoTPlugin.getSSID() ?? "");
final rssiProvider = FutureProvider.autoDispose<int>(
    (ref) async => await WiFiForIoTPlugin.getCurrentSignalStrength() ?? -90);

// AppId(for Review)
final appIdProvider = FutureProvider.autoDispose<String>(
    (ref) async => await AppReview.getAppID ?? "");
Future<void> requestAppReview() async {
  await AppReview.requestReview;
  print("app review");
}
