import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BalanceCard extends StatelessWidget {

  List<double> accountsValues;
  double balanceSum = 0;

  BalanceCard({required this.accountsValues}) {
    balanceSum = accountsValues.reduce((x, y) => x + y);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[700],
      child: Column(
        children: <Widget>[
          Text("Test"),
          ElevatedButton(
              onPressed: addAccount(
                name: "account",
                value: 100.50,
              ),
              child: Icon(Icons.accessibility),
          )
        ],
      ),
    );
  }

  static const channel = MethodChannel("com.flutter.epic/main");

  addAccount({required String name, required double value}) {
    var arguments = <String, dynamic> {
      "name" : name,
      "value" : value,
    };
    channel.invokeMethod("addAccount", arguments);
  }
}