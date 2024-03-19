import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/helper/validator.dart';
import 'package:datasource/models/study.dart';

class StudyDataGridProvider extends DataGridProvider<Study> {
  StudyDataGridProvider([super.data]);

  @override
  List<Cell> cellsProvider([Study? e]) => [
        CellEnum(
          e?.type ?? StudyType.university,
          id: 'type',
          values: StudyType.values,
        ),
        CellText(e?.title, id: 'title', validator: Validator.isNotEmpty),
        CellText(e?.parentId, id: 'parentId'),
      ];
}
