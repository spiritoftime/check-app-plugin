import 'package:flutter/material.dart';

class ScheduleName extends StatefulWidget {
  const ScheduleName({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  State<ScheduleName> createState() => _ScheduleNameState();
}

class _ScheduleNameState extends State<ScheduleName> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: TextField(
        textAlign: TextAlign.center,
        onChanged: (value) {
          setState(() {});  // update the width
        },
        controller: widget._controller,
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.only(top: 12),
          hintText: "Schedule Name",
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
