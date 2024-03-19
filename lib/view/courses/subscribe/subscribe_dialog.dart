import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kr_builder/kr_builder.dart';
import 'package:kr_button/text_button.dart';
import 'package:logic_study/view/courses/subscribe/controller.dart';
import 'package:pay/pay.dart';

class SubscribeDialog extends StatelessWidget {
  const SubscribeDialog({super.key, required this.data});

  final dynamic data;

  static show(dynamic data) async {
    return await Get.bottomSheet(
      SubscribeDialog(data: data),
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
        init: SubscriptionController(data: data),
        builder: (controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'اختر طريقة الدفع',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  KrTextButton(
                    onPressed: controller.payWithZainCash,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Zain Cash'),
                        const SizedBox(width: 10),
                        Image.asset(
                          'assets/images/zain_cash.png',
                          width: 40,
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (Platform.isIOS)
                    KrFutureBuilder(
                        future:
                            PaymentConfiguration.fromAsset('apple_pay.json'),
                        shimmerSize: const Size(double.maxFinite, 50),
                        shimmerRadius: 20,
                        builder: (config) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: ApplePayButton(
                              paymentConfiguration: config,
                              paymentItems: [
                                PaymentItem(
                                  label: 'Logic: ${data.title}',
                                  amount: data.price.toString(),
                                ),
                              ],
                              style: ApplePayButtonStyle.white,
                              type: ApplePayButtonType.buy,
                              onPaymentResult: controller.payWithApplePay,
                              width: double.maxFinite,
                              height: 40,
                              loadingIndicator: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        }),
                  const SafeArea(child: SizedBox(height: 40)),
                ],
              ),
            ),
          );
        });
  }
}
