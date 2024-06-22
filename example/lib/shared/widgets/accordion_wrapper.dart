import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';

class AccordionWrapper extends StatelessWidget {
  final Widget header;
  final Widget content;
  const AccordionWrapper(
      {super.key, required this.header, required this.content});

  @override
  Widget build(BuildContext context) {
    return Accordion(
      disableScrolling: true,
      headerBorderColor: Colors.black,
      // headerBorderColorOpened: Colors.black,
      headerBorderWidth: 0,
      headerBackgroundColorOpened: Colors.black,
      headerBackgroundColor: Colors.black,
      headerBorderRadius: 0,
      contentBorderRadius: 0,
      contentBackgroundColor: Colors.black,
      contentBorderColor: Colors.black,
      headerPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      contentBorderWidth: 0,
      contentHorizontalPadding: 0,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      // headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      // sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      // sectionClosingHapticFeedback: SectionHapticFeedback.light,
      children: [
        AccordionSection(
          headerPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 16),

          isOpen: true, headerBorderWidth: 0,
          contentBackgroundColor: Colors.black,
          contentBorderColor: Colors.black,
          contentBorderWidth: 0,
          contentHorizontalPadding: 0,
          // leftIcon: const Icon(Icons.input, color: Colors.white),
          header: header,
          // contentHorizontalPadding: 40,
          contentVerticalPadding: 0,
          content: content,
        ),
      ],
    );
  }
}
