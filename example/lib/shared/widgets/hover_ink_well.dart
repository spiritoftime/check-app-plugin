import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HoverInkWell extends StatelessWidget {
  final Function()? onTap;
  final EdgeInsets? inkWellPadding;
  final Widget child;
  const HoverInkWell({
    super.key,
    this.onTap,
    required this.child,
    this.inkWellPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Ink(
          color: const Color(0xff21222D),
          child: Container(
              padding: inkWellPadding ?? const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: child),
        ),
      ),
    );
  }
}
