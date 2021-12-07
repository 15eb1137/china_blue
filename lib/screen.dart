import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wifi_info/data.dart';
import 'package:flutter/material.dart';
import 'package:wifi_info/widget.dart';

class WifiInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, WidgetRef ref, child) {
      final AsyncValue<String> loadingSSID = ref.watch(ssidProvider);
      final AsyncValue<int> loadingRSSI = ref.watch(rssiProvider);
      String ssid = loadingSSID.when(
          data: (ssid) => ssid,
          loading: () => "loading...",
          error: (err, stack) => "Error: $err");
      int rssi = loadingRSSI.when(
          data: (rssi) => rssi, loading: () => -127, error: (err, stack) => -127);
      return Container(child: GaugeChart.fromData(ssid, rssi));
    });
  }
}

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, WidgetRef ref, child) {
      final ThemeMode themeMode = ref.watch(themeModeProvider);
      final StateController<ThemeMode> themeModeState =
          ref.read(themeModeProvider.state);
      final int uiUpdateSpeed = ref.watch(uiUpdateSpeedProvider);
      final StateController<int> uiUpdateSpeedState =
          ref.read(uiUpdateSpeedProvider.state);
      return ListView(
        children: [
          ProviderSwitchListTile(
              title: "更新頻度UP[beta]",
              isActive: uiUpdateSpeed == 1,
              update: (isActive) => uiUpdateSpeedState.state =
                  isActive ? 1 : 3),
          ProviderSwitchListTile(
              title: "ダークモード",
              isActive: themeMode == ThemeMode.dark,
              update: (isActive) => themeModeState.state =
                  isActive ? ThemeMode.dark : ThemeMode.light),
          AppReviewCard(onPressedFunction: () => requestAppReview()),
        ],
      );
    });
  }
}
