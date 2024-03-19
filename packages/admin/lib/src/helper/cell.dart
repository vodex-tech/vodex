import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'formatter.dart';
import 'validator.dart';

class Cell<T> {
  final String id;
  final double? minWidth;

  final String title;
  final T value;
  final FieldFormatter<T> formatter;
  final List<String>? options;
  final Future<List<String>> Function()? optionsAsync;

  final Validation<T> validator;
  final bool Function() showWhen;
  final bool canEdit;
  final bool hideColumn;
  final int? maxLines;
  final Size size;
  int? sizeOrDuration;
  String? payload;
  final Function(Cell<T>)? onEdit;

  Cell(
    this.value, {
    required this.id,
    required this.formatter,
    this.minWidth,
    String? title,
    this.options,
    this.optionsAsync,
    Validation<T>? validator,
    bool Function()? showWhen,
    this.canEdit = true,
    this.hideColumn = false,
    this.maxLines,
    this.size = const Size(0, 0),
    this.sizeOrDuration,
    this.onEdit,
  })  : title = title ?? id.titleCase,
        validator = validator ?? ((v) => true),
        showWhen = showWhen ?? (() => true);

  String get formatted => formatter.fromData(value);

  late T _newValue = value;

  T get newValue => _newValue;
  set newValue(T v) {
    _newValue = v;
    onEdit?.call(this);
  }

  dynamic get firestoreValue => formatter.toFirestore(newValue);

  String get formattedNewValue => formatter.fromData(newValue);
  set formattedNewValue(String v) {
    newValue = formatter.toData(v);
    onEdit?.call(this);
  }

  bool validate(String x) => validator(formatter.toData(x));

  bool get isValid => validator(newValue) || !canEdit;
}

class CellText extends Cell<String> {
  CellText(
    String? value, {
    required super.id,
    super.minWidth,
    super.title,
    super.validator,
    super.showWhen,
    super.canEdit,
    super.hideColumn,
    super.maxLines,
    super.onEdit,
  }) : super(
          value ?? '',
          formatter: FieldFormatter.string(),
        );
}

class CellNumber extends Cell<int> {
  CellNumber(
    int? value, {
    required super.id,
    super.minWidth,
    super.title,
    super.validator,
    super.showWhen,
    super.canEdit,
    super.hideColumn,
    super.onEdit,
    FieldFormatter<int>? formatter,
  }) : super(
          value ?? 0,
          formatter: formatter ??
              FieldFormatter(
                fromData: (v) => v.toString(),
                toData: (v) => int.tryParse(v) ?? 0,
              ),
        );
}

class CellEnum<T extends Enum> extends Cell<T> {
  CellEnum(
    super.value, {
    required super.id,
    super.minWidth,
    super.title,
    super.showWhen,
    super.canEdit,
    super.hideColumn,
    super.onEdit,
    required List<T> values,
    String Function(T)? formatter,
    dynamic Function(T)? toFirestore,
  }) : super(
          formatter: FieldFormatter(
            fromData: (x) => formatter?.call(x) ?? x.name.titleCase,
            toData: (x) {
              return values.firstWhere(
                  (e) => (formatter?.call(e) ?? e.name.titleCase) == x);
            },
            toFirestore: toFirestore ?? (x) => x.name,
          ),
          options: values
              .map((e) => formatter?.call(e) ?? e.name.titleCase)
              .toList(),
        );
}

class CellOptions extends Cell<String> {
  CellOptions(
    String? value, {
    required super.id,
    super.minWidth,
    super.title,
    super.showWhen,
    super.canEdit,
    super.hideColumn,
    super.optionsAsync,
    super.options,
    super.onEdit,
  })  : assert(options != null || optionsAsync != null,
            'options or optionsAsync must be provided'),
        super(
          value ?? '',
          formatter: FieldFormatter.string(),
        );
}
class CellOptionsGeneric<T> extends Cell<T> {
  CellOptionsGeneric(
    T value, {
    required super.id,
    required super.formatter,
    super.minWidth,
    super.title,
    super.showWhen,
    super.canEdit,
    super.hideColumn,
    super.optionsAsync,
    super.options,
    super.onEdit,
  })  : assert(options != null || optionsAsync != null,
            'options or optionsAsync must be provided'),
        super(
          value,
        );
}

class CellBoolean extends Cell<bool> {
  CellBoolean(
    bool? value, {
    required super.id,
    super.minWidth,
    super.title,
    super.showWhen,
    super.canEdit,
    super.hideColumn,
    super.onEdit,
  }) : super(
          value ?? false,
          formatter: FieldFormatter.boolean(),
        );
}

class CellDateTime extends Cell<DateTime> {
  CellDateTime(
    DateTime? value, {
    required super.id,
    super.minWidth,
    super.title,
    super.showWhen,
    super.canEdit,
    super.hideColumn,
    super.validator,
    super.onEdit,
    String? format,
  }) : super(
          value ?? DateTime.now(),
          formatter: FieldFormatter.dateTimeStamp(format),
        );
}

class CellImage extends Cell<String> {
  CellImage(
    String? value, {
    required super.id,
    super.minWidth,
    super.title,
    super.showWhen,
    super.canEdit,
    super.hideColumn,
    super.onEdit,
    required super.size,
  }) : super(
          value ?? '',
          formatter: FieldFormatter.string(),
          validator: Validator.isNotEmpty,
        );
}

class CellFile extends Cell<String> {
  CellFile(
    String? value, {
    required super.id,
    super.minWidth,
    super.title,
    super.showWhen,
    super.canEdit,
    super.hideColumn,
    super.onEdit,
  }) : super(
          value ?? '',
          formatter: FieldFormatter.string(),
          validator: Validator.isNotEmpty,
        );
}
