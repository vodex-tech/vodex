import '../src/base.dart';

class AttachmentVideo extends BaseModel {
  final String chapterId;
  final String title;
  final String description;
  final String thumbnail;
  final String videoUrl;
  final int duration;
  final bool isFree;

  @override
  List<String> get searchTerms => [title];

  AttachmentVideo({
    super.id,
    super.createdAt,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.videoUrl,
    required this.duration,
    required this.isFree,
  });

  AttachmentVideo.fromMap(super.data)
      : chapterId = data['chapterId'],
        title = data['title'],
        description = data['description'],
        thumbnail = data['thumbnail'],
        videoUrl = data['videoUrl'],
        duration = data['duration'],
        isFree = data['isFree'] ?? false,
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    return {
      'chapterId': chapterId,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'duration': duration,
      'isFree': isFree,
      ...super.toMap(),
    };
  }
}

typedef AttachmentStats = ({Duration duration, int fileCount, int videosCount});
