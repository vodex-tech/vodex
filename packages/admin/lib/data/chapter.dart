import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/helper/formatter.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/helper/validator.dart';
import 'package:datasource/models/chapter.dart';

class ChapterDataGridProvider extends DataGridProvider<Chapter> {
  ChapterDataGridProvider([super.data]);

  @override
  List<Cell> cellsProvider([Chapter? e]) => [
        CellText(
          e?.courseId,
          id: 'courseId',
          validator: Validator.isNotEmpty,
          hideColumn: true,
        ),
        CellText(e?.title, id: 'title', validator: Validator.isNotEmpty),
        CellNumber(
          e?.originalPrice,
          id: 'originalPrice',
          validator: Validator.isIraqiPrice,
          formatter: FieldFormatter.price(),
        ),
        CellNumber(e?.price,
            id: 'price',
            validator: Validator.isIraqiPrice,
            formatter: FieldFormatter.price()),
      ];
}
