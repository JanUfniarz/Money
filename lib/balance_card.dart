import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money/my_color.dart';

class BalanceCard extends StatefulWidget {

  @override
  State<BalanceCard> createState() => _BalanceCardState();

  BalanceCard({super.key});
}

class _BalanceCardState extends State<BalanceCard> {

  int accountCount = 0;
  List<Widget> accountCards = [];

  @override
  void initState() {
    super.initState();
    getLength();
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      color: Colors.grey[850],
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "  Your\n  Balance: ",
                style: TextStyle(
                    color: MyColor.greenLight,
                    fontSize: 20
                ),
              ),
              //SizedBox(width: 10),
              FutureBuilder<String>(
                future: balanceSum(),
                builder: (
                    BuildContext context,
                    AsyncSnapshot<String> snapshot
                    ) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data ?? "0.00",
                        style: TextStyle(
                          color: MyColor.greenLight,
                          fontSize: 50
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
              ),
              SizedBox(width: 80),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: accountCards,
          ),
        ],
      ),
    );
  }

  static const channel = MethodChannel("com.flutter.balance_card/MainActivity");

  addAccount({required String name, required double value}) {
    var arguments = <String, dynamic> {
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

  void getLength() async {
    accountCount = await channel.invokeMethod("getLength");
    _buildAccountCards();
  }

  List<Widget> _upList() {
    List<Widget> res = [];
    int index = 0;
    while (index < accountCount) {
      res.add(AccountCard(index: index));
      print("res: $res");
      index++;
    }
    return res;
  }

  void _buildAccountCards() {
    setState(() {
      accountCards = _upList();
    });
  }


}

class AccountCard extends StatefulWidget {
  static const channel = MethodChannel("com.flutter.balance_card/MainActivity");
  int index;


  AccountCard({super.key, required this.index});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {

  Future<String> name() async {
    String name = "";
    var arguments = <String, dynamic>{
      "index" : widget.index
    };
    name = await AccountCard.channel.invokeMethod("getName", arguments);
    return name;
  }

  Future<String> value() async {
    double value = 0.00;
    var arguments = <String, dynamic>{
      "index" : widget.index
    };
    value = await AccountCard.channel.invokeMethod("getValue", arguments);
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyColor.greenDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FutureBuilder<String>(
            future: name(),
            builder: (
                BuildContext context,
                AsyncSnapshot<String> snapshot
                ) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data ?? "null",
                  style: TextStyle(
                      color: MyColor.greenLight,
                      fontSize: 30
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          FutureBuilder<String>(
            future: value(),
            builder: (
                BuildContext context,
                AsyncSnapshot<String> snapshot
                ) {
              if (snapshot.hasData) {
                return  Text(
                  snapshot.data ?? "null",
                  style: TextStyle(
                      color: MyColor.greenLight,
                      fontSize: 30
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}