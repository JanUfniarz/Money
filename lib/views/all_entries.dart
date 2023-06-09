import 'package:flutter/material.dart';
import 'package:money/nav_director.dart';

import '../invoker.dart';
import '../palette.dart';
import '../widgets/entry_card.dart';

class AllEntries extends StatefulWidget {
  const AllEntries({Key? key}) : super(key: key);

  @override
  State<AllEntries> createState() => _AllEntriesState();
}

class _AllEntriesState extends State<AllEntries> {

  int filter = 0;
  String filterKey = "";

  int? superFilter;
  String? superFilterKey;

  List<String> categories = [
    "Basic expenditure",
    "Enterprise",
    "Travelling",
    "House",
    "Health and beauty",
    "Transport",
    "Full time job",
    "Part time job",
    "Exploitation",
    "Passive income",
    "Other",
  ];

  List<String> types = [
    "Income",
    "Expense",
    "Transfer",
  ];

  List<DropdownMenuItem<dynamic>> _dmi(List<String> list) {
    return list.map((String item) {
      return DropdownMenuItem<dynamic>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    if (NavDirector.argumentsAreAvailable(context)) {
      superFilter = NavDirector.fromRoute(context)["filter"];
      superFilterKey = NavDirector.fromRoute(context)["filterKey"];
    }

    List<DropdownMenuItem<dynamic>> categoriesDMI = _dmi(categories);
    List<DropdownMenuItem<dynamic>> typesDMI = _dmi(types);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Sort by",
                      style: TextStyle(
                        color: Palette.main2,
                        fontSize: 30
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                          width: 70,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.accent,
                            ),
                            onPressed: () => setState(() => filter = 1),
                            child: Text(
                              "Amount",
                              style: TextStyle(
                                fontSize: 10,
                                color: Palette.background,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 30,
                          width: 70,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.accent,
                            ),
                            onPressed: () => setState(() => filter = 2),
                            child: Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 10,
                                color: Palette.background,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: VerticalDivider(
                  thickness: 2,
                  color: Palette.main2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Filter by",
                      style: TextStyle(
                          color: Palette.main2,
                          fontSize: 30
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                          width: 70,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.accent,
                            ),
                            onPressed: () {
                              if (filterKey == "") { //! temporary
                                NavDirector.bottomSheet(context, Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(height: 10),
                                      Text(
                                        "Filter by category",
                                        style: TextStyle(
                                          color: Palette.font,
                                          fontSize: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 10,
                                          bottom: 30,
                                        ),
                                        child: Divider(
                                          color: Palette.accent,
                                          thickness: 2,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: DropdownButton(
                                          dropdownColor: Palette.background,
                                          value: categoriesDMI.first.value,
                                          items: categoriesDMI,
                                          onChanged: (item) {
                                            setState(() {
                                              filter = 3;
                                              filterKey = item;
                                            });
                                            NavDirector.back(context);
                                          },
                                          isExpanded: true,
                                          style: TextStyle(
                                              color: Palette.textField,
                                              fontSize: 25
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                              }
                            },
                            child: Text(
                              "Category",
                              style: TextStyle(
                                fontSize: 10,
                                color: Palette.background,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 30,
                          width: 70,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.accent,
                            ),
                            onPressed: () {
                              if (filterKey == "") { //! temporary
                                NavDirector.bottomSheet(context, Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(height: 10),
                                      Text(
                                        "Filter by type",
                                        style: TextStyle(
                                          color: Palette.font,
                                          fontSize: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 10,
                                          bottom: 30,
                                        ),
                                        child: Divider(
                                          color: Palette.accent,
                                          thickness: 2,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: DropdownButton(
                                          dropdownColor: Palette.background,
                                          value: typesDMI.first.value,
                                          items: typesDMI,
                                          onChanged: (item) {
                                            setState(() {
                                              filter = 4;
                                              filterKey = item;
                                            });
                                            NavDirector.back(context);
                                          },
                                          isExpanded: true,
                                          style: TextStyle(
                                              color: Palette.textField,
                                              fontSize: 25
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                              }
                            },
                            child: Text(
                              "Type",
                              style: TextStyle(
                                fontSize: 10,
                                color: Palette.background,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          EntriesTable(
            filter: filter,
            filterKey: filterKey,
            superFilter: superFilter,
            superFilterKey: superFilterKey,
          ),
        ],
      ),
    );
  }
}

class EntriesTable extends StatefulWidget {

  final int numberOfEntries;
  final int filter;
  final String filterKey;
  final String superFilterKey;
  final int superFilter;

  const EntriesTable({Key? key,
    numberOfEntries,
    filter,
    filterKey,
    superFilter,
    superFilterKey})
      : numberOfEntries = numberOfEntries ?? -1,
        filter = filter ?? 0,
        filterKey = filterKey ?? "",
        superFilter = superFilter ??  0,
        superFilterKey = superFilterKey ?? "",
        super(key: key);


  @override
  State<EntriesTable> createState() => _EntriesTableState();
}

class _EntriesTableState extends State<EntriesTable> {

  List<EntryCard> entryCards = [];

  @override
  void initState() {
    _loadData().then((cards) {
      if (mounted) {
        setState(() {
        entryCards = cards;
      });
      }
    });
    super.initState();
  }

  Future<List<EntryCard>> _loadData() async {
    int count = await Invoker.lengthOfEntries();
    final cards = <EntryCard>[];

    for (
    int index = 0;
    index < count;
    index++) {
      String type = await Invoker.entryType(index);
      String title = await Invoker.entryTitle(index);
      double amount = await Invoker.entryAmount(index);
      String category = await Invoker.entryCategory(index);
      String accountName = await Invoker.entryAccountName(index);
      String date = await Invoker.entryDate(index);
      String account2Name = await Invoker.entryAccount2Name(index);

      int indexInMA = index;

      date = date.replaceAll("-", ".");

      if (account2Name != "#") accountName = "$accountName -> $account2Name";

      cards.add(EntryCard(
        type: type,
        title: title,
        amount: amount,
        category: category,
        accountName: accountName,
        date: date,
        index: indexInMA,
      ));
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {

    if (entryCards.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    List<EntryCard> cards = entryCards;
    List<Widget> finalCards = [];

    //* Super filers
    if (widget.superFilter == 5) {
      cards = cards.where(
              (card) => (card.accountName.contains("${widget.superFilterKey} ->")
                  || card.accountName.contains("-> ${widget.superFilterKey}"))
                  || card.accountName == widget.superFilterKey
      ).toList();
    }

    //* Filters
    if (widget.filter == 1) {
      cards.sort(
              (a, b) => b.amount.compareTo(a.amount)
      );
    }
    if (widget.filter == 2) {
      cards.sort(
              (a, b) => int.parse(b.date.replaceAll(".", ""))
                  .compareTo(int.parse(a.date.replaceAll(".", "")))
      );
    }
    if (widget.filter == 3) {
      cards = cards.where(
              (card) => card.category == widget.filterKey
      ).toList();
    }
    if (widget.filter == 4) {
      cards = cards.where(
              (card) => card.type == widget.filterKey
      ).toList();
    }
    if (widget.filter == 5) {
      cards = cards.where(
              (card) => (card.accountName.contains("${widget.filterKey} ->")
                  || card.accountName.contains("-> ${widget.filterKey}"))
                  || card.accountName == widget.filterKey
      ).toList();
    }

    List<_DateKeeper> filteredCards = [];
    int index = 0;
    for (EntryCard card in cards) {
      if (index < (widget.numberOfEntries == -1
          ? cards.length : widget.numberOfEntries)) {
        int indexSave = index;
        filteredCards.add(_DateKeeper(
          date: card.date,
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 4,
                child: card
              ),
              Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 69,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.delete,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Palette.main,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25),
                              ),
                            ),
                            builder: (context) {
                              return SizedBox(
                                height: 300,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(height: 10),
                                      Text(
                                        "Delete Entry ${card.title}",
                                        style: TextStyle(
                                          color: Palette.font,
                                          fontSize: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 10,
                                          bottom: 30,
                                        ),
                                        child: Divider(
                                          color: Palette.accent,
                                          thickness: 2,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 90,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Invoker.deleteEntry(card.index);

                                                  NavDirector.back(context);

                                                  setState(() {
                                                    entryCards.removeAt(indexSave);
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Palette.delete,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Delete",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Palette.font,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 90,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () => NavDirector.back(context),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Palette.accent,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Cancel",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Palette.background,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      },
                      child: const Icon(
                        Icons.delete
                      ),
                    ),
                  ),
              ),
            ],
          ),
        ));
      }
      index++;
    }

    for (int it = filteredCards.length - 1; it > 0; it--) {
      _DateKeeper card = filteredCards[it];
      if (card.date == filteredCards[it - 1].date) {
        finalCards.add(card);
      } else {
        finalCards.add(card);
        finalCards.add(DateBar(date: card.date));
      }
    }
    if (filteredCards.isNotEmpty){
      finalCards.add(filteredCards[0]);
      finalCards.add(DateBar(date: filteredCards[0].date));
    }

    finalCards = finalCards.reversed.toList();

    return Card(
        color: Palette.background,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: finalCards,
        ),
    );
  }
}

class _DateKeeper extends StatefulWidget  {

  final Widget child;
  final String date;

  const _DateKeeper({Key? key,
    required this.date,
    required this.child,
  }) : super(key: key);

  @override
  State<_DateKeeper> createState() => _DateKeeperState();
}

class _DateKeeperState extends State<_DateKeeper> {

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


class DateBar extends StatefulWidget {

  final String date;

  const DateBar({Key? key, required this.date}) : super(key: key);

  @override
  State<DateBar> createState() => _DateBarState();
}

class _DateBarState extends State<DateBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                color: Palette.main2,
                thickness: 2,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(
            child: Text(
              widget.date,
              style: TextStyle(
                color: Palette.main2,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                color: Palette.main2,
                thickness: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}