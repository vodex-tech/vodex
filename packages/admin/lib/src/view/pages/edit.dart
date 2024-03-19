import 'package:admin/src/controllers/controller.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/view/widgets/cells/cell.dart';
import 'package:admin/src/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datasource/src/base.dart';

class EditDataScreen<T extends BaseModel> extends StatelessWidget {
  const EditDataScreen({super.key, this.data, this.dataGridProvider});

  final T? data;
  final DataGridProvider<T>? dataGridProvider;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataGridProvider<T>>(
        init: dataGridProvider ??
            Get.find<DataController<T>>().dataGridProvider(data),
        tag: 'edit',
        builder: (dataProvider) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                title: Text(data == null ? 'Add' : 'Edit'),
              ),
              backgroundColor: Colors.grey.shade100,
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 500),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: ListView(
                      children: [
                        ...dataProvider.cells
                            .map((e) => DataField(
                                field: e,
                                onChanged: () {
                                  dataProvider.checkValidation();
                                }))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    color: Colors.white,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 500),
                      child: SafeArea(
                        child: Builder(builder: (context) {
                          return GetBuilder<DataGridProvider<T>>(
                              tag: 'edit',
                              id: 'save',
                              builder: (context) {
                                return PrimaryButton(
                                  onTap: () async {
                                    final data = await dataProvider.save();
                                    if (data != null) Get.back(result: data);
                                  },
                                  status: dataProvider.isValid
                                      ? ButtonStatus.enabled
                                      : ButtonStatus.disabled,
                                  text: 'Save',
                                );
                              });
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
