import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';

class AccordionPage extends StatelessWidget //__
{
  final String header;
  final Widget content;
  const AccordionPage({super.key, required this.header, required this.content});

  static const headerStyle = TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0);
  static const contentStyleHeader = TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  static const contentStyle = TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  @override
  build(context) => Accordion(
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
        headerPadding: const EdgeInsets.symmetric(horizontal: 0),
        contentBorderWidth: 0,
        contentHorizontalPadding: 0,
        scaleWhenAnimating: true,
        openAndCloseAnimation: true,
        // headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        // sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
        // sectionClosingHapticFeedback: SectionHapticFeedback.light,
        children: [
          AccordionSection(
            isOpen: true, headerBorderWidth: 0,
            contentBackgroundColor: Colors.black,
            contentBorderColor: Colors.black,
            contentBorderWidth: 0,

            // leftIcon: const Icon(Icons.input, color: Colors.white),
            header: Text(header, style: headerStyle),
            // contentHorizontalPadding: 40,
            contentVerticalPadding: 20,
            content: content,
          ),
        ],
      );
}
