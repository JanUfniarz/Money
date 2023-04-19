import 'package:flutter/material.dart';
import 'package:money/palette.dart';

class EntryCard extends StatefulWidget {

  final String type;
  final String title;
  final double amount;
  final String category;
  final String accountName;
  final RestorableDateTime date;

  const EntryCard({Key? key,
    required this.type,
    required this.title,
    required this.amount,
    required this.category,
    required this.accountName,
    required this.date,
  }) : super(key: key);

  @override
  State<EntryCard> createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard> with RestorationMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ItemBox(
          color: widget.type == "Expense"
              ? Palette.delete : Palette.accent,
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
    String res = widget.type == "Expense"
        ? "-" : "+";
    String amountStr = amount.toString();
    return res + amountStr;
  }

  String _dateToString(RestorableDateTime date) {
    String res = date.value.toString();
    res = res.substring(0, res.length - 16);
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

