import 'package:admin/src/helper/cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DataTextField extends StatefulWidget {
  final bool canEdit;
  final TextEditingController? controller;
  final IconData? suffixIcon;
  final Cell cell;
  final Function(String)? onChanged;

  const DataTextField({
    super.key,
    required this.cell,
    this.canEdit = true,
    this.controller,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  State<DataTextField> createState() => _DataTextFieldState();
}

class _DataTextFieldState extends State<DataTextField> {
  late final controller = widget.controller ??
      TextEditingController(text: widget.cell.formattedNewValue);

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isValid = widget.cell.validate(widget.cell.formattedNewValue);
    bool isNumber = widget.cell is CellNumber;
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: StatefulBuilder(builder: (context, setState) {
        return TextFormField(
          controller: controller,
          textAlign: TextAlign.start,
          onChanged: (x) {
            widget.onChanged?.call(x);
            isValid = widget.cell.validate(x);
            setState(() {});
          },
          textInputAction: TextInputAction.next,
          maxLines: widget.cell.maxLines,
          readOnly: !widget.canEdit,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters: [
            if (isNumber) FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
            controller.text = widget.cell.formattedNewValue;
          },
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            errorText: isValid ? null : 'Invalid input',
            isDense: true,
            suffixIconColor: Colors.grey.shade800,
            suffixIcon: widget.suffixIcon != null
                ? Icon(
                    widget.suffixIcon,
                    size: 26,
                  )
                : widget.canEdit
                    ? null
                    : IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: widget.cell.formattedNewValue));
                          Get.snackbar(
                            'Copied',
                            'Data copied successfully',
                            backgroundColor: Colors.green.withOpacity(0.2),
                          );
                        },
                        icon: const Icon(Iconsax.copy),
                      ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.red),
            ),
            labelText: widget.cell.title,
            labelStyle: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(142, 33, 33, 33),
            ),
          ),
        );
      }),
    );
  }
}
