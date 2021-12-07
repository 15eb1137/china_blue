import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GaugeChart extends StatelessWidget {
  final List<charts.Series<GaugeSegment, String>> seriesList;
  final bool animate;
  final String ssid;
  final int rssi;
  final double signalStrength;

  static const double base = 1.1;
  static const int minStrength = -127;

  GaugeChart(this.seriesList,
      {required this.animate,
      required this.ssid,
      required this.rssi,
      required this.signalStrength});

  factory GaugeChart.fromData(String ssid, int rssi) {
    double signalStrength = 1 / (1 + pow(base, -rssi + minStrength / 2)) * 100;
    return GaugeChart(_createData(signalStrength),
        animate: false, ssid: ssid, rssi: rssi, signalStrength: signalStrength);
  }

  @override
  Widget build(BuildContext context) {
    Color checkColor(double signalStrength) {
      if (signalStrength >= 70) {
        return Colors.blue.shade700;
      } else if (signalStrength >= 50) {
        return Colors.amber.shade700;
      } else {
        return Colors.deepOrange.shade700;
      }
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        charts.PieChart<String>(seriesList,
            animate: animate,
            defaultRenderer: charts.ArcRendererConfig(
                arcWidth: 50, startAngle: 4 / 5 * pi, arcLength: 7 / 5 * pi)),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ssid != "<unknown ssid>" ? ssid : ""),
              Text(
                signalStrength.floor().toString(),
                style:
                    TextStyle(fontSize: 64, color: checkColor(signalStrength)),
              ),
              Text(rssi.toString() + 'dbm'),
            ],
          ),
        ),
      ],
    );
  }

  static List<charts.Series<GaugeSegment, String>> _createData(
      double signalStrength) {
    charts.Color checkColorMain(double signalStrength) {
      if (signalStrength >= 70) {
        return charts.ColorUtil.fromDartColor(Colors.blue);
      } else if (signalStrength >= 50) {
        return charts.ColorUtil.fromDartColor(Colors.amber);
      } else {
        return charts.ColorUtil.fromDartColor(Colors.deepOrange);
      }
    }

    charts.Color checkColorSub(double signalStrength) {
      if (signalStrength >= 70) {
        return charts.ColorUtil.fromDartColor(Colors.blue.shade100);
      } else if (signalStrength >= 50) {
        return charts.ColorUtil.fromDartColor(Colors.amber.shade100);
      } else {
        return charts.ColorUtil.fromDartColor(Colors.deepOrange.shade100);
      }
    }

    return [
      charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        colorFn: (GaugeSegment segment, _) => segment.color,
        data: [
          GaugeSegment('Low', signalStrength, checkColorMain(signalStrength)),
          GaugeSegment(
              'High', 100 - signalStrength, checkColorSub(signalStrength)),
        ],
      )
    ];
  }
}

class GaugeSegment {
  final String segment;
  final double size;
  final charts.Color color;

  GaugeSegment(this.segment, this.size, this.color);
}

// ThemeToggle
class ProviderSwitchListTile extends StatelessWidget {
  ProviderSwitchListTile(
      {required this.title, required this.isActive, required this.update});
  final String title;
  final bool isActive;
  final void Function(bool) update;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(title),
        value: isActive,
        onChanged: (isActive) => update(isActive));
  }
}

class AppReviewCard extends StatelessWidget {
  AppReviewCard({required this.onPressedFunction});

  final void Function() onPressedFunction;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      Container(
          padding: EdgeInsets.only(top: 16),
          child: Text("まだ成長中のアプリです！\n本当に役立つアプリを目指しています！\n率直なご意見お待ちしています😊")),
      TextButton(child: Text("レビューする"), onPressed: onPressedFunction)
    ]));
  }
}
