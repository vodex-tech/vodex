import 'dart:math';

import 'package:admin/admin.dart';
import 'package:admin/data/video.dart';
import 'package:datasource/models/video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kr_paginate_firestore/paginate_firestore.dart';
import 'package:logic_study/view/components/image.dart';
import 'package:logic_study/view/components/shimmer.dart';
import 'package:lottie/lottie.dart';

import 'controller.dart';

int x = 0;

class VideosList extends GetView<VideoController> {
  const VideosList({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return KrPaginateFirestore(
        key: ValueKey(controller.chapter.value!.id + x.toString()),
        useInsideScrollView: true,
        itemBuilder: (context, docs, index) {
          final e = docs.elementAt(index).data() as AttachmentVideo;
          return Column(
            children: [
              VideoTile(e, onEdit: () => setState(() => ++x)),
              if (index == docs.length - 1 && controller.isAdmin) ...[
                _AddButton(() => setState(() {
                      ++x;
                    }))
              ] else if (index == docs.length - 1)
                const SafeArea(top: false, child: SizedBox(height: 20)),
            ],
          );
        },
        query: controller.videosQuery,
        itemBuilderType: PaginateBuilderType.listView,
        separator: const SizedBox(height: 12),
        initialLoader: ListView.separated(
          itemCount: 3,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          separatorBuilder: (context, index) {
            return const SizedBox(height: 12);
          },
          itemBuilder: (context, index) {
            return const _PlaceHolder();
          },
        ),
        bottomLoader: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: _PlaceHolder(),
        ),
        onEmpty: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: Text('لا توجد محاضرات')),
                if (controller.isAdmin) _AddButton(() => setState(() {})),
              ],
            )),
      );
    });
  }
}

class VideoTile extends GetView<VideoController> {
  const VideoTile(
    this.attachment, {
    required this.onEdit,
    super.key,
  });

  final AttachmentVideo attachment;
  final Function()? onEdit;

  formatDuration(int duration) {
    final minutes = (duration / 60).floor();
    final seconds = duration % 60;
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.playAttachment(attachment);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: 20,
          end: controller.isAdmin ? 4 : 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 140,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomImage(
                            url: attachment.thumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Obx(() {
                          return Visibility(
                            visible: controller.selectedAttachment.value?.id ==
                                    attachment.id &&
                                controller.canPlayAttachment(attachment),
                            child: Positioned.fill(
                                child: Container(
                              color: Colors.black.withOpacity(0.7),
                              alignment: Alignment.center,
                              child: Obx(() => LottieBuilder.asset(
                                    'assets/animation/playing.json',
                                    repeat: true,
                                    reverse: true,
                                    animate: controller.isPlaying.value,
                                    width: 30,
                                    height: 30,
                                  )),
                            )),
                          );
                        }),
                        Obx(() {
                          return Visibility(
                            visible: !controller.canPlayAttachment(attachment),
                            child: Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.7),
                                alignment: Alignment.center,
                                child: const Icon(Iconsax.lock,
                                    color: Colors.white, size: 30),
                              ),
                            ),
                          );
                        }),
                        PositionedDirectional(
                          bottom: 3,
                          start: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              formatDuration(attachment.duration),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        PositionedDirectional(
                          bottom: 0,
                          end: 0,
                          child: Container(
                            width: 140,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        PositionedDirectional(
                          bottom: 0,
                          end: 0,
                          child: Container(
                            width: (Random().nextInt(120) + 20).toDouble(),
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.title,
                      style: const TextStyle(
                        color: Color(0xFF1D2130),
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      attachment.description,
                      style: const TextStyle(
                        color: Color(0xFF898989),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.isAdmin)
              IconButton(
                onPressed: () async {
                  final res = await edit<AttachmentVideo>(
                      attachment, VideoDataGridProvider(attachment));
                  if (res != null) onEdit?.call();
                },
                icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlaceHolder extends StatelessWidget {
  const _PlaceHolder();

  @override
  Widget build(BuildContext context) {
    return const ShimmerBloc(size: Size(double.maxFinite, 80), radius: 8);
  }
}

class _AddButton extends GetView<VideoController> {
  const _AddButton(this.onSave);

  final Function() onSave;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: TextButton(
          onPressed: () async {
            final attachment = AttachmentVideo(
              chapterId: controller.chapter.value!.id,
              title: '',
              duration: 0,
              thumbnail: '',
              videoUrl: '',
              description: '',
              isFree: false,
            );
            final res = await edit<AttachmentVideo>(
                attachment, VideoDataGridProvider(attachment));
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
          child: const Text('إضافة فيديو جديد'),
        ),
      ),
    );
  }
}
