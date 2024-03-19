import 'package:admin/admin.dart';
import 'package:admin/data/chapter.dart';
import 'package:admin/data/course.dart';
import 'package:datasource/models/chapter.dart';
import 'package:datasource/models/course.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logic_study/view/courses/chapter_tile.dart';
import 'package:logic_study/view/components/shimmer.dart';
import 'package:logic_study/view/courses/controllers/course_controller.dart';
import 'package:readmore/readmore.dart';

class CoursesInfo extends GetView<CourseController> {
  const CoursesInfo({super.key, required this.course, required this.onSave});

  final Course course;
  final Function(Course) onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: Text(
                    'الوصف',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (controller.isAdmin)
                IconButton(
                  onPressed: () async {
                    final res = await edit<Course>(
                        course, CourseDataGridProvider(course));
                    if (res != null) onSave(res);
                  },
                  icon: const Icon(Iconsax.edit, size: 18),
                ),
            ],
          ),
          const SizedBox(height: 6),
          ReadMoreText(
            course.description,
            textAlign: TextAlign.start,
            trimMode: TrimMode.Line,
            lessStyle: const TextStyle(color: Colors.black),
            trimLines: 3,
            moreStyle: const TextStyle(color: Colors.black),
            trimCollapsedText: 'عرض المزيد',
            trimExpandedText: '...عرض أقل',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class CourseChapters extends GetView<CourseController> {
  const CourseChapters({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SliverPadding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 80),
        sliver: Obx(() {
          return FutureBuilder(
              key: ValueKey(controller.isSubscribed.value),
              future: controller.chapters,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverList.separated(
                    itemCount: 3,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) => const ChapterPlaceHolder(),
                  );
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: controller.isAdmin
                          ? _AddChapter(() => setState(() {}))
                          : const Center(child: Text('لا توجد فصول')),
                    ),
                  );
                }
                final items = snapshot.data!;
                return SliverList.separated(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final e = items.elementAt(index);
                    return Column(
                      children: [
                        ChapterTile(chapter: e),
                        if (index == items.length - 1 &&
                            controller.isAdmin) ...[
                          const SizedBox(height: 12),
                          _AddChapter(() => setState(() {})),
                        ]
                      ],
                    );
                  },
                  separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                );
              });
        }),
      );
    });
  }
}

class ChapterPlaceHolder extends StatelessWidget {
  const ChapterPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerBloc(size: Size(double.maxFinite, 80), radius: 8);
  }
}

class _AddChapter extends GetView<CourseController> {
  const _AddChapter(this.onSave);

  final Function() onSave;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final chapter = Chapter(
          courseId: controller.course.id,
          title: '',
          originalPrice: 0,
          price: 0,
        );
        final res =
            await edit<Chapter>(chapter, ChapterDataGridProvider(chapter));
        if (res == true) onSave();
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        fixedSize: const Size(double.maxFinite, 50),
        textStyle: const TextStyle(
          fontSize: 14,
        ),
      ),
      child: const Text('إضافة فصل جديد'),
    );
  }
}
