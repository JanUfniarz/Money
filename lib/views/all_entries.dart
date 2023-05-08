import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    "Workers exploitation",
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

    if (ModalRoute.of(context)!.settings.arguments != null) {
      final arguments = ModalRoute.of(context)!
          .settings.arguments as Map<String, dynamic>;

      superFilter = arguments["filter"];
      superFilterKey = arguments["filterKey"];
    }

    List<DropdownMenuItem<dynamic>> categoriesDMI = _dmi(categories);
    List<DropdownMenuItem<dynamic>> typesDMI = _dmi(types);

    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.main,
        centerTitle: true,
        title: Text("All ${superFilterKey ?? ""} Entries"),
      ),
      body: SingleChildScrollView(
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
                                                    Navigator.pop(context);
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
                                        ),
                                      );
                                    }
                                  );
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
                                                      Navigator.pop(context);
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
                                          ),
                                        );
                                      }
                                  );
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

  static const channel = MethodChannel(
      "com.flutter.balance_card/MainActivity"
  );

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    int count = await channel.invokeMethod("getLengthOfEntries");
    final cards = <EntryCard>[];

    //? int numberOfEntries = widget.numberOfEntries;
    //? if (numberOfEntries == -1) numberOfEntries = count;

    for (
    int index = 0;
    index < count; //?&& index < numberOfEntries;
    index++) {
      Map<String, dynamic> arguments = {"index": index};
      String type = await channel
          .invokeMethod("getEntryType", arguments);
      String title = await channel
          .invokeMethod("getEntryTitle", arguments);
      double amount = await channel
          .invokeMethod("getEntryAmount", arguments);
      String category = await channel
          .invokeMethod("getEntryCategory", arguments);
      String accountName = await channel
          .invokeMethod("getEntryAccountName", arguments);
      String date = await channel
          .invokeMethod("getEntryDate", arguments);
      int indexInMA = index;
      String account2Name = await channel
          .invokeMethod("getEntryAccount2Name", arguments);

      if (account2Name != "#") accountName = "$accountName -> $account2Name";

      cards.add(EntryCard(
        type: type,
        title: title,
        amount: amount,
        category: category,
        accountName: accountName,
        date: _convertStringToDate(date),
        index: indexInMA,
      ));
    }
    setState(() => entryCards = cards);
  }
  @override
  Widget build(BuildContext context) {

    List<EntryCard> cards = entryCards;
    List<Widget> finalCards = [];

    List<Widget> labelRow = [Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const <Widget>[
        LabelBox(label: "Amount"),
        LabelBox(label: "Date"),
        LabelBox(label: "Title"),
        LabelBox(label: "Account"),
        LabelBox(label: "Category"),
      ],
    )];

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
              (a, b) => b.date.value.compareTo(a.date.value)
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

    List<Widget> filteredCards = [];
    int index = 0;
    for (EntryCard card in cards) {
      if (index < widget.numberOfEntries) {
        int indexSave = index;
        filteredCards.add(GestureDetector(
          onTap: () {
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
                                      var argumentsToJava = <String, dynamic>{
                                        "index": card.index,
                                      };

                                      channel.invokeMethod(
                                          "deleteEntry",
                                          argumentsToJava
                                      );

                                      Navigator.pop(context);

                                      //! Can not work with filters
                                      setState(() {
                                        entryCards.removeAt(indexSave);
                                      });
                                      //! ============
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
                                    onPressed: () => Navigator.pop(context),
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
          child: card,
        ));
      }
      index++;
    }

    finalCards = labelRow + filteredCards;

    return Card(
        color: Palette.background,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: finalCards,
        ),
    );
  }

  RestorableDateTime _convertStringToDate(String dateString) {
    // Split the date string by "-" to get year, month, and day
    List<String> dateParts = dateString.split("-");

    // Extract year, month, and day from dateParts
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Create a RestorableDateTime object with the parsed year, month, and day
    RestorableDateTime restorableDateTime = RestorableDateTime(
        DateTime(year, month, day)
    );

    return restorableDateTime;
  }
}

class LabelBox extends StatelessWidget {
  const LabelBox({
    super.key, required this.label
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return ItemBox(
      color: Palette.main,
      child: Text(
        label,
        style: TextStyle(
            color: Palette.accent
        ),
      ),
    );
  }
}