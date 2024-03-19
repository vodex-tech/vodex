import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:logic_study/theme/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:http/http.dart' as http;

class ZainCash {
  static const initUrl = 'https://api.zaincash.iq/transaction/init';
  static const requestUrl = 'https://api.zaincash.iq/transaction/pay?id=';
  static const redirectUrl = 'https://example.com/redirect';
  static const kMSISDN = 9647733062094;
  static const kMerchantId = '64dc72b422aed08b572b5a5f';
  static const kSecret =
      r'$2y$10$Bumgh0KEG2rqFh7bAG/jouUwcRa1om6yMab3pZz.01sXBHaeeVi0O';

  double amount;
  final String itemName;

  ZainCash({required this.amount, required this.itemName});

  Future<ZainCashResponse?> request() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    var data = {
      'amount': (amount / 250).ceil() * 250,
      'serviceType': 'Course',
      'msisdn': kMSISDN,
      'orderId': const Uuid().v4(),
      'redirectUrl': redirectUrl,
      'iat': time,
      'exp': time + 60 * 60 * 4
    };

    final claimSet = JwtClaim.fromMap(data);
    String token = issueJwtHS256(claimSet, kSecret);
    var postData = {
      'token': token,
      'merchantId': kMerchantId,
      'lang': 'ar',
    };
    var res = await http.post(Uri.parse(initUrl), body: jsonEncode(postData));
    final body = jsonDecode(res.body);
    if (body['err'] != null) {
      throw body['err']['msg'].toString();
    }
    String? result = await Get.to(
      Scaffold(
        appBar: AppBar(
          title: const Text(
            'تأكيد الدفع',
            style: TextStyle(color: AppColors.primary, fontSize: 18),
          ),
        ),
        body: SafeArea(
          child: WebViewX(
            width: Get.width,
            height: Get.height,
            initialContent: requestUrl + body['id'],
            initialSourceType: SourceType.url,
            onPageStarted: (x) {
              if (x.contains('//example.com/')) {
                Get.back(result: x.split('token=').last);
              }
            },
          ),
        ),
      ),
    );
    if (result == null) return null;
    var status = verifyJwtHS256Signature(result, kSecret);
    if (status.toJson()['status'] == "success") {
      return ZainCashResponse.fromJson(status.toJson());
    } else {
      throw status.toJson()['msg'];
    }
  }
}

class ZainCashResponse {
  String orderId;
  String id;
  String operationId;

  ZainCashResponse({
    required this.orderId,
    required this.id,
    required this.operationId,
  });

  static ZainCashResponse fromJson(Map e) => ZainCashResponse(
      orderId: e['orderid'], id: e['id'], operationId: e['operationid']);

  Map<String, String> get toJson =>
      {'zainOrderId': orderId, 'paymentId': id, 'operationId': operationId};
}
