import 'package:admin/src/helper/cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class BooleanField extends StatelessWidget {
  final Cell cell;
  final Function(String)? onChanged;

  const BooleanField({
    super.key,
    required this.cell,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: StatefulBuilder(builder: (context, setState) {
        return TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            backgroundColor: Colors.white,
            alignment: Alignment.center,
          ),
          onPressed: () {
            if (cell.canEdit) {
              cell.newValue = !cell.newValue;
              onChanged?.call(cell.formattedNewValue);
              setState(() {});
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cell.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              _RadioButtonIcon(
                isSelected: cell.newValue,
                isEnabled: cell.canEdit,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _RadioButtonIcon extends StatefulWidget {
  const _RadioButtonIcon({
    required this.isSelected,
    required this.isEnabled,
  });

  final bool isSelected;
  final bool isEnabled;

  @override
  State<_RadioButtonIcon> createState() => _RadioButtonIconState();
}

class _RadioButtonIconState extends State<_RadioButtonIcon> {
  final controller = ValueNotifier(true);
  @override
  void initState() {
    controller.value = widget.isSelected;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.value = widget.isSelected;
    return IgnorePointer(
      child: AdvancedSwitch(
        height: 24,
        width: 40,
        enabled: widget.isEnabled,
        controller: controller,
        activeColor: const Color(0xff6CC24A),
        inactiveColor: const Color(0xffD9D9D9),
      ),
    );
  }
}
