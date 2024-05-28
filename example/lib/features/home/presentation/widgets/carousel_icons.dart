import 'package:flutter/material.dart';
//  use for endless scrolling widget
 final List<Widget> preCarouselIcons=  templateList.map((item)=>Padding(
    padding: const EdgeInsets.only(right: 20.0),
    child: item.icon,
  )).toList();
  // need to duplicate in order to achieve infinite loop effect.
  final List<Widget> carouselIcons = [...preCarouselIcons,...preCarouselIcons];
//  use for accordion
class Template {
  final Icon icon;
  final String content;
  final String quote;
  const Template(
      {required this.icon, required this.content, required this.quote});
}
final List<Template> templateList = [
  const Template(
      icon: Icon(
        Icons.access_time,color:Colors.orange,
        size: 48,
      ),
      content: 'Limited Use',
      quote: '"30 minutes of doomscrolling per day"'),
  const Template(
      icon: Icon(Icons.home, size: 48,color:Colors.brown),
      content: 'Location blocking',
      quote: '"continue doomscrolling while outside!"'),
  const Template(
      icon: Icon(Icons.block, size: 48,color:Colors.red),
      content: 'Strict blocking',
      quote: '"Anti-doomscroll all the way!"'),
  const Template(
      icon: Icon(Icons.calendar_today, size: 48,color:Colors.blue),
      content: 'Scheduled blocking',
      quote: '"Block at specific times of the day!"'),
];
