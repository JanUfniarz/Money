import 'package:flutter/material.dart';
import 'package:money/palette.dart';

class EntryCard extends StatefulWidget {

  String type;
  String tittle;
  double amount;
  String category;
  String accountName;
  RestorableDateTime date;

  EntryCard({Key? key,
    required this.type,
    required this.tittle,
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

    print(_dateToString(widget.date));

    return Card(
      color: Palette.background,
      child: Row(
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
            child: Text(widget.tittle),
          ),
          ItemBox(
            child: Text(widget.accountName),
          ),
          ItemBox(
            color: Palette.accent,
            child: Text(
              widget.category,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _amountToStr(double amount) {
    String res = widget.type == "Expense"
        ? "-" : "";
    String amountStr = amount.toString();
    return res + amountStr;
  }

  String _dateToString(RestorableDateTime date) {
    String res = date.value.toString();
    res = res.substring(0, res.length - 16);
    //? res = res.replaceAll(" 00:00:00.000", "");
    return res.replaceAll("-", ".");
  }

  @override
  // TODO: implement restorationId
  String? get restorationId => "main";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // TODO: implement restoreState
    registerForRestoration(widget.date, 'date');
    //? registerForRestoration(
    //?     _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }
}

class ItemBox extends StatefulWidget {

  Widget? child;
  Color? color;
  double? width;

  ItemBox({Key? key, this.child, this.color, this.width}) : super(key: key);

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
            child: widget.child ?? SizedBox(),
          ),
        ),
      ),
    );
  }
}

