import 'package:checkapp_plugin_example/features/create_schedule/widgets/icon_selection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart';

Future<void> createAlertDialog(
    BuildContext context, Text title, Widget content) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

