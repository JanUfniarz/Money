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
      shadowColor: Colors.transparent,
      color: MyColor.background,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "  Your\n  Balance: ",
                style: TextStyle(
                    color: MyColor.font,
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
                          color: MyColor.accent,
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: accountCards,
            ),
          ),
        ],
      ),
    );
  }

  static const channel = MethodChannel(
      "com.flutter.balance_card/MainActivity"
  );

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
      index++;
    }
    res.add(
        GestureDetector(
          onTap: () async {
            dynamic result = await Navigator
                .pushNamed(context, "/add_account");
            Map<String, dynamic> arguments = result;
            channel.invokeMethod("addAccount", arguments);
            getLength();
          },
          child: SizedBox(
            width: 150,
            height: 80,
            child: Card(
              color: MyColor.main,
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 60,
                  color: MyColor.accent,
                ),
              ),
            ),
          ),
        )
    );
    return res;
  }

  void _buildAccountCards() {
    setState(() {
      accountCards = _upList();
    });
  }
}

class AccountCard extends StatefulWidget {
  static const channel = MethodChannel(
      "com.flutter.balance_card/MainActivity"
  );
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
    return GestureDetector(
      onTap: () async {
        var arguments = <String, dynamic>{
          "name" : await name(),
          "value" : double.parse(await value()),
        };
        await Navigator.pushNamed(
          context,
          "/account_view",
          arguments: arguments,
        );
      },
      child: SizedBox(
        width: 150,
        height: 80,
        child: Card(
          color: MyColor.main,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                          color: MyColor.font,
                          fontSize: 20
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                width: 100,
                child: Divider(
                  thickness: 2,
                  color: MyColor.accent,
                ),
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
                          color: MyColor.font,
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
        ),
      ),
    );
  }
}