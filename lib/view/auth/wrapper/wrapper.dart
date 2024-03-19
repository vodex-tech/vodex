import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logic_study/theme/theme.dart';

import 'controller.dart';

class WrapperScreen extends GetView<WrapperController> {
  const WrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.init();
    return AnnotatedRegion(
      value: lightSystemUI,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5FADFF),
              Color(0xFF248EFF),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/svg/logo.svg',
          fit: BoxFit.cover,
          width: 82,
          height: 82,
        ),
      ),
    );
  }
}
