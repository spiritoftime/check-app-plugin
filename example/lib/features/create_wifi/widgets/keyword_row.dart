import 'package:checkapp_plugin_example/features/create_wifi/models/wifi.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WifiRow extends StatelessWidget {
  final Wifi wifi;
  const WifiRow({
    required this.wifi,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.wifi,
          color: Colors.blue,
        ),
        const Gap(12),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              wifi.wifiName,
              softWrap: true,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}