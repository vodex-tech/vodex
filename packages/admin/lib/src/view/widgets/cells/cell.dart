import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/view/widgets/cells/boolean.dart';
import 'package:admin/src/view/widgets/cells/drop_down_button.dart';
import 'package:admin/src/view/widgets/cells/file.dart';
import 'package:admin/src/view/widgets/cells/image.dart';
import 'package:admin/src/view/widgets/cells/pick_date.dart';
import 'package:admin/src/view/widgets/cells/text_field.dart';
import 'package:flutter/material.dart';

class DataField<T> extends StatelessWidget {
  const DataField({
    super.key,
    required this.field,
    this.canEdit,
    this.onChanged,
  });

  final Cell<T> field;
  final bool? canEdit;
  final Function()? onChanged;

  onChange(String value) {
    field.formattedNewValue = value;
    onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Builder(
        builder: (context) {
          if (!field.canEdit) {
            return DataTextField(
                cell: field, canEdit: false, onChanged: onChange);
          }
          if (field is CellEnum || field is CellOptions) {
            return DropDownButton(cell: field, onChanged: onChange);
          }
          if (field is CellDateTime) {
            return DatePickerButton(
              cell: field,
              onChanged: (x) {
                field.newValue = x as T;
                onChange(field.formattedNewValue);
              },
            );
          }
          if (field is CellImage) {
            return ImageField(cell: field, onChanged: onChange);
          }
          if (field is CellFile) {
            return FileField(cell: field, onChanged: onChange);
          }
          if (field is CellBoolean) {
            return BooleanField(cell: field, onChanged: onChange);
          }
          return DataTextField(cell: field, onChanged: onChange);
        },
      ),
    );
  }
}
