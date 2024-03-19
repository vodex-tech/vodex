import 'package:admin/src/controllers/data_grid.dart';
import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/helper/filter.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/view/widgets/confirm.dart';
import 'package:admin/src/view/widgets/filter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:datasource/datasource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:datasource/src/base.dart';

class DataController<T extends BaseModel> extends GetxController {
  final Widget Function(T data)? rowBuilder;
  final double? rowHeight;
  final DataGridProvider<T> Function([T?]) dataGridProvider;

  DataController({
    this.rowBuilder,
    this.rowHeight,
    required this.dataGridProvider,
  });

  final _datasource = Get.find<Datasource>();
  late final _dataGridProvider =
      Get.put<DataGridProvider<T>>(dataGridProvider());

  final searchTerm = ''.obs;
  final filterOptions = Rx<List<FilterOptions>?>(null);
  final sortColumn = Rx<SortColumnDetails?>(null);
  final isLoading = true.obs;
  final showCheckboxColumn = false.obs;
  final gridController = DataGridController();
  final searchController = TextEditingController();
  final RxString error = ''.obs;

  late final datasource = AdminDataGridSource<T>(_dataGridProvider)
    ..addListener(() => update(['count']));

  final RxMap<String, double> columnWidths =
      RxMap.from(Map.from(GetStorage().read('columnWidths$T') ?? {}));

  updateColumnWidthsCache() =>
      GetStorage().write('columnWidths$T', Map.from(columnWidths));

  reset() async {
    searchTerm.value = '';
    filterOptions.value = null;
    sortColumn.value = null;
    searchController.clear();
    await datasource.handleRefresh();
  }

  search(String value) async {
    searchTerm.value = value.toLowerCase();
    searchController.text = value;
    await datasource.handleRefresh();
  }

  filter(List<FilterOptions> filters) async {
    if (filters.isEmpty) {
      reset();
      return;
    }
    filterOptions.value = filters;
    await datasource.handleRefresh();
  }

  addToFilter(FilterOptions filterOption) {
    if (filterOptions.value
            ?.any((e) => e.cell.title == filterOption.cell.title) ??
        false) {
      return;
    }
    filter([...filterOptions.value ?? [], filterOption]);
  }

  clearFilters() {
    filterOptions.value = null;
    datasource.handleRefresh();
  }

  sort(String title) {
    final lastDire = sortColumn.value?.sortDirection;
    final newDire = sortColumn.value?.name == title
        ? lastDire == DataGridSortDirection.ascending
            ? DataGridSortDirection.descending
            : lastDire == DataGridSortDirection.descending
                ? null
                : DataGridSortDirection.ascending
        : DataGridSortDirection.ascending;
    if (newDire == null) {
      sortColumn.value = null;
      datasource.handleRefresh();
      return;
    }
    sortColumn.value = SortColumnDetails(
      name: title,
      sortDirection: newDire,
    );
    datasource.handleRefresh();
  }

  Query<T> get collection {
    Query<T> query = _dataGridProvider.collection;
    if (searchTerm.value.isNotEmpty) {
      query = query.where('searchTerms',
          arrayContains: searchTerm.value.toLowerCase());
    } else if (sortColumn.value != null) {
      query = query.orderBy(
        _dataGridProvider.cells
            .firstWhere((e) => e.title == sortColumn.value!.name)
            .id,
        descending:
            sortColumn.value!.sortDirection == DataGridSortDirection.descending,
      );
    }
    if (filterOptions.value != null) {
      for (final filter in filterOptions.value!) {
        query = query.whereField(
            _dataGridProvider.cells
                .firstWhere((e) => e.title == filter.cell.title)
                .id,
            value: filter.cell.firestoreValue,
            condition: filter.condition);
      }
    }
    if (sortColumn.value == null &&
        searchTerm.value.isEmpty &&
        filterOptions.value == null) {
      query = query.orderBy('createdAt', descending: true);
    }
    return query;
  }

  Future delete(T data) => doAfterConfirm(
        () => _delete(data),
        title: 'Delete item',
        message: 'Are you sure you want to delete this item?',
        okColor: Colors.red,
        textOK: 'Delete',
        textCancel: 'Cancel',
        textDirection: TextDirection.ltr,
      );

  Future _delete(T data) => _datasource.delete(data);

  deleteSelected() async {
    doAfterConfirm(
      () async {
        final selected = gridController.selectedRows
            .map((e) => datasource.rows.indexOf(e))
            .toList();
        showCheckboxColumn.value = false;
        List dataToBeDeleted = [];
        List rowsToBeDeleted = [];
        await Future.wait(selected.map((e) async {
          await _delete(datasource.data[e]);
          dataToBeDeleted.add(datasource.data[e]);
          rowsToBeDeleted.add(datasource.rows[e]);
        }));
        gridController.selectedRows.clear();
        datasource.data.removeWhere((e) => dataToBeDeleted.contains(e));
        datasource.rows.removeWhere((e) => rowsToBeDeleted.contains(e));
        datasource.notifyListeners();
      },
      title: 'Delete selected items',
      message:
          'Are you sure you want to delete ${gridController.selectedRows.length} item?',
      okColor: Colors.red,
      textOK: 'Delete',
      textCancel: 'Cancel',
      textDirection: TextDirection.ltr,
    );
  }

  late List<Cell> headers = _headers;
  List<Cell> get _headers {
    final providedHeaders = _dataGridProvider.visiableCells;

    try {
      final cachedHeaders = GetStorage().read('headers$T');
      final bool isSameElements =
          providedHeaders.length == cachedHeaders?.length &&
              providedHeaders
                  .every((e) => cachedHeaders?.contains(e.title) ?? false);
      if (cachedHeaders != null && isSameElements) {
        return cachedHeaders
            .map((e) => providedHeaders.firstWhere((a) => a.title == e))
            .toList()
            .cast<Cell>();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return providedHeaders;
  }

  void reorderColumns(int from, int to) {
    final rearrangeColumn = headers[from];
    headers.removeAt(from);
    headers.insert(to, rearrangeColumn);
    datasource.refreshWithoutFetching();
    GetStorage().write('headers$T', headers.map((e) => e.title).toList());
  }

  Future<int> getCount() async {
    final count = await _dataGridProvider.collection
        .count()
        .get()
        .then((value) => value.count ?? 0);
    return count;
  }

  @override
  void onClose() {
    datasource.dispose();
    gridController.dispose();
    searchTerm.close();
    showCheckboxColumn.close();
    searchController.dispose();
    isLoading.close();
    filterOptions.close();
    sortColumn.close();
    columnWidths.close();
    error.close();
    super.onClose();
  }
}
