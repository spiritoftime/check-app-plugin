import 'package:checkapp_plugin_example/features/create_block/models/website/website.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WebsiteRow extends StatelessWidget {
  final Website website;
  const WebsiteRow({
    required this.website,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Row(
        children: [
          const Icon(
            Icons.public,
            color: Colors.blue,
          ),
          const Gap(12),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                website.url,
                softWrap: true,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
