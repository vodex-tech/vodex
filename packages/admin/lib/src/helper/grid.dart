import 'package:get/get.dart';
import 'package:datasource/datasource.dart';
import 'package:datasource/src/base.dart';
import 'package:uuid/uuid.dart';

import 'cell.dart';

abstract class DataGridProvider<T extends BaseModel> extends GetxController {
  final datasource = Get.find<Datasource>();

  final T? data;

  DataGridProvider([this.data]);

  late bool isValid = cells.every((e) => e.isValid);

  checkValidation() {
    isValid = cells.every((e) => e.isValid);
    update(['save']);
  }

  Future<T?> save() async {
    try {
      final model =
          datasource.registeredModels.firstWhere((e) => e is FirestoreModel<T>);
      final data = model.fromMap(cells.fold<Map<String, dynamic>>(
          {},
          (previousValue, element) => {
                ...previousValue,
                element.id: element.firestoreValue,
              }));
      await Get.find<Datasource>().put(data as T);
      return data;
    } catch (e) {
      print(e);
      Get.snackbar('Error while saving data', e.toString());
      return null;
    }
  }

  late final cells = getCells(data);

  late final List<Cell> visiableCells =
      cells.where((e) => !e.hideColumn).toList();

  List<Cell> getCells([T? data]) =>
      [...cellsProvider(data), ...baseCellsProvider(data)];

  List<Cell> cellsProvider([T? data]);

  List<Cell> baseCellsProvider([T? data]) {
    return [
      CellText(
        data?.id ?? const Uuid().v4(),
        id: 'id',
        canEdit: false,
        hideColumn: true,
      ),
      CellDateTime(
        data?.createdAt,
        id: 'createdAt',
        canEdit: false,
      ),
    ];
  }

  Cell getCellById(String id) => cells.firstWhere((e) => e.id == id);

  final collection = Get.find<Datasource>().collection<T>();
}
