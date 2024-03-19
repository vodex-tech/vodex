import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/view/auth/info/options.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBar extends AppBar {
  HomeAppBar({super.key})
      : super(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: InkWell(
            onTap: () {
              Get.to(const AccountSetupScreenWrapper());
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Get.find<Auth>().user.university,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          '${Get.find<Auth>().user.college} - ${Get.find<Auth>().user.department}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          actions: [
            const Text(
              'Logic Study',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8, end: 16),
              child: SvgPicture.asset(
                'assets/svg/logo.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
                height: 26,
              ),
            ),
          ],
        );
}
