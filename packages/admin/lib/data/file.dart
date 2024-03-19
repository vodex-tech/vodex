import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/helper/validator.dart';
import 'package:datasource/datasource.dart';

class FileDataGridProvider extends DataGridProvider<AttachmentFile> {
  FileDataGridProvider([super.data]);

  @override
  List<Cell> cellsProvider([AttachmentFile? e]) => [
        CellText(
          e?.chapterId,
          id: 'chapterId',
          validator: Validator.isNotEmpty,
          hideColumn: true,
        ),
        CellText(e?.title, id: 'title', validator: Validator.isNotEmpty),
        CellFile(
          e?.fileUrl,
          id: 'fileUrl',
          onEdit: (cell) {
            getCellById('size').newValue = cell.sizeOrDuration ?? 0;
            getCellById('extension').newValue = cell.payload ?? '';
          },
        ),
        CellNumber(
          e?.size,
          id: 'size',
          canEdit: false,
        ),
        CellText(
          e?.extension,
          id: 'extension',
          canEdit: false,
        ),
        CellBoolean(
          e?.isFree,
          id: 'isFree',
        ),
      ];
}
