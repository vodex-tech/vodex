import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/view/auth/info/options.dart';

class SignUpController extends GetxController {
  final _auth = Get.find<Auth>();

  final agreedToTerms = false.obs;
  final showPassword = false.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  final submitFocusNode = FocusNode();

  bool get isValid =>
      email.value.isEmail &&
      password.value.length >= 6 &&
      confirmPassword.value == password.value &&
      agreedToTerms.value;

  Future submit() async {
    await _auth.signUp(email.value, password.value) ?? '';
    Get.offAll(const AccountSetupScreenWrapper());
  }

  @override
  void onClose() {
    email.close();
    password.close();
    confirmPassword.close();
    agreedToTerms.close();
    showPassword.close();
    submitFocusNode.dispose();
    super.onClose();
  }
}
