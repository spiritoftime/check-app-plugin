import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BlockingCondition extends StatelessWidget {
  final String text;
  final String description;
  final Icon icon;
  final String route;
  const BlockingCondition(
      {super.key,
      required this.text,
      required this.description,
      required this.icon,
      required this.route});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(12),
        Material(
          child: InkWell(
            onTap: () => context.go(route),
            child: Ink(
              color: const Color(0xff21222D),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue,
                            border: Border.all(width: 5, color: Colors.blue)),
                        child: icon),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey),
                          ),
                          const Gap(4),
                          Text(
                            description,
                            softWrap: true,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
