import 'package:flutter/material.dart';

import '../invoker.dart';
import '../nav_director.dart';
import '../palette.dart';


class BudgetCard extends StatefulWidget {

  final int index;

  const BudgetCard({Key? key, required this.index}) : super(key: key);

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {

  _BaseBudgetCard? card;

  bool pinned = false;

  @override
  void initState() {
    _loadData().then((data) =>
      setState(() => card = data));

    _loadPinned().then((data) =>
        setState(() => pinned = data));

    super.initState();
  }

  Future<_BaseBudgetCard> _loadData() async =>
    _BaseBudgetCard(
      tittle: await Invoker.budgetTittle(widget.index),
      category: await Invoker.budgetCategory(widget.index),
      budgetAmount: await Invoker.budgetAmount(widget.index),
      actualAmount: await Invoker.budgetActualAmount(widget.index),
      date: await Invoker.budgetDate(widget.index),
      pinned: await Invoker.pinned(widget.index),
      index: widget.index,
    );

  Future<bool> _loadPinned() async => await Invoker.pinned(widget.index);

  @override
  Widget build(BuildContext context) =>
      card ?? const Center(
        child: CircularProgressIndicator(),
      );
}

class _BaseBudgetCard extends StatefulWidget {

  final String tittle;
  final String category;
  final double budgetAmount;
  final double actualAmount;
  final String date;
  final bool pinned;
  final int index;

  const _BaseBudgetCard({Key? key,
    required this.tittle,
    required this.category,
    required this.budgetAmount,
    required this.actualAmount,
    required this.date,
    required this.pinned,
    required this.index,
  }) : super(key: key);

  @override
  State<_BaseBudgetCard> createState() => _BaseBudgetCardState();
}

class _BaseBudgetCardState extends State<_BaseBudgetCard> {

  List<String> _list = [];

  @override
  Widget build(BuildContext context) {

    _list = [
      "You have left:", "To be used until:",
      widget.actualAmount.toString(), widget.date,
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Palette.accent,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Card(
            color: Palette.background,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Invoker.pin(widget.index);
                        NavDirector.goHere(context);
                      },
                      child: Icon(
                        Icons.pin_end,
                        size: 40,
                        color: widget.pinned ? Palette.accent : Palette.font,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        widget.tittle,
                        style: TextStyle(
                          color: Palette.font,
                          fontSize: 35
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Invoker.deleteBudget(widget.index);
                        NavDirector.goHere(context);
                      },
                      child: Icon(
                        Icons.delete,
                        size: 40,
                        color: Palette.delete,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.category,
                  style: TextStyle(
                    color: Palette.main2,
                    fontSize: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: Divider(
                    color: Palette.main2,
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(2, (index) =>
                      Column(
                        children: <Widget>[
                          Text(
                            _list[index],
                            style: TextStyle(
                              color: Palette.accent,
                              fontSize: 17
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _list[index + 2],
                            style: TextStyle(
                                color: Palette.font,
                                fontSize: 30
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: SizedBox(
                      width: 260,
                      height: 30,
                      child: LinearProgressIndicator(
                        value: widget.actualAmount / widget.budgetAmount,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(Palette.main),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}