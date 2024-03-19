import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kr_builder/kr_builder.dart';
import 'package:logic_study/view/components/bottom_dialog.dart';
import 'package:logic_study/view/auth/info/options.dart';
import 'package:logic_study/view/common/about.dart';
import 'package:logic_study/view/common/delete_my_account.dart';
import 'package:logic_study/view/common/tearms_and_condition.dart';
import 'package:logic_study/view/home/my_account/controller.dart';
import 'package:logic_study/theme/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: MyAccountController(),
        builder: (controller) {
          return Stack(
            children: [
              Image.asset('assets/images/accountbg.png'),
              SafeArea(
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 42),
                        child: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(214, 255, 255, 255),
                          maxRadius: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Lottie.asset('assets/animation/3.json',
                                width: 62, repeat: false),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(controller.email,
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 170.0),
                  child: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 30),
                    decoration: const BoxDecoration(
                      color: AppColors.greyBackground,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        _Button(
                          title: 'الجامعة التكنلوجيا',
                          icon: Iconsax.teacher,
                          hideArrow: false,
                          onPressed: () {
                            Get.to(const AccountSetupScreenWrapper());
                          },
                        ),
                        _Button(
                          title: 'معلومات عنا',
                          icon: Iconsax.info_circle,
                          onPressed: () {
                            showBottomDialog(context,
                                title: 'معلومات عنا', child: const AboutPage());
                          },
                        ),
                        _Button(
                          title: 'الشروط والاحكام',
                          icon: Iconsax.book,
                          onPressed: () {
                            showBottomDialog(context,
                                title: 'الشروط والاحكام',
                                child: const TermsAndConditions());
                          },
                        ),
                        Builder(builder: (context) {
                          return _Button(
                            title: 'مشاركة التطبيق',
                            icon: Iconsax.share,
                            onPressed: () {
                              final box =
                                  context.findRenderObject() as RenderBox?;
                              Share.share(
                                'حمل تطبيق Logic Study: www.logic-study.com/download',
                                sharePositionOrigin:
                                    box!.localToGlobal(Offset.zero) & box.size,
                              );
                            },
                          );
                        }),
                        _Button(
                          title: 'تقييم التطبيق',
                          icon: Iconsax.star,
                          onPressed: controller.rate,
                        ),
                        _Button(
                          title: 'حذف الحساب',
                          icon: Iconsax.profile_delete,
                          onPressed: () =>
                              Get.to(() => const DeleteMyAccount()),
                        ),
                        _Button(
                          title: 'تسجيل الخروج',
                          icon: Iconsax.logout,
                          onPressed: controller.logOut,
                          foregroundColor: Colors.red,
                        ),
                        const SizedBox(height: 20),
                        KrFutureBuilder<String>(
                            future: controller.version,
                            builder: (version) {
                              return Text(
                                'V $version',
                                style: const TextStyle(fontSize: 12),
                              );
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class _Button extends StatelessWidget {
  const _Button({
    super.key,
    this.foregroundColor = Colors.black,
    required this.title,
    required this.onPressed,
    this.hideArrow = true,
    required this.icon,
  });

  final Color foregroundColor;
  final String title;
  final Function() onPressed;
  final bool hideArrow;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            minimumSize: const Size(0, 50),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black38, width: 0.3),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: foregroundColor),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(color: foregroundColor),
              ),
              if (!hideArrow) ...[
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 17),
              ],
            ],
          )),
    );
  }
}
