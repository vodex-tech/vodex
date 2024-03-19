import 'package:datasource/datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/components/primary_button.dart';
import 'package:logic_study/view/components/image.dart';
import 'package:logic_study/view/courses/info.dart';
import 'package:logic_study/view/courses/subscribe/subscribe_dialog.dart';

import 'controllers/course_controller.dart';

bool isNested = false;

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key, required this.course});

  final Course course;

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final RxDouble scrollPosition = 0.0.obs;
  final ScrollController scrollController = ScrollController();

  late Course course = widget.course;

  @override
  void initState() {
    isNested = true;
    scrollController.addListener(() {
      scrollPosition.value = scrollController.offset;
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    isNested = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseController>(
        init: CourseController(course: course),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Obx(() => Opacity(
                    opacity: ((scrollPosition.value - 120) / 50).clamp(0, 1),
                    child: Text(
                      course.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
              iconTheme: const IconThemeData(color: Colors.white),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.light,
              ),
              actions: [
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Iconsax.export),
                // ),
              ],
            ),
            extendBodyBehindAppBar: true,
            body: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 180,
                        elevation: 0,
                        leading: const SizedBox.shrink(),
                        snap: false,
                        floating: true,
                        stretch: true,
                        pinned: true,
                        backgroundColor: Colors.black,
                        flexibleSpace: FlexibleSpaceBar(
                            stretchModes: const [
                              StretchMode.zoomBackground,
                            ],
                            background: Stack(
                              children: [
                                CustomImage(
                                  url: course.image,
                                  width: double.maxFinite,
                                  height: Get.width,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                        Colors.black54,
                                        Colors.black.withOpacity(0.0),
                                        Colors.black.withOpacity(0.0)
                                      ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter)),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.bottomStart,
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black,
                                            Colors.black.withOpacity(0.0),
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.bottomStart,
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      start: 16,
                                      bottom: 36,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          course.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            course.teacher,
                                            style: TextStyle(
                                                color: Colors.grey.shade200,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(16),
                          child: Transform.translate(
                            offset: const Offset(0, 1),
                            child: Container(
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SliverToBoxAdapter(
                      //   child: Center(
                      //     child: Container(
                      //       color: Colors.white,
                      //       margin: const EdgeInsets.symmetric(horizontal: 16),
                      //       constraints: const BoxConstraints(maxWidth: 300),
                      //       child: Obx(() => Row(
                      //             children: [
                      //               Expanded(
                      //                 child: _TabButton(
                      //                   isSelected:
                      //                       controller.selectedTab.value == 0,
                      //                   title: 'معلومات الكورس',
                      //                   onPressed: () {
                      //                     controller.selectedTab.value = 0;
                      //                   },
                      //                 ),
                      //               ),
                      //               Expanded(
                      //                 child: _TabButton(
                      //                   isSelected:
                      //                       controller.selectedTab.value == 1,
                      //                   onPressed: () {
                      //                     controller.selectedTab.value = 1;
                      //                   },
                      //                   title: 'الكورسات المشابهة',
                      //                 ),
                      //               ),
                      //             ],
                      //           )),
                      //     ),
                      //   ),
                      // ),
                      // SliverToBoxAdapter(
                      //   child: Obx(() {
                      //     if (controller.selectedTab.value == 0) {
                      //       return CoursesInfo(
                      //           course: course,
                      //           onSave: (e) => setState(() {
                      //                 course = e;
                      //               }));
                      //     }
                      //     return const SimilarCourses();
                      //   }),
                      // ),
                      // if (controller.selectedTab.value == 0)
                      SliverToBoxAdapter(
                          child: CoursesInfo(
                        course: widget.course,
                        onSave: (course) {
                          setState(() {
                            this.course = course;
                          });
                        },
                      )),
                      const CourseChapters(),
                    ],
                  ),
                ),
                Obx(() => Visibility(
                      visible: !controller.isSubscribed.value,
                      child: SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: PrimaryButton(
                              onTap: () async {
                                await SubscribeDialog.show(controller.course);
                              },
                              text: 'اشتراك ${course.price} د.ع',
                            ),
                          )),
                    )),
              ],
            ),
          );
        });
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.isSelected,
    required this.onPressed,
    required this.title,
  });

  final bool isSelected;
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? Colors.black : Colors.grey.shade600,
        textStyle: TextStyle(
          fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
          fontSize: 14,
        ),
      ),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSelected ? 100 : 0,
            height: 1,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
