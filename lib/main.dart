import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wifi_info/ad_manager.dart';

import 'package:wifi_info/data.dart';
import 'package:wifi_info/screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

void main() {
  if (!kIsWeb) _setTargetPlatformForDesktop();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  return runApp(ProviderScope(child: MyApp()));
}

void _setTargetPlatformForDesktop() {
  TargetPlatform? targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Pages page = ref.watch(pageProvider);
    final StateController<Pages> pageState = ref.read(pageProvider.state);
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final int uiUpdateSpeed = ref.watch(uiUpdateSpeedProvider);
    Timer timerInit(Timer? oldTimer) {
      if (oldTimer != null) oldTimer.cancel();
      return Timer.periodic(Duration(seconds: uiUpdateSpeed),
          (timer) => ref.refresh(rssiProvider));
    }
    Timer timer = timerInit(null);
    ref.listen<int>(uiUpdateSpeedProvider,
        (_, int uiUpdateSpeed) => timer = timerInit(timer));
    return MaterialApp(
        title: "Wi-Fi通信強さ測定",
        theme: ThemeData(
            primarySwatch: Colors.green, brightness: Brightness.light),
        darkTheme:
            ThemeData(primarySwatch: Colors.green, brightness: Brightness.dark),
        themeMode: themeMode,
        home: Scaffold(
          appBar: page == Pages.RealTimeGauge
              ? AppBar(title: Text("Wi-Fi通信強さ測定"), actions: [
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () => pageState.state = Pages.Settings)
                ])
              : AppBar(
                  title: Text("Wi-Fi通信強さ測定"),
                  leading: IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () => pageState.state = Pages.RealTimeGauge)),
          body: Navigator(
            pages: [
              if (page == Pages.RealTimeGauge)
                MaterialPage(child: WifiInfoScreen()),
              if (page == Pages.Settings) MaterialPage(child: SettingScreen()),
            ],
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }
              pageState.state = Pages.RealTimeGauge;
              return true;
            },
          ),
          bottomNavigationBar: bottomBarAdInit(),
        ));
  }
}
