import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class BaseModel {
  final String id;
  final DateTime? createdAt;

  List<String> get searchTerms => [];
  List<String> get additionalSearchTerms => [];

  BaseModel({
    String? id,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  @mustCallSuper
  @mustBeOverridden
  @useResult
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
      'searchTerms': generateSearchTerms,
    };
  }

  BaseModel.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        createdAt = data['createdAt'].toDate();

  List<String> get generateSearchTerms {
    List<String> terms = [];
    for (final term in searchTerms) {
      for (int i = 0; i < term.length; i++) {
        for (int j = 0; j < term.length - i; j++) {
          terms.add(term.substring(j, i + j + 1).toLowerCase());
        }
      }
    }
    terms.addAll(additionalSearchTerms);
    return terms;
  }
}
