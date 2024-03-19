import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/components/primary_button.dart';
import 'package:logic_study/functions/min_max.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/routes/routes.dart';
import 'package:logic_study/theme/colors.dart';
import 'package:logic_study/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends GetView<Auth> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: darkSystemUI,
      child: Scaffold(
        body: Stack(
          children: [
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 63),
                    Padding(
                      padding: EdgeInsets.only(),
                      child: Text(
                        'تسجيل الدخول',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 33.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'سجل الدخول عن طريق أحد حساباتك الخاصة، أو قم بإنشاء حساب جديد.',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
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
                        minHeight: 386,
                        maxHeight: [
                          [size.maxHeight - 365, 386].max,
                          600
                        ].min,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: Container(
                              height: 4,
                              width: 97,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(155, 158, 158, 158),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'سجل دخول باستخدام',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 20,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              AuthBorderButton(
                                image: 'assets/images/facebook.svg',
                                onTap: () async {},
                                text: ' Facebook',
                              ),
                              if (Platform.isAndroid)
                                AuthBorderButton(
                                  image: 'assets/images/google.svg',
                                  onTap: () async {},
                                  text: ' Google',
                                ),
                              if (Platform.isIOS)
                                AuthBorderButton(
                                  image: 'assets/images/apple.svg',
                                  onTap: () async {},
                                  text: 'Apple',
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text('او', style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            text: 'انشاء حساب',
                            backgroundColor: const Color(0xff409CFF),
                            foregroundColor: Colors.white,
                            onTap: () async {
                              Get.toNamed(Routes.signUp);
                            },
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.login);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: const Text.rich(
                              TextSpan(
                                text: 'لديك لديك حساب؟ ',
                                style: TextStyle(fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: 'تسجيل الدخول',
                                    style: TextStyle(
                                        color: AppColors.primary, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
      ),
    );
  }
}

class AuthBorderButton extends StatelessWidget {
  const AuthBorderButton({
    super.key,
    this.image,
    required this.onTap,
    required this.text,
  });
  final String? image;
  final String text;
  final Future Function() onTap;
  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onTap: onTap,
      backgroundColor: AppColors.lightGrey,
      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const SizedBox(width: 10),
          SvgPicture.asset(image!),
        ],
      ),
    );
  }
}
