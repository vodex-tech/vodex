import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/helper/validator.dart';
import 'package:datasource/models/study.dart';
import 'package:get/get.dart';
import 'package:datasource/datasource.dart';

class UserDataGridProvider extends DataGridProvider<User> {
  UserDataGridProvider([super.data]);

  Future<List<String>> getOptions(StudyType type, String? parentId) async {
    final res =
        await Get.find<Datasource>().getAccountOptionsById(type, parentId);
    return res.map((e) => e.title).toList();
  }

  @override
  List<Cell> cellsProvider([User? e]) => [
        CellText(
          e?.name,
          id: 'name',
          validator: Validator.isNotEmpty,
        ),
        CellText(
          e?.email,
          id: 'email',
          validator: Validator.isEmail,
        ),
        CellEnum(
          e?.type ?? UserType.user,
          id: 'type',
          values: UserType.values,
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
