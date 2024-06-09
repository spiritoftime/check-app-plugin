import 'package:flutter/material.dart';

class NumberPermissions extends StatelessWidget {
  const NumberPermissions({
    super.key,
    required this.blockPermissions,
  });

  final List<bool> blockPermissions;
  @override
  Widget build(BuildContext context) {
    final int disabledPermissions = blockPermissions.where((e) => !e).length;

    return Text(
      "$disabledPermissions Permission${disabledPermissions > 1 ? 's' : ''} Missing",
      style: const TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30.0),
    );
  }
}