import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

DateTime? toDateTime(dynamic date) {
  if (date == null) return null;
  if (date is String) {
    List _type = date.split(' ');
    List _date = _type[0].split('/');
    List _time = _type[1].split(':');
    if (_time.length == 2) _time.add('0');
    return DateTime(
        int.parse(_date[0]),
        int.parse(_date[1]),
        int.parse(_date[2]),
        int.parse(_time[0]),
        int.parse(_time[1]),
        int.parse(_time[2]));
  }
  if (date is Timestamp) return date.toDate();
  if (date is int) return DateTime.fromMillisecondsSinceEpoch(date);
  return null;
}

String? dateToString(DateTime? date) => date == null
    ? null
    : '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}:${date.second}';

extension DateTimeFormat on DateTime {
  String get fullDate => format('MMM d, yyyy - HH:mm a');
  String get ago {
    int min = DateTime.now().difference(this).inMinutes;
    int count = 0;
    if (min < 60) {
      count = math.max(min, 0);
      return '$count دقيقة';
    } else if (min < 60 * 24) {
      count = min ~/ 60;
      return '$count ساعة';
    } else if (min < 60 * 24 * 7) {
      count = min ~/ (60 * 24);
      return '$count يوم';
    } else {
      count = min ~/ (60 * 24 * 7);
      return '$count اسبوع';
    }
  }

  String format(String format) {
    initializeDateFormatting();
    return DateFormat(format, Get.locale?.languageCode).format(this);
  }

  DateTime get withoutTime => DateTime(year, month, day);
  DateTime get onlyMonth => DateTime(year, month);
  Timestamp get stamp => Timestamp.fromDate(this);
}

extension Count on int? {
  String get count {
    if (this == null) return '--';
    if (this! < 1000) return '$this';
    if (this! < 1000000) return '${(this! / 1000).toStringAsFixed(1)} الف';
    return '${(this! / 1000).toStringAsFixed(1)} مليون';
  }
}

extension Age on DateTime {
  String get age {
    final now = DateTime.now();
    final age = now.year - year;
    if (now.month < month) return '${age - 1} سنة';
    if (now.month == month && now.day < day) return '${age - 1} سنة';
    return '$age سنة';
  }
}

extension PhoneNumberValidation on String {
  bool get isIraqiPhoneNumber {
    String phoneNumber = this;
    phoneNumber = phoneNumber.replaceAll(' ', '');
    RegExp validPattern = RegExp(
      r'^(?:\+?964|00964)?(75|77|78|79|075|077|078|079)\d{8}$',
    );
    return validPattern.hasMatch(phoneNumber);
  }

  bool get isName {
    final validPattern = RegExp(
        r"^([a-zA-Z]{2,}\s[a-zA-Z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)");
    return validPattern.hasMatch(this);
  }

  bool get isArabicName {
    final validPattern = RegExp(
        r"^([\u0621-\u064A]{2,12}\s[\u0621-\u064A]{1,}'?-?[\u0621-\u064A]{2,}\s?([\u0621-\u064A]{1,})?)");
    return validPattern.hasMatch(this);
  }
}

extension LastTwoNamesFromUsersList on Iterable<String?> {
  String? lastThreeNames([int? others]) {
    if ((others ?? length) == 1) {
      return first;
    }
    if (length == 1 && (others ?? 1) > 1) {
      return '${first ?? 'غير معرف'} و ${others! - 1} آخرين';
    }
    if (length == 2 && (others ?? 2) == 2) {
      return '${first ?? 'غير معرف'} و ${last ?? 'غير معرف'}';
    }
    if (length == 2 && (others ?? 2) > 2) {
      return '${first ?? 'غير معرف'} و ${last ?? 'غير معرف'} و ${others! - 2} آخرين';
    }
    return '${first ?? 'غير معرف'} و ${elementAt(1) ?? 'غير معرف'} و ${(others ?? length) - 2} آخرين';
  }
}

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String mathFunc(Match match) => '${match[1]},';

String convertMoney(int data) =>
    data.toString().replaceAllMapped(reg, mathFunc);

extension StringToCurrency on String {
  String get toCurrency => replaceAllMapped(reg, mathFunc);
}

extension StringSplit on String {
  List<String> get urls {
    RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(this);

    var texts = split(exp);
    var links = matches.map((e) => substring(e.start, e.end));
    for (int i = 0; i < links.length; i++) {
      texts.insert(i + i + 1, links.elementAt(i));
    }
    return texts;
  }
}

// extension IntToCurrency on num?{
//   String get toCurrency => toString().toCurrency;
// }
extension NullableIntToCurrency on num? {
  String get toCurrency => this == null ? '0' : toString().toCurrency;
}

extension MaxMinIterable on Iterable<int> {
  int get max => reduce(math.max);

  int get min => reduce(math.min);
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String toTitleCase() => replaceAll(r'$', ' ')
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.toCapitalized())
      .join(" ");
}

extension Generator on String {
  List<String> get generateSearchTerms {
    List<String> terms = [];
    for (int i = 0; i < length; i++) {
      for (int j = 0; j < length - i; j++) {
        terms.add(substring(j, i + j + 1));
      }
    }
    return terms;
  }
}

extension Phone on String {
  String get phoneUniversal {
    if (length < 6) return this;
    String x = replaceAll(' ', '');
    if (x.substring(0, 2) == '00') return x;
    if (x.substring(0, 1) == '0') x = x.substring(1);
    if (x.substring(0, 3) == '964') return '+$x';
    if (x.substring(0, 1) == '+') return x;
    return '+964$x';
  }

  String get phoneLocally {
    if (length < 6) return this;
    String x = replaceAll(' ', '');
    if (x.substring(0, 1) == '+') x = x.substring(1);

    if (x.substring(0, 3) == '964') x = x.substring(3);
    if (x.substring(0, 1) != '0') x = '0$x';
    return x;
  }
}


extension NumRange on num {
  num withRange(double min, double max) => this < min ? min : this > max ? max : this;
}