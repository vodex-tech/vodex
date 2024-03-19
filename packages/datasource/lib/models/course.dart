import 'package:datasource/src/enum_from_string.dart';

import '../src/base.dart';

enum CourseStatus {
  active,
  inactive,
  deleted,
}

class Course extends BaseModel {
  final String title;
  final String subject;
  final String description;
  final String image;
  final String teacher;
  final String university;
  final String college;
  final String department;
  final String branch;
  final String stage;
  final CourseStatus status;
  final int price;
  final int originalPrice;

  @override
  List<String> get searchTerms => [title, teacher];

  @override
  List<String> get additionalSearchTerms => [id];

  Course({
    super.id,
    super.createdAt,
    required this.title,
    required this.subject,
    required this.description,
    required this.image,
    required this.teacher,
    required this.university,
    required this.college,
    required this.department,
    required this.branch,
    required this.stage,
    required this.price,
    required this.originalPrice,
    this.status = CourseStatus.active,
  });

  Course.fromMap(super.data)
      : title = data['title'],
        subject = data['subject']??'',
        description = data['description'],
        image = data['image'],
        teacher = data['teacher'],
        university = data['university'],
        college = data['college'],
        department = data['department'],
        branch = data['branch'],
        stage = data['stage'],
        price = data['price'] ?? 0,
        originalPrice = data['originalPrice'] ?? 0,
        status = getEnumFromString(data['status'], CourseStatus.values,
            defaultValue: CourseStatus.active),
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'description': description,
      'image': image,
      'teacher': teacher,
      'university': university,
      'college': college,
      'department': department,
      'branch': branch,
      'stage': stage,
      'price': price,
      'originalPrice': originalPrice,
      'status': status.name,
      ...super.toMap(),
    };
  }
}
