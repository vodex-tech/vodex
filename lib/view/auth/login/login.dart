import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logic_study/view/components/primary_button.dart';
import 'package:logic_study/functions/min_max.dart';
import 'package:logic_study/view/auth/login/controller.dart';
import 'package:logic_study/view/auth/widgets/text_field.dart';

class LogInScreen extends GetView<LogInController> {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackButton(),
                  SizedBox(height: 40),
                  Text(
                    'تسجيل الدخول',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 33.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.right,
                    'سجل الدخول عن طريق أحد حساباتك الخاصة، أو قم بإنشاء حساب جديد.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          IgnorePointer(
            child: SafeArea(
              child: Image.asset(
                'assets/images/bg2.png',
                width: double.maxFinite,
                height: double.maxFinite,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(22),
                ),
              ),
              child: SafeArea(
                top: false,
                child: LayoutBuilder(builder: (context, size) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 300,
                      maxHeight: [
                        [size.maxHeight - 365, 300].max,
                        600
                      ].min,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: 4,
                            width: 97,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(155, 158, 158, 158),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        AuthTextField(
                          icon: Iconsax.user,
                          hintText: 'البريد الالكرتوني',
                          onChanged: (v) => controller.email(v),
                          isEmail: true,
                          autofocus: true,
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          icon: Iconsax.lock,
                          hintText: 'كلمة المرور',
                          showPassword: controller.showPassword,
                          onChanged: (v) => controller.password(v),
                        ),
                        const SizedBox(height: 40),
                        Obx(() => PrimaryButton(
                              text: 'تسجيل الدخول',
                              backgroundColor: const Color(0xff409CFF),
                              foregroundColor: Colors.white,
                              status: controller.isValid
                                  ? ButtonStatus.enabled
                                  : ButtonStatus.disabled,
                              focusNode: controller.submitFocusNode,
                              onTap: controller.submit,
                            )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
