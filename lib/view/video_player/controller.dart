import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datasource/datasource.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/view/courses/controllers/course_controller.dart';
import 'package:logic_study/view/video_player/sliding_box.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:pod_player/pod_player.dart';

enum PlayerMainTabs { videos, files }

extension PlayerMainTabsExtension on PlayerMainTabs {
  String get name {
    switch (this) {
      case PlayerMainTabs.videos:
        return 'المحاضرات';
      case PlayerMainTabs.files:
        return 'الملفات';
    }
  }

  int count(ChapterWithDetails chapter) {
    switch (this) {
      case PlayerMainTabs.videos:
        return chapter.stats.videosCount;
      case PlayerMainTabs.files:
        return chapter.stats.fileCount;
    }
  }
}

class VideoController extends GetxController {
  final _datasource = Get.find<Datasource>();
  final _auth = Get.find<Auth>();

  final boxController = BoxController();

  PodPlayerController? controller;

  bool get isAdmin => _auth.isAdmin;

  final chapter = Rx<ChapterWithDetails?>(null);
  final attachmentStats =
      (duration: Duration.zero, fileCount: 0, videosCount: 0).obs;

  final selectedAttachment = Rx<AttachmentVideo?>(null);
  final isPlaying = false.obs;

  bool isButtonsShown = true;

  final selectedTab = PlayerMainTabs.videos.obs;

  bool get canPlay =>
      selectedAttachment.value?.isFree == true ||
      chapter.value?.isSubscribed == true;

  bool canPlayAttachment(dynamic attachment) {
    selectedAttachment.value;
    return attachment.isFree || chapter.value?.isSubscribed == true;
  }

  show(ChapterWithDetails chapter, AttachmentStats stats) async {
    try {
      final res = await _datasource.getFirstVideo(chapter);
      if (res == null && !_auth.isAdmin) {
        Get.snackbar('لا يوجد فيديو', 'لا يوجد فيديو في هذا الفصل');
        return;
      }
      if (res != null) {
        playAttachment(res);
      }

      this.chapter.value = chapter;
      boxController.openBox();
    } catch (e) {
      print(e);
    }
  }

  playAttachment(AttachmentVideo attachment) {
    selectedAttachment.value = attachment;
    final video = PlayVideoFrom.youtube(attachment.videoUrl);
    final config = PodPlayerConfig(autoPlay: canPlay);
    if (controller == null) {
      controller = PodPlayerController(
        playVideoFrom: video,
        podPlayerConfig: config,
      )..initialise();
      controller!.addListener(_listener);
    } else {
      controller!.changeVideo(
        playVideoFrom: video,
        playerConfig: config,
      );
    }
    if (canPlay) NoScreenshot.instance.screenshotOff();
  }

  void _listener() {
    isPlaying.value = controller?.isVideoPlaying ?? false;
    if (isPlaying.value) {
      NoScreenshot.instance.screenshotOff();
    } else {
      NoScreenshot.instance.screenshotOn();
    }
  }

  closeVideo() async {
    chapter.value = null;
    attachmentStats.value =
        (duration: Duration.zero, fileCount: 0, videosCount: 0);
    selectedAttachment.value = null;
    boxController.closeBox();
    final oldController = controller;
    controller = null;
    oldController?.pause();
    await Future.delayed(const Duration(milliseconds: 500));
    controller?.dispose();
    NoScreenshot.instance.screenshotOn();
  }

  Query<AttachmentVideo> get videosQuery =>
      _datasource.getVideos(chapter.value!);

  Query<AttachmentFile> get filesQuery => _datasource.getFiles(chapter.value!);
}
