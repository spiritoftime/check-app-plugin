import 'package:flutter/material.dart';

class GreyContainer extends StatelessWidget {
  final Widget child;
  const GreyContainer({super.key, required this.child, this.height});
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
