import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
class AccordionPage extends StatelessWidget //__
{
   const AccordionPage({super.key});


static const headerStyle = TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0);
  static const contentStyleHeader = TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  static const contentStyle = TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
 

  @override
  build(context) =>Accordion(
  headerBorderColor: Colors.black,
  // headerBorderColorOpened: Colors.black,
  headerBorderWidth: 0,
  headerBackgroundColorOpened: Colors.black,
  headerBackgroundColor: Colors.black,
  contentBackgroundColor: Colors.black,
  contentBorderColor: Colors.grey,

  contentBorderWidth: 0,
  // contentHorizontalPadding: 20,
  scaleWhenAnimating: true,
  openAndCloseAnimation: true,
  // headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
  // sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
  // sectionClosingHapticFeedback: SectionHapticFeedback.light,
  children: [

    AccordionSection(
      isOpen: true,
      contentBackgroundColor: Colors.black,
      contentBorderWidth: 1,
      contentBorderColor: Colors.grey[700],
      // leftIcon: const Icon(Icons.input, color: Colors.white),
      header: const Text("Schedule Templates", style: headerStyle),
      contentHorizontalPadding: 40,
      contentVerticalPadding: 20,
      content: const Text("Hi",style: TextStyle(color: Colors.white),),
    ),
  ],
);
}
