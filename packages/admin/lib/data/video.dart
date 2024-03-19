import 'dart:ui';

import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/helper/validator.dart';
import 'package:datasource/datasource.dart';
import 'package:get/get.dart';

class VideoDataGridProvider extends DataGridProvider<AttachmentVideo> {
  VideoDataGridProvider([super.data]);

  @override
  List<Cell> cellsProvider([AttachmentVideo? e]) => [
        CellText(
          e?.chapterId,
          id: 'chapterId',
          validator: Validator.isNotEmpty,
          hideColumn: true,
        ),
        CellText(e?.title, id: 'title', validator: Validator.isNotEmpty),
        CellText(e?.description,
            id: 'description', validator: Validator.isNotEmpty),
        CellText(
          e?.videoUrl,
          id: 'videoUrl',
          validator: (x) => x.isURL && x.contains('youtub'),
        ),
        CellImage(
          e?.thumbnail,
          id: 'thumbnail',
          size: Size(200, 100),
        ),
        CellNumber(
          e?.duration,
          id: 'duration',
        ),
        CellBoolean(
          e?.isFree,
          id: 'isFree',
        ),
      ];
}
