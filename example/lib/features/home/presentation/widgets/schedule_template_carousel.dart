import 'package:carousel_slider/carousel_slider.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/carousel_icons.dart';
import 'package:checkapp_plugin_example/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ScheduleTemplateCarousel extends StatefulWidget {
  const ScheduleTemplateCarousel({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<ScheduleTemplateCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  CheckappPlugin checkappPlugin = CheckappPlugin();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          child: InkWell(
            onTap: () async {
              try {
                List<bool> arePermissionsEnabled = await Future.wait([
                  checkappPlugin.checkUsagePermission(),
                  checkappPlugin.checkOverlayPermission(),
                  checkappPlugin.checkNotificationPermission(),
                  checkappPlugin.checkBackgroundPermission(),
                ]);
                if (arePermissionsEnabled.contains(false) && context.mounted) {
                  context.goNamed(RouteNames.createBlockPermission,
                      extra: <String, dynamic>{
                        'blockPermissions': arePermissionsEnabled
                      });
                } else if (context.mounted) {
                  context.goNamed(RouteNames.createBlock, extra: <String, dynamic>{});
                } else {
                  print('context not mounted');
                }
              } catch (e) {
                print(e);
              }
            },
            child: Ink(
              color: Colors.black,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CarouselSlider(
                  items: templateSliders,
                  carouselController: _controller,
                  options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1.0,
                      // enlargeCenterPage: true,
                      aspectRatio: 2,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
            ),
          ),
        ),
        const Gap(16),
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
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
