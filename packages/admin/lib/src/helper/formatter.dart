import 'package:intl/intl.dart';
import 'package:kr_extensions/kr_extensions.dart';

String toString<T>(T v) => v.toString();

class FieldFormatter<T> {
  final T Function(String) toData;
  final String Function(T) fromData;
  final dynamic Function(T)? _toFirestore;

  FieldFormatter({
    required this.fromData,
    required this.toData,
    dynamic Function(T)? toFirestore,
  }) : _toFirestore = toFirestore;

  dynamic toFirestore(dynamic value) {
    if (value is! T) {
      throw 'Value is not of type $T';
    }
    return _toFirestore?.call(value) ?? value;
  }

  FieldFormatter.dateTimeStamp([String? format])
      : this(
          fromData: (x) => (x as DateTime).format(format ?? 'dd-MM-yyyy HH:mm'),
          toData: (x) => DateFormat(format ?? 'dd-MM-yyyy HH:mm').parse(x) as T,
          toFirestore: (v) => (v as DateTime).stamp,
        );

  FieldFormatter.string()
      : this(
          fromData: (x) => x.toString(),
          toData: (x) => x as T,
        );

  FieldFormatter.boolean()
      : this(
          fromData: (x) => x.toString(),
          toData: (x) => (x == 'true') as T,
        );

  FieldFormatter.price()
      : this(
          fromData: (x) => (x as num).toCurrency,
          toData: (x) => (int.tryParse(x.replaceAll(',', '')) ?? 0) as T,
        );
}
