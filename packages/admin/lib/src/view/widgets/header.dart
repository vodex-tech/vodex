import 'package:admin/src/controllers/controller.dart';
import 'package:admin/src/helper/cell.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datasource/src/base.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GridColumnHeader<T extends BaseModel> extends GetView<DataController<T>> {
  const GridColumnHeader({
    super.key,
    required this.header,
  });

  final Cell header;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              controller.sort(header.title);
            },
            child: SizedBox(
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      header.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Obx(
                      () => Visibility(
                          visible:
                              controller.sortColumn.value?.name == header.title,
                          child: Icon(
                            controller.sortColumn.value?.sortDirection ==
                                    DataGridSortDirection.ascending
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
