import 'package:flutter/material.dart';

class GreyContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const GreyContainer({super.key, required this.child, this.height, this.padding, this.width});
  final double?width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xff21222D),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: child,
    );
  }
}
