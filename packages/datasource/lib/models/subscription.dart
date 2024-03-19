import 'package:datasource/src/enum_from_string.dart';

import '../src/base.dart';

enum PaymentMethod { zainCash, applePay}

class Subscription extends BaseModel {
  final String courseId;
  final String? chapterId;
  final String userId;
  final String itemName;
  final String userEmail;
  final PaymentMethod paymentMethod;
  final String? transactionId;
  final Map<String, dynamic> data;
  final int amount;
  final int baseAmount;
  final String coupon;

  @override
  List<String> get additionalSearchTerms => [
        id,
        if (chapterId != null) chapterId!,
        courseId,
        userId,
        itemName,
        userEmail,
        if (transactionId != null) transactionId!,
        coupon,
      ];

  Subscription({
    super.id,
    super.createdAt,
    required this.courseId,
    required this.chapterId,
    required this.userId,
    required this.paymentMethod,
    required this.amount,
    required this.baseAmount,
    required this.coupon,
    required this.itemName,
    required this.userEmail,
    this.transactionId,
    this.data = const {},
  });

  Subscription.fromMap(super.data) :
        courseId = data['courseId'],
        chapterId = data['chapterId'],
        userId = data['userId'],
        itemName = data['itemName'],
        userEmail = data['userEmail'],
        paymentMethod = getEnumFromString(data['paymentMethod'], PaymentMethod.values, defaultValue: PaymentMethod.zainCash),
        transactionId = data['transactionId'],
        amount = data['amount'],
        baseAmount = data['baseAmount'],
        coupon = data['coupon'],
        data = data['data'] ?? {},
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'chapterId': chapterId,
      'userId': userId,
      'itemName': itemName,
      'userEmail': userEmail,
      'paymentMethod': paymentMethod.name,
      'transactionId': transactionId,
      'amount': amount,
      'baseAmount': baseAmount,
      'coupon': coupon,
      'data': data,
      ...super.toMap(),
    };
  }
}
