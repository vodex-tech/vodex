import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/components/primary_button.dart';
import 'package:logic_study/functions/extensions.dart';
import 'package:logic_study/theme/theme.dart';
import 'package:logic_study/view/courses/controllers/course_controller.dart';
import 'package:logic_study/view/courses/subscribe/subscribe_dialog.dart';
import 'package:logic_study/view/video_player/controller.dart';
import 'package:logic_study/view/video_player/files_list.dart';
import 'package:logic_study/view/video_player/videos_list.dart';
import 'package:pod_player/pod_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key, required this.height});

  final double height;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  int x = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(builder: (controller) {
      if (widget.height < 1 && controller.isButtonsShown) {
        controller.isButtonsShown = false;
        controller.controller?.hideOverlay();
      } else {
        controller.isButtonsShown = true;
      }
      return Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (controller.boxController.isBoxClosed) {
                  controller.boxController.openBox();
                }
              },
              child: Container(
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    SizedBox(
                      width: (1 - widget.height) * (Get.width / 1.5),
                      child: Visibility(
                        visible: widget.height < 0.5,
                        child: Opacity(
                          opacity: ((1 - widget.height * 2))
                              .withRange(0, 1)
                              .toDouble(),
                          child: Row(children: [
                            IconButton(
                              onPressed: () {
                                Get.find<VideoController>().closeVideo();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                            if (controller.canPlay)
                              StatefulBuilder(builder: (context, setState) {
                                return IconButton(
                                  onPressed: () {
                                    if (controller.controller?.isVideoPlaying ??
                                        false) {
                                      controller.controller?.pause();
                                      controller.controller?.hideOverlay();
                                    } else {
                                      controller.controller?.play();
                                    }
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    (controller.controller?.isVideoPlaying ??
                                            false)
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.black,
                                  ),
                                );
                              }),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller
                                            .selectedAttachment.value?.title ??
                                        '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    controller.selectedAttachment.value
                                            ?.description ??
                                        '',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                          ]),
                        ),
                      ),
                    ),
                    Expanded(
                        child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Obx(() {
                        return Directionality(
                          textDirection: TextDirection.ltr,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              if (controller.controller != null)
                                IgnorePointer(
                                  ignoring:
                                      widget.height < 1 || !controller.canPlay,
                                  child: PodVideoPlayer(
                                    controller: controller.controller!,
                                    backgroundColor: Colors.black,
                                    matchFrameAspectRatioToVideo: true,
                                  ),
                                )
                              else
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    width: Get.width,
                                    color: Colors.black,
                                  ),
                                ),
                              if (!controller.canPlay)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.7),
                                    alignment: AlignmentDirectional.center,
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: widget.height < 0.9
                                          ? const SizedBox(
                                              key: ValueKey('sub1'))
                                          : _SubscribeTopButton(
                                              height: widget.height,
                                              chapter:
                                                  controller.chapter.value!,
                                            ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    )),
                  ],
                ),
              ),
            ),
            if (controller.selectedAttachment.value != null)
              Opacity(
                opacity: widget.height.withRange(0, 1).toDouble(),
                child: Stack(
                  children: [
                    const Positioned.fill(
                        child: ColoredBox(color: Colors.black)),
                    Container(
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        controller.selectedAttachment.value!.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(height: 80),
            Expanded(
              child: Obx(() {
                return CustomScrollView(
                  slivers: [
                    SliverStickyHeader(
                      header: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                const Divider(
                                  color: Color.fromARGB(106, 161, 160, 160),
                                  height: 1,
                                ),
                                const SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      ...PlayerMainTabs.values.map(
                                        (e) => Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  end: 10),
                                          child: SizedBox(
                                            height: 33,
                                            child: TextButton(
                                              onPressed: () {
                                                controller.selectedTab.value =
                                                    e;
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: controller
                                                            .selectedTab
                                                            .value ==
                                                        e
                                                    ? Colors.black
                                                    : Colors.grey.shade200,
                                                foregroundColor: controller
                                                            .selectedTab
                                                            .value ==
                                                        e
                                                    ? Colors.white
                                                    : Colors.black,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                minimumSize: Size.zero,
                                              ),
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${e.name} ',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: e
                                                          .count(controller
                                                              .chapter.value!)
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 16,
                            width: Get.width,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: AlignmentDirectional.topCenter,
                                end: AlignmentDirectional.bottomCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                  Color(0x00FFFFFF),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      sliver:
                          controller.selectedTab.value == PlayerMainTabs.videos
                              ? const VideosList()
                              : const FilesList(),
                    ),
                  ],
                );
              }),
            ),
            Obx(() {
              if (controller.canPlay) {
                return const SizedBox();
              }
              return SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: PrimaryButton(
                      onTap: () async {
                        final chapter = controller.chapter.value!;
                        await SubscribeDialog.show(chapter);
                      },
                      text:
                          'اشتراك ${controller.chapter.value?.price.toCurrency} د.ع',
                    ),
                  ));
            })
          ],
        ),
      );
    });
  }
}

class _SubscribeTopButton extends StatelessWidget {
  const _SubscribeTopButton({
    required this.height,
    required this.chapter,
  });

  final double height;
  final ChapterWithDetails chapter;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: height.withRange(0.3, 1).toDouble(),
      child: Column(
        key: const ValueKey('sub2'),
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () async {
              await SubscribeDialog.show(chapter);
            },
            style: TextButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'اشتراك',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'يجب الاشتراك لمشاهدة بقية المحاضرات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
