import 'package:datasource/datasource.dart';
import 'package:datasource/models/study.dart';
import 'package:datasource/models/subscription.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datasource/src/datasource.dart';

export 'models/course.dart';
export 'models/user.dart';
export 'models/chapter.dart';
export 'models/video.dart';
export 'models/file.dart';
export 'src/datasource.dart' hide DatasourceBase;

part 'queries.dart';

class Datasource extends DatasourceBase {
  @override
  final cachedTypes = [];

  @override
  final registeredModels = [
    FirestoreModel<User>(User.fromMap),
    FirestoreModel<Course>(Course.fromMap),
    FirestoreModel<Chapter>(Chapter.fromMap),
    FirestoreModel<AttachmentVideo>(AttachmentVideo.fromMap),
    FirestoreModel<AttachmentFile>(AttachmentFile.fromMap),
    FirestoreModel<Subscription>(Subscription.fromMap),
    FirestoreModel<Study>(Study.fromMap),
  ];

  Future<List<Study>> getAccountOptionsById(
      StudyType type, String? parentId) async {
    var query = collection<Study>().where('type', isEqualTo: type.name);
    if (parentId != null) {
      query = query.where('parentId', isEqualTo: parentId);
    }
    final res = await query.get();
    if (type == StudyType.stage) {
      final sortedFields = ['اول', 'ثاني', 'ثالث', 'رابع', 'خامس', 'سادس'];
      return res.docs.map((e) => e.data()).toList()
        ..sort((a, b) {
          final aIndex = sortedFields.indexWhere((e) => a.title.contains(e));
          final bIndex = sortedFields.indexWhere((e) => b.title.contains(e));
          return aIndex - bIndex;
        });
    }
    return res.docs.map((e) => e.data()).toList();
  }

  Query<Course> getCoursesFor(User user) {
    return collection<Course>()
        .where('university', isEqualTo: user.university)
        .where('college', isEqualTo: user.college)
        .where('department', isEqualTo: user.department)
        .where('branch', isEqualTo: user.branch)
        .where('stage', isEqualTo: user.stage);
  }

  Query<Chapter> chaptersByCourse(String courseId) {
    return collection<Chapter>().where('courseId', isEqualTo: courseId);
  }

  Query<Subscription> subscribedItems(String courseId, String userId) {
    return collection<Subscription>()
        .where('courseId', isEqualTo: courseId)
        .where('userId', isEqualTo: userId);
  }

  Query<Subscription> allSubscriptions(String userId) {
    return collection<Subscription>().where('userId', isEqualTo: userId);
  }

  Future<AttachmentVideo?> getFirstVideo(Chapter chapter) async {
    final res = await collection<AttachmentVideo>()
        .where('chapterId', isEqualTo: chapter.id)
        .limit(1)
        .get();
    return res.docs.isNotEmpty ? res.docs.first.data() : null;
  }

  Query<AttachmentVideo> getVideos(Chapter chapter) {
    return collection<AttachmentVideo>()
        .where('chapterId', isEqualTo: chapter.id);
  }

  Query<AttachmentFile> getFiles(Chapter chapter) {
    return collection<AttachmentFile>()
        .where('chapterId', isEqualTo: chapter.id);
  }

  Future<AttachmentStats> getChapterStats(String chapterId) async {
    try {
      final videos = await collection<AttachmentVideo>()
          .where('chapterId', isEqualTo: chapterId)
          .aggregate(
            count(),
            sum('duration'),
          );

      final videosCount =
          await videos.count().get().then((value) => value.count) ?? 0;
      final duration = await videos.get().then(
          (value) => Duration(seconds: value.getSum('duration')?.round() ?? 0));

      final files = await collection<AttachmentFile>()
          .where('chapterId', isEqualTo: chapterId)
          .aggregate(
            count(),
          );
      final fileCount =
          await files.count().get().then((value) => value.count) ?? 0;
      return (
        duration: duration,
        videosCount: videosCount,
        fileCount: fileCount
      );
    } catch (e) {
      print(e);
      return (duration: Duration.zero, videosCount: 0, fileCount: 0);
    }
  }
}
