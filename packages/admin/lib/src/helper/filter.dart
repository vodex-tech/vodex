import 'package:cloud_firestore/cloud_firestore.dart';

enum FilterConditionType {
  isEqualTo,
  isNotEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
}

extension FilterCondition<T extends Object?> on Query<T> {
  Query<T> whereField(
    String field, {
    required dynamic value,
    required FilterConditionType condition,
  }) {
    switch (condition) {
      case FilterConditionType.isEqualTo:
        return where(field, isEqualTo: value);
      case FilterConditionType.isNotEqualTo:
        return where(field, isNotEqualTo: value);
      case FilterConditionType.isLessThan:
        return where(field, isLessThan: value);
      case FilterConditionType.isLessThanOrEqualTo:
        return where(field, isLessThanOrEqualTo: value);
      case FilterConditionType.isGreaterThan:
        return where(field, isGreaterThan: value);
      case FilterConditionType.isGreaterThanOrEqualTo:
        return where(field, isGreaterThanOrEqualTo: value);
    }
  }
}
