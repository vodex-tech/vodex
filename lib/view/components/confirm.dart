import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

doAfterConfirm(
  Function() fun, {
  String? title,
  String? message,
  String? textCancel,
  String? textOK,
  String? inputText,
  Color okColor = Colors.red,
  TextDirection? textDirection,
}) async {
  final res = await showDialog<bool?>(
    context: Get.context!,
    useSafeArea: false,
    barrierColor: Colors.transparent,
    builder: (context) => ConfirmDialog(
      message: message,
      textCancel: textCancel,
      textOK: textOK,
      title: title,
      okColor: okColor,
      inputText: inputText,
      textDirection: textDirection,
    ),
  );
  if (res == true) {
    await fun();
  }
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    this.title,
    this.message,
    this.textCancel,
    this.textOK,
    required this.okColor,
    this.inputText,
    this.textDirection,
  });

  final String? title;
  final String? message;
  final String? textCancel;
  final String? textOK;
  final String? inputText;
  final Color okColor;
  final TextDirection? textDirection;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Directionality(
      textDirection: textDirection ?? Directionality.of(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(
            child: IgnorePointer(
              child: Blur(
                blur: 5,
                blurColor: Colors.black,
                colorOpacity: 0.3,
                child: SizedBox(),
              ),
            ),
          ),
          AlertDialog(
            title: Text(title ?? 'تأكيد', style: const TextStyle(fontSize: 18)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            titlePadding:
                const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    (message ?? 'هل انت متأكد من الاستمرار'),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                ),
                if (inputText != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: inputText,
                      ),
                    ),
                  ),
              ],
            ),
            buttonPadding: EdgeInsets.zero,
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            actions: <Widget>[
              TextButton(
                onPressed: Get.back,
                child: Text(
                  (textCancel ?? 'لا'),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
              TextButton(
                child:
                    Text((textOK ?? 'نعم'), style: TextStyle(color: okColor)),
                onPressed: () => Get.back(result: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
