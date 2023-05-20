import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../palette.dart';

class LinearGraph extends StatefulWidget {

  final String? account;

  const LinearGraph({this.account, Key? key}) : super(key: key);

  @override
  State<LinearGraph> createState() => _LinearGraphState();
}

class _LinearGraphState extends State<LinearGraph> {
  static const channel = MethodChannel(
      "com.flutter.balance_card/MainActivity"
  );

  List<ChartData> data = [];

  @override
  void initState() {
    super.initState();
    _loadData().then((data) {
      setState(() {
        this.data = data;
      });
    });
  }

  Future<List<ChartData>> _loadData() async {
    List<ChartData> data = [];

    double initialValue = await channel.invokeMethod("getInitValueSum");
    if(widget.account != null) {
      initialValue = await channel
          .invokeMethod("getInitialValue", {"account" : widget.account});
    }

    data.add(ChartData(date: "0", value: initialValue));

    int entriesSize = await channel.invokeMethod("getLengthOfEntries");
    double value = initialValue;
    for (int it = entriesSize - 1; it >= 0; it--) {
      Map<String, dynamic> arguments = {"index" : it};
      double amount = await channel.invokeMethod("getEntryAmount", arguments);
      String date = (await channel
          .invokeMethod("getEntryDate", arguments) as String)
          .replaceAll("-", ".")
          .substring(2);
      String type = await channel.invokeMethod("getEntryType", arguments);
      String account = await channel
          .invokeMethod("getEntryAccountName", arguments);

      if (type == "Expense") amount -= 2 * amount;
      value += amount;

      if ((type != "Transfer" && account != "Deleted")
          && ((widget.account == null) || (account == widget.account))) {
        data.add(ChartData(date: date, value: value));
      }
    }

    data.sort((a, b) => int.parse(a.date.replaceAll(".", ""))
        .compareTo(int.parse(b.date.replaceAll(".", ""))));

    return data;
  }
  @override
  Widget build(BuildContext context) {

    if (data.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Card(
        elevation: 0,
        shadowColor: Palette.background,
        color: Palette.background,
        child: Column(
          children: <Widget>[
            Text(
              "Balance over time",
              style: TextStyle(
                fontSize: 25,
                color: Palette.font,
              ),
            ),
            BaseLinearGraph(data: data),
          ],
        ),
      );
    }
  }
}

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
      elevation: 0,
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
              interval: 50,
              labelStyle: TextStyle(color: Palette.font),
              majorGridLines: MajorGridLines(
                width: 1,
                color: Palette.accent
              ),
               minimum: (widget.data
                  .map((d) => d.value)
                  .reduce((a, b) => a < b ? a : b) * 0.8)
                  .floor().toDouble(),
            ),
            series: <ChartSeries>[
              AreaSeries<ChartData, String>(
                dataSource: widget.data,
                xValueMapper: (ChartData d, _) => d.date,
                yValueMapper: (ChartData d, _) => d.value,
                gradient: LinearGradient(
                  colors: [
                    Palette.accent,
                    Palette.main2,
                  ],
                  stops: const [
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
  final String date;
  final double value;

  ChartData({
    required this.date,
    required this.value
  });

  @override
  String toString() => "\nCharData:\nDate: $date, value: $value";
}