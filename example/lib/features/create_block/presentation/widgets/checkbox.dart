
import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:flutter/material.dart';

class CheckBoxWidget extends StatefulWidget {
  final App app;
   const CheckBoxWidget({required this.app,super.key});

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.transparent;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: WidgetStateColor.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
