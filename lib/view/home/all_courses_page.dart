import 'package:datasource/datasource.dart';
import 'package:datasource/models/course.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/view/components/image.dart';
import 'package:logic_study/view/components/shimmer.dart';
import 'package:logic_study/view/courses/course.dart';
import 'package:logic_study/view/home/widgtes/app_bar.dart';

class AllCoursesPage extends StatelessWidget {
  const AllCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: GetBuilder<MyCoursesController>(
          init: MyCoursesController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FutureBuilder(
                  future: controller.getCourses(),
                  builder: (context, courses) {
                    if (courses.connectionState == ConnectionState.waiting) {
                      return LayoutBuilder(builder: (context, size) {
                        return GridView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: size.maxWidth / 2,
                            mainAxisExtent: (size.maxWidth / 2) + 48,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AspectRatio(
                                    aspectRatio: 1,
                                    child: ShimmerBloc(
                                      size: Size.infinite,
                                      radius: 8,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const ShimmerBloc(
                                    size: Size(double.maxFinite, 16),
                                    radius: 8,
                                  ),
                                  const SizedBox(height: 4),
                                  ShimmerBloc(
                                    size: Size(Get.width / 4, 16),
                                    radius: 8,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      });
                    } else if (!courses.hasData || courses.data == null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 100),
                          child: Text('لا توجد دورات'),
                        ),
                      );
                    }
                    return LayoutBuilder(builder: (context, size) {
                      return CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            sliver: SliverGrid.builder(
                              key: key,
                              itemCount: courses.data!.length,
                              itemBuilder: (ctx, index) {
                                final data = courses.data!.elementAt(index);
                                return InkWell(
                                  onTap: () {
                                    Get.to(CourseScreen(course: data), id: 1);
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: CustomImage(
                                            url: data.image,
                                            width: double.maxFinite,
                                            fit: BoxFit.cover,
                                            radius: 8,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          data.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${data.stage} | ${data.subject}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: size.maxWidth / 2,
                                mainAxisExtent: (size.maxWidth / 2) + 48,
                              ),
                            ),
                          )
                        ],
                      );
                    });
                  }),
            );
          }),
    );
  }
}

class MyCoursesController extends GetxController {
  final _auth = Get.find<Auth>();
  final _database = Get.find<Datasource>();

  Future<List<Course>> getCourses() async {
    List<Course> courses = [];
    final subscriptions = await _database.allSubscriptions(_auth.user.id).get();
    final courseIds = subscriptions.docs.map((e) => e.data().courseId).toSet();
    for (final e in courseIds) {
      final course = await _database.get<Course>(e);
      if (course != null) courses.add(course);
    }
    return courses;
  }
}
