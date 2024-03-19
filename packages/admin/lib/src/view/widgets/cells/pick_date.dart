import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/view/widgets/cells/text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DatePickerButton extends StatefulWidget {
  const DatePickerButton({
    super.key,
    required this.cell,
    required this.onChanged,
  });

  final Cell cell;
  final Function(DateTime) onChanged;

  @override
  State<DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  late DateTime selectedValue = widget.cell.newValue as DateTime;
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.cell.formattedNewValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          locale: const Locale('en'),
        ).then((date) {
          if (date != null) {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(selectedValue),
            ).then((time) {
              if (time != null) {
                selectedValue = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
                widget.onChanged(selectedValue);
                _controller.text = widget.cell.formattedNewValue;
              }
            });
          }
        });
      },
      behavior: HitTestBehavior.opaque,
      child: DataTextField(
        cell: widget.cell,
        controller: _controller,
        canEdit: false,
        suffixIcon: Iconsax.calendar,
      ),
    );
  }
}
