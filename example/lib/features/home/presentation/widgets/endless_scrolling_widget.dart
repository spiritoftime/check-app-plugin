import 'package:flutter/material.dart';

class EndlessScrollingWidget extends StatefulWidget {
  final int widgetWidth;
  final List<Widget> children;
  final int gap;
  final Duration scrollDuration;
  final int widgetHeight;
  const EndlessScrollingWidget(
      {super.key,
      required this.widgetWidth,
      required this.children,
      required this.scrollDuration,
      required this.widgetHeight, required this.gap});

  @override
  State<EndlessScrollingWidget> createState() => _EndlessScrollingWidgetState();
}

// MediaQuery.of(context).size.width
class _EndlessScrollingWidgetState extends State<EndlessScrollingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<Offset> _animation = Tween<Offset>(
    begin: const Offset(0, 0),
    end: Offset(
        (-(widget.widgetWidth * widget.children.length) / 2 - widget.gap*widget.children.length/2)
            .toDouble(), // assumes no gap, all widgets same width. if there is a gap/ margin between items, halve it and multiply by number of items. right to left = negative
        0), // 
  ).animate(_controller);
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: widget.scrollDuration)
          ..repeat()
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),

      child: Container(
        clipBehavior: Clip.hardEdge, // prevents overflow out of width
        decoration: const BoxDecoration(),
        height: (widget.widgetHeight).toDouble(),
        child: Transform.translate(
          offset: _animation.value,
          child: Row(
            children: widget.children,
          ),
        ),
      ),
    );
  }
}

