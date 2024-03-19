import 'package:admin/admin.dart';
import 'package:admin/data/course.dart';
import 'package:datasource/datasource.dart';
import 'package:firebase_feature_flag/firebase_feature_flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kr_paginate_firestore/paginate_firestore.dart';
import 'package:logic_study/view/components/image.dart';
import 'package:logic_study/view/components/shimmer.dart';
import 'package:logic_study/view/components/wrap_indicator.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/view/courses/course.dart';
import 'package:logic_study/view/home/controllers/home_controller.dart';
import 'package:logic_study/view/home/widgtes/app_bar.dart';

UniqueKey homePageKey = UniqueKey();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
            appBar: HomeAppBar(),
            body: CheckMarkIndicator(
              onRefresh: () async {
                homePageKey = UniqueKey();
                controller.update();
                await Future.delayed(const Duration(seconds: 1));
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: AspectRatio(
                      aspectRatio: 392 / 170,
                      child: FeatureFlagBuilder(
                          feature: controller.topBanner,
                          builder: (_, data) {
                            if (data.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return CustomImage(
                              url: data,
                              width: double.maxFinite,
                              fit: BoxFit.cover,
                              radius: 8,
                              padding: const EdgeInsets.only(
                                  top: 16, left: 16, right: 16),
                            );
                          }),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16, bottom: 8, right: 16, left: 16),
                      child: Row(
                        children: [
                          const Text(
                            'جميع الدورات',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          if (controller.isAdmin)
                            TextButton(
                              onPressed: () async {
                                final user = Get.find<Auth>().user;
                                final course = Course(
                                  title: '',
                                  subject: '',
                                  description: '',
                                  image: '',
                                  teacher: '',
                                  university: user.university,
                                  college: user.college,
                                  department: user.department,
                                  branch: user.branch,
                                  stage: user.stage,
                                  price: 0,
                                  originalPrice: 0,
                                );
                                final res = await edit<Course>(
                                    course, CourseDataGridProvider(course));
                                if (res != null) {
                                  homePageKey = UniqueKey();
                                  controller.update();
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                              ),
                              child: const Row(
                                children: [
                                  Icon(Iconsax.add, size: 16),
                                  SizedBox(width: 4),
                                  Text('إضافة دورة'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: LayoutBuilder(builder: (context, size) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: KrPaginateFirestore(
                          key: homePageKey,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, docs, index) {
                            final data = docs.elementAt(index).data() as Course;
                            return InkWell(
                              onTap: () {
                                Get.to(CourseScreen(course: data), id: 1);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          query: controller.courses,
                          shrinkWrap: true,
                          itemBuilderType: PaginateBuilderType.gridView,
                          onEmpty: const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 100),
                              child: Text('لا توجد دورات'),
                            ),
                          ),
                          initialLoader: GridView.builder(
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
                          ),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: size.maxWidth / 2,
                            mainAxisExtent: (size.maxWidth / 2) + 48,
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
