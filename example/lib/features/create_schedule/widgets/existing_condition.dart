import 'package:checkapp_plugin_example/features/create_location/models/location/location.dart';
import 'package:checkapp_plugin_example/features/create_wifi/models/wifi.dart';
import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ExistingCondition extends StatefulWidget {
  const ExistingCondition({
    super.key,
    required this.extra,
    required this.conditionType,
    required this.onTap,
    required this.text1,
    required this.text2,
    required this.updateUI,
  });
  final String conditionType;
  final Map<String, dynamic> extra;
    final Function(BuildContext context, Object extra) onTap;
  final Function() updateUI;
  final String text1;
  final String text2;

  @override
  State<ExistingCondition> createState() => _ExistingConditionState();
}

class _ExistingConditionState extends State<ExistingCondition> {
  @override
  Widget build(BuildContext context) {
    return HoverInkWell(
      onTap: () async {
            if (widget.conditionType == 'Location' || widget.conditionType == 'Wi-Fi') {
              await widget.onTap(context, widget.extra);
            } else {
              widget.onTap(context,widget.extra);
            }
          },
      inkWellPadding: const EdgeInsets.all(0),
      child: GreyContainer(
        child: Row(
          children: [
            widget.conditionType == 'Time'
                ? const Icon(Icons.schedule, color: Colors.blue, size: 24)
                : widget.conditionType == 'Location'
                    ? const Icon(Icons.location_on,
                        color: Colors.blue, size: 24)
                    : const Icon(Icons.wifi, color: Colors.blue, size: 24),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conditionType,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const Gap(4),
                  Text(
                    widget.text1,
                    softWrap: true,
                  ),
                  const Gap(4),
                  widget.text2.isNotEmpty ? Text(widget.text2) : Container()
                ],
              ),
            ),
            widget.conditionType != 'Time'
                ? GestureDetector(
                    onTap: () {
                      if (widget.conditionType == 'Location') {
                        widget.extra['locationCubit']
                            .updateLocation(location: <Location>[]);
                      } else if (widget.conditionType == 'Wifi') {
                        widget.extra['wifiCubit'].updateWifi(wifi: <Wifi>[]);
                      }

                      widget.updateUI();
                    },
                    child:
                        const Icon(Icons.close, size: 24, color: Colors.grey),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
