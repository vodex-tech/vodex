import 'package:get/get.dart';
import 'package:kr_extensions/kr_extensions.dart';

typedef Validation<T> = bool Function(T);

class Validator {
  final Validation validator;

  Validator(this.validator);

  static Validation<String> isNotEmpty = ((v) => v.isNotEmpty);
  static Validation<String> isEmail = ((v) => v.isEmail);
  static Validation<String> isNumeric = ((v) => v.isNumericOnly);
  static Validation<String> isUrl = ((v) => v.isURL);
  static Validation<String> isPhone = ((v) => v.isPhoneNumber);
  static Validation<num> isIraqiPrice = ((v) => v % 250 == 0);
  static Validation<String> isPassword = ((v) => v.length >= 6);
  static Validation<DateTime> futureDate = ((v) => v.isAfter(DateTime.now()));
  static Validation<DateTime> todayOrFuture =
      ((v) => v.isAfter(DateTime.now().withoutTime));
  static Validation<DateTime> pastDate = ((v) => v.isBefore(DateTime.now()));
  static Validation<DateTime> beforDate(DateTime date) =>
      ((v) => v.isBefore(date));
  static Validation<DateTime> afterDate(DateTime date) =>
      ((v) => v.isAfter(date));
  static Validation<DateTime> betweenDates(DateTime start, DateTime end) =>
      ((v) => v.isAfter(start) && v.isBefore(end));
}
