import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';

showToast(String message) {
  MotionToast.error(
    description: Text(message),
    toastDuration: const Duration(seconds: 5),
    constraints: const BoxConstraints(maxHeight: 100, minHeight: 50),
    displaySideBar: false,
    animationType: AnimationType.fromTop,
    position: MotionToastPosition.top,
  ).show(Get.context!);
}

showSuccessToast(String message) {
  MotionToast.success(
    description: Text(message),
    toastDuration: const Duration(seconds: 5),
    constraints: const BoxConstraints(maxHeight: 100, minHeight: 50),
    displaySideBar: false,
    animationType: AnimationType.fromTop,
    position: MotionToastPosition.top,
  ).show(Get.context!);
}