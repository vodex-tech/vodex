import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/components/confirm.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/theme/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAccountController extends GetxController {
  final _auth = Get.find<Auth>();

  String get email => _auth.user.email;

  Future<String> get version async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  logOut() {
    doAfterConfirm(() => _auth.signOut(),
        message: 'هل انت متأكد من تسجيل الخروج؟');
  }

  rate() {
    RateMyApp(
      preferencesPrefix: 'rateMyApp_',
    ).showStarRateDialog(Get.context!,
        title: 'تقييم التطبيق',
        message: 'اعجبك التطبيق؟ اترك تقييم.',
        actionsBuilder: (context, e) => [
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        if (e != 0) {
                          FirebaseFirestore.instance
                              .collection('appRates')
                              .add({
                            'createdAt': FieldValue.serverTimestamp(),
                            'rate': e,
                            'uid': _auth.user.id,
                            'email': _auth.user.email,
                          });
                        }
                        if ((e ?? 0) > 3) {
                          launchUrl(Uri.parse('www.logic-study.com/download'),
                              mode: LaunchMode.externalApplication);
                        }
                        Get.back();
                      },
                      child: Text(
                        'تم',
                        style: TextStyle(
                            color: e == 0 ? Colors.grey : AppColors.primary,
                            fontWeight: FontWeight.bold),
                      )),
                  TextButton(
                      onPressed: Get.back,
                      child: const Text(
                        'الغاء',
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              ),
            ]);
  }
}
