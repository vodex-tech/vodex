import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/helper/formatter.dart';
import 'package:admin/src/helper/grid.dart';
import 'package:admin/src/helper/validator.dart';
import 'package:datasource/models/subscription.dart';

class SubscriptionDataGridProvider extends DataGridProvider<Subscription> {
  SubscriptionDataGridProvider([super.data]);

  @override
  List<Cell> cellsProvider([Subscription? e]) => [
        CellText(
          e?.courseId,
          id: 'courseId',
          validator: Validator.isNotEmpty,
          hideColumn: true,
        ),
        CellText(
          e?.chapterId,
          id: 'chapterId',
          validator: Validator.isNotEmpty,
          hideColumn: true,
        ),
        CellText(
          e?.userId,
          id: 'userId',
          validator: Validator.isNotEmpty,
          hideColumn: true,
        ),
        CellText(
          e?.userEmail,
          id: 'userEmail',
          validator: Validator.isEmail,
        ),
        CellText(
          e?.itemName,
          id: 'itemName',
          validator: Validator.isNotEmpty,
        ),
        CellNumber(
          e?.amount,
          id: 'amount',
          validator: Validator.isIraqiPrice,
          formatter: FieldFormatter.price(),
        ),
        CellNumber(
          e?.baseAmount,
          id: 'baseAmount',
          validator: Validator.isIraqiPrice,
          formatter: FieldFormatter.price(),
        ),
        CellText(
          e?.coupon,
          id: 'coupon',
        ),
        CellEnum(
          e?.paymentMethod ?? PaymentMethod.zainCash,
          id: 'paymentMethod',
          values: PaymentMethod.values,
        ),
        CellText(
          e?.transactionId,
          id: 'transactionId',
          validator: Validator.isNotEmpty,
        ),
      ];
}
