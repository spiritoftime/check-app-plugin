import 'dart:convert';
import 'package:gap/gap.dart';

import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:flutter/material.dart';

class AppRow extends StatelessWidget {
  final App app;
  final double? width;
  const AppRow({
    super.key,
    required this.app, this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 2.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.memory(
              const Base64Decoder()
                  .convert(app.iconBase64String.replaceAll(RegExp(r'\s+'), '')),
              width:width?? 50,
              height: width?? 50,
            ),
          ),
          const Gap(12),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                app.appName,softWrap: true,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
