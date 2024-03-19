import 'package:admin/data/file.dart';
import 'package:admin/data/study.dart';
import 'package:admin/data/subscription.dart';
import 'package:admin/data/video.dart';
import 'package:admin/data/chapter.dart';
import 'package:admin/data/course.dart';
import 'package:admin/data/user.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/view/pages/edit.dart';
import 'package:admin/src/view/pages/grid.dart';
import 'package:datasource/models/study.dart';
import 'package:datasource/models/subscription.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:datasource/datasource.dart';
import 'package:datasource/src/base.dart';
import 'package:recase/recase.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Admin Dashboard'),
          ),
          backgroundColor: Colors.grey.shade100,
          body: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                _Button<User>(
                  icon: Iconsax.user,
                  dataGridProvider: ([e]) => UserDataGridProvider(e),
                ),
                _Button<Course>(
                  icon: Iconsax.book,
                  dataGridProvider: ([e]) => CourseDataGridProvider(e),
                ),
                _Button<Chapter>(
                  icon: Iconsax.folder,
                  dataGridProvider: ([e]) => ChapterDataGridProvider(e),
                ),
                _Button<AttachmentVideo>(
                  icon: Iconsax.video_circle,
                  dataGridProvider: ([e]) => VideoDataGridProvider(e),
                ),
                _Button<AttachmentFile>(
                  icon: Iconsax.document_1,
                  dataGridProvider: ([e]) => FileDataGridProvider(e),
                ),
                _Button<Subscription>(
                  icon: Iconsax.bookmark,
                  dataGridProvider: ([e]) => SubscriptionDataGridProvider(e),
                ),
                _Button<Study>(
                  icon: Iconsax.teacher,
                  dataGridProvider: ([e]) => StudyDataGridProvider(e),
                ),
              ],
            ),
          )),
    );
  }
}

class _Button<T extends BaseModel> extends StatelessWidget {
  _Button({
    String? title,
    this.page,
    required this.icon,
    this.rowBuilder,
    this.rowHeight,
    required this.dataGridProvider,
  }) : title = title ?? T.toString().titleCase + 's';

  final String title;
  final Widget? page;
  final IconData icon;
  final Widget Function(T data)? rowBuilder;
  final double? rowHeight;
  final DataGridProvider<T> Function([T?]) dataGridProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextButton(
          onPressed: () {
            Get.to(() =>
                page ??
                DataScreen<T>(
                  rowBuilder: rowBuilder,
                  rowHeight: rowHeight,
                  dataGridProvider: dataGridProvider,
                ));
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            minimumSize: const Size(0, 50),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black38, width: 0.3),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          )),
    );
  }
}

edit<T extends BaseModel>(T? data, DataGridProvider<T> provider) async {
  return await Get.to(
      () => EditDataScreen<T>(data: data, dataGridProvider: provider));
}
