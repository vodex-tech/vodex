import 'package:datasource/datasource.dart';
import 'package:datasource/models/subscription.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/components/toast.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/view/courses/controllers/course_controller.dart';
import 'package:logic_study/view/courses/subscribe/zain.dart';
import 'package:logic_study/view/video_player/controller.dart';

class SubscriptionController extends GetxController {
  final dynamic data;

  SubscriptionController({required this.data});

  final _auth = Get.find<Auth>();
  final _datasource = Get.find<Datasource>();

  Future payWithZainCash() async {
    try {
      ZainCash zainCash =
          ZainCash(amount: data.price.toDouble(), itemName: data.title);
      var res = await zainCash.request();
      if (res != null) {
        await addSubscription(PaymentMethod.zainCash, res.toJson);
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        'خطأ',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  payWithApplePay(Map<String, dynamic> json) async {
    await addSubscription(PaymentMethod.applePay, json);
  }

  addSubscription(PaymentMethod method, Map<String, dynamic>? json) async {
    final Subscription subscription;
    final user = _auth.user;
    final isCourse = data is Course;
    if (isCourse) {
      final course = data as Course;
      subscription = Subscription(
        courseId: course.id,
        chapterId: null,
        userId: user.id,
        paymentMethod: method,
        amount: course.price,
        baseAmount: course.originalPrice,
        coupon: '',
        itemName: course.title,
        userEmail: user.email,
        data: json ?? {},
      );
    } else {
      final chapter = data as ChapterWithDetails;
      subscription = Subscription(
        courseId: chapter.courseId,
        chapterId: chapter.id,
        userId: user.id,
        paymentMethod: method,
        amount: chapter.price,
        baseAmount: chapter.originalPrice,
        coupon: '',
        itemName: chapter.title,
        userEmail: user.email,
        data: json ?? {},
      );
    }
    await _datasource.put(subscription);
    Get.find<CourseController>().isSubscribed.value = true;
    if (data is! Course) {
      Get.find<CourseController>().isSubscribed.value = false;
      final chapter = data as ChapterWithDetails;
      Get.find<VideoController>().chapter.value =
          chapter.copyWith(isSubscribed: true);
    }
    Get.back();
    showSuccessToast('تم الدفع بنجاح');
  }
}
