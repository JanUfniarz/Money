import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BalanceCard extends StatefulWidget {

  @override
  State<BalanceCard> createState() => _BalanceCardState();

  BalanceCard();
}

class _BalanceCardState extends State<BalanceCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[700],
      child: Column(
        children: <Widget>[
          //Text(balanceSum() as String),
          FutureBuilder<String>(
            future: balanceSum(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data ?? "0.00");
                } else {
                  return CircularProgressIndicator();
                }
              },
          ),
          ElevatedButton(
            onPressed: () =>
                setState(() =>
                    addAccount(
                      name: "account",
                      value: 100.50,
                    )
                ),
            child: Icon(Icons.accessibility),
          )
        ],
      ),
    );
  }

  static const channel = MethodChannel("com.flutter.epic/main");

  addAccount({required String name, required double value}) {
    var arguments = <String, dynamic>{
      "name": name,
      "value": value,
    };
    channel.invokeMethod("addAccount", arguments);
  }

  Future<String> balanceSum() async {
    String res = "";
    try {
      res = await channel.invokeMethod("balanceSum");
    } catch (e) {
      print(e);
    }
    return res;
  }
}