import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/video_player/controller.dart';
import 'package:logic_study/view/video_player/sliding_box.dart';
import 'package:logic_study/view/video_player/video_player_screen.dart';

class VideoPlayerWrapper extends StatelessWidget {
  const VideoPlayerWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(
        init: VideoController(),
        builder: (controller) {
          return Obx(() {
            return SlidingBox(
              controller: controller.boxController,
              draggableIconVisible: false,
              collapsed: true,
              minHeight: controller.chapter.value == null
                  ? 0
                  : 80 + MediaQuery.of(context).padding.bottom,
              maxHeight: Get.height - MediaQuery.of(context).padding.top,
              borderRadius: BorderRadius.zero,
              bodyBuilder: (scrollController, boxPosition) {
                return Obx(() {
                  if (controller.chapter.value == null) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    height: Get.height - MediaQuery.of(context).padding.top,
                    child: VideoScreen(height: boxPosition),
                  );
                });
              },
              backdrop: Backdrop(
                fading: true,
                overlay: true,
                body: child,
              ),
            );
          });
        });
  }
}
