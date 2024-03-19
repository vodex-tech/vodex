import 'dart:math';

import 'package:admin/src/controllers/controller.dart';
import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/view/pages/edit.dart';
import 'package:admin/src/view/widgets/filter.dart';
import 'package:admin/src/view/widgets/header.dart';
import 'package:admin/src/view/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kr_builder/kr_builder.dart';
import 'package:kr_button/text_button.dart';
import 'package:datasource/src/base.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Stack;
import '../../helper/save_file_mobile.dart'
    if (dart.library.html) '../../helper/save_file_web.dart' as helper;

class DataScreen<T extends BaseModel> extends StatelessWidget {
  const DataScreen({
    super.key,
    required this.rowBuilder,
    required this.rowHeight,
    required this.dataGridProvider,
  });

  final Widget Function(T data)? rowBuilder;
  final double? rowHeight;
  final DataGridProvider<T> Function([T?]) dataGridProvider;

  bool get hasCustomBuilder => rowBuilder != null;

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<SfDataGridState>();
    final primaryColor = Theme.of(context).primaryColor;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GetBuilder<DataController<T>>(
          init: DataController<T>(
            rowBuilder: rowBuilder,
            rowHeight: rowHeight,
            dataGridProvider: dataGridProvider,
          ),
          builder: (controller) {
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 700),
                      child: Row(
                        children: [
                          const BackButton(),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: TextField(
                                controller: controller.searchController,
                                onSubmitted: controller.search,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  hintText: 'Search...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  isDense: true,
                                  suffixIcon: Obx(() {
                                    if (controller
                                        .searchTerm.value.isNotEmpty) {
                                      return IconButton(
                                        onPressed: () => controller.search(''),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      );
                                    }
                                    return const Icon(
                                      Iconsax.search_normal,
                                      color: Colors.black,
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: () =>
                                showFilter<T>(controller.filterOptions.value),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              minimumSize: const Size(44, 44),
                            ),
                            child: const Icon(Iconsax.filter, size: 22),
                          ),
                          const SizedBox(width: 4),
                          KrTextButton(
                            onPressed: () async {
                              final Workbook workbook =
                                  key.currentState!.exportToExcelWorkbook();
                              final List<int> bytes = workbook.saveAsStream();
                              workbook.dispose();
                              await helper.saveAndLaunchFile(
                                  bytes, 'Logic.xlsx');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              minimumSize: const Size(44, 44),
                            ),
                            child: const Icon(Iconsax.export, size: 22),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                    Obx(
                      () {
                        if (controller.filterOptions.value == null) {
                          return const SizedBox(height: 16);
                        }
                        return Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            runAlignment: WrapAlignment.start,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              for (final filter
                                  in controller.filterOptions.value!)
                                SizedBox(
                                  height: 30,
                                  child: TextButton(
                                    onPressed: () {
                                      controller.filter(List.from(
                                          controller.filterOptions.value!)
                                        ..remove(filter));
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey.shade200,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      minimumSize: Size.zero,
                                      maximumSize:
                                          Size(min(Get.width / 3, 300), 30),
                                      alignment: Alignment.center,
                                    ),
                                    child: Text(
                                      '${filter.cell.title} ${filter.conditionSymbol} ${filter.cell.formattedNewValue}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 30,
                                child: TextButton(
                                  onPressed: () {
                                    controller.clearFilters();
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize: Size.zero,
                                    maximumSize: Size(Get.width / 3, 30),
                                    alignment: Alignment.center,
                                  ),
                                  child: const Text(
                                    'Clear',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Expanded(
                        child: Center(
                      child: KrFutureBuilder(
                        future: controller.getCount(),
                        builder: (count) {
                          if (count == 0) {
                            return const Center(
                              child: Text('No Data'),
                            );
                          }
                          final datasource = controller.datasource;
                          return SfDataGridTheme(
                            data: SfDataGridThemeData(
                              headerColor: primaryColor.withOpacity(0.2),
                              selectionColor: primaryColor.withOpacity(0.4),
                            ),
                            child: Obx(() {
                              if (controller.error.value.isNotEmpty) {
                                return DataGridErrorWidget(
                                  message: controller.error.value,
                                  controller: controller,
                                );
                              }
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  SfDataGrid(
                                    key: key,
                                    source: datasource,
                                    controller: controller.gridController,
                                    // shrinkWrapColumns: true,
                                    gridLinesVisibility: hasCustomBuilder
                                        ? GridLinesVisibility.none
                                        : GridLinesVisibility.both,
                                    headerGridLinesVisibility: hasCustomBuilder
                                        ? GridLinesVisibility.none
                                        : GridLinesVisibility.both,
                                    allowPullToRefresh: true,
                                    selectionMode:
                                        controller.showCheckboxColumn.value &&
                                                hasCustomBuilder
                                            ? SelectionMode.none
                                            : SelectionMode.multiple,
                                    showCheckboxColumn:
                                        controller.showCheckboxColumn.value,
                                    isScrollbarAlwaysShown: true,
                                    checkboxShape: const CircleBorder(),
                                    rowHeight:
                                        controller.rowHeight ?? double.nan,
                                    headerRowHeight: hasCustomBuilder ? 0 : 40,
                                    onCellLongPress: (cell) async {
                                      if (hasCustomBuilder) {
                                        return;
                                      }
                                      if (cell.rowColumnIndex.rowIndex == 0) {
                                        return;
                                      }
                                      controller.showCheckboxColumn.value =
                                          true;
                                      await Future.delayed(100.milliseconds);
                                      controller.gridController.selectedIndex =
                                          cell.rowColumnIndex.rowIndex - 1;
                                    },
                                    allowColumnsDragging: true,

                                    onColumnDragging:
                                        (DataGridColumnDragDetails details) {
                                      if (details.action ==
                                              DataGridColumnDragAction
                                                  .dropped &&
                                          details.to != null) {
                                        controller.reorderColumns(
                                            details.from, details.to!);
                                      }
                                      return true;
                                    },
                                    allowColumnsResizing: true,
                                    onSelectionChanged:
                                        (addedRows, removedRows) {
                                      if (controller.gridController.selectedRows
                                          .isEmpty) {
                                        controller.showCheckboxColumn.value =
                                            false;
                                      }
                                    },
                                    onColumnResizeUpdate:
                                        (ColumnResizeUpdateDetails details) {
                                      controller.columnWidths[details
                                          .column.columnName] = details.width;
                                      return true;
                                    },
                                    onColumnResizeEnd:
                                        (ColumnResizeEndDetails details) {
                                      controller.updateColumnWidthsCache();
                                    },
                                    columns: (hasCustomBuilder
                                            ? [CellText('', id: 'no_column')]
                                            : controller.headers)
                                        .map((e) => GridColumn(
                                              columnName: e.title,
                                              label: GridColumnHeader<T>(
                                                  header: e),
                                              minimumWidth: hasCustomBuilder
                                                  ? Get.width
                                                  : 40,
                                              maximumWidth: 400,
                                              allowSorting: false,
                                              width: hasCustomBuilder
                                                  ? Get.width
                                                  : controller.columnWidths[
                                                          e.title] ??
                                                      e.minWidth ??
                                                      140,
                                            ))
                                        .toList(),
                                    footerHeight: 0,
                                    loadMoreViewBuilder: (_, load) {
                                      if (controller.datasource.reachedEnd) {
                                        return const SizedBox.shrink();
                                      }
                                      return KrFutureBuilder(
                                          future: load(),
                                          onLoading: const Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              LinearProgressIndicator(
                                                backgroundColor:
                                                    Colors.transparent,
                                                color: Colors.black,
                                              )
                                            ],
                                          ),
                                          builder: (_) =>
                                              const SizedBox.shrink());
                                    },
                                  ),
                                  Visibility(
                                    visible: controller.isLoading.value,
                                    child: const IgnorePointer(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          LinearProgressIndicator(
                                            backgroundColor: Colors.transparent,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: GetBuilder<DataController<T>>(
                                          id: 'count',
                                          builder: (controller) {
                                            return Text(
                                              '${datasource.dataGridRows.length} of $count',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          );
                        },
                      ),
                    )),
                  ],
                ),
              ),
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Visibility(
                        visible: controller.showCheckboxColumn.value,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FloatingActionButton(
                            heroTag: 'delete',
                            onPressed: controller.deleteSelected,
                            backgroundColor: Colors.red,
                            child: const Icon(Iconsax.trash),
                          ),
                        ),
                      )),
                  FloatingActionButton(
                    onPressed: () async {
                      final res = await Get.to(() => EditDataScreen<T>());
                      if (res == true) {
                        await controller.datasource.handleRefresh();
                      }
                    },
                    heroTag: 'add',
                    child: const Icon(Iconsax.add),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
