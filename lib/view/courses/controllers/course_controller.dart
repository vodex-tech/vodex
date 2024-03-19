import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datasource/datasource.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/auth/auth/controller.dart';

class CourseController extends GetxController {
  final Course course;

  CourseController({required this.course});

  final _datasource = Get.find<Datasource>();
  final _auth = Get.find<Auth>();

  final selectedTab = 0.obs;
  final isSubscribed = false.obs;
  bool get isAdmin => _auth.isAdmin;

  Query<Chapter> get getChapters => _datasource.chaptersByCourse(course.id);

  Future<AttachmentStats> chapterStats(String id) async {
    if (_chapterStats[id] != null) return _chapterStats[id]!;
    _chapterStats[id] = await _datasource.getChapterStats(id);
    return _chapterStats[id]!;
  }

  Future<List<ChapterWithDetails>> get chapters async {
    final chapters = await getChapters.get();
    final userId = _auth.user.id;
    final subscribedItems =
        await _datasource.subscribedItems(course.id, userId).get();
    final subscriptions =
        subscribedItems.docs.map((e) => e.data().chapterId).toSet();
    isSubscribed.value = subscribedItems.docs.any(
        (e) => e.data().courseId == course.id && e.data().chapterId == null);
    return Future.wait(chapters.docs.map((e) async {
      final stats = await chapterStats(e.id);
      return ChapterWithDetails.fromChapter(
        chapter: e.data(),
        isSubscribed: subscriptions.contains(e.id) || isSubscribed.value,
        stats: stats,
      );
    }).toList());
  }

  final Map<String, AttachmentStats> _chapterStats = {};

  @override
  void onClose() {
    selectedTab.close();
    isSubscribed.close();
    super.onClose();
  }
}

class ChapterWithDetails extends Chapter {
  ChapterWithDetails.fromChapter({
    required Chapter chapter,
    required this.isSubscribed,
    required this.stats,
  }) : super(
          id: chapter.id,
          title: chapter.title,
          courseId: chapter.courseId,
          originalPrice: chapter.originalPrice,
          price: chapter.price,
          createdAt: chapter.createdAt,
        );

  final AttachmentStats stats;
  final bool isSubscribed;
  bool get isFree => price == 0;

  @override
  Map<String, dynamic> toMap() => super.toMap()..addAll({});

  ChapterWithDetails copyWith({
    bool? isSubscribed,
  }) {
    return ChapterWithDetails.fromChapter(
      chapter: this,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      stats: stats,
    );
  }
}
