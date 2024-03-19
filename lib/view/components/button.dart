import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.color,
    required this.text,
    required this.textColor,
    this.border,
    required this.ontap,
    this.image,
  });

  final Color? color;
  final String text;
  final Color textColor;
  final BoxBorder? border;
  final String? image;
  final void Function()? ontap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: screenWidth < 600 ? screenWidth - 32 : 365,
        height: 60,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(
                image!,
              ),
            ),
            color: color,
            borderRadius: BorderRadius.circular(18),
            border: border),
        child: Center(
          child: DefaultTextStyle(
            style:
                TextStyle(color: textColor, fontSize: 16, letterSpacing: 0.5),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
