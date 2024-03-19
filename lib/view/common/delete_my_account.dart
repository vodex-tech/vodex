import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/components/primary_button.dart';
import 'package:logic_study/view/components/confirm.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/view/auth/widgets/text_field.dart';

class DeleteMyAccount extends StatelessWidget {
  const DeleteMyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    String password = '';
    return GetBuilder<Auth>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0.5,
          title: const Text(
            'حذف الحساب',
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
              controller: ScrollController(),
              physics: const BouncingScrollPhysics(),
              child: StatefulBuilder(builder: (context, setState) {
                return Column(
                  children: [
                    AuthTextField(
                      onChanged: (x) => setState(() => password = x),
                      hintText: 'كلمة المرور الحالية',
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthTextField(
                      onChanged: (_) {},
                      hintText: 'سبب الحذف',
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                        text: 'حذف الحساب',
                        status: password.isNotEmpty && password.length >= 6
                            ? ButtonStatus.enabled
                            : ButtonStatus.disabled,
                        onTap: () async {
                          doAfterConfirm(() => controller.signOut(),
                              message: 'هل انتة متأكد من حذف الحساب؟');
                        }),
                  ],
                );
              })),
        )),
      );
    });
  }
}
