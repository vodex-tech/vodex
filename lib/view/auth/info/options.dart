import 'package:datasource/datasource.dart';
import 'package:datasource/models/study.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kr_builder/kr_builder.dart';
import 'package:kr_button/kr_button.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/view/auth/info/controller.dart';

class AccountSetupScreenWrapper extends StatelessWidget {
  const AccountSetupScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserInfoController>(
      init: UserInfoController(),
      builder: (controller) {
        return AccountSetupScreen(
          title: 'الجامعة',
          message: 'قم بأختيار الجامعة التي تدرس فيها',
          type: StudyType.university,
          onSubmit: controller.submitUnviersity,
        );
      },
    );
  }
}

class AccountSetupScreen extends GetView<UserInfoController> {
  const AccountSetupScreen({
    super.key,
    required this.message,
    required this.title,
    required this.type,
    required this.onSubmit,
    this.parentId,
  });

  final String message;
  final String title;
  final StudyType type;
  final String? parentId;
  final Future Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    final isAdmin = Get.find<Auth>().isAdmin;
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: StatefulBuilder(builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  right: 24,
                ),
                child: Row(
                  children: [
                    Text(
                      'اختر $title',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 33.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (isAdmin)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextButton(
                          onPressed: () async {
                            String? value;
                            await Get.defaultDialog(
                              title: 'إضافة $title',
                              content: TextField(
                                autofocus: true,
                                onChanged: (v) => value = v,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: 'أدخل اسم $title',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Get.back();
                                  },
                                  child: const Text('إضافة'),
                                ),
                              ],
                            );
                            if (value != null) {
                              await Get.find<Datasource>().put(
                                Study(
                                  type: type,
                                  title: value!,
                                  parentId: parentId,
                                ),
                              );
                              setState(() {});
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Iconsax.add,
                                size: 20,
                              ),
                              Text(
                                'إضافة',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24.0, top: 15),
                child: Text.rich(
                  TextSpan(
                    text: '$message، في حال كانت غير موجودة',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    children: const [
                      TextSpan(
                        text: ' تواصل معنا.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: KrFutureBuilder(
                    future: controller.getOptions(type, parentId),
                    builder: (data) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 16),
                            child: KrTextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                              child: Text(data[index].title),
                              onPressed: () async {
                                HapticFeedback.heavyImpact();
                                await onSubmit(data[index].title);
                              },
                            ),
                          );
                        },
                      );
                    }),
              )
            ],
          );
        }),
      ),
    );
  }
}
