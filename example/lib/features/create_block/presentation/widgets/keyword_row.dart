
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class KeywordRow extends StatelessWidget {
  final String keyword;
  const KeywordRow({
    required this.keyword,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 2.0),
      child: Row(
        children: [
          const Icon(
            Icons.public,
            color: Colors.blue,
          ),
          const Gap(12),
          Expanded(
            child: Text(
              keyword,
              softWrap: true,
              maxLines: 3,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
