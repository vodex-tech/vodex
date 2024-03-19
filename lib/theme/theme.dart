import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logic_study/theme/colors.dart';

final theme = ThemeData(
  fontFamily: 'Vazirmatn',
  colorScheme: const ColorScheme.light(
    surfaceTint: Colors.transparent,
    primary: AppColors.primary,
  ),
  useMaterial3: true,
);

const lightSystemUI = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarDividerColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
);

const darkSystemUI = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarDividerColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
);
