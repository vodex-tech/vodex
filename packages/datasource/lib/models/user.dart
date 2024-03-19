import 'package:datasource/src/enum_from_string.dart';

import '../src/base.dart';

enum UserType {
  user,
  teacher,
  admin,
}

class User extends BaseModel {
  final String name;
  final String email;
  final UserType type;
  final String university;
  final String college;
  final String department;
  final String branch;
  final String stage;

  @override
  List<String> get searchTerms => [name];

  @override
  List<String> get additionalSearchTerms => [email];

  User({
    required this.name,
    required this.email,
    required this.type,
    required this.university,
    required this.college,
    required this.department,
    required this.branch,
    required this.stage,
    super.id,
    super.createdAt,
  });

  User.fromMap(super.data)
      : name = data['name'],
        email = data['email'],
        type = getEnumFromString(data['type'], UserType.values,
            defaultValue: UserType.user),
        university = data['university'],
        college = data['college'],
        department = data['department'],
        branch = data['branch'],
        stage = data['stage'],
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.name,
      'email': email,
      'university': university,
      'college': college,
      'department': department,
      'branch': branch,
      'stage': stage,
      ...super.toMap(),
    };
  }
}
