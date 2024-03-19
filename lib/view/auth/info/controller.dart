import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datasource/models/study.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datasource/datasource.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/view/auth/info/options.dart';
import 'package:logic_study/view/home/home_page.dart';

class UserInfoController extends GetxController {
  final _auth = Get.find<Auth>();
  final _datasource = Get.find<Datasource>();

  final agreedToTerms = false.obs;
  final showPassword = false.obs;
  final email = (FirebaseAuth.instance.currentUser?.email ?? '').obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  late final id = FirebaseAuth.instance.currentUser?.uid ?? '';
  String university = '';
  String college = '';
  String department = '';
  String branch = '';
  String stage = '';

  final submitFocusNode = FocusNode();

  bool get isValid =>
      email.value.isEmail &&
      password.value.length >= 6 &&
      confirmPassword.value == password.value &&
      agreedToTerms.value;

  Future submit() async {
    if (id.isNotEmpty) {
      Get.offAll(
        AccountSetupScreen(
          title: 'الجامعة',
          message: 'قم بأختيار الجامعة التي تدرس فيها',
          type: StudyType.university,
          onSubmit: submitUnviersity,
        ),
      );
    }
  }

  Future submitUnviersity(String value) async {
    university = value;
    Get.to(
        () => AccountSetupScreen(
              title: 'الكلية',
              message: 'قم بأختيار الكلية التي تدرس فيها',
              type: StudyType.college,
              parentId: university,
              onSubmit: submitCollege,
            ),
        routeName: '/account_setup/college');
  }

  Future submitCollege(String value) async {
    college = value;
    Get.to(
      () => AccountSetupScreen(
        title: 'القسم',
        message: 'قم بأختيار القسم التي تدرس فيه',
        type: StudyType.department,
        parentId: college,
        onSubmit: submitDepartment,
      ),
      routeName: '/account_setup/department',
    );
  }

  Future submitDepartment(String value) async {
    department = value;
    Get.to(
      () => AccountSetupScreen(
        title: 'الفرع',
        message: 'قم بأختيار الفرع الذي تدرس فيه',
        type: StudyType.branch,
        onSubmit: submitBranch,
      ),
      routeName: '/account_setup/branch',
    );
  }

  Future submitBranch(String value) async {
    branch = value;
    Get.to(
      () => AccountSetupScreen(
        title: 'المرحلة',
        message: 'قم بأختيار المرحلة الدراسية',
        type: StudyType.stage,
        onSubmit: submitStage,
      ),
      routeName: '/account_setup/stage',
    );
  }

  Future submitStage(String value) async {
    try {
      stage = value;
      await FirebaseFirestore.instance.collection('users').doc(id).update({
        'university': university,
        'college': college,
        'department': department,
        'branch': branch,
        'stage': stage,
      });
      homePageKey = UniqueKey();
      await _auth.initAuth();
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'An error occured while creating your account');
    }
  }

  Future<List<Study>> getOptions(StudyType type, String? parentId) async {
    return _datasource.getAccountOptionsById(type, parentId);
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
