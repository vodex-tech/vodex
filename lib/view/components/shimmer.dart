import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBloc extends StatelessWidget {
  const ShimmerBloc(
      {super.key,
      required this.size,
      required this.radius,
      this.padding,
      this.borderRadius});

  final Size size;
  final double radius;
  final EdgeInsets? padding;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.2),
      highlightColor: Colors.grey.withOpacity(0.4),
      child: Container(
        width: size.width,
        height: size.height,
        margin: padding,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: borderRadius ?? BorderRadius.circular(radius)),
      ),
    );
  }
}

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.2),
      highlightColor: Colors.grey.withOpacity(0.4),
      child: child,
    );
  }
}
