import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:logic_study/theme/colors.dart';

doWhile(Future Function() fun) async {
  Get.dialog(
    const _LoadingDialog(),
    barrierDismissible: false,
  );
  await fun();
  Get.back();
}

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
        child:
            const SpinKitRing(color: AppColors.primary, size: 50, lineWidth: 3),
      ),
    );
  }
}
