import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/auth/auth/controller.dart';

class LogInController extends GetxController {

  final _auth = Get.find<Auth>();

  final showPassword = false.obs;
  final email = ''.obs;
  final password = ''.obs;

  final submitFocusNode = FocusNode();

  bool get isValid =>
      email.value.isEmail &&
      password.value.length >= 6;

  Future submit() => _auth.signIn(email.value, password.value);

  @override
  void onClose() {
    email.close();
    password.close();
    showPassword.close();
    submitFocusNode.dispose();
    super.onClose();
  }
}
