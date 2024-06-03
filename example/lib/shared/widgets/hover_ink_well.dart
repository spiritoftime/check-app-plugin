import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HoverInkWell extends StatelessWidget {
  final Function()? onTap;
  final EdgeInsets? inkWellPadding;
  final Widget child;
  final Color? borderColor;
  final Color? inkColor;
  const HoverInkWell({
    super.key,
    this.onTap,
    required this.child,
    this.inkWellPadding,
    this.borderColor,
    this.inkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Ink(
          color: inkColor ?? const Color(0xff21222D),
          child: Container(
              padding: inkWellPadding ?? const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                shape:  BoxShape.rectangle,
                border: Border.all(
                    color: borderColor?.withOpacity(0.4) ??
                        Colors.grey.withOpacity(0.4),
                    width: 2),
                borderRadius:
                     BorderRadius.circular(8),
              ),
              child: child),
        ),
      ),
    );
  }
}
