import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final RxBool? showPassword;
  final IconData? icon;
  final Function(String)? onChanged;
  final Function()? onSubmitted;
  final int? maxLines;
  final bool isEmail;
  final bool autofocus;

  const AuthTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.showPassword,
    this.icon,
    this.onChanged,
    this.onSubmitted,
    this.maxLines,
    this.isEmail = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showPassword != null) {
      return Obx(() {
        return _TextField(
          showText: showPassword!.value,
          icon: icon,
          hintText: hintText,
          onShowPasswordChanged: showPassword!.toggle,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          maxLines: maxLines,
          isEmail: isEmail,
          autofocus: autofocus,
        );
      });
    }
    return _TextField(
      icon: icon,
      showText: !obscureText,
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      isEmail: isEmail,
      autofocus: autofocus,
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    this.showText = true,
    required this.icon,
    required this.hintText,
    this.onShowPasswordChanged,
    this.onChanged,
    required this.onSubmitted,
    this.maxLines,
    this.isEmail = false,
    this.autofocus = false,
  });

  final bool showText;
  final IconData? icon;
  final String hintText;
  final Function()? onShowPasswordChanged;
  final Function(String)? onChanged;
  final Function()? onSubmitted;
  final int? maxLines;
  final bool isEmail; 
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines == null ? 57 : null,
      child: TextField(
        textAlign: TextAlign.right,
        obscureText: !showText,
        onChanged: onChanged,
        autofocus: autofocus,
        maxLines: maxLines ?? 1,
        textInputAction:
            onSubmitted == null ? TextInputAction.next : TextInputAction.done,
        onSubmitted: (value) {
          onSubmitted?.call();
        },
        autocorrect: false,
        autofillHints: [
          if(isEmail) AutofillHints.email,
          if(!showText) AutofillHints.password,
        ],
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          suffixIcon: onShowPasswordChanged != null
              ? GestureDetector(
                  onTap: onShowPasswordChanged,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      !showText ? Iconsax.eye : Iconsax.eye_slash,
                      color: Colors.grey,
                    ),
                  ),
                )
              : null,
          prefixIconColor: Colors.grey.shade500,
          suffixIconColor: Colors.grey,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(142, 33, 33, 33),
          ),
        ),
      ),
    );
  }
}
