import 'package:flutter/material.dart';
import 'package:money/nav_director.dart';
import 'package:money/palette.dart';

import '../invoker.dart';

class BalanceCard extends StatefulWidget {

  @override
  State<BalanceCard> createState() => _BalanceCardState();
  const BalanceCard({super.key});
}

class _BalanceCardState extends State<BalanceCard> {

  int accountCount = 0;
  List<Widget> accountCards = [];

  @override
  void initState() {
    super.initState();
    getLength();
  }

  Future<String> balanceSum() async {
    String res = "0.00";
    try {
      res = await Invoker.balanceSum();
    } catch (e) {
      print(e);
    }
    return res;
  }

  void getLength() async {
    accountCount = await Invoker.length();
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
            Map<String, dynamic> result = await NavDirector.pushAddAccount(context);
            Invoker.addAccount(result["name"], result["value"]);
            getLength();
          },
          child: SizedBox(
            width: 150,
            height: 80,
            child: Card(
              color: Palette.main,
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 60,
                  color: Palette.accent,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color: Palette.background,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "  Your\n  Balance: ",
                style: TextStyle(
                    color: Palette.font,
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
                          color: Palette.accent,
                          fontSize: 70
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
              ),
              const SizedBox(width: 60),
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
}

class AccountCard extends StatefulWidget {
  final int index;

  const AccountCard({super.key, required this.index});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {

  Future<String> name() async {
    String name = await Invoker.name(widget.index);
    return name;
  }

  Future<String> value() async {
    double value = await Invoker.value(index: widget.index);
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await NavDirector.pushAccountView(
          context,
          name: await name(),
          value: double.parse(await value()),
          index: widget.index,
        );
        NavDirector.goHere(context);
      },
      child: SizedBox(
        width: 150,
        height: 80,
        child: Card(
          color: Palette.main,
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
                          color: Palette.font,
                          fontSize: 20
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                width: 100,
                child: Divider(
                  thickness: 2,
                  color: Palette.accent,
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
                          color: Palette.font,
                          fontSize: 30
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
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