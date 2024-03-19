import 'package:datasource/datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kr_button/text_button.dart';
import 'package:logic_study/functions/extensions.dart';
import 'package:logic_study/theme/colors.dart';
import 'package:logic_study/view/courses/controllers/course_controller.dart';
import 'package:logic_study/view/video_player/controller.dart';

class ChapterTile extends GetView<CourseController> {
  const ChapterTile({super.key, required this.chapter});

  final ChapterWithDetails chapter;

  @override
  Widget build(BuildContext context) {
    AttachmentStats stats =
        (duration: Duration.zero, fileCount: 0, videosCount: 0);
    return KrTextButton(
      onPressed: () async {
        await Get.find<VideoController>().show(chapter, stats);
      },
      onLoading: const SizedBox(
        height: 37,
        child: Center(
          child: SpinKitRing(
            color: AppColors.primary,
            size: 20,
            lineWidth: 2,
          ),
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 20,
                    child: Builder(builder: (context) {
                      stats = chapter.stats;
                      final list = [
                        if (stats.videosCount == 0)
                          Text(
                            'No content',
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey.shade700),
                          )
                        else ...[
                          if (stats.duration != Duration.zero)
                            Text(
                              '${stats.duration.inHours} H ${stats.duration.inMinutes.remainder(60)} Min',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey.shade700),
                            ),
                          if (stats.videosCount != 0)
                            Text(
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey.shade700),
                                '${stats.videosCount} Videos'),
                          if (stats.fileCount != 0)
                            Text(
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey.shade700),
                                '${stats.fileCount} files'),
                        ],
                      ];
                      return ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        itemBuilder: (context, index) =>
                            Center(child: list[index]),
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/dot.png',
                            width: 5,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (controller.isSubscribed.value ||
                        chapter.isSubscribed) ...[
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    ] else if (chapter.isFree) ...[
                      const Text(
                        'Free',
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ] else ...[
                      Text(
                        chapter.price.toCurrency,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'IQD',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ]
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
