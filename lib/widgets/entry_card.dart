import 'package:flutter/material.dart';
import 'package:money/palette.dart';


class NewEntryCard extends StatefulWidget {

  final String type;
  final String title;
  final double amount;
  final String category;
  final String accountName;
  final RestorableDateTime date;

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
                    color: widget.type == "Expense"
                        ? Palette.font : Palette.background,
                    fontSize: 20,
                  ),
                ),
                Text(
                  _amountToStr(widget.amount),
                  style: TextStyle(
                    color: widget.type == "Expense"
                        ? Palette.main2 : Palette.main,
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
                    color: widget.type == "Expense"
                        ? Palette.font : Palette.background,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.category,
                  style: TextStyle(
                    color: widget.type == "Expense"
                        ? Palette.main2 : Palette.main,
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

class _EntryCardState extends State<EntryCard> /*?with RestorationMixin*/ {

  //? Color _entryColor(String type) {
  //   if (type == "Expense") return Palette.delete;
  //   if (type == "Income") return Palette.accent;
  //   return Palette.textField;
  //? }

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
    //? return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: <Widget>[
    //     ItemBox(
    //       color: _entryColor(widget.type),
    //       child: Text(
    //         _amountToStr(widget.amount),
    //         style: TextStyle(
    //           color: widget.type == "Expense"
    //6               ? Palette.font : Palette.background,
    //         ),
    //       ),
    //     ),
    //     ItemBox(
    //       child: Text(
    //         _dateToString(widget.date),
    //       ),
    //     ),
    //     ItemBox(
    //       color: Palette.accent,
    //       child: Text(widget.title),
    //     ),
    //     ItemBox(
    //       child: Text(
    //         widget.accountName,
    //         textAlign: TextAlign.center,
    //       ),
    //     ),
    //     ItemBox(
    //       color: Palette.accent,
    //       child: Text(
    //         widget.category,
    //         textAlign: TextAlign.center,
    //       ),
    //     ),
    //   ],
    //? );
  }

  //? String _amountToStr(double amount) {
  //   String res;
  //   if (widget.type == "Expense") {
  //     res = "-";
  //   } else if (widget.type == "Income") {
  //     res = "+";
  //   } else {
  //     res = "";
  //   }
  //   String amountStr = amount.toString();
  //   return res + amountStr;
  //? }

  //? String _dateToString(RestorableDateTime date) {
  //   String res = date.value.toString();
  //   res = res.substring(0, res.length - 13);
  //   return res.replaceAll("-", ".");
  // }
  //
  // @override
  // String? get restorationId => "main";
  //
  // @override
  // void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
  //   registerForRestoration(widget.date, 'date');
  //? }
}

//? class ItemBox extends StatefulWidget {
//
//   final Widget? child;
//   final Color? color;
//   final double? width;
//
//   const ItemBox({Key? key, this.child, this.color, this.width}) : super(key: key);
//
//   @override
//   State<ItemBox> createState() => _ItemBoxState();
// }
//
// class _ItemBoxState extends State<ItemBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(1),
//       child: SizedBox(
//         height: 30,
//         width: widget.width ?? 70,
//         child: Container(
//           color: widget.color ?? Palette.main2,
//           child: Center(
//             child: widget.child ?? const SizedBox(),
//           ),
//         ),
//       ),
//     );
//   }
//? }