import 'package:flutter/material.dart';
import 'package:money/nav_director.dart';
import 'package:money/views/all_entries.dart';
import 'package:money/widgets/entry_card.dart';

import '../invoker.dart';
import '../palette.dart';
import '../widgets/graph_linear.dart';
import '../widgets/my_scaffold.dart';
import 'home.dart';

class AllAccounts extends StatefulWidget {
  const AllAccounts({Key? key}) : super(key: key);

  @override
  State<AllAccounts> createState() => _AllAccountsState();
}

class _AllAccountsState extends State<AllAccounts> {
  List<BigAccountCard> cards = [];

  @override
  void initState() {
    _loadData().then((data) {
      setState(() {
        cards = data;
      });
    });
    super.initState();
  }

  Future<List<BigAccountCard>> _loadData() async {
    List<BigAccountCard> data = [];

    int length = await Invoker.length();

    for (int it = 0; it < length; it++) {
      String name = await Invoker.name(it);
      data.add(BigAccountCard(name: name));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {

    if (this.cards.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    List<Widget> cards = [];
    int index = 0;
    for (BigAccountCard card in this.cards) {
      cards.add(GestureDetector(
        onTap: () async {
          double value = await Invoker.value(name: card.name);

          await NavDirector.pushAccountView(
            context,
            name: card.name,
            value: value,
            index: index,
          );
          NavDirector.goAllAccounts(context);
        },
        child: card,
      ));
      index++;
    }

    cards.add(GestureDetector(
      //? behavior: HitTestBehavior.opaque,
      onTap: () async {
        Map<String, dynamic> result = await NavDirector.pushAddAccount(context);
        Invoker.addAccount(result["name"], result["value"]);
        _loadData().then((data) {
          setState(() {
            cards = data;
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Palette.main2,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Card(
              color: Palette.background,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Palette.accent,
                    size: 100,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));

    return MyScaffold(
      picked: 1,
      title: "All Accounts",
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return cards[index];
        },
      ),
    );
  }
}

class BigAccountCard extends StatefulWidget {

  final String name;

  const BigAccountCard({required this.name, Key? key}) : super(key: key);

  @override
  State<BigAccountCard> createState() => _BigAccountCardState();
}

class _BigAccountCardState extends State<BigAccountCard> {

  Map<String, dynamic> dataMap = {};

  @override
  void initState() {
    super.initState();
    _loadData().then((data) {
      setState(() {
        dataMap = data;
      });
    });
  }

  Future<Map<String, dynamic>> _loadData() async {
    Map<String, dynamic> data = {};

    String name = widget.name;
    double value = await Invoker.value(name: name);

    int index = await Invoker.lastEntryIndex(name);
    
    data.addAll({
      "name" : name,
      "value" : value,
    });

    if (index < 0) return data;

    String type = await Invoker.entryType(index);
    String title = await Invoker.entryTitle(index);
    double amount = await Invoker.entryAmount(index);
    String category = await Invoker.entryCategory(index);
    String accountName = await Invoker.entryAccountName(index);
    String date = await Invoker.entryDate(index);
    String account2Name = await Invoker.entryAccount2Name(index);

    date = date.replaceAll("-", ".");
    if (account2Name != "#") accountName = "$accountName -> $account2Name";

    data.addAll({
      "type" : type,
      "title" : title,
      "amount" : amount,
      "category" : category,
      "accountName" : accountName,
      "date" : date,
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {

    if (dataMap.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (dataMap.length <= 2) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Palette.main2,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Card(
              color: Palette.background,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 const SizedBox(height: 10),
                  Text(
                    dataMap["name"],
                    style: TextStyle(
                      color: Palette.font,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dataMap["value"].toString(),
                    style: TextStyle(
                      color: Palette.accent,
                      fontSize: 50,
                    ),
                  ),
                  const MyDivider(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Palette.main2,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Card(
            color: Palette.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                Text(
                  dataMap["name"],
                  style: TextStyle(
                    color: Palette.font,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  dataMap["value"].toString(),
                  style: TextStyle(
                    color: Palette.accent,
                    fontSize: 50,
                  ),
                ),
                const MyDivider(),
                IgnorePointer(
                  child: LinearGraph(account: dataMap["name"])
                ),
                Text(
                  "Last Entry",
                  style: TextStyle(
                    color: Palette.font,
                    fontSize: 20,
                  ),
                ),
                DateBar(date: dataMap["date"]),
                EntryCard(
                  type: dataMap["type"],
                  title: dataMap["title"],
                  amount: dataMap["amount"],
                  category: dataMap["category"],
                  accountName: dataMap["accountName"],
                  date: dataMap["date"],
                  index: -1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}