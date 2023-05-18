import 'package:flutter/material.dart';
import 'package:money/palette.dart';


class NewEntryCard extends StatefulWidget {

  final String type;
  final String title;
  final double amount;
  final String category;
  final String accountName;
  final String date;

  const NewEntryCard({Key? key,
    required this.type,
    required this.title,
    required this.amount,
    required this.category,
    required this.accountName,
    required this.date,
  }) : super(key: key);

  @override
  State<NewEntryCard> createState() => _NewEntryCardState();
}

class _NewEntryCardState extends State<NewEntryCard> {

  String _amountToStr(double amount) {
    String res;
    if (widget.type == "Expense") {
      res = "-";
    } else if (widget.type == "Income") {
      res = "+";
    } else {
      res = "";
    }
    String amountStr = amount.toString();
    return res + amountStr;
  }

  Color _entryColor(String type) {
    if (type == "Expense") return Palette.expense;
    if (type == "Income") return Palette.accent;
    return Palette.textField;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _entryColor(widget.type),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Palette.background,
                    fontSize: 20,
                  ),
                ),
                Text(
                  _amountToStr(widget.amount),
                  style: TextStyle(
                    color: Palette.main,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  widget.accountName,
                  style: TextStyle(
                    color: Palette.background,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.category,
                  style: TextStyle(
                    color: Palette.main,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Adapter class
class EntryCard extends StatefulWidget {

  final String type;
  final String title;
  final double amount;
  final String category;
  final String accountName;
  final String date;

  final int index;

  const EntryCard({Key? key,
    required this.type,
    required this.title,
    required this.amount,
    required this.category,
    required this.accountName,
    required this.date,
    required this.index,
  }) : super(key: key);

  @override
  State<EntryCard> createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard> {

  @override
  Widget build(BuildContext context) {
    return NewEntryCard(
      type: widget.type,
      title: widget.title,
      amount: widget.amount,
      category: widget.category,
      accountName: widget.accountName,
      date: widget.date
    );
  }
}