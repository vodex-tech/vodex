import 'dart:math';

import 'package:admin/src/controllers/controller.dart';
import 'package:admin/src/helper/filter.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/view/pages/edit.dart';
import 'package:admin/src/view/widgets/filter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datasource/datasource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kr_pull_down_button/pull_down_button.dart';
import 'package:datasource/src/base.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AdminDataGridSource<T extends BaseModel> extends DataGridSource {
  final DataGridProvider<T> _dataGridProvider;
  final controller = Get.find<DataController<T>>();

  AdminDataGridSource(this._dataGridProvider) {
    loadData();
  }

  bool get hasCustomBuilder => controller.rowBuilder != null;

  List<DataGridRow> dataGridRows = [];
  List<T> data = [];

  clearData() {
    _lastDocument = null;
    reachedEnd = false;
    dataGridRows.clear();
    data.clear();
    _isLoading = false;
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    clearData();
    await loadData();
  }

  Future<void> refreshWithoutFetching() async {
    controller.isLoading.value = true;
    dataGridRows.clear();
    await loadData(false);
  }

  @override
  Future<void> handleLoadMoreRows() => loadData();

  bool reachedEnd = false;
  QueryDocumentSnapshot? _lastDocument;

  bool _isLoading = false;
  loadData([bool fetch = true]) async {
    if (_isLoading || reachedEnd) return;
    _isLoading = true;
    if (controller.error.value.isNotEmpty) {
      controller.error.value = '';
    }
    if (data.isEmpty) controller.isLoading.value = true;
    try {
      final List<T> data;
      if (fetch) {
        if (_lastDocument == null) {
          data = await getInitialData();
        } else {
          data = await getMoreData();
        }
      } else {
        data = List.from(this.data);
      }
      if (data.isEmpty) {
        reachedEnd = true;
      } else {
        this.data.addAll(data);
        dataGridRows.addAll(data
            .map((e) => hasCustomBuilder
                ? DataGridRow(cells: [
                    DataGridCell(
                        columnName: 'no_column',
                        value: controller.rowBuilder!(e))
                  ])
                : DataGridRow(cells: sortedCells(e)))
            .toList());
      }
      if (Get.isRegistered<AdminDataGridSource<T>>()) notifyListeners();
    } finally {
      controller.isLoading.value = false;
      _isLoading = false;
    }
  }

  List<DataGridCell<String>> sortedCells(e) {
    final headers = controller.headers.map((e) => e.title).toList();
    final cells = _dataGridProvider.getCells(e).where((e) => !e.hideColumn);
    return headers
        .map((e) => cells.firstWhere((a) => a.title == e))
        .map((e) => DataGridCell<String>(
              columnName: e.title,
              value: e.formatted,
            ))
        .toList();
  }

  Future<List<T>> getInitialData() async {
    try {
      final res = await controller.collection.limit(20).get();
      if (res.docs.isEmpty) {
        reachedEnd = true;
        return List<T>.empty();
      }
      _lastDocument = res.docs.last;
      return res.docs.map((e) => e.data()).toList();
    } catch (e) {
      printError(info: e.toString());
      String msg = e.toString();
      if (e is AssertionError) {
        msg = e.message?.toString() ?? '';
      }
      if (e is FirebaseException) {
        msg = e.message ?? '';
      }
      controller.error.value = msg;
      return List<T>.empty();
    }
  }

  Future<List<T>> getMoreData() {
    return controller.collection
        .startAfterDocument(_lastDocument!)
        .limit(10)
        .get()
        .then(
      (value) {
        if (value.docs.isEmpty) {
          reachedEnd = true;
          return [];
        }
        _lastDocument = value.docs.last;
        return value.docs.map((e) => e.data()).toList();
      },
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(
    DataGridRow row,
  ) {
    return DataGridRowAdapter(
        color: hasCustomBuilder || dataGridRows.indexOf(row) % 2 == 0
            ? Colors.white
            : Colors.grey[100],
        cells: row.getCells().map<Widget>((e) {
          return PullDownButton(
              routeTheme: const PullDownMenuRouteTheme(
                width: 130,
                backgroundColor: Colors.white,
              ),
              itemBuilder: (context) => [
                    PullDownMenuItem(
                      title: 'Edit',
                      itemTheme: const PullDownMenuItemTheme(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      icon: Iconsax.edit,
                      onTap: () async {
                        final model = data[dataGridRows.indexOf(row)];
                        final res =
                            await Get.to(() => EditDataScreen(data: model));
                        if (res == true) {
                          await handleRefresh();
                        }
                      },
                    ),
                    PullDownMenuItem(
                      title: 'Match',
                      itemTheme: const PullDownMenuItemTheme(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      icon: Iconsax.search_normal,
                      onTap: () {
                        final model = data[dataGridRows.indexOf(row)];
                        final cells = _dataGridProvider.getCells(model);
                        final cell = cells.firstWhere(
                            (a) => a.title == e.columnName,
                            orElse: () => cells.first);
                        Get.find<DataController<T>>().addToFilter(FilterOptions(
                          cell: cell,
                          condition: FilterConditionType.isEqualTo,
                        ));
                      },
                    ),
                    PullDownMenuItem(
                      title: 'Copy',
                      itemTheme: const PullDownMenuItemTheme(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      icon: Iconsax.copy,
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: e.value.toString(),
                          ),
                        );
                      },
                    ),
                    if (kDebugMode)
                      PullDownMenuItem(
                        title: 'Duplicate',
                        itemTheme: const PullDownMenuItemTheme(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        icon: Iconsax.document,
                        onTap: () async {
                          final datasource = Get.find<Datasource>();
                          final model = data[dataGridRows.indexOf(row)];
                          final convertedModel = datasource.registeredModels
                              .firstWhere((e) => e is FirestoreModel<T>)
                              .fromMap({
                            ...model.toMap(),
                            'id': model.id + '_${Random().nextInt(1000)}'
                          });
                          await Get.find<Datasource>().put(convertedModel as T);
                          await handleRefresh();
                        },
                      ),
                    PullDownMenuItem(
                      title: 'Delete',
                      itemTheme: const PullDownMenuItemTheme(
                        textStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      icon: Iconsax.trash,
                      iconColor: Colors.red,
                      onTap: () async {
                        final index = dataGridRows.indexOf(row);
                        await Get.find<DataController<T>>().delete(data[index]);
                        dataGridRows.removeAt(index);
                        data.removeAt(index);
                        notifyListeners();
                      },
                    ),
                  ],
              applyOpacity: true,
              buttonBuilder: (context, showMenu) {
                if (hasCustomBuilder) {
                  return controller
                      .rowBuilder!(data[dataGridRows.indexOf(row)]);
                }
                return InkWell(
                  onTap: Get.find<DataController<T>>().showCheckboxColumn.value
                      ? null
                      : showMenu,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextHighlight(
                      text: e.value.toString(),
                      words: {
                        if (controller.searchTerm.value.isNotEmpty)
                          controller.searchTerm.value: HighlightedWord(
                            textStyle: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                      },
                    ),
                  ),
                );
              });
        }).toList());
  }
}
