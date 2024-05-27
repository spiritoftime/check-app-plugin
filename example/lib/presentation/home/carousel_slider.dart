import 'package:carousel_slider/carousel_slider.dart';
import 'package:checkapp_plugin_example/presentation/home/carousel_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: templateSliders,
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1.0,
              // enlargeCenterPage: true,
              aspectRatio: 1.8,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: templateList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

final List<Widget> templateSliders = templateList.map((item) {
  Icon icon = item.icon;
  String content = item.content;
  String quote = item.quote;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          children: [Icon(Icons.schedule), Spacer(), Icon(Icons.add_circle)],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const Gap(16),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Gap(12),
        Text(
          quote,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ],
    ),
  );
}).toList();
