import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:money/palette.dart';

import '../invoker.dart';
import '../nav_director.dart';

class MyScaffold extends StatefulWidget {

  final String title;
  final int picked;
  final Widget body;

  const MyScaffold({Key? key, title, picked, required this.body})
      : title = title ?? "Money",
        picked = picked ?? 0,
        super(key: key);

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.main,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Palette.font,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: _MyNavigationBar(
        picked: widget.picked,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _MyFAB(picked: widget.picked),
      body: widget.body,
    );
  }
}


class _MyFAB extends StatefulWidget {

  final int picked;

  const _MyFAB({required this.picked, Key? key}) : super(key: key);

  @override
  State<_MyFAB> createState() => _MyFABState();
}

class _MyFABState extends State<_MyFAB> {
  late ValueNotifier<bool> _isOpen;

  List<SpeedDialChild> speedDialChildren = [];

  @override
  void initState() {
    _isOpen = ValueNotifier<bool>(false);

    switch (widget.picked) {

      case 0 :
      case 2 :
        speedDialChildren = [
          SpeedDialChild(
            child: Icon(
              Icons.arrow_right_alt_outlined,
              color: Palette.background,
            ),
            label: "Transfer",
            backgroundColor: Palette.accent,
            onTap: () => _onTap("Transfer"),
          ),
          SpeedDialChild(
            child: Icon(
              Icons.trending_down,
              color: Palette.background,
            ),
            label: "Expense",
            backgroundColor: Palette.accent,
            onTap: () => _onTap("Expense"),
          ),
          SpeedDialChild(
            child: Icon(
              Icons.trending_up,
              color: Palette.background,
            ),
            label: "Income",
            backgroundColor: Palette.accent,
            onTap: () => _onTap("Income"),
          ),
        ];
        break;

      case 1 :
        speedDialChildren = [
          SpeedDialChild(
            child: Icon(
              Icons.account_balance,
              color: Palette.background,
            ),
            label: "Account",
            backgroundColor: Palette.accent,
            onTap: () => _onTap("Account"),
          ),
        ];
        break;

      case 3 :
        speedDialChildren = [
          SpeedDialChild(
            child: Icon(
              Icons.savings,
              color: Palette.background,
            ),
            label: "Budget",
            backgroundColor: Palette.accent,
            onTap: () => _onTap("Budget"),
          ),
        ];
        break;
    }

    super.initState();
  }

  @override
  void dispose() {
    _isOpen.dispose();
    super.dispose();
  }

  void _onTap(String type) async {
    int accountCount = await Invoker.length();

    switch (type) {

      case "Expense" :
      case "Income" :
        if (accountCount > 0) {
          await NavDirector.pushAddEntry(context, arguments: type);
          NavDirector.goHere(context);
        }
        break;

      case "Transfer" :
        if (accountCount > 1) {
          await NavDirector.pushAddEntry(context, arguments: type);
          NavDirector.goHere(context);
        }
        break;

      case "Account" :
        Map<String, dynamic> result = await NavDirector.pushAddAccount(context);
        Invoker.addAccount(result["name"], result["value"]);
        NavDirector.goHere(context);
        break;

      case "Budget" :
        // TODO IMPLEMENT
        break;
    }

    if (((type == "Expense" || type == "Income") && accountCount > 0)
        || ((type == "Transfer") && accountCount > 1)) {
      await NavDirector.pushAddEntry(context, arguments: type);
      NavDirector.goHere(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Add an account first"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Palette.accent,
      foregroundColor: Palette.background,
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 30,
      openCloseDial: _isOpen,
      overlayColor: Colors.transparent,
      children: speedDialChildren,
      onOpen: () => _isOpen.value = true,
      onClose: () => _isOpen.value = false,
    );
  }
}

class _MyNavigationBar extends StatefulWidget {
  final int picked;

  const _MyNavigationBar({Key? key, required this.picked}) : super(key: key);

  @override
  State<_MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<_MyNavigationBar> {
  final double FAB_SPACE = 30;

  final List<IconData> _icons = [
    Icons.home,
    Icons.account_balance,
    Icons.exposure,
    Icons.savings,
  ];

  final List<String> _labels = [
    "Home",
    "Accounts",
    "Entries",
    "Budgets",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.main,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _icons.length,
              (index) => InkWell(
            onTap: () {
              switch (index) {
                case 0: NavDirector.goHome(context); break;
                case 1: NavDirector.goAllAccounts(context); break;
                case 2: NavDirector.goAllEntries(context); break;
                case 3: NavDirector.goBudgets(context); break;
              }
            },
            child: Padding(
              padding: EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: (index == _icons.length ~/ 2) ? (FAB_SPACE / 2) : 0,
                right: (index == _icons.length ~/ 2 - 1) ? (FAB_SPACE / 2) : 0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icons[index],
                    color: index == widget.picked
                        ? Palette.main2
                        : Palette.font,
                  ),
                  Text(
                    _labels[index],
                    style: TextStyle(
                      color: index == widget.picked
                          ? Palette.main2
                          : Palette.font,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}