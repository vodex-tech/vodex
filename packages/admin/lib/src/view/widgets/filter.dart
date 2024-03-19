import 'package:admin/src/controllers/controller.dart';
import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/helper/filter.dart';
import 'package:admin/src/view/widgets/cells/cell.dart';
import 'package:admin/src/view/widgets/cells/drop_down_button.dart';
import 'package:admin/src/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:datasource/src/base.dart';
import 'package:blur/blur.dart';
import 'package:recase/recase.dart';

showFilter<T extends BaseModel>(List<FilterOptions>? filters) async {
  await Get.to(_FilterScreen<T>(filters));
}

class _FilterScreen<T extends BaseModel> extends StatefulWidget {
  const _FilterScreen(this.filters);

  final List<FilterOptions>? filters;

  @override
  State<_FilterScreen<T>> createState() => _FilterScreenState<T>();
}

class _FilterScreenState<T extends BaseModel> extends State<_FilterScreen<T>> {
  final cells = Get.find<DataController<T>>().dataGridProvider(null).cells;

  late final List<FilterOptions> filters = widget.filters ??
      [
        FilterOptions(
          cell: cells.first,
          condition: FilterConditionType.isEqualTo,
        )
      ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(
            child: IgnorePointer(
              child: Blur(
                blur: 5,
                blurColor: Colors.black,
                colorOpacity: 0.3,
                child: SizedBox(),
              ),
            ),
          ),
          Scaffold(
            appBar: AppBar(
              title: const Text('Filter'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        ...filters.map(
                          (e) => _Filter(
                            options: e,
                            cells: cells,
                            filters: filters,
                            onUpdate: () => setState(() {}),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            filters.add(FilterOptions(
                              cell: cells.first,
                              condition: FilterConditionType.isEqualTo,
                            ));
                            setState(() {});
                          },
                          child: const Text('Add filter'),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 500),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            if (widget.filters != null)
                              Expanded(
                                child: PrimaryButton(
                                  onTap: () async {
                                    Get.find<DataController<T>>()
                                        .clearFilters();
                                    Get.back();
                                  },
                                  foregroundColor: Colors.red,
                                  backgroundColor: Colors.grey.shade200,
                                  margin:
                                      const EdgeInsetsDirectional.only(end: 10),
                                  child: const Text('Reset'),
                                ),
                              ),
                            Expanded(
                              child: PrimaryButton(
                                onTap: () async => Get.back(),
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.grey.shade200,
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: PrimaryButton(
                                child: const Text('Filter'),
                                onTap: () async {
                                  Get.find<DataController<T>>().filter(filters);
                                  Get.back();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterOptions {
  Cell cell;
  FilterConditionType condition;

  String get conditionSymbol {
    switch (condition) {
      case FilterConditionType.isEqualTo:
        return '==';
      case FilterConditionType.isNotEqualTo:
        return '!=';
      case FilterConditionType.isGreaterThan:
        return '>';
      case FilterConditionType.isGreaterThanOrEqualTo:
        return '>=';
      case FilterConditionType.isLessThan:
        return '<';
      case FilterConditionType.isLessThanOrEqualTo:
        return '<=';
    }
  }

  FilterOptions({required this.cell, required this.condition});
}

class _Filter extends StatefulWidget {
  const _Filter({
    required this.options,
    required this.cells,
    required this.filters,
    required this.onUpdate,
  });
  final FilterOptions options;
  final List<Cell> cells;
  final List<FilterOptions> filters;
  final Function() onUpdate;

  @override
  State<_Filter> createState() => _FilterState();
}

class _FilterState extends State<_Filter> {
  List<FilterConditionType> get conditions {
    final filters = widget.filters.where((e) => e != widget.options);
    var conditions = List<FilterConditionType>.from(FilterConditionType.values);

    if (filters.any((e) => e.cell.title != widget.options.cell.title)) {
      conditions = [
        FilterConditionType.isEqualTo,
        FilterConditionType.isNotEqualTo,
      ];
    }
    if (filters.any((e) => e.condition == FilterConditionType.isNotEqualTo)) {
      conditions.remove(FilterConditionType.isNotEqualTo);
    }
    return conditions;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      constraints: const BoxConstraints.tightFor(width: 400),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropDownMore(
                  onChanged: (value) {
                    widget.options.cell = widget.cells
                        .firstWhere((element) => element.title == value);
                    widget.onUpdate();
                  },
                  maxHeight: 400,
                  hint: 'Select Column',
                  items: widget.cells.map((e) => e.title).toList(),
                  initialValue: widget.options.cell.title,
                ),
              ),
              if (widget.filters.length > 1)
                IconButton(
                  onPressed: () {
                    widget.filters.remove(widget.options);
                    widget.onUpdate();
                  },
                  icon: const Icon(Iconsax.trash),
                )
            ],
          ),
          const SizedBox(height: 10),
          DataField(field: widget.options.cell, canEdit: true),
          const SizedBox(height: 10),
          DropDownMore(
            key: UniqueKey(),
            onChanged: (value) {
              widget.options.condition = FilterConditionType.values
                  .firstWhere((element) => element.name.titleCase == value);
              setState(() {});
            },
            maxHeight: 300,
            showSearch: false,
            hint: 'Select Condition',
            items: conditions.map((e) => e.name.titleCase).toList(),
            initialValue: widget.options.condition.name.titleCase,
          ),
        ],
      ),
    );
  }
}
