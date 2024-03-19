import '../src/base.dart';

class AttachmentFile extends BaseModel {
  final String chapterId;
  final String title;
  final String fileUrl;
  final int size;
  final String extension;
  final bool isFree;

  @override
  List<String> get searchTerms => [title];

  AttachmentFile({
    super.id,
    super.createdAt,
    required this.chapterId,
    required this.title,
    required this.fileUrl,
    required this.size,
    required this.extension,
    required this.isFree,
  });

  AttachmentFile.fromMap(super.data)
      : chapterId = data['chapterId'],
        title = data['title'],
        fileUrl = data['fileUrl'],
        size = data['size'],
        extension = data['extension'],
        isFree = data['isFree'] ?? false,
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    return {
      'chapterId': chapterId,
      'title': title,
      'fileUrl': fileUrl,
      'size': size,
      'extension': extension,
      'isFree': isFree,
      ...super.toMap(),
    };
  }
}
