import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../palette.dart';

class BaseLinearGraph extends StatefulWidget {

  final List<ChartData> data;

  const BaseLinearGraph({
    required this.data,
    Key? key}) : super(key: key);

  @override
  State<BaseLinearGraph> createState() => _BaseLinearGraphState();
}

class _BaseLinearGraphState extends State<BaseLinearGraph> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color: Palette.background,
      child: Center(
        child: SizedBox(
          height: 180,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(color: Palette.font),
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              labelStyle: TextStyle(color: Palette.font),
              majorGridLines: const MajorGridLines(width: 0),
            ),
            series: <ChartSeries>[
              AreaSeries<ChartData, String>(
                dataSource: widget.data,
                xValueMapper: (ChartData d, _) => d.xValue,
                yValueMapper: (ChartData d, _) => d.yValue,
                gradient: LinearGradient(
                  colors: [
                    Palette.accent,
                    Palette.main2,
                  ],
                  stops: [
                    0.2,
                    0.8,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ChartData {
  final String xValue;
  final double yValue;

  ChartData({
    required this.xValue,
    required this.yValue
  });
}