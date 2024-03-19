import '../src/base.dart';

enum StudyType {
  university,
  college,
  department,
  branch,
  stage,
}

class Study extends BaseModel {
  final StudyType type;
  final String title;
  final String? parentId;

  @override
  List<String> get searchTerms => [];

  Study({
    super.id,
    super.createdAt,
    required this.type,
    required this.title,
    this.parentId,
  });

  Study.fromMap(super.data)
      : parentId = data['parentId'],
        type = StudyType.values.firstWhere(
          (e) => e.name == data['type'],
          orElse: () => StudyType.university,
        ),
        title = data['title'],
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'type': type.name,
      'title': title,
      ...super.toMap(),
    };
  }
}
