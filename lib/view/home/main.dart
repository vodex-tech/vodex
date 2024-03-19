import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/courses/course.dart';
import 'package:logic_study/view/home/controllers/main_controller.dart';
import 'package:logic_study/theme/theme.dart';
import 'package:logic_study/view/video_player/controller.dart';
import 'package:logic_study/view/video_player/player_wrapper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserMainScreen extends StatelessWidget {
  const UserMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        final controller = Get.find<VideoController>();
        if (controller.boxController.getPosition == 1) {
          controller.boxController.closeBox();
          return Future.value(false);
        } else {
          if (isNested) {
            Get.back(id: 1);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        }
      },
      child: VideoPlayerWrapper(
        child: Navigator(
          key: Get.nestedKey(1),
          onGenerateRoute: (_) {
            return GetPageRoute(page: () {
              return GetBuilder(
                  init: MainController(),
                  builder: (controller) {
                    return Obx(() {
                      return AnnotatedRegion(
                        value: controller.selectedIndex.value != 2
                            ? darkSystemUI
                            : lightSystemUI,
                        child: Scaffold(
                          body: Obx(
                            () => IndexedStack(
                              index: controller.selectedIndex.value,
                              children: controller.bottomNavBarItems
                                  .map((e) => e.page)
                                  .toList(),
                            ),
                          ),
                          extendBody: true,
                          bottomNavigationBar: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Divider(
                                height: 0,
                                thickness: 1,
                                color: Colors.grey.shade300,
                              ),
                              BottomNavigationBar(
                                type: BottomNavigationBarType.fixed,
                                iconSize: 24,
                                selectedFontSize: 14,
                                unselectedFontSize: 14,
                                backgroundColor: Colors.white,
                                selectedItemColor: Colors.black,
                                unselectedItemColor: Colors.grey.shade600,
                                selectedIconTheme: const IconThemeData(
                                  color: Colors.black,
                                ),
                                showUnselectedLabels: true,
                                items: List.generate(
                                  controller.bottomNavBarItems.length,
                                  (index) {
                                    final isSelected =
                                        controller.selectedIndex.value == index;
                                    return BottomNavigationBarItem(
                                      icon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        child: SvgPicture.asset(
                                          'assets/svg/${controller.bottomNavBarItems[index].icon}${isSelected ? '_bold' : ''}.svg',
                                          width: 22,
                                          height: 22,
                                          colorFilter: ColorFilter.mode(
                                            isSelected
                                                ? Colors.black
                                                : Colors.grey.shade600,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                      label: controller
                                          .bottomNavBarItems[index].title,
                                    );
                                  },
                                ),
                                currentIndex: controller.selectedIndex.value,
                                onTap: (index) =>
                                    controller.selectedIndex.value = index,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  });
            });
          },
        ),
      ),
    );
  }
}
