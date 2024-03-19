import 'dart:ui';

import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/helper/validator.dart';
import 'package:datasource/models/study.dart';
import 'package:get/get.dart';
import 'package:datasource/datasource.dart';

class CourseDataGridProvider extends DataGridProvider<Course> {
  CourseDataGridProvider([super.data]);

  Future<List<String>> getOptions(StudyType type, String? parentId) async {
    final res =
        await Get.find<Datasource>().getAccountOptionsById(type, parentId);
    return res.map((e) => e.title).toList();
  }

  @override
  List<Cell> cellsProvider([Course? e]) => [
        CellText(e?.title, id: 'title', validator: Validator.isNotEmpty),
        CellText(e?.subject, id: 'subject', validator: Validator.isNotEmpty),
        CellNumber(e?.price, id: 'price', validator: Validator.isIraqiPrice),
        CellNumber(
          e?.originalPrice,
          id: 'originalPrice',
          validator: Validator.isIraqiPrice,
        ),
        CellText(
          e?.description,
          id: 'description',
          maxLines: 4,
          validator: Validator.isNotEmpty,
        ),
        CellText(
          e?.teacher,
          id: 'teacher',
          validator: Validator.isNotEmpty,
        ),
        CellImage(
          e?.image,
          id: 'image',
          size: Size(1200, 855),
        ),
        CellEnum(
          e?.status ?? CourseStatus.active,
          id: 'status',
          values: CourseStatus.values,
        ),
        CellOptions(
          e?.university,
          id: 'university',
          optionsAsync: () => getOptions(StudyType.university, null),
        ),
        CellOptions(
          e?.college,
          id: 'college',
          optionsAsync: () => getOptions(
            StudyType.college,
            getCellById('university').newValue,
          ),
        ),
        CellOptions(e?.department,
            id: 'department',
            optionsAsync: () => getOptions(
                  StudyType.department,
                  getCellById('college').newValue,
                )),
        CellOptions(
          e?.branch,
          id: 'branch',
          optionsAsync: () => getOptions(StudyType.branch, null),
        ),
        CellOptions(
          e?.stage,
          id: 'stage',
          optionsAsync: () => getOptions(StudyType.stage, null),
        ),
      ];
}
