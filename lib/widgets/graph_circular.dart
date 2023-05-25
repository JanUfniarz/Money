import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../invoker.dart';
import '../palette.dart';

class CircularGraph extends StatefulWidget {
  const CircularGraph({Key? key}) : super(key: key);

  @override
  State<CircularGraph> createState() => _CircularGraphState();
}

class _CircularGraphState extends State<CircularGraph> {

  String type = "Expense";

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color: Palette.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: type == "Expense"
                      ? Palette.main2Clicked : Palette.main2,
                ),
                onPressed: () => setState(() => type = "Expense"),
                child: Text(
                  "Expense",
                  style: TextStyle(
                    color: type == "Expense"
                        ? Palette.font : Palette.background,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: type == "Income"
                      ? Palette.main2Clicked : Palette.main2,
                ),
                onPressed: () => setState(() => type = "Income"),
                child: Text(
                  "Income",
                  style: TextStyle(
                    color: type == "Income"
                        ? Palette.font : Palette.background,
                  ),
                ),
              ),
            ],
          ),
          EnCircularGraph(type: type),
        ],
      ),
    );
  }
}


class EnCircularGraph extends StatefulWidget {

  final String type;

  const EnCircularGraph({
    required this.type,
    Key? key}) : super(key: key);

  @override
  State<EnCircularGraph> createState() => _EnCircularGraphState();
}

class _EnCircularGraphState extends State<EnCircularGraph> {
  Map<String, double> exValues = {};
  Map<String, double> inValues = {};

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    Map<String, double> exValues = {};
    Map<String, double> inValues = {};

    List<String> exCategories = [
      "Basic expenditure",
      "Enterprise",
      "Travelling",
      "House",
      "Health and beauty",
      "Transport",
      "Other",
    ];

    List<String> inCategories = [
      "Full time job",
      "Part time job",
      "Exploitation",
      "Passive income",
      "Other",
    ];

    for (String category in exCategories) {
      double value = await Invoker.categorySum(category, "Expense");
      exValues.addAll({category : value});
    }

    for (String category in inCategories) {
      double value = await Invoker.categorySum(category, "Income");
      inValues.addAll({category : value});
    }

    if (mounted) {
      setState(() {
        this.exValues = exValues;
        this.inValues = inValues;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Palette.main,
      Palette.main2,
      Palette.accent,
      Palette.textField,
    ];

    Map<String, double> values = widget.type == "Expense"
        ? exValues : inValues;

    values.removeWhere((key, value) => value == 0.0);

    int colorIndex = 0;
    List<Data> data = [];
    for (var it in values.entries) {
      data.add(Data(
        label: it.key,
        value: it.value,
        color: colors.elementAt(colorIndex),
      ));

      colorIndex++;
      if (colorIndex == colors.length) colorIndex = 0;
    }
    return BaseCircularGraph(data: data);
  }
}


class BaseCircularGraph extends StatefulWidget {
  final List<Data> data;

  const BaseCircularGraph({required this.data, Key? key}) : super(key: key);

  @override
  State<BaseCircularGraph> createState() => _BaseCircularGraphState();
}

class _BaseCircularGraphState extends State<BaseCircularGraph> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color: Palette.background,
      child: Center(
        child: SfCircularChart(
          series: <CircularSeries<Data, String>>[
            DoughnutSeries<Data, String>(
              dataSource: widget.data,
              xValueMapper: (Data data, _) => data.label,
              yValueMapper: (Data data, _) => data.value,
              dataLabelMapper: (Data data, _) => data.label,
              pointColorMapper: (Data data, _) => data.color,
              startAngle: 270,
              endAngle: 270,
              innerRadius: '60%',
              dataLabelSettings: DataLabelSettings(
                textStyle: TextStyle(
                  color: Palette.font,
                ),
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                connectorLineSettings: const ConnectorLineSettings(
                  length: '10%',
                  type: ConnectorType.curve,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Data {
  final String label;
  final double value;
  final Color color;

  const Data({
    required this.label,
    required this.value,
    required this.color
  });
}