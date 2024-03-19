import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kr_button/kr_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum ButtonStatus {
  enabled,
  disabled,
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.backgroundColor,
    this.text,
    this.foregroundColor,
    this.border,
    required this.onTap,
    this.child,
    this.expand = true,
    this.margin = const EdgeInsets.all(0),
    this.padding,
    this.status = ButtonStatus.enabled,
    this.focusNode,
  }) : assert(text != null || child != null, 'text or child must be provided');

  final Color? backgroundColor;
  final String? text;
  final Color? foregroundColor;
  final BorderSide? border;
  final Widget? child;
  final Future Function() onTap;
  final bool expand;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;
  final ButtonStatus status;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: KrTextButton(
        onPressed: status == ButtonStatus.enabled ? onTap : () async {},
        focusNode: focusNode,
        onLoading: SpinKitRing(
          color: foregroundColor ?? Colors.white,
          size: 24,
          lineWidth: 2,
        ),
        style: TextButton.styleFrom(
          backgroundColor: (backgroundColor ?? Theme.of(context).primaryColor)
              .withOpacity(status == ButtonStatus.disabled ? 0.5 : 1),
          foregroundColor: foregroundColor ?? Colors.white,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: border ?? BorderSide.none,
          ),
          minimumSize: Size(
              expand
                  ? Get.width < 600
                      ? Get.width - 32
                      : 365
                  : 0,
              54),
          alignment: Alignment.center,
        ),
        child: child ??
            DefaultTextStyle(
              style: TextStyle(
                color: foregroundColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              child: Text(text!),
            ),
      ),
    );
  }
}
