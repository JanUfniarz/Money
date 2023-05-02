import 'package:flutter/material.dart';
import 'package:money/palette.dart';

class EntryCard extends StatefulWidget {

  final String type;
  final String title;
  final double amount;
  final String category;
  final String accountName;
  final RestorableDateTime date;

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

class _EntryCardState extends State<EntryCard> with RestorationMixin {

  Color _entryColor(String type) {
    if (type == "Expense") return Palette.delete;
    if (type == "Income") return Palette.accent;
    return Palette.textField;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ItemBox(
          color: _entryColor(widget.type),
          child: Text(
            _amountToStr(widget.amount),
            style: TextStyle(
              color: widget.type == "Expense"
                  ? Palette.font : Palette.background,
            ),
          ),
        ),
        ItemBox(
          child: Text(
            _dateToString(widget.date),
          ),
        ),
        ItemBox(
          color: Palette.accent,
          child: Text(widget.title),
        ),
        ItemBox(
          child: Text(
            widget.accountName,
            textAlign: TextAlign.center,
          ),
        ),
        ItemBox(
          color: Palette.accent,
          child: Text(
            widget.category,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

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

  String _dateToString(RestorableDateTime date) {
    String res = date.value.toString();
    res = res.substring(0, res.length - 13);
    return res.replaceAll("-", ".");
  }

  @override
  String? get restorationId => "main";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(widget.date, 'date');
  }
}

class ItemBox extends StatefulWidget {

  final Widget? child;
  final Color? color;
  final double? width;

  const ItemBox({Key? key, this.child, this.color, this.width}) : super(key: key);

  @override
  State<ItemBox> createState() => _ItemBoxState();
}

class _ItemBoxState extends State<ItemBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: SizedBox(
        height: 30,
        width: widget.width ?? 70,
        child: Container(
          color: widget.color ?? Palette.main2,
          child: Center(
            child: widget.child ?? const SizedBox(),
          ),
        ),
      ),
    );
  }
}

