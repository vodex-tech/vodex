import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logic_study/routes/routes.dart';
import 'package:logic_study/view/components/primary_button.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'حدث خطأ ما! حاول مرة أخرى.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                onTap: () async => Get.offAllNamed(Routes.wrapper),
                expand: false,
                text: 'اعادة المحاولة',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
