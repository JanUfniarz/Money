import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:money/palette.dart';

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
      bottomNavigationBar: MyNavigationBar(
        picked: widget.picked,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const MyFAB(),
      body: widget.body,
    );
  }
}


class MyFAB extends StatefulWidget {
  const MyFAB({Key? key}) : super(key: key);

  @override
  State<MyFAB> createState() => _MyFABState();
}

class _MyFABState extends State<MyFAB> {
  late ValueNotifier<bool> _isOpen;

  static const channel = MethodChannel(
      "com.flutter.balance_card/MainActivity"
  );

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
    int accountCount =
    await channel.invokeMethod("getLength");

    if (((type == "Expense" || type == "Income") && accountCount > 0)
        || ((type == "Transfer") && accountCount > 1)) {
      await Navigator.pushNamed(
        context,
        "/add_entry",
        arguments: type,
      );
      Navigator.pushReplacementNamed(
        context,
        (ModalRoute.of(context)?.settings)?.name ?? ""
      );
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
      children: [
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
      ],
      onOpen: () => _isOpen.value = true,
      onClose: () => _isOpen.value = false,
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  final int picked;

  const MyNavigationBar({Key? key, required this.picked}) : super(key: key);

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
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
              String route = "";

              switch (index) {
                case 0: route = "/home"; break;
                case 1: route = "/all_accounts"; break;
                case 2: route = "/all_entries"; break;
                case 3: /* TODO connect budgets route */ break;
              }

              Navigator.pushNamedAndRemoveUntil(
                context,
                route,
                    (Route<dynamic> route) => false,
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: (index == _icons.length ~/ 2 - 1)
                    || (index == _icons.length ~/ 2) ? 15 : 0,
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