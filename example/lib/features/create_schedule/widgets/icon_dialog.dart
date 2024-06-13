import 'package:checkapp_plugin_example/features/create_schedule/widgets/icon_selection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class IconDialog extends StatefulWidget {
  final String currentIconName;
  final Function(dynamic) onChanged;

  const IconDialog(
      {super.key,
      required this.currentIconName,
      required this.onChanged});
  static double avatarPadding = 66;
  static double contentPadding = 16;

  @override
  State<IconDialog> createState() => _IconDialogState();
}

class _IconDialogState extends State<IconDialog> {
  late String _iconName;
  @override
  void initState() {
    super.initState();
    _iconName = widget.currentIconName;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IconDialog.contentPadding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: dialogContext(context));
  }

  dialogContext(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
              top: IconDialog.contentPadding + IconDialog.avatarPadding,
              bottom: IconDialog.contentPadding,
              right: IconDialog.contentPadding,
              left: IconDialog.contentPadding),
          margin: EdgeInsets.only(top: IconDialog.avatarPadding),
          decoration: BoxDecoration(
            color: Colors.purple[100],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(IconDialog.contentPadding),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose An Icon",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue),
              ),
              const Gap(16),
              IconSelection(
                  currentIcon: _iconName,
                  setIcon: (String iconName) {
                    widget.onChanged(iconName);
                    setState(() => _iconName = iconName);
                  }),
              const Gap(24),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text("Okay", style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: IconDialog.contentPadding,
          right: IconDialog.contentPadding,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: IconDialog.avatarPadding,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 60,
              child: Icon(
                icons[_iconName]!,
                size: 80,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
