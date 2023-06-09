import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:money/palette.dart';
import 'package:money/views/all_accounts.dart';
import 'package:money/views/all_entries.dart';

import '../invoker.dart';
import '../nav_director.dart';
import '../views/budgets.dart';
import '../views/home.dart';

class MyScaffold extends StatefulWidget {

  final String? title;
  final int? picked;
  final Widget? body;

  const MyScaffold({Key? key, this.title, this.picked, this.body})
      : super(key: key);

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {

  int? picked;

  Widget _body(int picked) {
    switch (picked) {
      case 0: return const Home();
      case 1: return const AllAccounts();
      case 2: return const AllEntries();
      case 3: return const Budgets();
      default: return const Center(
        child: Text("Invalid picked value!"),
      );
    }
  }

  String _title(int picked) {
    switch (picked) {
      case 0: return "Money";
      case 1: return "All Accounts";
      case 2: return "All Entries";
      case 3: return "All budgets";
      default: return "Invalid picked value!";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.picked == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Palette.background,
        appBar: AppBar(
          backgroundColor: Palette.main,
          title: Text(
            widget.title ?? "Money",
            style: TextStyle(
              color: Palette.font,
            ),
          ),
          centerTitle: true,
        ),
        body: widget.body,
      );
    } else {
      picked ??= widget.picked;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Palette.background,
        appBar: AppBar(
          backgroundColor: Palette.main,
          title: Text(
            _title(picked!),
            style: TextStyle(
              color: Palette.font,
            ),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: _MyNavigationBar(
          onClick: (index) => setState(() => picked = index),
          picked: picked!,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _MyFAB(picked: picked!),
        body: _body(picked!),
      );
    }
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
          await NavDirector.pushAddEntry(context, type: type);
          NavDirector.goHere(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Add an account first"),
          ));
        }
        break;

      case "Transfer" :
        if (accountCount > 1) {
          await NavDirector.pushAddEntry(context, type: type);
          NavDirector.goHere(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Add an account first"),
          ));
        }
        break;

      case "Account" :
        Map<String, dynamic> result = await NavDirector.pushAddAccount(context);
        Invoker.addAccount(result["name"], result["value"]);
        NavDirector.goHere(context);
        break;

      case "Periodic" :
      case "One Time" :
        await NavDirector.pushAddBudget(context, periodic: (type == "Periodic"));
        NavDirector.goHere(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

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
              Icons.refresh,
              color: Palette.background,
            ),
            label: "Periodic",
            backgroundColor: Palette.accent,
            onTap: () => _onTap("Periodic"),
          ),
          SpeedDialChild(
            child: Icon(
              Icons.redo,
              color: Palette.background,
            ),
            label: "One Time",
            backgroundColor: Palette.accent,
            onTap: () => _onTap("One Time"),
          ),
        ];
        break;
    }

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
  final Function(int index) onClick;

  const _MyNavigationBar({Key? key,
    required this.picked,
    required this.onClick,
  }) : super(key: key);

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
            //? onTap: () {
            //   switch (index) {
            //     case 0: NavDirector.goHome(context); break;
            //     case 1: NavDirector.goAllAccounts(context); break;
            //     case 2: NavDirector.goAllEntries(context); break;
            //     case 3: NavDirector.goBudgets(context); break;
            //   }
            //? },
            onTap: () => widget.onClick(index),
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