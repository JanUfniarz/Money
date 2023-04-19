import 'package:flutter/material.dart';
import 'package:money/palette.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key, this.restorationId, required this.selectedDate});

  final String? restorationId;
  final RestorableDateTime selectedDate;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

/// RestorationProperty objects can be used because of RestorationMixin.
class _DatePickerState extends State<DatePicker>
    with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;

  //? final RestorableDateTime _selectedDate =
  //?   RestorableDateTime(DateTime(2021, 7, 25));

  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
    RestorableRouteFuture<DateTime?>(
      onComplete: _selectDate,
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(
          _datePickerRoute,
          arguments: widget.selectedDate.value.millisecondsSinceEpoch,
        );
      },
    );

  static Route<DateTime> _datePickerRoute(
      BuildContext context,
      Object? arguments,
      ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            // Customize the theme here
            colorScheme: const ColorScheme.light().copyWith(
              // Example: Change the color of the header text
              primary: Palette.main,
              // Example: Change the color of the selected day
              onPrimary: Palette.accent,
            ),
          ),
          child: DatePickerDialog(
            restorationId: 'date_picker_dialog',
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
            firstDate: DateTime(2021),
            lastDate: DateTime.now(),
          ),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(widget.selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        widget.selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${widget.selectedDate.value.day}'
                  '/${widget.selectedDate.value.month}'
                  '/${widget.selectedDate.value.year}'
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _restorableDatePickerRouteFuture.present();
        setState(() {

        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) =>
            states.contains(MaterialState.disabled) ? Colors.grey : Palette.main),
      ),
      child: Text(
        '${widget.selectedDate.value.day}'
          '/${widget.selectedDate.value.month}'
          '/${widget.selectedDate.value.year}',
        style: TextStyle(
          color: Palette.accent,
        ),
      ),
    );
  }
}